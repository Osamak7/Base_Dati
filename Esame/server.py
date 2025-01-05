from flask import Flask, request, jsonify
import psycopg2
import psycopg2.extras  # Importa il modulo per i dizionari

app = Flask(__name__)


# Funzione per connettersi al database PostgreSQL
def get_db_connection():
    conn = psycopg2.connect(
        dbname="esame",         # Nome del tuo database
        user="postgres",        # Username del database
        password="postgres",    # Password per l'utente
        host="localhost",       # Indirizzo del server (o localhost se nel tuo PC)
        port="5432"             # Porto del database PostgreSQL
    )
    conn.cursor_factory = psycopg2.extras.RealDictCursor  # Abilita il cursore per i dizionari
    return conn


# Servizio: CercaCasaVendita (per case in vendita)
@app.route('/cerca_vendita', methods=['POST','GET'])
def cerca_vendita():
    print("ricevuta richiesta di vendita")
    data = request.get_json()
    stato = data.get('stato', None)
    filiale = data.get('filiale_proponente', None)
    
    query = "SELECT * FROM case_in_vendita WHERE 1=1"
    
    if stato:
        query += " AND stato = %s"
    if filiale:
        query += " AND filiale_proponente = %s"
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    params = [] # su parametri appendiamo i valori che si sostituiranno alle %s nella query 
    if stato:
        params.append(stato)
    if filiale:
        params.append(filiale)
    
    cursor.execute(query, params)
    result = cursor.fetchall()
    conn.close()
    
    houses = []
    for row in result:
        houses.append(row)
    
    return jsonify(houses)

# Servizio: VendiCasa (per vendere una casa)
@app.route('/vendi_casa', methods=['POST','GET'])
def vendi_casa():
    data = request.get_json()
    catastale = data['catastale']
    filiale_proponente = data['filiale_proponente']
    filiale_venditrice = data['filiale_venditrice']
    prezzo_vendita = data['prezzo_vendita']
    data_vendita = data['data_vendita']
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute("""
        INSERT INTO vendite_casa (catastale, data_vendita, filiale_proponente, filiale_venditrice, prezzo_vendita)
        VALUES (%s, %s, %s, %s, %s)
    """, (catastale, data_vendita, filiale_proponente, filiale_venditrice, prezzo_vendita))
    
    conn.commit()
    conn.close()
    
    return jsonify({"message": "Casa venduta con successo!"})

# Servizio: Marketing - Statistiche vendite e affitti
@app.route('/statistiche', methods=['POST'])
def statistiche():
    data = request.get_json()
    data_inizio = data['data_inizio']
    data_fine = data['data_fine']
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Statistiche per vendite e affitti
    query = """
        SELECT filiale_venditrice, 
        TO_CHAR(v.data_vendita, 'YYYY-MM') AS mese,
        COUNT(DISTINCT v.catastale) AS num_vendite,
        COUNT(DISTINCT a.catastale) AS num_affitti
        FROM vendite_casa v
        LEFT JOIN affitti_casa a ON v.catastale = a.catastale
        WHERE v.data_vendita BETWEEN %s AND %s
        GROUP BY filiale_venditrice, mese
        ORDER BY filiale_venditrice, mese;

    """
    cursor.execute(query, (data_inizio, data_fine))
    result = cursor.fetchall()
    conn.close()
    
    stats = []
    for row in result:
        stats.append({
            'filiale': row['filiale_venditrice'],
            'mese': row['mese'],
            'num_vendite': row['num_vendite'],
            'num_affitti': row['num_affitti']
        })
    
    # Salvataggio dei dati in un file JSON
    # with open('statistiche.json', 'w') as f:
    #     json.dump(stats, f)
    
    return jsonify(stats)

# Avvio del server
if __name__ == '__main__':
    app.run(debug=True)
