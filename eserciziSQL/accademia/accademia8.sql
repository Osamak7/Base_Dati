#1
select p.id, p.nome, p.cognome
from persona p
EXCEPT 
	(select p.id, p.nome, p.cognome
	from persona p  
	join assenza ass on ass.persona = p.id
	left join AttivitaProgetto atp on atp.giorno = ass.giorno and ass.persona = atp.persona
	left join AttivitaNonProgettuale anp on anp.giorno = ass.giorno and ass.persona = anp.persona
	where atp.id is not null or anp.id is not null)
order by id asc

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

with max_stip as(
select  max(p.stipendio) as stipendio
from persona p
where posizione = 'Professore Associato' 
or posizione = 'Professore Ordinario'
)
select p.id , p.nome, p.cognome, p.stipendio
from persona p , max_stip m
where p.stipendio > m.stipendio

#4
with media_budget as (
select avg(budget) as budget
from progetto
),
media_sup as (select pg.id
from progetto pg, media_budget mb
where pg.budget > mb.budget)

select p.id, p.nome, p.cognome
from persona p , attivitaProgetto atp , media_sup ms
where p.id = atp.persona and ms.id = atp.progetto

#5
#v1.1
WITH media_budget AS (
    SELECT AVG(p.budget) AS budget, AVG(atp.oredurata) AS media
    FROM progetto p
    JOIN Attivitaprogetto atp ON atp.progetto = p.id
)
SELECT DISTINCT pg.id, pg.nome
FROM progetto pg
JOIN media_budget mb ON TRUE
JOIN Attivitaprogetto atp ON atp.progetto = pg.id
WHERE pg.budget < mb.budget
AND atp.oredurata > mb.media
AND atp.tipo = 'Ricerca e Sviluppo'

#v1.2
WITH media_budget AS (
    SELECT AVG(p.budget) AS budget, AVG(atp.oredurata) AS media
    FROM progetto p
    JOIN Attivitaprogetto atp ON atp.progetto = p.id
)
SELECT DISTINCT pg.id, pg.nome
FROM progetto pg
JOIN media_budget mb ON TRUE
JOIN Attivitaprogetto atp ON atp.progetto = pg.id
WHERE pg.budget < mb.budget
AND atp.oredurata > mb.media
AND atp.tipo::text LIKE 'Ricerca%'
order by pg.id asc




