from flask import Flask , request , jsonify
import psycopg2

app = Flask(__name__)
def db_connect():
    conn = psycopg2.connect(
        host= "localhost",
        namedb= "esame",
        port = "5432",
        user= "postgres",
        password ="postgres"
    )
    
    return conn

@app.route("/cerca_vendita", methods=['POST','GET'])
def cerca_vendita(): 
    print("ricevuta richiesta di vendita")
    data = request.get_json()
    stato = data.get('stato', None)
    filiale = data.get('filiale_proponente', None)

    query = "Select *  from case_in_vendita Where 1=1"
    
    parametri =[]
    if stato:
        query += "and stato = %s"
        parametri.append()
    if filiale:
        query += "and filiale_proponente = %s"
        parametri.append()
    
    conn = db_connect()
    cursor = conn.cursor()
    cursor.execute(query,parametri)
    result = cursor.fetchall()
    conn.close()
    
    return jsonify(result)

@app.route("/vendi_casa", methods=['GET','POST'])
def vendi_casa():
    data = request.get_json()
    catastale = data['catastale']
    filiale_proponente = data['filiale_proponente']
    filiale_venditrice = data['filiale_venditrice']
    prezzo_vendita = data['prezzo_vendita']
    data_vendita = data['data_vendita']

    conn = db_connect()
    cursor = conn.cursor()

    cursor.execute("""
    insert into vendita_casa (catastale, data_vendita , filiale_proponente, filiale_venditrice, prezzo_vendita)
    values(%s, %s, %s, %s, %s)
    """)

    conn.commit()
    conn.close()
    return jsonify({"message": "Casa venduta con successo!"})
    
    






if __name__ == '__main__':
    app.run()