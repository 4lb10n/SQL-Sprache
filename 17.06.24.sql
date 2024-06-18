-- 17.06.24

-- OFFSET FETCH

-- übungen zu TOP Klausel

-- Gesucht sind die Drei Lieferungen mit den höchsten Liefermengen
SELECT TOP(3) lmenge, lnr, anr, ldatum FROM lieferung
ORDER BY lmenge DESC;

-- Mit OFFSET gibt man an, wieviele Datensätze übersprungen werden sollen bevor ein Ergebnis
-- ausgegeben wird

-- FETCH gibt die Anzahl der Zeilen an, die zurückgebenen werden sollen, nachdem OFFSET
-- verarbeitet wurde

-- gesucht sind die stärksten Lieferungen nach den ersten drei starken Lieferungen
SELECT a.lnr, lname, lmenge FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr 
ORDER BY lmenge DESC
OFFSET 3 ROWS FETCH NEXT 5 ROWS only;

SELECT * FROM lieferung;


-- Datumsfunktion

-- year				yy,yyyy
-- quarter			qq,q
-- month			mm,m
-- dayofyear		dy,y
-- day				dd,d
-- week				wk,ww
-- hour				hh
-- minute			mn,n
-- second			ss,s
-- milliesecond		ms

-- Datumsfunktionen können in der SELECT anweisung Überall stehen, wo ausdrücke entstehen können
-- Datumangaben werden in Hochkommas gesetzt

-- gesucht sind die artikel nummern, das lieferdatum und möglihce Zahlungsziel (30 Tage)
SELECT anr, ldatum, DATEADD(DD,30,ldatum) AS 'Zahlungsziel' FROM lieferung;




-- Rangfolgefunktion RANK

-- patition by
-- teilt das von der FROM Klausel erzeugte ergebnis, in Partitionen auf, die die
-- RANK funktion angewendet wird

-- ORDER BY
-- bestimmt die Reinfolge, in der die RANK Werte sortiert werden

-- Die Rangfolge der Lieferanten anhand der Gesamliefermenge, mit Lücken
SELECT a.lnr, lname, RANK() OVER (ORDER BY SUM(lmenge) DESC) AS 'Rang',
SUM(lmenge) AS 'Gesamtliefermenge'
FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
GROUP BY a.lnr,lname;

-- Rangofgefunktion NTILE

-- Verteilt die Zeilen in einer sortierten Partition in eine angegebene Anzahl von Gruppen

-- Bildung von Lieferantenbereichen und Zuordnungen der jeweiligen gelieferten Artikel
-- ensprechend der Liefermenge

SELECT NTILE(4) OVER(PARTITION BY aname ORDER BY lmenge) AS 'Kategorie',
aname, lmenge FROM artikel a JOIN lieferung b
ON a.anr=b.anr
ORDER BY aname;


-- Rangfolgefunltion ROW_NUMBER

-- gibt die fortlaufende Nummer einer Zeile innerhalb einer Partition zurück.
-- Sie kann mit oder ohne PARTITION BY Klausel verwendet werden

-- Zeilennummern für jeden Lieferanten
SELECT ROW_NUMBER() OVER(ORDER BY lnr DESC) AS'row number', lnr,lname, lstadt
FROM lieferant;

-- Die Order BY Klausel bestimmt die Reihenfolge, in der die Zeilen eine eindeutige
-- ROW_NUMBER innerhalb der angegebenen Partition zugewiesen wird.

---------------------------------------------------------------------------------------

-- Temporäre Tabellen

-- Lokale temporäre Tabellenn, können von jeden Datenbanknutzer erstellt werden.
-- Sie sind nur in der aktuellen Sitzung verfügbar

-- Die temporäre Tabelle gute_lieferanten soll erstellt werden, mit allen Lieferanten
-- deren Status 30 oder höher ist
SELECT lnr, lname INTO #gute_lieferanten FROM lieferant
WHERE status >= '30';

SELECT * FROM #gute_lieferanten;

-- lokale temporäre Tabellen # tabellenname
-- globale temporäre Tabellen ## tabellenname


/*
Übungsaufgaben

1. Lieferantennummern und Namen der Lieferanten, 
	die 3 verschiedene Artikel geliefert haben
2. Nummern, Namen und Wohnort der Lieferanten, die bereits
	geliefert haben und deren Statuswert größer als der
	durchschnittliche Statuswert aller Lieferanten ist.
3. durchschnittliche Liefermenge des Artikels "A01"
4. Anzahl der Lieferungen roter Artikel, die seit dem 05.05.90 
	durchgefüht wurden
5. Nummern, Namen, und Wohnorte der Lieferanten, deren Status kleiner
	als der von Lieferant L03 ist
*/
-- 1:
SELECT a.lnr, a.lname 
FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
GROUP BY a.lnr, a.lname
HAVING COUNT(DISTINCT b.lnr) = '3';

-- oder
SELECT DISTINCT a.lnr, lname FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
AND '3' = (SELECT COUNT(anr) FROM lieferung
			WHERE b.lnr= lnr GROUP BY lnr);

-- 2: 
SELECT DISTINCT a.lnr, a.lname, a.lstadt FROM lieferant a JOIN lieferung b
ON a.lnr=b.lnr
WHERE a.status > (SELECT AVG(status) FROM lieferant);


-- 3:
SELECT AVG(lmenge) FROM lieferung
WHERE anr = 'A01';

-- 4:
-- falschen
SELECT DISTINCT a.lnr, c.lname FROM lieferung a JOIN artikel b
ON a.anr=b.anr JOIN lieferant c
ON a.lnr=c.lnr
WHERE farbe ='rot' AND ldatum >= '05.05.90';

-- Lösung 
SELECT COUNT (a.anr) FROM lieferung a JOIN artikel b
ON a.anr=b.anr
WHERE farbe = 'rot'
AND ldatum >= '05.05.1990'

-- 5: 
SELECT lnr, lname, lstadt FROM lieferant
WHERE status < (SELECT status FROM lieferant
							WHERE lnr='L03');

-- oder 
SELECT a.lnr, a.lname, a.lstadt FROM lieferant a JOIN lieferant b
ON a.status <b.status
AND b.lnr='L03';