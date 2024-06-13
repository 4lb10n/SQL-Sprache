-- SQL 12.06.24

-- Having- Klause

-- HAVING ist die WHERE Klause für Gruppen
-- HAVING selektiert Gruppen die duch GROUP BY definiert werden.

-- In der HAVING Klausel dürfen keine Aggregatfunktionen stehen
-- In der HAVING Klausel fürfen nicht nur Konstanten sondern 
-- in Unterabfragen dürfen wiederum auch Aggregatfunktionen enthalten sein

-- Gesucht ist der größte Lieferantenstatus des jeweiligen wohnortes von Lieferanten die nicht
-- aus AAchen kommnen, wnn der durchschnittliche Statuswert am jeweiligen Ort
-- nicht kleiner als 15 ist

SELECT MAX(status), lstadt FROM lieferant
WHERE  lstadt <> 'Aachen'
AND AVG(status) > '15'
GROUP BY lstadt;
-- Diese Abgrage ist falsch
-- In der WHERE-Klausel darf kein Aggregat auftreten, es sei denn, es befindet sich in einer Unterabfrage, die in einer HAVING-Klausel oder einer Auswahlliste enthalten ist, und die Spalte, die aggregiert wird, ist ein äußerer Verweis.

SELECT MAX(status), lstadt FROM lieferant
WHERE lstadt <> 'Aachen'
GROUP BY lstadt
HAVING AVG(status) > '15';

-- Für argumente von HAVING gilt: Sie dürfen nur einen Wert pro ausgegebener
-- Gruppe als Ergbnis liefern

-- Nicht in jeder Abfrage macht eine Having Klausel in der GROUP BY Klausel besser
SELECT lnr, MAX(lmenge) FROM lieferung
GROUP BY lnr
HAVING anr= 'A02';
-- nicht erlaubt

-- besser wäre
SELECT lnr, MAX(lmenge) FROM lieferung
WHERE anr= 'A02'
GROUP BY lnr;

-- ES gibt keine Beschränkung betzüglich der Anzahl von Bedingungen in den
-- Suchbedingungne der HAVING Klausel

SELECT SUM(lmenge), lnr FROM lieferung
GROUP BY lnr
HAVING MIN(lmenge) > '200' AND AVG(lmenge) < '1300';


-- generelle Übungsaufgaben
/*
1. Schreibe eine Abfrage die folgenden Satz ausgibt:
	In Mannheim müssten noch 400 ARtikel mit der farbe blaue lagern.
2. Schreibe eine Abfrage die den Namen und den Status aller Lieferanten anzeigt,
	die im Juli 1990 geliefert haben.
3. Schreibe eine Abfrage die den folgenden Artikel in die Tablle einfügt
	ein gelber Bolzen mitr einem Gewicht von 13 Gramm
4. Gescuht sind alle Namen, Nummern und gewicht aller Artikel die am 23.07. versendet wurden. 
5. Gesucht sind alle Wohnorte von Lieferanten, die mit H bis L beginnen.
*/

-- 1:
SELECT 'In' + astadt + ' müssen noch ', amenge,
+ ' Artikel mit der Farbe' + 'lagern.'
FROM artikel
WHERE anr = 'A03';

-- 2:
SELECT lname, lnr, status FROM lieferant
WHERE lnr IN (SELECT lnr FROM lieferung
				WHERE ldatum BETWEEN '01.07.1990' AND '31.07.1990');

-- 3:
INSERT INTO artikel VALUES('A07', 'Bolzen', 'gelb', '13' ,NULL, NULL);
DELETE FROM artikel WHERE anr= 'A07';
-- 4:
SELECT aname, anr, gewicht FROM artikel
WHERE anr IN (SELECT anr FROM lieferung
				WHERE ldatum = '23.07.1990');

-- 5:
SELECT DISTINCT lstadt FROM lieferant
WHERE lstadt LIKE '[HL]%';

/*
6.Gesucht ist die Menge aller grünen Artikel, minus die 200
	die wir bereits verplant aber noch nicht versendet haben.

7. Gesucht sind alle Liefertan mit dem höchsten Status
8. Gesucht ist das durchschnittliche Gewicht aller Artikel
9. Gesucht ist die größte Lieferung jedes Lieferanten,
	die nach dem 23.7.90 stattgefunden hta und deren durchschnittliche Liefermenge mindestens 250 beträgt.
10. Gesucht ist der kleinste Status des jeweiligen Wohnortes von 
	Lieferantem die nicht aus Erfurt kommen, wenn der Durchschnittliche
	Statuswert am jeweiligen Ort nicht kleiner ist als 12
*/

-- 6:
SELECT aname, amenge - '200' FROM artikel
WHERE farbe= 'grün';

-- 7:
SELECT MAX(status) AS 'Höchster status' FROM lieferant;

SELECT lname FROM lieferant
WHERE status IN (SELECT MAX(STATUS) from lieferant);

-- 8:
SELECT AVG(gewicht) AS 'durchschnitts Gewicht' FROM artikel;

-- 9 
SELECT MAX(lmenge) FROM lieferung
WHERE ldatum > '23.07.1990'
HAVING MIN(lmenge) = '250'

SELECT lnr, MAX(lmenge) FROM lieferung
WHERE ldatum >'23.07.1990'
GROUP BY lnr
HAVING AVG(lmenge) >= '250'

-- 10
SELECT lstadt, MIN(status) FROM lieferant
WHERE lstadt NOT LIKE 'Erfurt'
HAVING AVG(status) < 12;

SELECT lstadt, MIN(status) FROM lieferant
WHERE lstadt <> 'Erfurt'
GROUP BY lstadt
HAVING AVG(status) >= 12;


-- Unterabfragen

-- ist eine Abfrage innerhalb einer anderen Abfrage. Die erste Abfrage wird obere oder Äußere
-- Abfrage genannt. Alle darunter liegenden werden als unter oider auch innere Abfragen bezeichnet.

-- Bei diesen Abfragen wird immer zuerst die innere und danach die Äußere Abfrage ausgeführt

-- Gesucht sidn die lieferanten, die in der selben Stadt leben, in Artikel A02 gelagert wird
SELECT * FROM lieferant
WHERE lstadt = (SELECT astadt FROM artikel
					WHERE anr = 'A02');

-- gesucht sind die Lieferanten, deren Status über den durschnittlichen
-- Status aller Lieferanten liegt
SELECT * FROM lieferant
WHERE status > (SELECT AVG(status) FROM lieferant);

-- einfache Unterabfraghen mit IN
-- es kommt vor, dass eine innere Abfrage nicht genau einen Wert als Ergebnis ausgibnt.
-- Dieser Vergleich muss mit IN stattfinden

-- gesucht sind alle Angaben über Lieferanten, die bereits geliefert haben
SELECT * FROM lieferant
WHERE lnr IN (SELECT lnr FROM lieferung);


-- Unterabfragen in der SELECT-Liste

-- Gesucht sind die Nummern, Namen, gewicht und das durchschnittsgewicht aller Artikel
-- sowie die Differenz des Gewichtes jedes einzelnen Artikels zum Durchschnittsgewicht aller Artikel

SELECT anr, aname, gewicht, (SELECT AVG(gewicht) FROM artikel) AS 'Durschnittsgewicht',
		gewicht - (SELECT AVG(gewicht) FROM Artikel) AS 'Differenz'
FROM artikel;

-- korrelierte abfragen mit bezeichneten Tabellen

-- gesucht sind die Lieferanten, die mindestens dreimal geliefert haben
SELECT * FROM lieferant a
WHERE 3 <= (SELECT COUNT(*) FROM lieferung b
							WHERE a.lnr = b.lnr);


-- Die Operatoren ANY und ALL
-- ALL bedeutet "größer als jeder Wert"
-- ANY bedeutet "größer als mindestens ein Wert"

-- gesucht sind alle Artikel deren gewwicht größer als jeders Gewichrt der Artikel aus Ludwiegshafen
SELECT * FROM artikel
WHERE gewicht > (SELECT MAX (gewicht) FROM artikel
						WHERE astadt= 'Ludwigshafen');

-- Mit ALL benötigt man Befehl MAX(geicht) nicht mehr
SELECT * FROM artikel
WHERE gewicht >ALL (SELECT MAX (gewicht) FROM artikel
						WHERE astadt= 'Ludwigshafen');

-- gesucht sind die artikel, deren gewicht mindestens ein Gewicht
--	der Artikel aus Ludwigshafen ist
SELECT * FROM artikel
WHERE gewicht > ANY (SELECT gewicht FROM artikel
						WHERE astadt = 'Ludwigshafen');
--oder
SELECT * FROM artikel
WHERE gewicht > (SELECT MIN(gewicht) FROM artikel
						WHERE astadt = 'Ludwigshafen');


-- Generelle Übungsaufgaben
/*
1. Gesucht ist der Name, Nummer von allen Artikeln.
	Zudem soll die Menge der Artikel bewertet werden. Bis 600 Artikel
	soll nachbestellt werden, bis 1000 soll es unbedingt verkauft 
	werden, bis 1200 sollen sie verschenkt werden. Alle Artikel mit
	einem Bestand über 1200 sollen weggeworfen werden.

2. Schreibe eine Abfrage die das aktuelle Datum ausgibt.

3. Gesucht sind die Namen aller Lieferanten aus Aachen mit einem
	Statuswert zwischen 20 und 30

4. Gesucht sind die Namen und Nummern aller Artikel, deren Gewicht
	12, 14 oder 17 gramm beträgt.

5. Gesucht ist der Statuswert aller Lieferanten, die am 5.8.90 und 
	6.8.90 ausgeliefert haben.
	*/
-- 1:
SELECT aname, anr, amenge FROM artikel
WHERE amenge IN (SELECT amenge FROM artikel
						WHERE amenge= '600');

--lösung
SELECT anr, aname, CASE WHEN amenge BETWEEN '0' AND '600' THEN 'Nachbestellen'
						WHEN amenge BETWEEN '601' AND '1000' THEN 'Verkaufen'
						WHEN amenge BETWEEN '1001' AND '1200' THEN 'verwschenken'
						ELSE 'wegwerfem'
						END AS 'Bewertung'
FROM artikel;

-- 2:
SELECT GETDATE() AS 'Datum';

-- 3:
SELECT lname FROM lieferant
WHERE status BETWEEN '20' AND '30' AND lstadt= 'Aachen';

-- 4:
SELECT aname, anr FROM artikel
WHERE gewicht IN  (12,14,17);

-- 5:
SELECT status FROM lieferant
WHERE lnr IN (SELECT lnr FROM lieferung
				WHERE ldatum BETWEEN '05.8.90' AND '06.08.90');

--------------------------------------------------------------------
-- EXISTS UND NOT EXISTS
-- Die bedingun für den Prüfsatz der äußeren Abfragen wird als Wahr ausgewertet
-- wenn die innere Abfrage zumindest eine Ergebnisreihe liefert

-- Die innere Abfrage ist immer von einere Variable(Spalte) abhängig,
-- die in äußeren Abfrage berechnet wird

-- gesucht sind Ortsnamen, die Wohnort aber nicht Lagerort sind.
SELECT lstadt FROM lieferant
WHERE NOT EXISTS (SELECT * FROM artikel
					WHERE lstadt=astadt);

-- gesucht sind Lieferranten, die bereits geliefert haben
SELECT * FROM lieferant
WHERE EXISTS (SELECT * FROM lieferung
				WHERE lieferant.lnr=lieferung.lnr);

-- Die Tabellen können einmalig bezeichnet werden um lieferant.lnr nicht schreiben zu müssen
SELECT * FROM lieferant a
WHERE EXISTS (SELECT * FROM lieferung b
				WHERE a.lnr=b.lnr);
