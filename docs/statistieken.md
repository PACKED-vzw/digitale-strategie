# Statistieken berekenen

## Doorlichting beelden Stad Hasselt

### Aantal beeldbestanden

Onderstaande query berekent het aantal beeldbestanden.

```sql
SELECT COUNT(filename) as 'aantal' FROM siegfried WHERE organisation = $organisation;
```

### Vereiste opslagcapaciteit voor beeldbestanden

Met onderstaande query wordt de opslagcapaciteit in GB berekend. Indien je in het MB wil weten, kies voor POW(1024,2); TB is POW(1024,4)

```sql
SELECT ROUND(SUM(filesize)/POW(1024,3)) as 'aantal GB' FROM siegfried
WHERE organisation = $organisation;
```

### Bestandsformaten van bestanden en hun aantallen

Met onderstaande query ken je de bestandsformaten en hun hoeveelheid. Ze worden geordend op aantal, van groot naar klein.

```sql
SELECT format, COUNT(format) AS 'aantal' FROM siegfried
WHERE organisation = $organisation GROUP BY format ORDER BY aantal DESC;
```

### Duplicaten

#### Aantal unieke bestanden

```sql
SELECT COUNT(DISTINCT md5) AS 'aantal unieke bestanden' FROM siegfried
WHERE organisation = $organisation;
```

#### Aantal unieke bestanden die duplicaten hebben

```sql
SELECT COUNT(DISTINCT md5) as 'unieke bestanden met dubbels' FROM siegfried t1
WHERE organisation = $organisation
AND EXISTS (SELECT 1 from siegfried t2 WHERE t2.md5 = t1.md5
AND organisation = $organisation AND t1.filename != t2.filename))
```

#### Aantal duplicaten

Omdat er een rekensom nodig is, maken we gebruik van variabelen om een aantal waarden op te slaan en om zo vervolgens het aantal dubbele bestanden te geven. Hiervoor moet het totaal aantal dubbels (inclusief het unieke bestand) afgetrokken worden van het aantal unieke bestanden met dubbels.

```sql
SET @dubbels := (SELECT COUNT(DISTINCT filename) FROM siegfried
WHERE md5 IN (SELECT md5 FROM siegfried WHERE organisation = $organisation GROUP BY md5
HAVING COUNT(md5) > 1) AND organisation = $organisation);

SET @unieke_dubbels := (SELECT COUNT(DISTINCT md5) FROM siegfried WHERE
md5 IN (SELECT md5 FROM siegfried WHERE organisation = $organisation GROUP BY md5
HAVING COUNT(md5) > 1) AND organisation = $organisation);

SELECT @dubbels - @unieke_dubbels AS 'aantal dubbels';
```

#### Vereiste opslagcapaciteit dubbels

```sql
SET @opslag_alle_dubbels := (SELECT ROUND(SUM(filesize)/POW(1024,3)) FROM siegfried WHERE md5
IN (SELECT md5 FROM siegfried WHERE organisation = $organisation GROUP BY md5
HAVING COUNT(md5) > 1) AND organisation = $organisation);

SET @opslag_unieke_dubbels := (SELECT ROUND(SUM(size)/POW(1024,3)) FROM (SELECT md5 as md5, filesize AS size FROM siegfried WHERE
md5 in (SELECT DISTINCT md5 FROM siegfried WHERE
md5 IN (SELECT md5 FROM siegfried WHERE organisation = $organisation GROUP BY md5
HAVING COUNT(md5) > 1)) AND organisation = $organisation GROUP BY md5, filesize) temp);

SELECT @opslag_alle_dubbels - @opslag_unieke_dubbels AS 'GB dubbels';
```

## Aanvullingen na Svend

Enkele aanvullingen na het gebruik van de databank voor Svend T.

### Hulptabellen

#### Creëer een view met distincte md5

Dit om bv. de opslag voor de unieke videobestanden te kunnen berekenen

```sql
CREATE VIEW unique_video 
AS
SELECT DISTINCT md5, filesize FROM siegfried 
WHERE mime LIKE 'video/%' 
```

#### Creëer een view met enkel videobestanden

De focus lag op de video's van Svend T.

```sql
CREATE VIEW video
AS
SELECT * FROM siegfried
WHERE mime LIKE 'video/%'
```

## TODO

Er zijn verbeteringen mogelijk. Het zou beter zijn om een aantal queries om te zetten in functies (waarbij bijvoorbeeld de organisatie als parameter meegegeven kan worden). Voor de kleine schaal van deze opdracht leek dit niet nodig. Er zou meer tijd besteed worden aan het creëren van de functies, dan aan het uitvoeren van de qeuries zelf.

Moesten we nog derglijke opdrachten krijgen, dan zou het beter zijn om één databank te hebben waarbij we de CSV's kunnen instoppen. Nu hebben we een databank specifiek voor de Hasselt case. Als deze databank neergehaald wordt, dan verliezen we alle indices, functies etc.
