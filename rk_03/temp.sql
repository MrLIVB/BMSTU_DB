-- SELECT eid, fio, birth from employee
-- WHERE dep = 'BookKeeping'
-- ORDER BY birth
-- LIMIT 1


-- SELECT t.eid, fio, dep FROM employee JOIN (
-- SELECT eid, COUNT(*) as cnt FROM co
-- WHERE atype = 2
-- GROUP BY eid, adt) t on employee.eid = t.eid
-- WHERE t.cnt > 3


SELECT t.eid, fio, dep FROM employee e JOIN
(
    WITH c AS (
        SELECT eid, min(atime) as ctime
        FROM co
        WHERE adt='2018-12-14' -- Подставить своё
        GROUP BY eid)
    SELECT * FROM c
    ORDER BY c.ctime DESC
    LIMIT 1) t ON e.eid = t.eid
    
