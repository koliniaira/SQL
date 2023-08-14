/*
This assignment introduces an example concerning World War II capital ships.
It involves the following relations:

Classes(class, type, country, numGuns, bore, displacement)
Ships(name, class, launched)  --launched is for year launched
Battles(name, date_fought)
Outcomes(ship, battle, result)


Ships are built in "classes" from the same design, and the class is usually
named for the first ship of that class.

Relation Classes records the name of the class,
the type (bb for battleship or bc for battlecruiser),
the country that built the ship, the number of main guns,
the bore (diameter of the gun barrel, in inches)
of the main guns, and the displacement (weight, in tons).

Relation Ships records the name of the ship, the name of its class,
and the year in which the ship was launched.

Relation Battles gives the name and date of battles involving these ships.

Relation Outcomes gives the result (sunk, damaged, or ok)
for each ship in each battle.
*/


/*
Exercise 1. (1 point)

1.	Create simple SQL statements to create the above relations
    (no constraints for initial creations).
2.	Insert the following data.


For Classes:
('Bismarck','bb','Germany',8,15,42000);
('Kongo','bc','Japan',8,14,32000);
('North Carolina','bb','USA',9,16,37000);
('Renown','bc','Gt. Britain',6,15,32000);
('Revenge','bb','Gt. Britain',8,15,29000);
('Tennessee','bb','USA',12,14,32000);
('Yamato','bb','Japan',9,18,65000);

For Ships
('California','Tennessee',1921);
('Haruna','Kongo',1915);
('Hiei','Kongo',1914);
('Iowa','Iowa',1943);
('Kirishima','Kongo',1914);
('Kongo','Kongo',1913);
('Missouri','Iowa',1944);
('Musashi','Yamato',1942);
('New Jersey','Iowa',1943);
('North Carolina','North Carolina',1941);
('Ramilles','Revenge',1917);
('Renown','Renown',1916);
('Repulse','Renown',1916);
('Resolution','Revenge',1916);
('Revenge','Revenge',1916);
('Royal Oak','Revenge',1916);
('Royal Sovereign','Revenge',1916);
('Tennessee','Tennessee',1920);
('Washington','North Carolina',1941);
('Wisconsin','Iowa',1944);
('Yamato','Yamato',1941);

For Battles
('North Atlantic','27-May-1941');
('Guadalcanal','15-Nov-1942');
('North Cape','26-Dec-1943');
('Surigao Strait','25-Oct-1944');

For Outcomes
('Bismarck','North Atlantic', 'sunk');
('California','Surigao Strait', 'ok');
('Duke of York','North Cape', 'ok');
('Fuso','Surigao Strait', 'sunk');
('Hood','North Atlantic', 'sunk');
('King George V','North Atlantic', 'ok');
('Kirishima','Guadalcanal', 'sunk');
('Prince of Wales','North Atlantic', 'damaged');
('Rodney','North Atlantic', 'ok');
('Scharnhorst','North Cape', 'sunk');
('South Dakota','Guadalcanal', 'ok');
('West Virginia','Surigao Strait', 'ok');
('Yamashiro','Surigao Strait', 'sunk');
*/

-- Write your sql statements here.

create table Classes(class VARCHAR(30), type VARCHAR(10), country VARCHAR(30), numGuns int, bore int, displacement int);
create table Ships(name VARCHAR(30), class VARCHAR(30), launched int);
create table Battles(name VARCHAR(30), date_fought DATE);
create table Outcomes(ship VARCHAR(30), battle VARCHAR(30), result VARCHAR(10));


insert into Classes values('Bismarck','bb','Germany',8,15,42000);
insert into Classes values('Kongo','bc','Japan',8,14,32000);
insert into Classes values('North Carolina','bb','USA',9,16,37000);
insert into Classes values('Renown','bc','Gt. Britain',6,15,32000);
insert into Classes values('Revenge','bb','Gt. Britain',8,15,29000);
insert into Classes values('Tennessee','bb','USA',12,14,32000);
insert into Classes values('Yamato','bb','Japan',9,18,65000);

insert into Ships values('California','Tennessee',1921);
insert into Ships values('Haruna','Kongo',1915);
insert into Ships values('Hiei','Kongo',1914);
insert into Ships values('Iowa','Iowa',1943);
insert into Ships values('Kirishima','Kongo',1914);
insert into Ships values('Kongo','Kongo',1913);
insert into Ships values('Missouri','Iowa',1944);
insert into Ships values('Musashi','Yamato',1942);
insert into Ships values('New Jersey','Iowa',1943);
insert into Ships values('North Carolina','North Carolina',1941);
insert into Ships values('Ramilles','Revenge',1917);
insert into Ships values('Renown','Renown',1916);
insert into Ships values('Repulse','Renown',1916);
insert into Ships values('Resolution','Revenge',1916);
insert into Ships values('Revenge','Revenge',1916);
insert into Ships values('Royal Oak','Revenge',1916);
insert into Ships values('Royal Sovereign','Revenge',1916);
insert into Ships values('Tennessee','Tennessee',1920);
insert into Ships values('Washington','North Carolina',1941);
insert into Ships values('Wisconsin','Iowa',1944);
insert into Ships values('Yamato','Yamato',1941);


insert into Battles values('North Atlantic','27-May-1941');
insert into Battles values('Guadalcanal','15-Nov-1942');
insert into Battles values('North Cape','26-Dec-1943');
insert into Battles values('Surigao Strait','25-Oct-1944');

insert into Outcomes values('Bismarck','North Atlantic', 'sunk');
insert into Outcomes values('California','Surigao Strait', 'ok');
insert into Outcomes values('Duke of York','North Cape', 'ok');
insert into Outcomes values('Fuso','Surigao Strait', 'sunk');
insert into Outcomes values('Hood','North Atlantic', 'sunk');
insert into Outcomes values('King George V','North Atlantic', 'ok');
insert into Outcomes values('Kirishima','Guadalcanal', 'sunk');
insert into Outcomes values('Prince of Wales','North Atlantic', 'damaged');
insert into Outcomes values('Rodney','North Atlantic', 'ok');
insert into Outcomes values('Scharnhorst','North Cape', 'sunk');
insert into Outcomes values('South Dakota','Guadalcanal', 'ok');
insert into Outcomes values('West Virginia','Surigao Strait', 'ok');
insert into Outcomes values('Yamashiro','Surigao Strait', 'sunk');


-- Exercise 2. (6 points)
-- Write SQL queries for the following requirements.

-- 1.	(2 pts) List the name, displacement, and number of guns of the ships engaged in the battle of Guadalcanal.
-- name: Ships, displacement: classes, numguns = classes
--battle = guadalcanal
--ships: south dakota, ki

SELECT ship, displacement, numGuns
FROM Outcomes   LEFT OUTER JOIN ships on Outcomes.ship = ships.name
                LEFT OUTER JOIN classes on ships.class = classes.class
WHERE battle = 'Guadalcanal';


/*
Expected result:
ship,displacement,numguns
Kirishima,32000,8
South Dakota,NULL,NULL
*/

-- 2.	(2 pts) Find the names of the ships whose number of guns was the largest for those ships of the same bore.
SELECT name
FROM (
    SELECT name, numGuns, bore
    FROM Classes c NATURAL JOIN Ships) C
    WHERE numGuns IN (
        SELECT MAX(numGuns)
        FROM Classes c1
        WHERE c.bore = c1.bore
);

--3. (2 pts) Find for each class with at least three ships the number of ships of that class sunk in battle.
SELECT x.class, count(result) as sunk
FROM (
    SELECT class
    FROM ships
    GROUP BY class
    HAVING count(name) >= 3) X
      LEFT OUTER JOIN
    (SELECT ship, result
     FROM outcomes
     WHERE result = 'sunk') Y
on x.class = y.ship
GROUP BY x.class;


/*
class,sunk_ships
Revenge,0
Kongo,1
Iowa,0
*/



-- Exercise 3. (4 points)

-- Write the following modifications.

-- 1.	(2 points) Two of the three battleships of the Italian Vittorio Veneto class –
-- Vittorio Veneto and Italia – were launched in 1940;
-- the third ship of that class, Roma, was launched in 1942.
-- Each had 15-inch guns and a displacement of 41,000 tons.
-- Insert these facts into the database.

INSERT INTO Classes(class, type, country, bore, displacement)
VALUES ('Vittorio Veneto', 'bb', 'Italy', 15, 41000);

INSERT INTO Ships(name, class, launched)
VALUES('Vittorio Veneto', 'Vittorio Veneto', 1940);

INSERT INTO Ships(name, class, launched)
VALUES('Italia', 'Vittorio Veneto', 1940);

INSERT INTO Ships(name, class, launched)
VALUES('Roma', 'Vittorio Veneto', 1942);


-- 2.	(1 point) Delete all classes with fewer than three ships.
DELETE FROM Classes
WHERE clsss in (
    SELECT class
    FROM Classes LEFT OUTER JOIN Ships
    GROUP BY class
    HAVING count(name) <= 3
)

-- 3.	(1 point) Modify the Classes relation so that gun bores are measured in centimeters
-- (one inch = 2.5 cm) and displacements are measured in metric tons (one metric ton = 1.1 ton).

UPDATE Classes
SET bore = bore * 2.5, displacement = displacement / 1.1;


-- Exercise 4.  (9 points)
-- Add the following constraints using views with check option.

--1. (3 points) No ship can be in battle before it is launched.

-- Write your sql statement here.
CREATE OR REPLACE VIEW OutcomesView AS 
SELECT ship, battle, result
FROM Outcomes O
WHERE NOT EXISTS (
    SELECT *
    FROM Ships S, Battles B
    WHERE S.name=O.ship AND O.battle=B.name AND 
          S.launched > extract(year from B.date_fought)
)
WITH CHECK OPTION;

-- Now we can try some insertion on this view.

INSERT INTO OutcomesView (ship, battle, result)
VALUES('Musashi', 'North Atlantic','ok');

-- This insertion, as expected, should fail since Musashi is launched in 1942,
-- while the North Atlantic battle took place on 27-MAY-41.

