-- CREATE EXTENSION plpython3u
-- DROP EXTENSION plpython3u

-- Определяемая пользователем скалярная функция
-- Возвращает год начала работы хирурга !!!!!!!!
CREATE OR REPLACE FUNCTION StartedWork(lid INTEGER)
    RETURNS INTEGER
AS $$
    request = "SELECT * FROM surgeon"
    surg = plpy.execute(request)
    for cur in surg:
        if cur['surgeonid'] == lid:
            return cur['age'] - cur['workexp']
    
    plpy.error("There is no surgeon with such id")
    return None
$$ LANGUAGE plpython3u;

SELECT StartedWork(3);

-- Пользовательская агрегатная функция
-- Возвращает средний возраст реципиентов с заданным приоритетом
CREATE OR REPLACE FUNCTION AverageRecipientAgePr(priority INTEGER)
    RETURNS FLOAT
AS $$
    if priority < 1 or priority > 5:
        plpy.error("Priority is out of bounds")
    request = "SELECT * FROM recipient WHERE priority = " + str(priority)
    records = plpy.execute(request)
    avgage = 0
    for cur in records:
        avgage += cur['age']
    return avgage / records.nrows()
$$ LANGUAGE plpython3u;

-- SELECT AverageRecipientAgePr(2);

-- Определяемая пользователем табличная функция
-- Возвращает реципиентов старше !!!!!!!!
CREATE OR REPLACE FUNCTION older(age INT) RETURNS
SETOF recipient AS $$
    request = "SELECT * FROM recipient"
    records = plpy.execute(request)
    result = []
    for cur in records:
        if cur['age'] > age:
            result.append(cur)
    return result
$$ LANGUAGE plpython3u;


SELECT *
from older(50);

-- Хранимая процедура
-- Выводит сообщение о наличии/отсутствии реципиентов с приоритетом 5
CREATE OR REPLACE PROCEDURE IsThereHighestPriority()
AS $$
    records = plpy.execute("SELECT * FROM recipient WHERE priority = 5", 1)
    if records.nrows():
        plpy.info("There are recipients with priority of 5")
    else:
        plpy.info("There are no recipients with priority of 5")
$$ LANGUAGE plpython3u;

-- CALL IsThereHighestPriority();

-- Триггер
-- После действия в таблице organ выводит информацию о событии
CREATE OR REPLACE function Inform() RETURNS TRIGGER AS $$
   str = "Triggered " + TD["when"] + " " + TD["event"] + " for table " + TD["table_name"]
   plpy.info(str)
$$ LANGUAGE plpython3u;

CREATE TRIGGER Informs AFTER
INSERT OR update or delete on clinic
FOR EACH ROW EXECUTE PROCEDURE inform();

UPDATE operation
SET organid=1
where operationid = 1;


-- Определяемый пользователем тип данных
-- create TYPE person AS 
-- ( 
--     name VARCHAR(30),
--     age smallint, 
--     sex varchar(1)
-- );

--drop  type person;

create or replace function generate(age int) RETURNS person as $$
	class person:
		def __init__(self, age):
			self.name = str(age)
			self.age = age
			self.sex = 'm' if age % 2 else 'f'
	return person(age)
$$ language plpython3u;


select generate(123);

-- Создать таблицу с заданным типом добавить данные, получить все данные и получить только имя и возраст
CREATE TABLE IF NOT EXISTS volunteer (vid INT PRIMARY KEY,
                                                      pdata person,
                                                      city VARCHAR(30));
INSERT INTO volunteer VALUES (1, ROW('Asld', 22, 'm'), 'Moscow');
INSERT INTO volunteer VALUES (2, ROW('Alas', 24, 'm'), 'Tomsk');

SELECT * FROM volunteer;
SELECT (volunteer.pdata).name, (volunteer.pdata).age  FROM volunteer;