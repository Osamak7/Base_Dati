-- QUERY --;

select distinct cognome
from Persona;


-- QUERY2--;
select id, nome, cognome
from Persona
where posizione = 'Ricercatore';

--QUERY3--;
select id, nome, cognome
from Persona
where posizione = 'Professore Associato' and cognome like 'V%';

--query 4--
select id, nome, cognome
from Persona
where (posizione = 'Professore Associato' or posizione = 'Professore Ordinario') and cognome like 'V%';

--query 5--

select *
from Progetto
where fine < CURRENT_DATE;

--query 6 --
select id, nome
from Progetto
where fine < CURRENT_DATE
order by inizio asc;

--query 7--
select id,nome
from WP
where True
order by nome asc