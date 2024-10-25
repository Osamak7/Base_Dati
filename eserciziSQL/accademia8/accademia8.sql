#1
select  p.id, p.nome, p.cognome
from Persona p 
join Assenza ass on ass.persona = p.id 
full outer join attivitaProgetto atp on  atp.persona = ass.persona
full outer join attivitaNonProgettuale anp on anp.persona = ass.persona
where atp.persona is null and anp.persona is null 
order by p.id asc

#2
select p.id, p.nome, p.cognome 
from Persona p
join Progetto pr on p.id = pr.