import requests
import json

# URL del server
BASE_URL = 'http://127.0.0.1:5000'

# Funzione per cercare case in vendita
def cerca_case_vendita(stato=None, filiale=None):
    data = {
        'stato': stato,
        'filiale_proponente': filiale
    }
    response = requests.post(f'{BASE_URL}/cerca_vendita', json=data)
    if response.status_code == 200:
        return response.json()
    else:
        print("Errore nella richiesta:", response.status_code)
        return None

# Funzione per vendere una casa
def vendi_casa(catastale, filiale_proponente, filiale_venditrice, prezzo_vendita, data_vendita):
    data = {
        'catastale': catastale,
        'filiale_proponente': filiale_proponente,
        'filiale_venditrice': filiale_venditrice,
        'prezzo_vendita': prezzo_vendita,
        'data_vendita': data_vendita
    }
    response = requests.post(f'{BASE_URL}/vendi_casa', json=data)
    if response.status_code == 200:
        print(response.json())
    else:
        print("Errore nella richiesta:", response.status_code)

# Funzione per ottenere statistiche di vendite e affitti
def statistiche(data_inizio, data_fine):
    data = {
        'data_inizio': data_inizio,
        'data_fine': data_fine
    }
    response = requests.post(f'{BASE_URL}/statistiche', json=data)
    if response.status_code == 200:
        print("Statistiche:", response.json())
    else:
        print("Errore nella richiesta:", response.status_code)

# Esempio di utilizzo del client
if __name__ == '__main__':
    # 1. Cerca case in vendita (utilizza i dati che abbiamo inserito nel DB)
    case = cerca_case_vendita(stato='LIBERO', filiale='IT12345678901')  # Filiale IT12345678901 (Via Roma, 10)
    print("Case trovate:", case)
    
    # 2. Vendi una casa (utilizza un codice catastale valido)
    vendi_casa('C1234567890', 'IT12345678901', 'IT23456789012', 250000.00, '2024-01-10')  # Casa venduta
    
    # 3. Ottieni statistiche (utilizza un periodo di tempo valido)
    statistiche('2024-01-01', '2024-12-31')  # Statistiche per l'anno 2024
