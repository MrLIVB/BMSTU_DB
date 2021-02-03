CREATE TABLE IF NOT EXISTS EmplVisits(
    Department VARCHAR(20),
    FIO VARCHAR(20),
    DT DATE,
    Stat VARCHAR(20)
)

delete from emplvisits;

INSERT INTO EmplVisits VALUES ('ИТ', 'И И И', '2020-01-15', 'Больничный');
INSERT INTO EmplVisits VALUES ('ИТ', 'И И И', '2020-01-16', 'На работе');
INSERT INTO EmplVisits VALUES ('ИТ', 'И И И', '2020-01-17', 'На работе');
INSERT INTO EmplVisits VALUES ('ИТ', 'И И И', '2020-01-18', 'На работе');
INSERT INTO EmplVisits VALUES ('ИТ', 'И И И', '2020-01-19', 'Оплачиваемый отпуск');
INSERT INTO EmplVisits VALUES ('ИТ', 'И И И', '2020-01-20', 'Оплачиваемый отпуск');

INSERT INTO EmplVisits VALUES ('Бухгалтерия', 'П И И', '2020-01-15', 'Оплачиваемый отпуск');
INSERT INTO EmplVisits VALUES ('Бухгалтерия', 'П И И', '2020-01-16', 'На работе');
INSERT INTO EmplVisits VALUES ('Бухгалтерия', 'П И И', '2020-01-17', 'На работе');
INSERT INTO EmplVisits VALUES ('Бухгалтерия', 'П И И', '2020-01-18', 'На работе');
INSERT INTO EmplVisits VALUES ('Бухгалтерия', 'П И И', '2020-01-19', 'Оплачиваемый отпуск');
INSERT INTO EmplVisits VALUES ('Бухгалтерия', 'П И И', '2020-01-20', 'Оплачиваемый отпуск');

select * from emplvisits;
