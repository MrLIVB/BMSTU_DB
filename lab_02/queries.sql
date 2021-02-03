-- 1. 
-- SELECT DISTINCT donor.name, donor.age, donor.city
--     FROM donor
--     WHERE donor.age > 20 AND donor.c ity <> 'Moscow'
--     ORDER BY donor.name, donor.city;


-- 2. Все операции удаления с января по апрель 2020
-- SELECT DISTINCT d.name, o.start
--     FROM donor d JOIN operation AS o ON (o.patientid = d.donorid and o.type = 'o')
--     WHERE o.start BETWEEN '2020-01-01' AND '2020-04-01';

-- 3. доноры с именем Robert которые жертвуют
-- SELECT DISTINCT o.name as organ, od.name as name,  od.city
--     FROM organ o JOIN donor as od ON (o.donorid = od.donorid)
--     WHERE od.name LIKE ('Robert%');

-- 4. id всех операций в клинике с id 2, для доноров мужского пола
-- SELECT DISTINCT operation.operationid, operation.patientid, operation.type
--     FROM operation
--     WHERE patientid in (
--         SELECT donorid
--         FROM donor
--         WHERE donor.sex = 'm'
--     ) AND operation.clinicid = 2;

-- 5. 
-- SELECT recipientid,
--     name,
--     priority
-- FROM recipient
-- WHERE NOT EXISTS (
--         SELECT patientid
--         FROM operation
--         WHERE recipientid = patientid
--             AND type = 'i'
--     )

-- 6. Всех Хирургов, которые старше хирургов из Магнитогорска
-- SELECT *
--     FROM surgeon
--     WHERE age > ALL (
--         SELECT age
--         FROM surgeon
--         WHERE CITY = 'Magnitogorsk'
--     );

-- 7. Средний возраст реципиентов
-- SELECT AVG(sage) AS "Actual Avg",
--         SUM(sage) / COUNT(city) AS "Calc Avg"
--     FROM (
--         SELECT city, AVG(age) AS sage
--         FROM recipient
--         GROUP BY city
--     ) AS totrec;

-- 8. 
-- SELECT surgeonid,
--     (
--         SELECT AVG(duration)
--         FROM operation
--         WHERE operation.surgeonid = surgeon.surgeonid
--     ) AS AvgLength,
--     (
--         SELECT MAX(duration)
--         FROM operation
--         WHERE operation.surgeonid = surgeon.surgeonid
--     ),
--     name
--     FROM surgeon
--     WHERE city = 'Magnitogorsk';

-- 9.
-- SELECT recipient.name,
--     CASE EXTRACT(YEAR FROM start)
--         WHEN EXTRACT(YEAR FROM CURRENT_DATE) THEN 'This year'
--         WHEN EXTRACT(YEAR FROM CURRENT_DATE) - 1 THEN 'Last year'
--         ELSE 'Next year'
--     END AS "When"
-- FROM operation JOIN recipient ON operation.patientid = recipient.recipientid AND operation.type = 'i'

-- 10.
-- SELECT name, 
--     CASE 
--         WHEN workexp < 5 THEN 'Not expirienced'
--         WHEN workexp < 15 THEN 'Little bit expirienced'
--         WHEN workexp < 30 THEN 'Eexpirienced'
--         ELSE 'Very expirienced'
--     END AS "Expirience"
-- FROM surgeon

-- 11. 
-- SELECT name, COUNT(organid) AS OQ
-- INTO OrganNumbers
-- FROM organ
-- GROUP BY name
-- SELECT *
-- FROM organnumbers 

-- 12. Хиирурги, у которых больше всего суммарная длительность операций
-- SELECT OP.surgeonid, name, age, SD
-- FROM  surgeon S JOIN
--     (
--         SELECT surgeonid, SUM(duration) AS SD
--         FROM operation
--         GROUP BY surgeonid
--         ORDER BY SD DESC
--         LIMIT 5
--     ) AS OP ON OP.surgeonid = S.surgeonid

-- 13. Те клиники, хирурги которых не пересаживают орган, который встречается чаще всего
-- SELECT *
-- FROM clinic
-- where clinicid NOT IN (
--         SELECT clinicid
--         FROM surgeon
--             JOIN (
--                 SELECT operation.surgeonid AS SI
--                 FROM operation
--                     JOIN organ ON (operation.organid = organ.organid)
--                 WHERE organ.name = (
--                         SELECT name
--                         FROM organ
--                         GROUP BY name
--                         ORDER BY COUNT(organid) DESC
--                         LIMIT 1
--                     )
--             ) AS T ON surgeonid = SI
--     )

-- 14.
-- SELECT name,
--     AVG(lifetime) AS AvgLifetime,
--     COUNT(organid) AS OrganQ
-- FROM organ
-- GROUP BY name

-- 15.
-- SELECT bloodtype, AVG(age) as "Average age"
-- FROM donor D
-- GROUP BY bloodtype
-- HAVING AVG(age) >
-- (
--     SELECT AVG(age) AS AVA
--     FROM donor
-- )

-- 16.
-- INSERT INTO clinic (city, address, phone)
-- VALUES ('Moscow', 'a', 'A');

-- 17.
-- INSERT INTO donor (name, age, sex, bloodtype, rhFactor, city)
-- SELECT name, (
--     SELECT MAX(AGE)
--     FROM recipient
--     WHERE recipient.city = 'Omsk'
-- ), sex, bloodtype, rhfactor, city
-- FROM recipient
-- WHERE recipientid = 12

-- 18.
-- UPDATE organ
-- SET lifetime = lifetime * 1.5
-- WHERE organid = 17

-- 19.
-- UPDATE donor
-- SET age = 
-- (
--     SELECT MAX(age)
--     FROM recipient
-- )
-- WHERE donorid = 123

-- 20.
-- DELETE FROM clinic
-- WHERE address = 'a';

-- 21.
-- DELETE FROM recipient
-- WHERE clinicid IN (
--         SELECT clinic.clinicid
--         FROM clinic
--         WHERE city = 'Omsk'
--     );

-- 22.
-- WITH CTE(bloodtype, NumberOfDonors)
-- AS
-- (
--     SELECT bloodtype, COUNT(donorid) AS total
--     FROM donor
--     WHERE age > 30
--     GROUP BY bloodtype
-- )
-- SELECT AVG(NumberOfDonors) AS AvgNumber
-- FROM CTE

-- 23.
WITH RECURSIVE surgeonsRec(id, clinicid, name)
AS
(
    SELECT s.surgeonid, s.clinicid, s.name
    FROM surgeon AS s
    WHERE s.surgeonid = 1
    UNION ALL
    SELECT *
    FROM s JOIN surgeonRec AS sr ON (s.clinicid = sr.clinicid AND s.id < sr.id)
)

SELECT * FROM surgeonsRec


-- ДОБАВИТЬ НОВЫЙ СТОЛБЕЦ???

-- 24.
-- SELECT donorid,
--     name,
--     AVG(age) OVER (PARTITION BY bloodtype, rhfactor) AS AvgAge,
--     MAX(age) OVER (PARTITION BY bloodtype, rhfactor) AS MaxAge,
--     MIN(age) OVER (PARTITION BY bloodtype, rhfactor) AS MinAge
-- FROM donor

-- 25.
-- SELECT *,
--     ROW_NUMBER () OVER ()
-- FROM
-- (
--     SELECT * FROM clinic
--     UNION ALL
--     SELECT * FROM clinic
-- ) AS C
