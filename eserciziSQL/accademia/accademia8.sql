#1
select  p.id, p.nome, p.cognome
from Persona p 
join Assenza ass on ass.persona = p.id 
full outer join attivitaProgetto atp on  atp.persona = ass.persona
full outer join attivitaNonProgettuale anp on anp.persona = ass.persona
where atp.persona is null and anp.persona is null 
order by p.id asc

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
