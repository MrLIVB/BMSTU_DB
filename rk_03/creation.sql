-- Вариант 3

CREATE TABLE IF NOT EXISTS employee (
    eid INTEGER PRIMARY KEY,
    fio VARCHAR(40),
    birth DATE,
    dep VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS co(
    eid INTEGER REFERENCES employee(eid),
    adt DATE,
    day VARCHAR(10),
    atime TIME,
    atype INTEGER
);

-- INSERT INTO employee VALUES (1,'A A A', '25-09-1990', 'IT')
-- INSERT INTO employee VALUES (2, 'B B B', '12-11-1987', 'BookKeeping')
-- INSERT INTO employee VALUES (3, 'C C C', '12-11-1990', 'BookKeeping')

-- SELECT * FROM employee

-- INSERT INTO co VALUES (1, '14-12-2018', 'Satruday', '9:00', 1);
-- INSERT INTO co VALUES (1, '14-12-2018', 'Satruday', '9:20', 2);
-- INSERT INTO co VALUES (1, '14-12-2018', 'Satruday', '9:25', 1);
-- INSERT INTO co VALUES (1, '14-12-2018', 'Satruday', '10:00', 2);
-- INSERT INTO co VALUES (1, '14-12-2018', 'Satruday', '10:10', 1);
-- INSERT INTO co VALUES (1, '14-12-2018', 'Satruday', '11:10', 2);
-- INSERT INTO co VALUES (2, '14-12-2018', 'Satruday', '9:05', 1);
-- INSERT INTO co VALUES (2, '14-12-2018', 'Satruday', '9:45', 2);
-- SELECT * FROM co;

-- ВРЕМЯ прихода

CREATE OR REPLACE FUNCTION MinAgeLate() RETURNS INTEGER AS $$
DECLARE
    maxBirth DATE;
BEGIN
    RETURN
    (SELECT extract(year from age(MAX(birth)))
    FROM employee
    JOIN
        (WITH c AS
            (SELECT eid,
                    adt,
                    min(atime) as ctime
            FROM co
            GROUP BY eid,
                    adt) SELECT *
        FROM c
        WHERE ctime - '9:00' > '10 minutes') t on employee.eid = t.eid);
END;
$$ LANGUAGE plpgsql;

SELECT MinAgeLate();
