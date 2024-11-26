#1

--Quali sono i voli di durata maggiore della durata media di tutti i voli della stessa
--compagnia? Restituire il codice del volo, la compagnia e la durata.

with med_c as (
select v.comp , avg(v.durataminuti) as durataminuti
from volo v
group by v.comp
)

select v.codice, v.comp , v.durataminuti
from volo v , med_c m
where v.durataminuti > m.durataminuti and m.comp = v.comp  