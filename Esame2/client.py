import requests , json , sys
import psycopg2

BASE_URL = "localhost"

def cerca_case_vendita(stato=None , filiale=None):
    data ={
        "stato": stato,
        "filiale_proponente": filiale
    }
    response = requests.post(f"{BASE_URL}/cerca_vendita",json= data)
    if response.status_code == 200:
        return response.json()
    else:
        print("errore nella richiesta: ",response.status_code)
        return None
    
def vendi_casa(catastale , filiale_proponente, filiale_venditrice, prezzo_vendita, data_vendita):
    data = {
        "catastale" : catastale,
        "filiale_proponente": filiale_proponente,
        "filiale_venditrice" : filiale_venditrice,
        "prezzo_vendita" : prezzo_vendita,
        "data_vendita" : data_vendita
    }
    response = requests.post(f"{BASE_URL}/vendi_casa", json=data)
    if response.status_code == 200:
        print(response.json())
    else:
        print("Errore nella richiesta:", response.status_code)
    
def statistiche(data_inizio, data_fine):
    data = {
        "data_inizio": data_inizio , 
        "data_fine": data_fine
    }
    response = requests.post(f"{BASE_URL}/statistiche" , json=data)
    if response.status_code == 200:
        print("Statistiche: ",response.json())
    else:
        print("Errore nella richiesta:", response.status_code)
    
    