import psycopg2
from psycopg2 import sql

def scalar(cursor):
    cursor.execute('SELECT AVG(sage) AS "Actual Avg",\
                   SUM(sage) / COUNT(city) AS "Calc Avg"\
                   FROM(\
                        SELECT city, AVG(age) AS sage\
                        FROM recipient\
                        GROUP BY city\
                    ) AS totrec')
    print("Средний возраст по городам")
    for row in cursor:
        print(row)

def joins(cursor):
    cursor.execute('SELECT *\
                   FROM clinic\
                   where clinicid NOT IN(\
                       SELECT clinicid\
                       FROM surgeon\
                       JOIN(\
                           SELECT operation.surgeonid AS SI\
                           FROM operation\
                           JOIN organ ON(operation.organid=organ.organid)\
                           WHERE organ.name=(\
                               SELECT name\
                               FROM organ\
                               GROUP BY name\
                               ORDER BY COUNT(organid) DESC\
                               LIMIT 1\
                           )\
                       ) AS T ON surgeonid=SI\
                   )')
    
    print("Те клиники, хирурги которых не пересаживают орган, который встречается чаще всего")
    for row in cursor:
        print(row)

def cte_partition(cursor):
    city = input("Введите город: ")
    cursor.execute("with cte(donorid, name, age, bloodtype, rhfactor)\
                   as\
                   (\
	                    select donorid, name, age, bloodtype, rhfactor from donor\
	                    where city=%s\
                    )\
                    SELECT donorid,\
                    name,\
                    AVG(age) OVER(PARTITION BY bloodtype, rhfactor) AS AvgAge,\
                    MAX(age) OVER(PARTITION BY bloodtype, rhfactor) AS MaxAge,\
                    MIN(age) OVER(PARTITION BY bloodtype, rhfactor) AS MinAge\
                    FROM cte", (city, ))
    print("Выделяет средний, максимальный и минимальный возраст разбивая его по группе крови и резус фактору из определённого города")
    for row in cursor:
        print(row)

def metadata(cursor):
    cursor.execute("\
    SELECT count(*) FROM pg_proc\
    where pronamespace =\
            ( SELECT oid\
            FROM pg_namespace\
            WHERE nspname = 'public')")
        
    print("Выводит количество созданных процедур и функций")
    for row in cursor:
        print(row)

def call_scalar(cursor):
    cursor.execute("SELECT RecipientsWaiting();")
    print("Количество реципиентов ожидающих операции:")
    for row in cursor:
        print(row)

def call_table(cursor):
    print("Возвращает имена всех хирургов с опытом работы больше заданного")
    exp = int(input("Введите минимальный опыт работы: "))
    cursor.callproc('SurgeonWithExp', [exp, ])
    for row in cursor:
        print(row)

def procedure(cursor):
    print("Проверяет есть ли 2 операции одинакового типа для одного органа")
    cursor.execute("CALL FindDuplicates();")
    for row in cursor:
        print(row)

def call_system(cursor):
    print("Выводит имя текущей базы данных")
    cursor.callproc('current_database')
    for row in cursor:
        print(row)

def create_table(cursor):
    print("Создать таблицу organtype")
    cursor.execute("CREATE TABLE IF NOT EXISTS organtype(oid SERIAL PRIMARY KEY, oname  VARCHAR(40))")
    print("Таблица была создана. Подтвердить изменение? 0-нет")
    ch = int(input("Вариант: "))
    if ch:
        cursor.commit()

def insert_into(cursor):
    print("Вставить данные в таблицу")
    oname = input("Введите имя оргна: ")
    cursor.execute("INSERT INTO organtype(oname) VALUES(%s)", (oname,))
    print("Данные были добавлены")

if __name__ == "__main__":
    connection = psycopg2.connect(dbname='Donors', user='postgres', password='Deep123Dark', host='localhost')
    cursor = connection.cursor()
    while 1:
        print("Меню")
        print("1. Скалярный запрос")
        print("2. Запрос с несколькими JOIN")
        print("3. Запрос c ОТВ и оконными функциями")
        print("4. Запрос к метаданным")
        print("5. Вызвать скалярную функцию")
        print("6. Вызвать подставляемую табличную функцию функцию")
        print("7. Хранимую процедуру")
        print("8. Системную функцию или процедуру")
        print("9. Создать таблицу")
        print("10. Выполнить вставку данных в созданную таблицу")
        print("0. - Выход\n")
        choice = int(input("Номер пункта: "))
        if not choice:
            cursor.close()
            connection.close()
            break
        elif choice == 1:
            scalar(cursor)
        elif choice == 2:
            joins(cursor)
        elif choice == 3:
            cte_partition(cursor)
        elif choice == 4:
            metadata(cursor)
        elif choice == 5:
            call_scalar(cursor)
        elif choice == 6:
            call_table(cursor)
        elif choice == 7:
            procedure(cursor)
        elif choice == 8:
            call_system(cursor)
        elif choice == 9:
            create_table(cursor)
        elif choice == 10:
            insert_into(cursor)
