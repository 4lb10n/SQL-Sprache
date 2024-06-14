-- 14.06.24

-- Einfügen von Daten
-- INSERT INTO Befehl ohne nähere definition der Daten
-- muss die Spaltenreihenfolge und der Datentyp übereinstimmt

-- In der Reinfolge
INSERT INTO lieferant VALUES('L07','Gaspricki', '40', 'Erfurt');

SELECT * FROM lieferant;

-- veränderte Reihenfolge
INSERT INTO lieferant (lstadt,lnr,lname,status)
VALUES ('Mordor','L08','Gollum','30');

-- unbekannte Werte aufnehmen
INSERT INTO lieferant VALUES ('L10', 'Aragon','10',NULL);

-- oder
INSERT INTO lieferant (lnr,lname) VALUES ('L09', 'Frodo');


--- Ändern von Daten
-- einfache UPDATE Anweisung

-- Lieferant L08 heißt jetzt Golle
UPDATE lieferant SET lstadt = 'Gondor'
WHERE lnr= 'L08';

-- ändern des Status der Lieferanten, die nach dme 13.08.90 geliefert haben
UPDATE lieferant SET status= status + 10
FROM lieferant , lieferung
WHERE lieferant.lnr=lieferung.lnr
AND ldatum >= '13.08.1990';

-- ändern des Status in abhängigkeit mehrerer Faktoren
UPDATE lieferant 
SET status= CASE WHEN status BETWEEN '0' AND '10' THEN status * 2.0
				WHEN status BETWEEN '11' AND '20' THEN status * 1.3
				WHEN status BETWEEN '21' AND '30' THEN status * 1.4
				ELSE status * 1.
				END;

SELECT * FROM lieferant;

-- löschen von Daten

-- löschen des Fahrers Aragon
DELETE FROM lieferant
WHERE lname='Aragon';

-- löschen aller Lieferanten die in Gotha
DELETE FROM lieferant
WHERE lstadt= 'Gotha';

-- löschen aller lieferungen des lieferanten 

-- damit wir sie löschen können geben wir ihm erst eine lieferung Golle
INSERT INTO lieferung VALUES ('L08', 'A02','300', '19.05.1990');

SELECT * FROM lieferung;

-- löschén seiner lieferungen
DELETE FROM lieferung
WHERE lnr= (SELECT lnr FROM lieferant
			WHERE lname= 'Golle');

-- kleine Übungsaufgabe
-- Schreibe zwei verschiedene Abfragen die alle Lieferanten ausgibt, deren
-- Namen mit S, C, oder B, beginnen und deren dritter Buchstabe ein a ist.

SELECT * FROM lieferant
WHERE lname LIKE '__a%' AND lname LIKE '[S,C,B]%';

SELECT * FROM lieferant
WHERE lname LIKE '[S,C,B]%' AND lname IN (SELECT lname FROM lieferant
											WHERE lname LIKE '__a%');


-- große Übungsaufgabe
/*
1. Lieferannummern und Namen, die alle artikel geliefert haben
2. Nummern, Namen und Wohnort der Lieferanten, die bereits geliefert haben
	und deren status größer als der kleinste status aller lieferanten ist
3. Nummern und namen aller artikel, deren durchschnittliche liefermegne kleiner als die von artikel A03 ist
4. Lieferantennamen und nummern , Artikelname und artikelnummer aller lieferungen
	die seit dem 05.05.1990 von Hamburger lieferanten durchgeführt wurden
*/

-- 1:
SELECT a.lnr, a.lname FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
GROUP BY a.lname
HAVING COUNT;

SELECT lnr FROM lieferung
WHERE lnr IN (SELECT lname FROM lieferant)
GROUP BY anr
HAVING COUNT(lname);

-- Lösung

SELECT a.lnr, a.lname FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
GROUP BY a.lnr, a.lname
HAVING COUNT(b.anr)= (SELECT COUNT(anr) FROM artikel);

-- 2:
SELECT DISTINCT a.lnr, lname, lstadt FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
WHERE b.lmenge >1 AND a.status > (SELECT AVG (status) FROM lieferant);

--Lösung
SELECT DISTINCT a.lnr, lname, lstadt FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
WHERE b.lmenge >1 AND a.status > (SELECT MIN (status) FROM lieferant);

-- 3:
SELECT DISTINCT a.anr,aname FROM artikel a 
JOIN lieferung b ON a.anr=b.anr
GROUP BY a.anr, aname 
HAVING AVG(lmenge) < (SELECT avg(lmenge)
					FROM lieferung 
					WHERE anr= 'A03');

-- oder 

SELECT anr, aname FROM artikel 
WHERE anr IN (SELECT anr FROM (
SELECT anr, AVG(lmenge) avglmenge FROM lieferung GROUP BY anr) verweis
WHERE avglmenge<(SELECT AVG(lmenge) FROM lieferung 
WHERE anr ='A03'));

-- 4:
SELECT a.lname, a.lnr, c.aname, c.anr FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr JOIN artikel c ON b.anr=c.anr
WHERE a.lstadt ='Hamburg' AND b.ldatum BETWEEN '05.05.1990' AND '31.12.1990';

--oder
SELECT a.lnr, a.lname, c.anr, c.aname FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr JOIN artikel c
ON b.anr=c.anr
WHERE b.ldatum >='05.05.1990'
AND a.lstadt='Hamburg';

/*
5. Ortsnamen die Wohnort aber kein Lagerort sind
6. Ortsnamen die sowohl Wohn- als auch Lagerort sind
7. Nummern aller Lieferanten, die mindestens einen Artikel geliefert haben
	den auch Lieferant L03 geliefert hat
*/

-- 5:
SELECT DISTINCT lstadt FROM lieferant 
WHERE lstadt NOT IN (SELECT astadt FROM artikel);

-----------------------------------------------

SELECT lstadt FROM lieferant
WHERE lstadt NOT IN (SELECT astadt FROM artikel);

SELECT lstadt FROM lieferant
WHERE NOT EXISTS (SELECT * FROM artikel
					WHERE lstadt= astadt);

-- 6: 
SELECT DISTINCT a.lstadt FROM lieferant a JOIN artikel b
ON a.lstadt=b.astadt
WHERE a.lstadt=b.astadt;

------------------------------------------------

SELECT DISTINCT lstadt FROM lieferant
WHERE lstadt IN (SELECT astadt FROM artikel);

SELECT * FROM lieferant;
SELECT * FROM artikel;

-- 7:
SELECT lnr FROM lieferung
WHERE; 

--------------Lösung
SELECT a.lnr FROM lieferung a, lieferung b
WHERE a.anr=b.anr
AND b.lnr='L03'
AND a.lnr<> 'L03';
