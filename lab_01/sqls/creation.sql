CREATE TABLE IF NOT EXISTS public.donor
(
    donorid SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    age SMALLINT NOT NULL CHECK (age >= 0),
    sex VARCHAR(1) NOT NULL CHECK (sex in ('m', 'f', 'o')),
    bloodtype SMALLINT NOT NULL CHECK (
        bloodtype > 0
        AND bloodtype < 5
    ),
    rhfactor BOOLEAN NOT NULL,
    city VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.clinic
(
    clinicid SERIAL PRIMARY KEY,
    city VARCHAR(30) NOT NULL,
    address VARCHAR(50) NOT NULL UNIQUE,
    phone VARCHAR(25) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS public.recipient
(
    recipientid SERIAL PRIMARY KEY,
    clinicid INT REFERENCES public.clinic(clinicid),
    name VARCHAR(30) NOT NULL,
    age SMALLINT NOT NULL CHECK (age >= 0),
    sex VARCHAR(1) NOT NULL CHECK (sex in ('m', 'f', 'o')),
    bloodtype SMALLINT NOT NULL CHECK (
        bloodtype > 0
        AND bloodtype < 5
    ),
    rhfactor BOOLEAN NOT NULL,
    priority SMALLINT NOT NULL CHECK(priority >= 1 AND priority <= 5),
    city VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.surgeon
(
    surgeonid SERIAL PRIMARY KEY,
    clinicid INT REFERENCES public.clinic(clinicid),
    name VARCHAR(30) NOT NULL,
    age SMALLINT NOT NULL CHECK (age >= 0),
    sex VARCHAR(1) NOT NULL CHECK (sex in ('m', 'f', 'o')),
    workexp SMALLINT NOT NULL,
    city VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.organ
(
    organid SERIAL PRIMARY KEY,
    donorid INT REFERENCES public.donor(donorid),
    clinicid INT REFERENCES public.clinic(clinicid),
    name VARCHAR(30) NOT NULL,
    lifetime SMALLINT NOT NULL CHECK (lifetime > 0)
);

CREATE TABLE IF NOT EXISTS public.operation (
    operationdid SERIAL PRIMARY KEY,
    organid INT REFERENCES public.organ(organid),
    patientid INT NOT NULL,
    surgeonid INT REFERENCES public.surgeon(surgeonid),
    clinicid INT REFERENCES public.clinic(clinicid),
    type CHARACTER(1) NOT NULL CHECK(type in ('i', 'o')),
    duration SMALLINT NOT NULL CHECK(duration > 0),
    start TIMESTAMP NOT NULL
);