CREATE IF NOT EXISTS TABLE Table1 (
    id integer,
    var1 varchar(5), 
    valid_from_dttm date, 
    valid_to_dttm date
);

CREATE IF NOT EXISTS TABLE Table2 (
    id integer,
    var2 varchar(5), 
    valid_from_dttm date, 
    valid_to_dttm date
);

INSERT INTO Table1 VALUES(1, 'A', '2018-09-01', '2018-09-15');
INSERT INTO Table1 VALUES(1, 'B', '2018-09-16', '5999-12-31');

INSERT INTO Table2 VALUES(1, 'A', '2018-09-01', '2018-09-18');
INSERT INTO Table2 VALUES(1, 'B', '2018-09-19', '5999-12-31');
