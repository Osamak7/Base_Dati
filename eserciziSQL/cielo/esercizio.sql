#1
select codice, comp
from Volo
where durataminuti > 180
#2
select distinct comp
from Volo
where durataminuti > 180
#3
select codice, comp
from ArrPart 
where partenza ='CIA'
#4
select distinct comp
from arrPart 
where arrivo ='FCO'
#5
select distinct codice , comp
from arrPart 
where partenza ='FCO' 
and arrivo ='JFK'
#6
select distinct  comp
from arrPart 
where partenza ='FCO' 
and arrivo ='JFK'
#7
SELECT DISTINCT v.comp
FROM Volo v
JOIN ArrPart ap ON v.codice = ap.codice AND v.comp = ap.comp
JOIN LuogoAeroporto laPart ON ap.partenza = laPart.aeroporto
JOIN LuogoAeroporto laArr ON ap.arrivo = laArr.aeroporto
WHERE laPart.citta = 'Roma' AND laArr.citta = 'New York';
#8
SELECT DISTINCT a.codice, a.nome, la.citta
FROM Volo v
JOIN ArrPart ap ON v.codice = ap.codice AND v.comp = ap.comp
JOIN Aeroporto a ON ap.partenza = a.codice
JOIN LuogoAeroporto la ON a.codice = la.aeroporto
WHERE v.comp = 'MagicFly';

#9
SELECT v.codice, v.comp, ap.partenza ,ap.arrivo
FROM Volo v
JOIN ArrPart ap ON v.codice = ap.codice AND v.comp = ap.comp
JOIN Aeroporto aPart ON ap.partenza = aPart.codice
JOIN LuogoAeroporto laPart ON aPart.codice = laPart.aeroporto
JOIN Aeroporto aArr ON ap.arrivo = aArr.codice
JOIN LuogoAeroporto laArr ON aArr.codice = laArr.aeroporto
WHERE laPart.citta = 'Roma'
AND laArr.citta = 'New York';

#10
