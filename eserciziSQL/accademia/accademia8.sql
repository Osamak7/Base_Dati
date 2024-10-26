#1
select distinct p.id , p.nome , p.cognome
from persona p 
join assenza ass on ass.persona = p.id
full join Attivitanonprogettuale anp on anp.giorno = ass.giorno 
full join AttivitaProgetto atp on atp.giorno = ass.giorno 
group by p.id , p.nome, p.cognome
having count (anp.giorno) = 0
and count (atp.giorno)= 0


#2
WITH nPeg AS (
    SELECT atp.persona
    FROM attivitaProgetto atp
    JOIN progetto pg ON pg.id = atp.progetto
    JOIN progetto pg2 ON pg2.nome = 'Pegasus'
    WHERE atp.giorno BETWEEN pg2.inizio AND pg2.fine
)
SELECT DISTINCT p.id, p.nome, p.cognome
FROM persona p
LEFT JOIN nPeg ON p.id = nPeg.persona
WHERE nPeg.persona IS NULL
ORDER BY p.id ASC;

#3
