-- 18.06.24

-- Übungsaufgaben
/*
1. Nummern und Namen aller Lieferanten, die mindestens zwei verschiedene Artikel geliefert haben.
2. Nummern, Namen und Status aller Lieferanten,
	die schon einmal geliefert haben, aber den Artikel A05 nicht lieferten.
3.Die Daten aller Lieferanten, die alle Artikel mindestens einmal lieferten.
4. Anzahl der Lieferungen, die seit dem 01.06.1990 von Lieferanten aus Ludwigshafen
	durchgeführt wurden
5. Gesantlieferemenge aller Lieferungen des Artikel A01 durch den Lieferanten L02
*/

-- 1:
SELECT DISTINCT a.lnr, lname FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
AND (SELECT COUNT(DISTINCT anr) FROM lieferung
				WHERE a.lnr=lnr) >= '2';

-- oder
SELECT DISTINCT b.lnr, a.lname FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
GROUP BY b.lnr, a.lname
HAVING COUNT(anr) > '1';

-- oder
SELECT lnr, lname FROM lieferant
WHERE lnr IN (SELECT DISTINCT lnr FROM lieferung
				GROUP BY lnr, anr
				HAVING COUNT (anr)<= '2');
-- 2:
SELECT DISTINCT a.lnr,lname status FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
WHERE b.anr NOT LIKE 'A05';

-- oder
SELECT DISTINCT a.lnr, lname, status FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
WHERE b.lnr NOT IN (SELECT lnr FROM lieferung
						WHERE anr = 'A05');
-- oder
SELECT lnr, lname, status FROM lieferant
WHERE lnr NOT IN (SELECT lnr FROM lieferung
					WHERE anr = 'A05')
AND lnr in (SELECT lnr FROM lieferung);

-- 3:
SELECT * FROM lieferung
WHERE anr LIKE 'A0%' AND lmenge >= '1';

-- lösung
SELECT a.* FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
GROUP BY a.lnr, lname, status, lstadt
HAVING COUNT(DISTINCT anr) = (SELECT COUNT(anr) FROM artikel);


-- 4:
SELECT COUNT (*) FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
WHERE lstadt = 'Ludwigshafen' AND ldatum >= '01.06.1990';

-- 5:
SELECT SUM(lmenge) AS 'Gesamtmenge' FROM lieferung
WHERE lnr = 'L02' AND anr = 'A01';

-- Wiederholungsaufgaben
/*
1. Die Daten aller Lieferanten aus Aachen
2. Die Nummern, Namen und Lagerorte aller gelieferten Artikel
3. Die Nummern, und ´namen aller artikel sowie ihr Gewicht in KG
4. Die Daten aller Lieferanten, mit eionem Status zwischen 20 und 40
5. Die Namen und das Gewicht aller Artikel, wenn ihr Gewicht 17 oder 19 gramm beträgt
6.Artikelnamen und Artikelnummern sowie die Lieferantennummer mit Übereinstimmenden
	Wohn und Lagerort
7. Nummern und Namen aller Lieferanten, die die selben Arikel wie Lieferant L03 geliefert haben
8. Durchschnittliche Liefermenge des Artikels A01
9. Lagerorte der Artikel, die von Lieferanten L02 ausgeliefert wurden
10. Die Namen aller Orte die Lagerort und Wohnort zugleich sind.
*/

-- 1:
SELECT * FROM lieferant
WHERE lstadt = 'Aachen';

-- 2:
SELECT anr, aname, astadt FROM artikel
WHERE anr IN (SELECT anr FROM lieferung);

-- 3:
SELECT anr, aname, gewicht * 0.001 AS 'Gewicht in Kg' FROM artikel;

-- 4:
SELECT * FROM lieferant
WHERE status BETWEEN '20' AND '40';

-- 5:
SELECT aname, gewicht FROM artikel
WHERE gewicht = '17' OR gewicht = '19';

-- 6:
SELECT aname, anr, lnr, lname FROM artikel a, lieferant b
WHERE a.astadt=b.lstadt;

-- 7:
SELECT a.lnr, lname FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
WHERE anr IN (SELECT anr FROM lieferung
				WHERE lnr= 'L03')
AND a.lnr <>'L03';

-- 8:
SELECT AVG(lmenge) AS 'Durchschnittliche Lagermenge' FROM lieferung
WHERE anr = 'A01';

-- 9:
SELECT astadt FROM artikel a JOIN lieferung b
ON a.anr=b.anr
WHERE lnr ='L02';

-- 10:
SELECT DISTINCT lstadt FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr 
JOIN artikel c ON b.anr=c.anr
WHERE lstadt = astadt;
