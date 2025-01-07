from flask import Flask, request, jsonify
import sqlite3
from datetime import datetime
import json

app = Flask(__name__)

DB_FILE = "real_estate.db"

# ------------------- Database Setup -------------------
def init_db():
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    
    # Create tables
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS case_in_vendita (
        catastale TEXT PRIMARY KEY,
        indirizzo TEXT,
        civico TEXT,
        piano INTEGER,
        metri INTEGER,
        vani INTEGER,
        prezzo REAL,
        stato TEXT CHECK(stato IN ('LIBERO', 'OCCUPATO')),
        filiale_proponente TEXT
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS case_in_affitto (
        catastale TEXT PRIMARY KEY,
        indirizzo TEXT,
        civico TEXT,
        tipo_affitto TEXT CHECK(tipo_affitto IN ('PARZIALE', 'TOTALE')),
        bagno_personale BOOLEAN,
        prezzo_mensile REAL,
        filiale_proponente TEXT
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS filiali (
        partita_iva TEXT PRIMARY KEY,
        nome TEXT,
        indirizzo_sede TEXT,
        civico TEXT,
        telefono TEXT
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS vendite_casa (
        catastale TEXT,
        data_vendita TEXT,
        filiale_proponente TEXT,
        filiale_venditrice TEXT,
        prezzo_vendita REAL
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS affitti_casa (
        catastale TEXT,
        data_affitto TEXT,
        filiale_proponente TEXT,
        filiale_venditrice TEXT,
        prezzo_affitto REAL,
        durata_contratto INTEGER
    )
    """)

    conn.commit()
    conn.close()

# ------------------- Helper Functions -------------------
def query_db(query, args=(), one=False):
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    cursor.execute(query, args)
    rv = cursor.fetchall()
    conn.commit()
    conn.close()
    return (rv[0] if rv else None) if one else rv

# ------------------- Routes -------------------
@app.route("/CercaCasaVendita", methods=["POST"])
def cerca_casa_vendita():
    criteria = request.json
    query = "SELECT * FROM case_in_vendita WHERE stato = ? AND prezzo <= ? AND vani >= ?"
    params = (criteria.get("stato"), criteria.get("prezzo", float("inf")), criteria.get("vani", 0))
    results = query_db(query, params)
    return jsonify(results)

@app.route("/CercaCasaAffitto", methods=["POST"])
def cerca_casa_affitto():
    criteria = request.json
    query = "SELECT * FROM case_in_affitto WHERE tipo_affitto = ? AND prezzo_mensile <= ?"
    params = (criteria.get("tipo_affitto"), criteria.get("prezzo_mensile", float("inf")))
    results = query_db(query, params)
    return jsonify(results)

@app.route("/VendiCasa", methods=["POST"])
def vendi_casa():
    data = request.json
    query = "INSERT INTO vendite_casa (catastale, data_vendita, filiale_proponente, filiale_venditrice, prezzo_vendita) VALUES (?, ?, ?, ?, ?)"
    params = (data["catastale"], datetime.now().strftime("%Y-%m-%d"), data["filiale_proponente"], data["filiale_venditrice"], data["prezzo_vendita"])
    query_db(query, params)
    return jsonify({"status": "success"})

@app.route("/AffittaCasa", methods=["POST"])
def affitta_casa():
    data = request.json
    query = "INSERT INTO affitti_casa (catastale, data_affitto, filiale_proponente, filiale_venditrice, prezzo_affitto, durata_contratto) VALUES (?, ?, ?, ?, ?, ?)"
    params = (data["catastale"], datetime.now().strftime("%Y-%m-%d"), data["filiale_proponente"], data["filiale_venditrice"], data["prezzo_affitto"], data["durata_contratto"])
    query_db(query, params)
    return jsonify({"status": "success"})

@app.route("/MarketingCaseVendute", methods=["POST"])
def marketing_case_vendute():
    data = request.json
    query = """
    SELECT filiale_venditrice, strftime('%m', data_vendita) as mese, COUNT(*) as numero_vendite
    FROM vendite_casa
    WHERE data_vendita BETWEEN ? AND ?
    GROUP BY filiale_venditrice, mese
    """
    params = (data["data_inizio"], data["data_fine"])
    results = query_db(query, params)

    # Salva risultati in un file JSON
    with open("marketing_case_vendute.json", "w") as f:
        json.dump(results, f)

    return jsonify(results)

@app.route("/MarketingGuadagni", methods=["POST"])
def marketing_guadagni():
    data = request.json
    query = """
    SELECT filiale_proponente, SUM(CASE WHEN vendite_casa.filiale_proponente = vendite_casa.filiale_venditrice THEN prezzo_vendita * 0.03 ELSE prezzo_vendita * 0.01 END) + COUNT(affitti_casa.catastale) * 500 as guadagno
    FROM vendite_casa
    LEFT JOIN affitti_casa ON vendite_casa.filiale_proponente = affitti_casa.filiale_proponente
    WHERE data_vendita BETWEEN ? AND ?
    GROUP BY filiale_proponente
    """
    params = (data["data_inizio"], data["data_fine"])
    results = query_db(query, params)
    return jsonify(results)

# ------------------- Main -------------------
if __name__ == "__main__":
    init_db()
    app.run(debug=True)
