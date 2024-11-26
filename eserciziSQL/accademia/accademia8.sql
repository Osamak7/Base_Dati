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
select p.id, p.nome, p.cognome 
from Persona p
join Progetto pr on p.id = pr.