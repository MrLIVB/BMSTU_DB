-- Вариант 2
CREATE TABLE IF NOT EXISTS work(
    wid SERIAL PRIMARY KEY,
    wname VARCHAR(50),
    workcost INT,
    equipment VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS executer(
    eid SERIAL PRIMARY KEY,
    ename VARCHAR(50),
    birth DATE,
    workexp INT,
    phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS client(
    cid SERIAL PRIMARY KEY,
    cname VARCHAR(50),
    birth DATE,
    workexp INT,
    phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS CE(
    cid INT REFERENCES client(cid),
    eid INT REFERENCES executer(eid)
);

CREATE TABLE IF NOT EXISTS WE(
    wid INT REFERENCES work(wid),
    eid INT REFERENCES executer(eid)
);

CREATE TABLE IF NOT EXISTS CtoW(
    cid INT REFERENCES client(cid),
    wid INT REFERENCES work(wid)
);

INSERT INTO executer(ename, birth, workexp, phone) VALUES ('Qwe Rty', '12.1.1992', 5, '123456789');
INSERT INTO executer(ename, birth, workexp, phone) VALUES ('Asd Fgh', '16.6.1995', 8, '+123123');
INSERT INTO executer(ename, birth, workexp, phone) VALUES ('Zxc Vbn', '25.10.2000', 1, '+83729-212');
INSERT INTO executer(ename, birth, workexp, phone) VALUES ('Kjs Kqwe', '1.2.1983',24, '+287-3827-2');
INSERT INTO executer(ename, birth, workexp, phone) VALUES ('LAsja Ak', '30.12.1987',24, '+287-3237-212');

INSERT INTO client(cname, birth, workexp, phone) VALUES ('Kjds ANbx', '27.06.1985', 8, '4872934');
INSERT INTO client(cname, birth, workexp, phone) VALUES ('Knash Znq', '18.02.1986', 12, '+34-128493-1');
INSERT INTO client(cname, birth, workexp, phone) VALUES ('Lnqwek Zkasd', '24.05.1989', 18, '+93284-123');
INSERT INTO client(cname, birth, workexp, phone) VALUES ('Lamqwe Axcvq', '20.08.1998', 6, '+03432424');
INSERT INTO client(cname, birth, workexp, phone) VALUES ('Aqqwe Lllsdf', '29.10.2000', 7, '82341');

INSERT INTO work(wname, workcost, equipment) VALUES ('Nail', 10, 'Differs a lot');
INSERT INTO work(wname, workcost, equipment) VALUES ('Build house', 50, 'Hamer, screwdriver, ladder');
INSERT INTO work(wname, workcost, equipment) VALUES ('Destroy house', 20, 'Hamer');

INSERT INTO WE(wid, eid) VALUES (1, 1);
INSERT INTO WE(wid, eid) VALUES (2, 2);
INSERT INTO WE(wid, eid) VALUES (3, 2);
INSERT INTO WE(wid, eid) VALUES (1, 3);
INSERT INTO WE(wid, eid) VALUES (2, 4);
INSERT INTO WE(wid, eid) VALUES (3, 5);

INSERT INTO CtoW(cid, wid) VALUES (1, 1);
INSERT INTO CtoW(cid, wid) VALUES (1, 2);
INSERT INTO CtoW(cid, wid) VALUES (1, 3);
INSERT INTO CtoW(cid, wid) VALUES (2, 1);
INSERT INTO CtoW(cid, wid) VALUES (3, 2);
INSERT INTO CtoW(cid, wid) VALUES (4, 3);
INSERT INTO CtoW(cid, wid) VALUES (5, 1);
INSERT INTO CtoW(cid, wid) VALUES (5, 2);

INSERT INTO CE(cid, eid) VALUES (1, 2);
INSERT INTO CE(cid, eid) VALUES (1, 5);
INSERT INTO CE(cid, eid) VALUES (2, 3);
INSERT INTO CE(cid, eid) VALUES (3, 4);
INSERT INTO CE(cid, eid) VALUES (4, 5);
INSERT INTO CE(cid, eid) VALUES (5, 1);
INSERT INTO CE(cid, eid) VALUES (5, 2);
INSERT INTO CE(cid, eid) VALUES (5, 4);