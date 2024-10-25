#1
with ap_ita as (select ap.codice
from arrpart ap , luogoaeroporto lap
where lap.nazione = 'Italy'
and lap.aeroporto = ap.partenza
)
select v.comp compagnia, avg(v.durataminuti) durata_media
from volo v , ap_ita ap
where ap.codice = v.codice
group by v.comp
order by v.comp

#2
