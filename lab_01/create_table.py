from generators import generate_donor, generate_clinic, generate_recipient, generate_surgeon, generate_organ, generate_operation

def generate_table(filename, header, generator, amount=1000):
    table_file = open(filename, 'w')
    table_file.write(header)

    l = len(generator())
    records = []
    for _ in range(amount):
        record = generator()
        records.append(record)
        for i in range(l):
            table_file.write(str(record[i]) + (',' if i != (l - 1) else ''))
        table_file.write('\n')
    return records


def generate_table_wc(filename, header, generator, clinics, amount=1000):
    table_file = open(filename, 'w')
    table_file.write(header)

    l = len(generator(clinics))
    records = []
    for _ in range(amount):
        record = generator(clinics)
        records.append(record)
        for i in range(l):
            table_file.write(str(record[i]) + (',' if i != (l - 1) else ''))
        table_file.write('\n')
    return records

def generate_table_organs(filename, header, generator=generate_organ, amount = 1000):
    table_file=open(filename, 'w')
    table_file.write(header)

    l=len(generator())
    records=[]
    for i in range(amount):
        record=generator()
        record[0] = i+1
        records.append(record)
        for i in range(l):
            table_file.write(str(record[i]) + (',' if i != (l - 1) else ''))
        table_file.write('\n')
    return records


def generate_table_operations(filename, header, generator=generate_operation, amount=1000):
    table_file = open(filename, 'w')
    table_file.write(header)

    l = len(generator())
    records = []
    for i in range(amount):
        record = generator()
        record[0] = i % 500 + 1
        if record[1] > 500:
            record[4] = 'i'
        else:
            record[4] = 'o'
        records.append(record)
        for i in range(l):
            table_file.write(str(record[i]) + (',' if i != (l - 1) else ''))
        table_file.write('\n')
    return records

if __name__ == "__main__":
    # donors = generate_table(
    #     "data\donors.csv",
    #     "name, age, sex, bloodtype, rhfactor, city\n",
    #     generate_donor,
    #     500
    # )
    # print("donors are generated")

    clinics = generate_table(
        "data\clinics.csv",
        "city, address, number\n",
        generate_clinic,
        100
    )
    print("clinics are generated")

    generate_table_wc(
        "data\\recipients.csv",
        "clinicid, name, age, sex, bloodtype, rhfactor, city, priority\n",
        generate_recipient,
        clinics,
        1000
    )
    print("recipients are generated")

    # generate_table_wc(
    #     "data\\surgeons.csv",
    #     "clinicid, name, age, sex, workExp, city\n",
    #     generate_surgeon,
    #     clinics,
    #     200
    # )
    # print("surgeons are generated")

    # generate_table_organs(
    #     "data\\organs.csv",
    #     "donorid, clinicid, name, lifetime\n",
    #     generate_organ,
    #     500
    # )
    # print("organs are generated")

    # generate_table_operations(
    #     "data\\operations.csv",
    #     "organid, patientid, surgeonid, clinicid, type, duration, start\n",
    #     generate_operation,
    #     750
    # )
