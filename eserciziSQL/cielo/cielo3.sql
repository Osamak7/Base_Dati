#1

select v.comp as compagnia ,
avg(v.durataminuti) as durata_minuti
from ArrPart ar,  LuogoAeroporto larp, volo v 
where v.codice = ar.codice
and ar.partenza = larp.aeroporto
and larp.nazione = 'Italy'
group by v.comp
order by v.comp asc

#2

WITH DurataTotale AS (
    SELECT AVG(durataMinuti) AS durata_media_totale
    FROM Volo
)
SELECT V.comp, AVG(V.durataMinuti) AS durata_media
FROM Volo V
GROUP BY V.comp
HAVING AVG(V.durataMinuti) > (SELECT durata_media_totale FROM DurataTotale);


#3
WITH ArriviPerCitta AS (
    SELECT LA.citta, COUNT(*) AS numero_arrivi
    FROM ArrPart AP
    JOIN Aeroporto A ON AP.arrivo = A.codice
    JOIN LuogoAeroporto LA ON A.codice = LA.aeroporto
    GROUP BY LA.citta
)
SELECT citta, numero_arrivi
FROM ArriviPerCitta
WHERE numero_arrivi > (SELECT AVG(numero_arrivi) FROM ArriviPerCitta);

###########################







#5

WITH StatisticheVoli AS (
    SELECT AVG(V.durataMinuti) AS durata_media_totale, STDDEV(V.durataMinuti) AS dev_std
    FROM Volo V
)
SELECT LA.citta, AVG(V.durataMinuti) AS durata_media
FROM Volo V
JOIN ArrPart AP ON V.codice = AP.codice AND V.comp = AP.comp
JOIN Aeroporto A ON AP.arrivo = A.codice
JOIN LuogoAeroporto LA ON A.codice = LA.aeroporto
GROUP BY LA.citta
HAVING ABS(AVG(V.durataMinuti) - (SELECT durata_media_totale FROM StatisticheVoli)) > (SELECT dev_std FROM StatisticheVoli);

#6

WITH CittaConVoliInternazionali AS (
    SELECT LA.citta, LA.nazione
    FROM ArrPart AP
    JOIN Aeroporto A1 ON AP.partenza = A1.codice
    JOIN LuogoAeroporto LA ON A1.codice = LA.aeroporto
    JOIN Aeroporto A2 ON AP.arrivo = A2.codice
    JOIN LuogoAeroporto LA2 ON A2.codice = LA2.aeroporto
    WHERE LA.nazione != LA2.nazione
    GROUP BY LA.citta, LA.nazione
)
SELECT nazione, COUNT(DISTINCT citta) AS num_citta
FROM CittaConVoliInternazionali
GROUP BY nazione
ORDER BY num_citta DESC;