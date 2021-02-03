-- Функции
-- Скалярная
-- Находит количество реципиентов, которым не назначена операция
-- CREATE OR REPLACE FUNCTION RecipientsWaiting() RETURNS INTEGER AS $$
-- BEGIN
--     RETURN
--     (SELECT count(*)
--     FROM recipient
--     JOIN
--         (SELECT recipientid
--         FROM recipient
--         JOIN operation ON recipientid = patientid
--         WHERE operation.type = 'i') t on t.recipientid = recipient.recipientid);
-- END;
-- $$ LANGUAGE plpgsql;

SELECT RecipientsWaiting();


-- Подставляемая табличная функция
-- Возвращает имена всех хирургов с опытом работы больше заданного
-- Убрать TABLE и запустить
CREATE OR REPLACE FUNCTION SurgeonWithExp(minExp int) RETURNS
SETOF surgeon AS $$
BEGIN
    RETURN QUERY (SELECT * FROM surgeon
    WHERE workexp > minExp);
END;
$$ LANGUAGE plpgsql;


SELECT * FROM SurgeonWithExp(12);
-- DROP FUNCTION SurgeonWithExp;


-- Больше операторов
-- Многооператорная табличная функция !!!
-- Все хирурги мужского пола, работающие в тех же клиниках, где оперировали доноров старше 20 лет, жертвующих сердце
CREATE OR REPLACE FUNCTION SurgeonsFromDonorClinic() RETURNS TABLE (surgeonid int, surgeonname VARCHAR) AS $$
declare
    organName VARCHAR(30);
    donorAge int;
    surgeonSex CHAR;
BEGIN
    organName = 'heart';
    donorAge = 20;
    surgeonSex = 'm';

    RETURN QUERY
    SELECT surgeon.surgeonid, surgeon.name
    FROM donor
        JOIN organ ON donor.donorid = organ.donorid
        JOIN clinic ON organ.clinicid = clinic.clinicid
        JOIN surgeon ON surgeon.clinicid = clinic.clinicid
    WHERE organ.name = organName AND donor.age > donorAge AND surgeon.sex = surgeonSex;
END;
$$ LANGUAGE plpgsql;


SELECT *
FROM SurgeonsFromDonorClinic();

-- Рекурсивная функция или функция с рекурсивным ОТВ
-- Рекурсивно находит всех хирургов, id которых равен опыту работы предыдущего
-- DROP FUNCTION RecursiveSurgeon;

CREATE OR REPLACE FUNCTION RecursiveSurgeon(searchedid integer)
RETURNS TABLE (id int, age smallint)
AS $$
BEGIN
    RETURN QUERY (
    WITH RECURSIVE r AS
    ( SELECT surgeon.surgeonid,
             surgeon.age
     FROM surgeon
     WHERE surgeonid = searchedid
     UNION SELECT surgeon.surgeonid,
                  surgeon.age
     FROM surgeon
     JOIN r ON surgeon.surgeonid = r.age)

    SELECT * FROM r);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM RecursiveSurgeon(2);

-- Хранимая процедура без параметров
-- Проверяет есть ли 2 операции одинакового типа для одного органа
CREATE OR REPLACE PROCEDURE FindDuplicates()
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT *
                FROM operation o1
                JOIN operation o2 ON o1.organid = o2.organid
                AND o1.type = o2.type
                AND O1.operationid <> o2.operationid)
        THEN
        RAISE NOTICE 'There are two simillar operations for one organ';
    ELSE
        RAISE NOTICE 'Everything ok with operations';
    END IF;
END;
$$;

CALL FindDuplicates();

-- Рекурсивная хранимая процедура или хранимая процедура с рекурсивным ОТВ
-- Выбираются доноры с айди равным возрасту предыдущего, выводится глубина такой рекускии
CREATE OR REPLACE PROCEDURE CountDonorsDepth(did int, rdepth int DEFAULT 0) LANGUAGE plpgsql AS $$
DECLARE
    nextid int;
BEGIN
    nextid := (SELECT age FROM donor WHERE donorid = did);
    IF nextid > did THEN
        CALL CountDonorsDepth(nextid, rdepth + 1);
    ELSE
        RAISE NOTICE 'Depth is %', rdepth;
    END IF;
END;
$$;

CALL CountDonorsDepth(2);

-- Хранимая процедура с курсором
-- Ищет самую длинную растущую последовательность реципиентов по возрасту
CREATE OR REPLACE PROCEDURE LongestGrowingSequence() LANGUAGE plpgsql AS $$
DECLARE
    cur RECORD; prev RECORD;
    mycursor CURSOR FOR SELECT * FROM recipient;
	curseq int; maxseq int;
BEGIN
	curseq := 1;
	maxseq := 0;
    FOR cur IN mycursor LOOP
		IF maxseq = 0 THEN
			prev := cur;
		END IF;
        IF maxseq > 0 AND cur.age > prev.age THEN
            curseq := curseq + 1;
		ELSE
			IF curseq > maxseq THEN
				maxseq = curseq;
			END IF;
			curseq = 0;
        END IF;
        prev := cur;
    END LOOP;
	RAISE NOTICE 'Longest growing sequence %', maxseq;
END;
$$;

CALL LongestGrowingSequence();

-- Хранимая процедура доступа к метаданным
-- Выводит количество созданных процедур и функций
CREATE OR REPLACE PROCEDURE CreatedFunctions() LANGUAGE plpgsql AS $$
DECLARE
    num int;
BEGIN
    num := (SELECT count(*) FROM pg_proc
    where pronamespace =
            ( SELECT oid
            FROM pg_namespace
            WHERE nspname = 'public'));
    RAISE NOTICE 'There are % functions and procedures created', num;
END;
$$;

CALL CreatedFunctions();

-- Триггер AFTER
-- После добавления операции по удалению органа выводит сообщение о дате, когда орган погибнет
CREATE OR REPLACE FUNCTION AlertOrgansDeathTime() RETURNS TRIGGER AS $$
DECLARE 
    DeathDt TIMESTAMP;
    OrganLifetime int;
BEGIN
    IF NEW.type = 'o' THEN
        OrganLifetime := (SELECT lifetime FROM organ WHERE organ.organid = NEW.organid);
        DeathDt := NEW.start + concat(OrganLifetime, 'hour')::interval;
        RAISE NOTICE 'Insert operation must start before %', DeathDt;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER AlertOrgnasDeathTime AFTER
INSERT OR UPDATE ON OPERATION
FOR EACH ROW EXECUTE PROCEDURE AlertOrgansDeathTime();

UPDATE operation
SET organid=1
where operationid = 1;

INSERT INTO OPERATION

-- Триггер INSTEAD OF

-- CREATE VIEW operation_view AS
-- SELECT *
-- FROM operation;

-- DROP TRIGGER IsOrganAlive on operation_view;

CREATE OR REPLACE FUNCTION IsOrganAlive() RETURNS TRIGGER AS $$
DECLARE
    RemovalDate TIMESTAMP;
    OrganLifetime  int;
BEGIN
    RemovalDate := (SELECT operation.start
                    FROM operation 
                    WHERE operation.organid = NEW.organid AND operation.type = 'o');
    OrganLifetime := (SELECT lifetime FROM organ WHERE organ.organid = new.organid);
    RemovalDate := RemovalDate + concat(OrganLifetime, 'hour')::interval;
    IF NEW.start > RemovalDate THEN
        RAISE EXCEPTION 'Organ % cant survive to the operation', NEW.organid;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER IsOrganAlive INSTEAD OF
INSERT ON operation
FOR EACH STATEMENT EXECUTE PROCEDURE IsOrganAlive();

-- Функция, которая выводит все функции в порядке уменьшения количества входных параметров
CREATE OR REPLACE FUNCTION functionsOrderedByArguments() RETURNS
SETOF pg_proc AS $$
BEGIN
    RETURN QUERY SELECT * FROM pg_proc
    ORDER BY pronargs DESC;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM functionsOrderedByArguments();