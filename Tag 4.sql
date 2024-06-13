-- 13.06.24

-- Verknüpfen von Tabellen - JOIN

-- Man unterscheidet in drei arten von Verknüpfungen
-- Innere Verknüpfung (INNER JOIN)
-- Äußere Verknüpfung (OUTER JOIN)
-- Kreuzverknüpfung (CROSS JOIN)

-- JOIN Typen
-- CROSS JOIN		-kennzeichnet das Kartesische Produkt
-- (INNER) JOIN		-kennzeichnet die natürliche Verknüpfung zweier Tabellen

-- LEFT (OUTER) JOIN - linke Außenverknüpfung
-- RIGHT (OUTER) JOIN - rechte Außenverknüpung
-- FULL (OUTER) JOIN - eine Kombination beider Außenverknüpfungen



-- CROSS JOIN

-- das kartesiche Produkt zwischen den TAbellen lieferant und lieferung
SELECT * FROM lieferant CROSS JOIN lieferung;

SELECT * FROM lieferant, lieferung;

-- INNER JOIN

-- Beim INNER JOIN werden zwei oder mehrere Tabellen über zwei spalten miteinander verknüpft
-- DER IINER JOIN ist die Standardvariante und wird oft nur mit JOIN abgekürzt

SELECT * FROM lieferung a JOIN lieferant b
ON b.lnr=a.lnr;

SELECT * FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr JOIN artikel c ON b.anr=c.anr;

-- gesucht sind die nummern und Namen der Lieferanten die geliefert haben

SELECT DISTINCT a.lnr, lname FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr;

-- ohne JOIN
SELECT lnr, lname FROM lieferant
WHERE EXISTS (SELECT * FROM lieferung
				WHERE lieferant.lnr=lieferung.lnr);

-- gesucht sind lieferanten und Ihre lieferung
SELECT * FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr;

SELECT * FROM artikel a JOIN lieferant b
ON a.astadt=b.lstadt;

-- gesucht sind die lieferanen, die einer stadt wohnen, in welcher auch andere
-- lieferranten wohnen
SELECT a.* FROM lieferant a JOIN lieferant b
ON a.lstadt=b.lstadt
AND a.lnr<>b.lnr;

--- OUTER JOIN

-- LEFT JOIN beinhaltet sämtliche Reihen der zuerst (linken) genannten Tabelle, 
-- sowie die Reihe der zweiten (rechten) Tabelle die die Verknüpfung

-- gesucht sind alle lieferanten und die von ihnen ausgeführten Lieferungen
-- Es sollen abner auch die lieferanten angezeigt werden, die noch geliefert haben
SELECT a.*, anr, lmenge, ldatum FROM lieferant a LEFT JOIN lieferung b
ON a.lnr=b.lnr;


-- RIGHT JOIN beinhaltet sämtliche Reihen der zuerst (rechts) genannten Tabelle, 
-- sowie die Reihe der zweiten (linken) Tabelle die die Verknüpfung

-- gesucht sind alle lieferungen und Lieferanten, die diese Liefrung durchgeführt haben.
-- Weiterhin sollen alle Lieferungen angezeigt werden, für die kein Lieferant existiert
SELECT a.*, lname, status, lstadt FROM lieferung a RIGHT JOIN lieferant b
ON a.lnr=b.lnr;

-- FULL JOIN

-- beinhaltet smätlichen Reihen der linken und rechten Tabelle
-- die die Bedingungen erfüllen aber auch die Reihen der linken und recheten Tabelle
-- die sie nicht erfüllen

-- gesucht sind alle Lieferanten und deren Lieferungen, außerdem sollen die Lieferanten
-- angezeigt werden, die noch nicht geliefert haben, aber auch die Lieferungen
-- für die es keine Lieferanten gibt

SELECT * FROM lieferant a FULL JOIN lieferung b
ON a.lnr= b.lnr;

-- Übungsaufgaben
/*
1. Nummern aller Lieferanten, die mindestens einen Artikel geliefert
	haben den auch Lieferant L03 geliefert hat.
2. Nummern aller Lieferanten, die mehr als eine Artikel geliefert haben
3. Nummern und Namen der Artikel, die am selben Ort wie Artikel A03 gelagert werden.
4. Durchschnittliche Liefermenge von Artikel A01
5. Gesamtliefermenge aller Lieferungen des Artikels A01 durch den
	Lieferanten L02
6. Lagerorte der Artikel, die von Lieferant L02 geliefert wurden
7. Nummern und Namen der Lieferanten, deren Status kleiner als der 
	von Lieferant L03 ist
8. Nummern und Namen aller Lieferanten, die den Artikel A05 nicht 
	geliefert haben.
*/

--1:
SELECT * FROM lieferant a JOIN artikel b
ON a.lstadt=b.astadt
WHERE b.anr='L03';

SELECT DISTINCT a.lnr FROM lieferung a JOIN lieferung b
ON a.anr=b.anr
WHERE b.lnr= 'L03'
AND a.lnr <> 'L03';

--2:
SELECT lnr FROM lieferung
GROUP BY lnr
HAVING COUNT(DISTINCT anr)>1;

--3
SELECT a.anr, b.aname FROM artikel a JOIN artikel b
ON a.astadt=b.astadt
AND a.anr ='A03';

--4:
SELECT AVG(lmenge) AS 'Durchschnittsmenge' FROM lieferung
WHERE anr='A01';

--5:
SELECT AVG(lmenge) AS 'Liefermenge' FROM lieferung
WHERE anr='A01' AND lnr='L02';

-- 6:
SELECT astadt FROM lieferung a JOIN artikel b
ON a.anr=b.anr
WHERE lnr='L02';

-- 7:
SELECT a.lnr, a.lname FROM lieferant a JOIN lieferant b
ON a.status < b.status
WHERE b.lnr = 'L03';

SELECT * FROM lieferant a JOIN lieferant b
ON a.status < b.status 
WHERE b.lnr = 'L03';

-- 8:
SELECT* FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
WHERE b.anr NOT LIKE 'A05';

SELECT lnr, lname FROM lieferant a
WHERE lnr  IN (SELECT lnr FROM lieferung b
					WHERE anr = 'A05');

SELECT lnr, lname FROM lieferant
WHERE lnr NOT IN (SELECT lnr FROM lieferung
					WHERE anr= 'A05');
-- oder ohne die Lieferanten die noch nicht geliefert haben
SELECT a.lnr, a.lname FROM lieferant AS a
WHERE EXISTS (SELECT b.lnr FROM lieferung AS b WHERE a.lnr=b.lnr)
AND a.lnr NOT IN (SELECT lnr FROM lieferung WHERE anr='A05');
