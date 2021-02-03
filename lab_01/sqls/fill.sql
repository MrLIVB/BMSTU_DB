COPY public.donor(name, age, sex, bloodtype, rhfactor, city) 
FROM 'E:\study\5sem\DB\lab_01\data\donors.csv' 
    DELIMITER ',' 
    CSV HEADER;

COPY public.clinic(city, address, phone)
FROM 'E:\study\5sem\DB\lab_01\data\clinics.csv'
    DELIMITER ','
    CSV HEADER;

COPY public.recipient(clinicid, name, age, sex, bloodtype, rhfactor, city, priority)
FROM 'E:\study\5sem\DB\lab_01\data\recipients.csv'
    DELIMITER ','
    CSV HEADER;

COPY public.surgeon(clinicid, name, age, sex, workexp, city)
FROM 'E:\study\5sem\DB\lab_01\data\surgeons.csv'
    DELIMITER ','
    CSV HEADER;

COPY public.organ(donorid, clinicid, name, lifetime)
FROM 'E:\study\5sem\DB\lab_01\data\organs.csv'
    DELIMITER ','
    CSV HEADER;

COPY public.operation(organid, patientid, surgeonid, clinicid, type, duration, start)
FROM 'E:\study\5sem\DB\lab_01\data\operations.csv'
    DELIMITER ','
    CSV HEADER;