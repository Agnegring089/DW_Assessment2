-- Criar schema DW
CREATE SCHEMA IF NOT EXISTS dw;
SET search_path = dw;

-- Dimensão Data (DimDate)
CREATE TABLE DimDate (
    date_sk SERIAL PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    UNIQUE (full_date)
);

-- Dimensão de Pacientes (DimPatient)
CREATE TABLE DimPatient (
    patient_sk SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    name VARCHAR(200),
    date_of_birth DATE,
    gender CHAR(1),
    address VARCHAR(500),
    smoker BOOLEAN
);

-- Dimensão de Médicos (DimDoctor) - SCD Tipo 2
CREATE TABLE DimDoctor (
    doctor_sk SERIAL PRIMARY KEY,
    doctor_id INT NOT NULL,
    name VARCHAR(200),
    specialty VARCHAR(200),
    years_of_experience INT,
    current_hospital VARCHAR(200),
    row_effective_date DATE NOT NULL,
    row_expiration_date DATE NOT NULL DEFAULT ('9999-12-31'::DATE),
    row_current_flag BOOLEAN NOT NULL DEFAULT TRUE
);

-- Dimensão de Tratamentos (DimTreatment)
CREATE TABLE DimTreatment (
    treatment_sk SERIAL PRIMARY KEY,
    treatment_id INT NOT NULL,
    treatment_type VARCHAR(200),
    cost NUMERIC(10,2),
    active BOOLEAN
);

-- Dimensão de Diagnósticos (DimDiagnosis)
CREATE TABLE DimDiagnosis (
    diagnosis_sk SERIAL PRIMARY KEY,
    diagnosis_code VARCHAR(50) NOT NULL,
    diagnosis_name VARCHAR(200),
    risk_factor VARCHAR(200)
);

-- Tabela de Fatos (FactMedicalRecords)
CREATE TABLE FactMedicalRecords (
    fact_id BIGSERIAL PRIMARY KEY,
    date_sk INT NOT NULL,
    patient_sk INT NOT NULL,
    doctor_sk INT NOT NULL,
    treatment_sk INT NOT NULL,
    diagnosis_sk INT NOT NULL,
    severity INT,
    outcome INT,
    cost NUMERIC(10,2),
    FOREIGN KEY (date_sk) REFERENCES DimDate(date_sk),
    FOREIGN KEY (patient_sk) REFERENCES DimPatient(patient_sk),
    FOREIGN KEY (doctor_sk) REFERENCES DimDoctor(doctor_sk),
    FOREIGN KEY (treatment_sk) REFERENCES DimTreatment(treatment_sk),
    FOREIGN KEY (diagnosis_sk) REFERENCES DimDiagnosis(diagnosis_sk)
);
