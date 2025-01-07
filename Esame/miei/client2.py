import requests ,json

BASE_URL= 'localhost'

def cerca_case_vendita(stato=None , filiale=None ): # controllo lo stato e la filiale 
    data ={
        'stato' : stato,
        'filiale_proponente' : filiale
    }
    risposta = requests.post(f"{BASE_URL}/cerca_vendita", json= data)#gli passo in formato json data al server in base all'url
    if risposta.status_code == 200: #200 va bene per get e post significa che la richiesta e andata a buon fine 
        return risposta.json()
    else:
        print("Errore nella richiesta: ", risposta.status_code)
        return None
    
print("che operazione vuoi fare \n 1 = scrittura")
operazione = int(input("inserisci l'operazione desiderata: "))
if operazione == 1:
    stato = input("inserisci lo stato dell'immobile o None se non ne hai uno")