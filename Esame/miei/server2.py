from flask import Flask , request , jsonify
import psycopg2

app = Flask(__name__)

def conn_db():
    conn = psycopg2.connect(
        host = 'localhost',
        port = 5432,
        user = 'postgres',
        password = 'postgres',
        db_name = 'esame'
    )
    return conn

@app.route('/cerca_vendita', methods=['GET','POST'])
def cerca_case():
    data = request.get_json()
    stato= data.get('stato',None)
    filiale= data.get('filiale_proponente',None)

    query = "Select * from case_in_vendita where 1==1"#inserisco il where1==1
    #perche è sempre vero e cosi mi permette di concatenare altre parti in seguito con and

    conn = conn_db()
    cursor = conn.cursor()
    
    # su parametri appendiamo i valori che si sostituiranno alle %s nella query attraverso il cursore
    parametri= []  

    # controllo lo stato e le filiali
    if stato: 
        query += "and stato = %s" #aggiungo solo che sara una stringa in mofo da evitare sql injection 
        parametri.append(stato) 
    if filiale:
        query += "and filiale_proponente = %s" #stesso discorso di stato
        parametri.append(filiale)

    cursor.execute(query,parametri)
    result = cursor.fetchall()
    conn.close() 
    return jsonify(result)


if __name__ == '__main__':
    app.run()