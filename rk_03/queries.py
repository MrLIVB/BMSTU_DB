from sqlalchemy import create_engine, select, func
from sqlalchemy import Table, Column, String, Integer, MetaData, Date, TIME
from sqlalchemy.engine import Engine

engine = create_engine('postgresql+psycopg2://postgres:Deep123Dark@localhost:5432/postgres')
meta = MetaData()

co = Table(
    "co", meta,
    Column('eid', Integer),
    Column('adt', Date),
    Column('day', String),
    Column('atime', TIME),
    Column('atype', Integer)
)

employee = Table(
    "employee", meta,
    Column('eid', Integer, primary_key=True),
    Column('fio', String),
    Column('birth', Date),
    Column('dep', String)
)

engine: Engine
with engine.connect() as conn:
    # Самый старший сотрудник
    query = select([employee.c.eid, employee.c.fio, employee.c.birth]).where(employee.c.dep == 'BookKeeping').order_by(employee.c.birth).limit(1)
    res = conn.execute(query).fetchall()
    for row in res:
        print(row)

    # Выходивший 3 раза
    sub_query = co.select([co.c.eid, func.count().label('cnt')]).where(co.c.atype == 2).group_by(co.c.eid, co.c.adt)
    query = select().join_from(employee, sub_query, employee.c.eid == sub_query.c.eid and sub_query.c.cnt > 3)
    res = conn.execute(query).fetchall()
    for row in res:
        print(row)

print('------')

import psycopg2
from psycopg2 import sql
connection = psycopg2.connect(dbname='postgres', user='postgres', password='Deep123Dark', host='localhost')
cursor = connection.cursor()

def task21(cur):
    cur.execute('''SELECT eid, fio, birth from employee
                        WHERE dep = 'BookKeeping'
                        ORDER BY birth
                        LIMIT 1''')
    for row in cur:
        print(row)

def task22(cur):
    cur.execute('''SELECT t.eid, fio, dep FROM employee JOIN (
                    SELECT eid, COUNT(*) as cnt FROM co
                        WHERE atype = 2
                    GROUP BY eid, adt) t on employee.eid = t.eid
                    WHERE t.cnt > 3
                    ''')
    for row in cur:
        print(row)

def task23(cur, today):    
    cur.execute("SELECT t.eid, fio, dep FROM employee e JOIN\
                    (\
                        WITH c AS (\
                            SELECT eid, min(atime) as ctime\
                            FROM co\
                            WHERE adt=%s\
                            GROUP BY eid)\
                        SELECT * FROM c\
                        ORDER BY c.ctime DESC\
                        LIMIT 1) t ON e.eid = t.eid", (today,))
    for row in cur:
        print(row)

task21(cursor)

task22(cursor)

task23(cursor, '2018-12-14')
