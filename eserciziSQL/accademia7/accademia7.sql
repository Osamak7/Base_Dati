#1
select distinct posizione ,
avg (stipendio),  
stddev(stipendio) as dev_standard
from persona
group by posizione 

#2
with media_pos as (
select posizione , avg(stipendio) as media
from persona
group by posizione
)
select p.*
from persona as p
join media_pos m on p.posizione = m.posizione 
where p.posizione = 'Ricercatore' 
and p.stipendio > m.media

#3
WITH media_dev AS (
    SELECT posizione,
    AVG(stipendio) AS media,
    STDDEV(stipendio) AS deviazione
    FROM Persona
    GROUP BY posizione
)

SELECT p.posizione, COUNT(p.stipendio) AS numero
FROM Persona p
JOIN media_dev m ON p.posizione = m.posizione
WHERE p.stipendio >= (m.media - m.deviazione) 
    AND p.stipendio <= (m.media + m.deviazione)
GROUP BY p.posizione

#4
with atp as (
select persona , sum(oredurata) as oredurata
from AttivitaProgetto 
group by persona 
)
select p.* , atp.oredurata
from persona p
join atp on atp.persona = p.id
where atp.oredurata >= 20


#5
with dg as (
select nome , 
(fine - inizio) as durata_giorni
from progetto

)
select p.nome , dg.durata_giorni
from progetto as p 
join dg on dg.nome = p.nome 
where(select avg(dg.durata_giorni) from dg) < dg.durata_giorni




#6
-- nota
-- se si sostituisce '2014-12-31' con CURRENT_DATE
-- dice la data attuale ma restituisce una tabbella vuota poiche non esiste un progetto 
-- in data odierna e non combacia con il risultato richiesto
-- per questo ho messo la data piu vicina presente nel database 

select p.id ,
p.nome,
sum(atp.oredurata)
from progetto p
join attivitaprogetto atp on atp.progetto = p.id
and atp.tipo = 'Dimostrazione'
where fine >= '2014-12-31'
group by p.id , p.nome

#7
with ass as(
	SELECT persona , 
	count(giorno) as num_giorni_malattia
	FROM assenza
	where tipo = 'Malattia'
	group by persona

)
select p.id ,
p.nome,
p.cognome , 
ass.num_giorni_malattia
from persona p 
join ass on p.id = ass.persona
where posizione = 'Professore Ordinario'
and (select avg(num_giorni_malattia) from ass) < ass.num_giorni_malattia
