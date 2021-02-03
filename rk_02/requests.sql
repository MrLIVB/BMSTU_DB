-- Инструкция SELECT использующая предикат сравнения
-- Выводит всех исполнителей со стажем больше 6 лет
SELECT eid, ename, workexp FROM executer
    WHERE workexp > 6;

-- Инструкцию SELECT использующую оконную функцию
-- Инструкция для каждого типа работы из CtoW сопоставлеяем максимальный стаж клиента 
SELECT wid, MAX(workexp) OVER (PARTITION BY CtoW.wid)
    FROM CtoW JOIN client on CtoW.cid = client.cid;

-- Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM
-- Выводит id и название Вида работ, для которого существует клиент с опытом работы больше 15 
SELECT temp.wid, temp.wname FROM
    (SELECT * FROM
     work w WHERE EXISTS
             (SELECT *
              FROM CtoW cw
              JOIN client c ON (cw.cid = c.cid)
              WHERE c.workexp > 15
                  AND cw.wid = w.wid)) temp;




CREATE OR REPLACE PROCEDURE Indecies(table_name VARCHAR)
AS $$
DECLARE 
    table_id INT;
BEGIN
    EXECUTE 'SELECT pg_class.oid
                    FROM pg_class
                    WHERE pg_class.relname=$1'
    INTO table_id
    USING table_name;

    EXECUTE 'SELECT * FROM pg_index WHERE pg_index.indrelid=$1'
    USING table_id);
END;
$$ LANGUAGE plpgsql;

CALL Indecies('client');
