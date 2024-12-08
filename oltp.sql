-- Criar schema OLTP (Exemplo)
CREATE SCHEMA IF NOT EXISTS oltp;
SET search_path = oltp;

-- Tabela de Pacientes
CREATE TABLE Patients (
    patient_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    date_of_birth DATE,
    gender CHAR(1),
    address VARCHAR(200),
    smoker BOOLEAN,
    contact_number VARCHAR(50),
    registration_date DATE
);

-- Tabela de Médicos
CREATE TABLE Doctors (
    doctor_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    specialty VARCHAR(100),
    years_of_experience INT,
    current_hospital VARCHAR(100)
);

-- Tabela de Tratamentos
CREATE TABLE Treatments (
    treatment_id SERIAL PRIMARY KEY,
    treatment_type VARCHAR(100),
    cost NUMERIC(10,2),
    active BOOLEAN
);

-- Tabela de Diagnósticos
CREATE TABLE Diagnoses (
    diagnosis_code VARCHAR(10) PRIMARY KEY,
    diagnosis_name VARCHAR(200),
    risk_factor VARCHAR(200)
);

-- Tabela de Atendimentos (Medical_Records)
CREATE TABLE Medical_Records (
    record_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES Patients(patient_id),
    diagnosis_code VARCHAR(10) NOT NULL REFERENCES Diagnoses(diagnosis_code),
    treatment_id INT NOT NULL REFERENCES Treatments(treatment_id),
    doctor_id INT NOT NULL REFERENCES Doctors(doctor_id),
    visit_date DATE,
    severity INT,   -- 1=Leve, 2=Grave
    outcome INT     -- 1=Sucesso, 0=Falha
);
