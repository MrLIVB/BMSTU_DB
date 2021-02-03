CREATE OR REPLACE FUNCTION SurgeonWithExp(minExp int) RETURNS
SETOF surgeon AS $$
BEGIN
    RETURN QUERY (SELECT * FROM surgeon
    WHERE workexp > minExp);
END;
$$ LANGUAGE plpgsql;


SELECT *
FROM SurgeonWithExp(12);


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

-- Функция, которая выводит все функции в порядке уменьшения количества входных параметров
CREATE OR REPLACE FUNCTION functionsOrderedByArguments() RETURNS
SETOF pg_proc AS $$
BEGIN
    RETURN QUERY SELECT * FROM pg_proc
    ORDER BY pronargs DESC;
END;
$$ LANGUAGE plpgsql;


SELECT *
FROM functionsOrderedByArguments();