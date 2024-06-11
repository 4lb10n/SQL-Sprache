

-- Auskommentiert


-- Select Befehle

SELECT getdate();


-- Select mit Objectangaben
-- * beschreibt alles was sich in der Tabelle befindet

SELECT * FROM lieferant;

SELECT lname FROM lieferant;

SELECT lname, lstadt FROM lieferant;
-- Selcect (Was soll angezeit werden) from (Tabelle= woher soll er die Infio bekommen.)

-- where- klause

SELECT * FROM artikel
WHERE farbe = 'rot';
-- Alle roten artikel werden angezeigt

-- gesucht sind alle lieferungen mit einer Liefermenge von 300 st�ck
SELECT * FROM lieferung
WHERE lmenge = '300';

-- gesucht sind alle lieferranten die in Hamburg wohnen
SELECT * FROM lieferant
WHERE lstadt= 'Hamburg';

-- gesucht sind die Namen und die Lieferantennummer alles Lieferanten die un Ludwifshafen wohnen
SELECT lname, lnr FROM lieferant
WHERE lstadt= 'Ludwigshafen';

-- alternativ kann man sich auch zus�tzlich die Stadt anzeigen lassen, es gibt keinen Punktabzug bie der IHK

SELECT lname, lnr, lstadt FROM lieferant
WHERE lstadt= 'Ludwigshafen';

-- gescuht sind alle Lieferungen vom 09.08.1990

SELECT * FROM lieferung
WHERE ldatum ='09.08.1990';


-- Vergleichsoperatoren

-- alle leiferungen mit einer liefermenge von mindestens 200 St�ck
SELECT * FROM lieferung
WHERE lmenge >= '200';

-- gesucht sind alle Lieferanten deren Status kleiner als 30 ist
SELECT * FROM lieferant
WHERE status < '30';

-- Schl�sselwort BETWEEN
-- wird mt dem Operator AND benutzt

-- gescuth sind alle Lieferungen die zwischen dem 01.08.90 und dem 31.08.90 durchgef�hrt wurden
SELECT * FROM lieferung
WHERE ldatum BETWEEN '01.08.1990' AND '31.08.1990';

-- Gesucht sind alle Artikelnamen der Artikel mit einem Gewicht von 14 bis 17 gramm
SELECT aname, gewicht FROM artikel
WHERE gewicht BETWEEN '14' AND '17';

-- alle Namen und Wohnorte der Lieferanten, die an einem Ort dessen Namen mit H bis L beginnen
SELECT lname, lstadt FROM lieferant
WHERE lstadt BETWEEN 'H' AND 'Lz';

-- Schl�sselwort IN
-- ermittelt, ob ein bestimmter Spaltenwert mit einem Wert aus der Unterabfrage oder Liste �bereinstimmt

-- gesucht sind die Namen der Hamburger und Aachner Lieferanten

-- ohne IN
SELECT lname, lstadt FROM lieferant
WHERE lstadt = 'Hamburg' OR lstadt= 'Aachen';

-- IN Operator
SELECT lname, lstadt FROM lieferant
WHERE lstadt IN ('Hamburg', 'Aachen')

-- Gesucht sind alle Lieferungen von 100, 300 oder 400 St�ck
SELECT * FROM lieferung
WHERE lmenge IN ('100','300','400');

-- gesucht sind alle Roten und gr�nen Artikel
SELECT * FROM artikel
WHERE farbe IN ('rot', 'gr�n');

-- oder
SELECT * FROM artikel
WHERE farbe='rot' OR farbe='gr�n';


SELECT * FROM lieferant
WHERE lstadt ='Ludwigshafen' AND status='30';

-- gesucht sind alle Artikel die nicht rot oder gr�n sind
SELECT * FROM artikel
WHERE farbe NOT IN ('rot', 'gr�n');

-- gesucht sind alle Lieferungen die nicht zwischen dem 01.08.90 und dem 31.08.90 duchgef�hrt wurden
SELECT * FROM lieferung
WHERE ldatum NOT BETWEEN '01.08.1990' AND '31.08.1990';



------------------------------------------------------------------------------------
-- Schl�sselwert LIKE

SELECT * FROM artikel
WHERE aname LIKE 'S%';

-- gesucht sind alle artikel deren an zweiter stelle ein o haben
SELECT * FROM artikel
WHERE aname LIKE '_o%';

-- gesucht sind alle Artikel deren Namen Vorletzer Stelle ein l haben
SELECT * FROM artikel
WHERE aname LIKE '%l_';

-- gescuht sind alle Lieferanten deren Namen mit dem Bzchenstaben B bis J beginnen
SELECT * FROM lieferant
WHERE lname LIKE '[B-J]%';

-- -- gescuht sind alle Lieferanten deren Namen mit dem Bzchenstaben B oder J beginnen
SELECT * FROM lieferant
WHERE lname LIKE '[BJ]%';
-- oder

SELECT * FROM lieferant
WHERE lname LIKE '[B,J]%';

-- gesucht sind alle Lieferanten in deren Namen kein a vorkommt
SELECT * FROM lieferant
WHERE lname NOT LIKE '%a%';

-- �bungsaufgaben

-- Gesucht sind die Nummern, die Namen und der Status aller Lieferanten die in Ludwigshafen leben
SELECT lnr, lname status FROM lieferant
WHERE lstadt ='Ludwigshafen';

-- Gesucht sind alle Lieferungen zwischen dem 13.07.90 und dem 25.07.90
SELECT * FROM lieferung
WHERE ldatum BETWEEN '18.07.1990' AND '25.07.1990';

-- Gesucht sind alle roten Artikel die mit dem Bucstaben S beginnen.
SELECT * FROM Artikel
WHERE AName LIKE 's%' AND farbe= 'rot';

------------------------------------------------------------------------------------------
-- Arbeiten mit NULL
-- NULL wei�t darauf hin, dass ein Wert unbekannt ist.
-- NULL-Werte weisen in der Rrgel auf Daten hin, die unbekannt, nicht zutreffend oder zu einem
-- sp�teren Zeitpunkt hinzugef�gt werden sollen

INSERT INTO lieferant VALUES('L06', 'Zinke', '10', 'Erfurt');
INSERT INTO lieferant VALUES('L07', 'Hustensaft', NULL,NULL);

SELECT * FROM lieferant;

-- mehrere Bedingungen in der Where Klausel

-- Gescuht sind alle Artikel die �ber 16 gram wiegen, mehrals 700 st�ck gelagert sind und deren Standort mit E-L beginnt
SELECT * FROM artikel
WHERE gewicht > '15' AND amenge >'700' AND astadt like '[E-L]%';



DELETE FROM lieferant WHERE lnr = 'LO7';

-- Entfernt doppleter Reihen aus dem Ergebnis

SELECT lnr FROM lieferung;
-- Ergebnis sind 12 Datens�tze

SELECT DISTINCT lnr FROM lieferung;
-- Ergbnis sind 4 Datens�tze

-- Distinct wirkt sich auf den ganzen Datensatz der Ergebnissumee aus
-- darum wird es nur einmal unmittelbar nach dem SELECT angegeben
-- Die gleichheit wird �ber alle in der SELECT-Liste angegebenen Spalten �berpr�ft

-----------------------------------------------------------------------------------
-- Sortieren von Ergebnissen mit ORDER BY
SELECT aname, farbe, astadt FROM artikel;


SELECT aname, farbe, astadt FROM artikel
ORDER BY aname ASC;

-- ASC (ascending) aufsteigend
-- DESC (decending) absteigend

SELECT aname, farbe, astadt, amenge FROM artikel
ORDER BY amenge ASC;

-- Sortieren nach Spaltennamen

SELECT aname AS 'Artikelname', farbe AS 'Artikelfarbe', astadt AS 'Lagerort' FROM artikel
ORDER BY Artikelname ASC;

-- Reine Info
-- Sortieren in der deutschen Telefonbuchsortierung
SELECT aname, farbe, astadt FROM artikel
ORDER BY aname, astadt COLLATE German_Phonebook_CI_AS ASC;

 ----------------------------------------------------------------------------------------------

 -- Auflisten der TOP n Werte

 -- Gesucht sind die drei Lieferungen mit dem h�chsten Liefermengen
 SELECT TOP(3) lnr, ldatum, lmenge FROM lieferung
 ORDER BY lmenge DESC;

-- gesucht sind alle Werte der vier Lieferanten mit dem H�chsten Status
SELECT TOP(4) * FROM lieferant
ORDER BY status DESC;

-- gesucht sind alle Werte der vier Lieferanten mit dem niedrigsten Status
SELECT TOP(4) * FROM lieferant
ORDER BY status ASC;

---------------------------------------------------------------------------------
--Korrelierte Abfrage

-- gesucht sind alle Lieferanten die mehr als 2 mal geliefert haben
SELECT * FROM lieferant
WHERE 2 < (SELECT COUNT(*)FROM lieferung
			WHERE lieferant.lnr = lieferung.lnr);

-- gesucht sind die Artikelnummer und der Artikelname aller Artikel die am 18.05.90 ausgeliefert wurde
SELECT anr, aname FROM artikel
WHERE anr = (SELECT anr FROM lieferung
			WHERE ldatum = '18.05.1990');


-- �bungsaufgaben
-- 1. gesucht sind alle Artikel die mehr als 13 grasm wiegen
SELECT aname, gewicht, anr FROM artikel
WHERE Gewicht >= 13;

-- 2. gescuht sind alle Lieferanten die kein B in Ihrem Namen TRAGEN
SELECT lname FROM lieferant
WHERE lname NOT LIKE '%b%';

-- 3. gescuht sidn alle Lieferungen die Zwischen dem 06.08.90 und dem 21.08.90 stattgefunden haben
SELECT * FROM lieferung
WHERE ldatum BETWEEN '06.08.1990' AND '21.08.1990';

-- 4. gescuht sind alle Artikel die nicht rot oder blau sind
SELECT * FROM artikel
WHERE farbe NOT IN ('rot','blau');

-- 5. gescuht sind Artikel die mit Buchstabe e enden
SELECT * FROM artikel
WHERE aname LIKE '_%e';

-- 6. gesucht sind alle Artikel die ein c an zweiter stelle im Namen Tragen
SELECT * FROM artikel
WHERE aname LIKE '_c%';

-- 7. gescuht sind alle Artikel die mehr als 15 gramm wiegen oder deren Menge gr��er als 600 ist
SELECT * FROM artikel
WHERE gewicht > '15' OR amenge > 600;
