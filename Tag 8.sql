-- 19.06.24

-- Addition von Mengen mit UNION Kompatibilität
-- zwischen beiden Mengen muss UNION- Kompatibilität existieren
-- das bedeutet gleiche Anzahl von Spalten und Datentypen der zu addierenden
-- Spalten muss kompatibel sein

-- UNION eliminiert automatisch doppelte Datensätze im Ergebnis

-- Alle Orte in denen Lieferanten wohnen oder in denen Artikel lagern.
SELECT lstadt FROM lieferant
UNION
SELECT astadt FROM artikel;

-- alle Datensätze des Ergebis anzeigen
SELECT lstadt FROM lieferant
UNION ALL
SELECT astadt FROM artikel;

SELECT lstadt AS 'Orte' FROM lieferant
UNION ALL
SELECT astadt FROM artikel;


-- Minux mit EXCEPT

-- Gesucht sind alle Wohnorte von Lieferanten in dennen keine Artikel gelagert sind
SELECT lstadt FROM lieferant
EXCEPT
SELECT astadt FROM artikel;

SELECT astadt FROM artikel
EXCEPT
SELECT lstadt FROM lieferant

-- Schnittmenge mit INTERSECT

-- Gesucht sind alle Orte wo Lieferanten wohnen, aber auch Artikel gelagert werden.
SELECT lstadt AS 'Orte' FROM lieferant
INTERSECT
SELECT astadt FROM artikel;

------------------------------------------------------------------------------------
-- zahlen runden

-- Modulo gibt den Ganzzahligen Divisionsrest zurück
SELECT 5 % 2;

SELECT ROUND(23.775, 1);		-- eine Stelle nach dem Komma
SELECT ROUND(23.775, 2);		-- zwei Stelle nach dem Komma
SELECT ROUND(23.775, -1);		-- eine Stelle vor dem Komma

--------------------------------------------------------------
SELECT lnr, lname, DATALENGTH(lname) FROM lieferant;
-- verwendeten Bytes


SELECT lnr, lname, LEN(lname) FROM lieferant;
-- Anzahl der Zeichen

-- Wo befindet ich mich?
SELECT HOST_ID();
SELECT HOST_NAME();

SELECT USER_NAME();
SELECT SUSER_NAME();

SELECT NEWID();		-- Global Unique Identifier

-------------------------------------------------------------------
-- Datumsformate

SELECT GETDATE();
SELECT DAY(GETDATE());
SELECT MONTH(GETDATE());
SELECT YEAR(GETDATE());

-- den letzen Tag des Monats im angegebenen Datum
SELECT EOMONTH('23.03.2024');

SELECT @@DATEFIRST;

SET lANGUAGE us_english;

SELECT @@DATEFIRST;
SET lANGUAGE german;

-- Datumsberechnung
SELECT DATEADD(dd, 70,GETDATE());

-- Zahlungsziel 35 Tage nach lieferdatum
SELECT lnr, ldatum, DATEADD(dd, 35,ldatum) AS 'Zahlungsziel' FROM lieferung;

-- Vor wie vielen MOnaten waren die Lieferungen
SELECT lnr, ldatum,	DATEDIFF(MM, ldatum, GETDATE())FROM lieferung;

SELECT DATENAME(YY,GETDATE());
SELECT DATENAME(DW,GETDATE());
SELECT DATENAME(MM,GETDATE());

SELECT anr AS 'Artikelnummer', lmenge AS 'Liefermenge', 
DATENAME(DW, ldatum) + ' der ' + DATENAME(DD,ldatum) + '. ' + DATENAME(MM,ldatum)
+ DATENAME(YY, ldatum) AS 'Lieferdatum'
FROM lieferung
ORDER BY ldatum ASC;

-- Übungsaufgaben

-- 1. Ortsnamen, die Wohnort aber keine Lagerorte sind
-- 2. Nummern und Bezeichnung aller Artikel, deren durchschnittliche Liefermenge
-- größer als die von A02 ist
-- 3. Nummern, Namen und Wohnorte der Lieferanten, die bereits mindestens einmal geliefert haben
--	  und deren Status größer als der kleinste Lieferstatus aller Lieferanten ist
-- 4. Namen und Nummern der Lieferanten, die mindestens 3 verschiedene Artikel geliefert haben
-- 5. Lagerorte der Artikel die von Lieferant L04 ausgeliefert wurden
-- 6. Schreibe eine Abfrege die folgenden Satz ausgibt:
--    Das Zahnrad mit der Artikelnummer A06 ist rot und wird in Hamburg gelagert.

-- 1:
SELECT a.lstadt FROM lieferant a JOIN artikel b
ON a.lstadt=b.astadt
WHERE a.lstadt<>b.astadt
GROUP BY a.lstadt;

--Lösung



-- 2:
SELECT a.anr, aname FROM artikel a JOIN lieferung b
ON a.anr=b.anr
GROUP BY a.anr ,a.aname
HAVING AVG(lmenge) > (SELECT AVG(lmenge) FROM lieferung
						WHERE anr = 'A02');

-- 3:
SELECT a.lnr, lname, lstadt FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
WHERE lmenge = '1' AND status < (SELECT MIN(status) FROM lieferant);

--lösung
SELECT lnr, lname,lstadt FROM lieferant
WHERE lnr IN (SELECT lnr FROM lieferung)
AND status > (SELECT MIN(status) FROM lieferant);

-- 4:
SELECT a.lnr, lname FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
WHERE;

-- lösung
SELECT lname, lnr FROM lieferant
WHERE lnr IN (SELECT lnr FROM lieferung
				GROUP BY lnr
				HAVING COUNT(DISTINCT anr) >= '3');

-- 5:
SELECT a.astadt FROM artikel a JOIN lieferung b
ON a.anr=b.anr
WHERE lnr = 'L04';

-- 6:
SELECT 'Das '+aname + ' mit der Artikelnummer ' + anr + ' ist ' + farbe +'und wird in '+ astadt + ' gelagert.' FROM artikel
WHERE anr = 'A06';
						
