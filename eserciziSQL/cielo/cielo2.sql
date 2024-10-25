°1
SELECT a.codice ,  a.nome , 
COUNT(DISTINCT ap.comp) AS numero_compagnie
FROM ArrPart as ap
JOIN Aeroporto as a ON (a.codice = ap.arrivo OR a.codice = ap.partenza)
GROUP BY a.nome , a.codice;

#2
select count(ap.comp) as num_voli
from arrpart as ap , volo as v
where ap.partenza = 'HTR'
and ap.codice = v.codice 
and v.durataminuti >= 100

#3
SELECT la.nazione AS nazione, COUNT( distinct a.codice) AS num_aerop
FROM Volo v
JOIN ArrPart ap ON v.codice = ap.codice AND v.comp = ap.comp
JOIN Aeroporto a ON (a.codice = ap.arrivo OR a.codice = ap.partenza)
JOIN LuogoAeroporto la ON la.aeroporto = a.codice
WHERE v.comp = 'Apitalia'
GROUP BY la.nazione

#4
select avg(durataminuti) as media ,
min(durataminuti) as minimo,
max(durataminuti) as massimo
from volo
where comp = 'MagicFly'

#5
SELECT a.codice ,	a.nome , MIN(c.annoFondaz) AS anno
FROM Aeroporto as a
JOIN ArrPart as ap ON a.codice = ap.arrivo OR a.codice = ap.partenza
JOIN Volo as v ON ap.codice = v.codice AND ap.comp = v.comp
JOIN  Compagnia as c ON v.comp = c.nome
GROUP BY a.codice, a.nome

#6
SELECT la1.nazione,
    COUNT(DISTINCT la2.nazione) AS raggiungibili
FROM ArrPart as ap
JOIN Aeroporto as a1 ON a1.codice = ap.partenza
JOIN LuogoAeroporto as la1 ON la1.aeroporto = a1.codice
JOIN Aeroporto as a2 ON a2.codice = ap.arrivo
JOIN LuogoAeroporto as la2 ON la2.aeroporto = a2.codice
GROUP BY la1.nazione

#7
select distinct a.codice , 
a.nome , 
avg(v.durataminuti) as media_durata
from aeroporto as a , ArrPart as ap , Volo as v
where a.codice = ap.partenza and ap.codice = v.codice
group by a.codice , a.nome 

#8
select c.nome , 
sum(v.durataminuti) as durata_tot
from compagnia as c , Volo as v 
where c.annofondaz >= 1950 
and c.nome = v.comp
group by c.nome

#9
SELECT a.codice ,a.nome
FROM ArrPart ap
JOIN Aeroporto a ON (a.codice = ap.arrivo OR a.codice = ap.partenza)
JOIN Volo v ON ap.codice = v.codice AND ap.comp = v.comp
GROUP BY a.codice, a.nome
HAVING COUNT(DISTINCT v.comp) = 2

#10
SELECT la.citta 
FROM LuogoAeroporto la
JOIN Aeroporto a ON la.aeroporto = a.codice
GROUP BY la.citta
HAVING COUNT(DISTINCT a.codice) >= 2


#11
SELECT v.comp AS compagnia
FROM Volo as v
GROUP BY v.comp
HAVING 
AVG(v.durataMinuti) > 360

#12
SELECT v.comp AS compagnia
FROM Volo v
GROUP BY v.comp
HAVING  MIN(v.durataMinuti) > 100