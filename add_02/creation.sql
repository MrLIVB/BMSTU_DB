CREATE TABLE IF NOT EXISTS EmplVisits(
    Department VARCHAR(20),
    FIO VARCHAR(20),
    DT DATE,
    Stat VARCHAR(20)
)

delete from emplvisits;

INSERT INTO EmplVisits VALUES ('��', '� � �', '2020-01-15', '����������');
INSERT INTO EmplVisits VALUES ('��', '� � �', '2020-01-16', '�� ������');
INSERT INTO EmplVisits VALUES ('��', '� � �', '2020-01-17', '�� ������');
INSERT INTO EmplVisits VALUES ('��', '� � �', '2020-01-18', '�� ������');
INSERT INTO EmplVisits VALUES ('��', '� � �', '2020-01-19', '������������ ������');
INSERT INTO EmplVisits VALUES ('��', '� � �', '2020-01-20', '������������ ������');

INSERT INTO EmplVisits VALUES ('�����������', '� � �', '2020-01-15', '������������ ������');
INSERT INTO EmplVisits VALUES ('�����������', '� � �', '2020-01-16', '�� ������');
INSERT INTO EmplVisits VALUES ('�����������', '� � �', '2020-01-17', '�� ������');
INSERT INTO EmplVisits VALUES ('�����������', '� � �', '2020-01-18', '�� ������');
INSERT INTO EmplVisits VALUES ('�����������', '� � �', '2020-01-19', '������������ ������');
INSERT INTO EmplVisits VALUES ('�����������', '� � �', '2020-01-20', '������������ ������');

select * from emplvisits;
