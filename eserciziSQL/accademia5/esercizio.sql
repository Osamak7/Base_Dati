#es1
select wp.nome , wp.inizio , wp.fine
from WP  
join Progetto pr on pr.id = wp.progetto 
and pr.nome = 'Pegasus'

#es2
select distinct p.nome , p.cognome, p.posizione 
from Persona p 
join AttivitaProgetto ap on ap.persona = p.id
join Progetto pr on pr.id = ap.progetto
where pr.nome = 'Pegasus' 
order by cognome desc

#3
select distinct p.nome, p.cognome, p.posizione
from Persona p
join AttivitaProgetto ap1 on ap1.persona = p.id
join AttivitaProgetto ap2 on ap2.persona = p.id 
join Progetto pr on pr.id = ap1.progetto
where pr.nome = 'Pegasus' 
and ap1.id <> ap2.id



#4
select distinct p.nome, p.cognome
from Persona p 
join Assenza a on p.id = a.persona 
where p.posizione = 'Professore Ordinario'
and a.tipo ='Malattia'

#5
select distinct p.nome, p.cognome
from Persona p 
join Assenza a1 on p.id = a1.persona 
join Assenza a2 on p.id = a2.persona 
where p.posizione = 'Professore Ordinario'
and a1.tipo ='Malattia'
and a1.id <>a2.id

#6
select distinct p.nome , p.cognome 
from Persona p 
join AttivitaNonProgettuale anp on anp.persona = p.id
where p.posizione = 'Ricercatore'

#7
select distinct p.nome , p.cognome 
from Persona p 
join AttivitaNonProgettuale anp1 on anp1.persona = p.id
join AttivitaNonProgettuale anp2 on anp2.persona = p.id
where p.posizione = 'Ricercatore'
and anp1.id <> anp2.id

#8
select distinct p.nome , p.cognome 
from Persona p 
join AttivitaNonProgettuale anp on anp.persona = p.id
join AttivitaProgetto ap on ap.persona = p.id
where ap.giorno = anp.giorno


#9
SELECT p.nome, p.cognome, ap.giorno, pr.nome , 
anp.tipo , ap.oreDurata , anp.oreDurata 
FROM Persona p
JOIN AttivitaProgetto ap ON p.id = ap.persona
JOIN Progetto pr ON ap.progetto = pr.id
join AttivitaNonProgettuale anp on anp.persona = p.id
where ap.giorno = anp.giorno


#10
select distinct p.nome , p.cognome 
from Persona p 
join assenza ass on ass.persona = p.id
join AttivitaProgetto ap on ap.persona = p.id
where ass.giorno = ap.giorno


#11
SELECT p.nome, p.cognome, ap.giorno, ass.tipo, pr.nome  , ap.oreDurata  
from Persona p 
join assenza ass on ass.persona = p.id
join AttivitaProgetto ap on ap.persona = p.id
JOIN Progetto pr ON ap.progetto = pr.id
where ass.giorno = ap.giorno


#12
SELECT distinct wp1.nome
FROM WP wp1, WP wp2
WHERE wp1.nome = wp2.nome
AND wp1.progetto <> wp2.progetto

