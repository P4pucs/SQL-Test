CREATE TABLE IF NOT EXISTS patients (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    mothers_name VARCHAR(200) NOT NULL,
    gender VARCHAR(6) NOT NULL,
    date_of_birth DATE NOT NULL,
    date_of_death DATE CHECK (date_of_death >= date_of_birth),
    birthplace VARCHAR(200) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    residence VARCHAR(200) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE IF NOT EXISTS relation_type (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS relation_quality (
    id SERIAL PRIMARY KEY,
    quality VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS relations (
    patient1_id INT REFERENCES patients(id),
    patient2_id INT REFERENCES patients(id),
    type_id INT REFERENCES relation_type(id),
    quality_id INT REFERENCES relation_quality(id) NOT NULL,
	proximity INT CHECK (proximity BETWEEN 1 AND 10),
    started DATE NOT NULL,
    ended DATE,
    PRIMARY KEY(patient1_id, patient2_id, type_id)
);
