-- Возвращает год начала работы хирурга !!!!!!!!
CREATE OR REPLACE FUNCTION StartedWork(lid INTEGER) RETURNS INTEGER AS $$
    request = "SELECT * FROM surgeon"
    surg = plpy.execute(request)
    for cur in surg:
        if cur['surgeonid'] == lid:
            return cur['age'] - cur['workexp']

    plpy.error("There is no surgeon with such id")
    return None
$$ LANGUAGE plpython3u;


SELECT StartedWork(3);

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

-- Создать таблицу с заданным типом добавить данные, получить все данные и получить только имя и возраст
CREATE TABLE IF NOT EXISTS volunteer (vid INT PRIMARY KEY,
                                                      pdata person,
                                                      city VARCHAR(30));
INSERT INTO volunteer VALUES (1, ROW('Asld', 22, 'm'), 'Moscow');
INSERT INTO volunteer VALUES (2, ROW('Alas', 24, 'm'), 'Tomsk');

SELECT * FROM volunteer;
SELECT (volunteer.pdata).name, (volunteer.pdata).age  FROM volunteer;