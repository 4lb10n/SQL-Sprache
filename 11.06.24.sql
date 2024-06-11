
-- SQL 11.06.2024

-- Übungsaufgaben zu LIKE, IN, BETWEEN

--1. Schreibe zwei Abfragen (BETWEEN, IN), die alle Lieferungen vom 05.08.90. bzw. 06.08.90 ausgeben
--2. Schreibe eine Abfrage die die Nummer und Namen aller roten oder blauen Artikel aus Hamburg 
--ausgibt sowie die Artikel die eine Lagermenge zwischen 900 und 1500 Stück haben
--3. Schreibe eine Abfrage die alle Lieferanten ausgibt, deren Namen mit A oder S beginnen
--4. Schreibe eine Abfrage die die Namen, Lieferantennummern und den Status aller Lieferanten
-- ausgibt, die im August 1990 ausgeliefert haben und in Ludwigshafen leben.

--1:
SELECT * FROM lieferung
WHERE ldatum BETWEEN '05.08.1990' AND '06.08.1990';

SELECT * FROM lieferung
WHERE ldatum IN ('05.08.1990' , '06.08.1990');

--2:
SELECT anr, aname  FROM artikel
WHERE farbe= 'rot' OR farbe= 'blau' AND astadt LIKE 'Hamburg' OR 
amenge BETWEEN '900' AND '1500';

--3:
SELECT * FROM lieferant
WHERE lname LIKE '[A,S]%';

--4:
SELECT lnr, lname, status FROM Lieferant
WHERE lstadt = 'Ludwigshafen' AND lnr IN (SELECT lnr FROM lieferung
											WHERE ldatum BETWEEN '01.08.1990' AND '31.08.1990');


-- CASE-Funktionen

-- Vergelicht einen Ausdruck mit mehreren einfachen Ausdrücken um das Ergebnis zu bestimmen
-- wird in der Select abfrage eingefügt

SELECT anr, aname, amenge, CASE astadt
								WHEN 'Hamburg' THEN 'lagert in Hamburg'
								WHEN 'Ludwigshafen' THEN 'lagert in Ludwigshafen'
								ELSE 'lagert an einem anderen ort'
								END AS 'Lagerorte'
FROM artikel;


SELECT lnr, anr, CASE
					WHEN lmenge BETWEEN '0' AND '100' THEN 'hätte mehr draufgepast'
					WHEN lmenge BETWEEN '101' AND '300' THEN 'Gut ausgelastet'
					ELSE 'Anzeige ist raus du birne'
					END AS 'Liefermengennotiz'
FROM lieferung;

SELECT anr, aname, astadt, CASE
							WHEN amenge BETWEEN '0' AND '400' THEN 'nachbestellen'
							WHEN amenge BETWEEN '401' AND '1000' THEN 'Lagervoll'
							ELSE 'ins Angebot nehmen'
							END AS 'Lagerbestand'
FROM artikel;

----------------------------------------------------------------------------------
-- Berechnen der Ergebnismengen

-- + addieren
-- - subrahieren
-- * multiplizieren
-- / dividieren
-- % (Modulo) gibt denn ganzzahligen rest einer Division aus.

SELECT gewicht * 0.001 AS 'Gewicht in Klogramm' FROM artikel;

SELECT lnr , ldatum, lmenge + 200 AS 'Neue Liefermenge' FROM lieferung
WHERE lnr= 'L03';


SELECT anr, astadt, amenge / 200 AS 'Restmenge' FROM artikel
WHERE anr= 'A05';
-- Ergbnis 6 = 1300/200 = 6 ganze

SELECT anr, astadt, amenge % 200 AS 'Restmenge' FROM artikel
WHERE anr= 'A05';
-- Ergbnis 100 | % zeigt den ganzzahligen Rest 1300/200= 6 Rest= 100

-- der Operator + kann auch für das verketten von Zeichenfolgen verwendet werden
-- fügt zwie Zeichenfoglen aneinander

SELECT 'Der Lieferant ' + lname + 'wohnt in ' + lstadt FROM lieferant
-- Ausgabe: DEr Lieferant Schmidt wohnt in Hamburg


SELECT 'Die ' + aname + ' mit der Artikelnummer' + anr +' ist' +  farbe + 
'und wird in' + astadt + 'gelagert'
FROM artikel
WHERE anr= 'A03';
-- Ausgabe: Die Schraube mit der Artikelnummer A03 ist blau und wird in Mannheim gelagert.

-------------------------------------------------------------------------------------------
-- Übungsaufgabe
--1. Die nummern und namen aller Artikel und ihr gewicht in KG
--2. Artikelnummer, Name und Lagerort aller Artikel die am 23.7.90 versendet wurden
--3. Nummern und Namen der Lieferanten, deren Status kleiner als der von Lieferant L03 ist.
--4. die Liefeermenge und das Lieferdatum an dem rote Muttern versendet wurden
--5. Die Daten aller lieferungen von Liferranten aus Hamburg
--6. Namen und nummern aller lieferanten, die nicht den A05 geliefert haben

-- 1:
SELECT anr, aname, gewicht * 0.001 AS 'Gewicht in Kg' FROM artikel;

-- 2:
SELECT anr, aname ,astadt FROM artikel
WHERE anr = (SELECT anr FROM lieferung
				WHERE ldatum = '23.07.1990');

-- 3:
SELECT lnr, lname FROM lieferant
WHERE status < (SELECT status FROM lieferant
					WHERE lnr = 'L03');

-- 4:
SELECT lmenge, ldatum, anr FROM lieferung
WHERE anr IN (SELECT anr FROM artikel
			WHERE farbe = 'rot' AND aname ='Mutter');

-- 5:
SELECT * FROM lieferung
WHERE lnr IN (SELECT lnr FROM lieferant
				WHERE lstadt = 'Hamburg');

-- 6
SELECT lnr, lname FROM lieferant
WHERE lnr NOT IN(SELECT lnr FROM lieferung
				WHERE anr = 'A05');

---------------------------------------------------------------------------------------------
-- Einsatz von Aggregatfunktionen

-- AVG (average) Durschnitt der Spaltenwerte
-- MAX größter Spaltenwert
-- MIN kleinster Spaltenwert
-- SUM Summe der nummerischen Spalten
-- COUNT Anzahl der Spaltenwerte

-- der Nach der Alphabetischen Reihnfolge erster Lieferant
SELECT MIN(lname) FROM lieferant;

-- größten, kleinsten und den durchschnitts status aller Lieferranten
SELECT MAX(status) AS 'Maximum', MIN(status) AS 'Minimum', AVG(status) AS 'Durchschnitt' FROM lieferant;

--- Anzahl aller bisherigen Lieferungen, die Lieferanten durchgeführt haben
SELECT COUNT(*) FROM lieferung;

SELECT COUNT(lnr) FROM lieferung;

-- Aggregatfunktionen dürfen nicht miteinader verschachtelt werden
SELECT COUNT(MAX(status)) FROM lieferant;
-- Geht nicht!
-- folgende Meldungen wird ausgegeben:
-- Eine Aggregatfunktion kann auf einem Ausdruck, der ein Aggregat oder eine Unterabfrage enthält, nicht ausgeführt werden.

-- Übungen
--1. Namen des Artikels mit dem höchsten Lagerbestand
--2. Die durchschnittsmenge aller gelagerten artikel
--3. Den kleinsten Status aller Lieferanten
--4. Die größte Liefermenge aller lieferungen

--1:
SELECT MAX(amenge) AS 'Höhste Lagermenge' FROM artikel;

--2:
SELECT AVG(amenge) AS 'durchschnittliche Lagermenge' FROM artikel;

--3:
SELECT MIN(status) AS 'kleinster Status' FROM lieferant;

--4:
SELECT MAX(lmenge) AS 'Max Liefermenge' FROM lieferung;

-- GROUP BY- Klausel
-- legt Spalten fest, über die Gruppen gebildet werden

-- gesucht sind die kleinste Liefermenge eines jeden Lieferanten
SELECT lnr, MIN(lmenge) FROM lieferung
GROUP BY lnr;

-- ist in der SELECT anweisung eine WHERE klausesel enthalten, werden alle Zeilen,
-- die diese nichterfüllen, von dee Gruppenbildung eliminiert

-- gescuht ist die größte Lieferung eines jeden Lieferanten nach dem 23.07.90
SELECT lnr, MAX(lmenge) AS 'Liefermenge' FROM lieferung
WHERE ldatum > '23.07.1990'
GROUP BY lnr ORDER BY 'Liefermenge' ASC;

SELECT lnr AS 'Lieferant', COUNT(*) AS 'Anzahl' FROM lieferung
WHERE ldatum > '23.07.1990'
GROUP BY lnr;