from faker import Faker
from faker.providers import date_time, address, person, phone_number
from random import *


def generate_age():
    return randint(0, 75)


def generate_fk(start, stop):
    return randint(start, stop)

def generate_date():
    return Faker().date_between(start_date='-1y', end_date='+1y')

def generate_sex():
    var = ['m', 'f', 'o']
    res = 0
    rand = random()
    if rand > 0.95:
        res = var[2]
    elif rand > 0.45:
        res = var[1]
    else:
        res = var[0]

    return res


def generate_bloodtype():
    return randint(1, 4)


def generate_rhfactor():
    return randint(0, 1)


def generate_priority():
    return randint(1, 5)


fakeaddress = Faker(address)
fakeaperson = Faker(person)
fakephone = Faker(phone_number)


def generate_city():
    f = open("cities.txt", "r")
    cities = []
    for i in range(117):
        cities.append(f.readline().strip('\n'))
    f.close()
    return choice(cities)


def generate_address():
    fake = Faker()
    return fake.street_address()


def generate_name(sex='o'):
    if sex == 'm':
        return fakeaperson.name_male()
    elif sex == 'f':
        return fakeaperson.name_female()
    else:
        return fakeaperson.name()


def generate_phone():
    return fakephone.phone_number()


if __name__ == "__main__":
    print(generate_date())