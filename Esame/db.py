from flask import Flask, request , jsonify 
import psycopg2
app = Flask(__name__)

try:
    # Connessione al database Docker tramite il nome del servizio
    def get_db_connection():
        conn = psycopg2.connect(
            dbname="esame",
            user="postgres",
            password="postgres",
            host="localhost",  # Nome del servizio nel docker-compose.yml
            port="5432"
        )
        return conn
        
except Exception as e:
    print(f"Errore di connessione: {e}")

@app.route('/cerca_vendita', methods=['GET'])
def cerca_vendita():
    
    query= "select * from case_in_vendita "
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Esegui una query per ottenere tutte le tabelle
    cursor.execute(query)
    result = cursor.fetchall()
    conn.close()
    return jsonify(result)

@app.route("/cerca_affitto", methods=["GET"])
def cerca_affitto():
    query = "select * from case_in_affitto"
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    result = cursor.fetchall()
    conn.close()
    return jsonify(result)


# Avvio del server
if __name__ == '__main__':
    app.run(debug=True)
