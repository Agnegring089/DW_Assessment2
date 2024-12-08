-- Configurar o schema OLTP
SET search_path = oltp;

-- Populando a Tabela Patients
INSERT INTO Patients (name, date_of_birth, gender, address, smoker, contact_number, registration_date)
SELECT
    CONCAT('Paciente_', i)::TEXT AS name,
    TO_DATE('19' || LPAD((60 + i)::TEXT, 2, '0') || '-01-01', 'YYYY-MM-DD') AS date_of_birth,
    CASE WHEN i % 2 = 0 THEN 'M' ELSE 'F' END AS gender,
    CONCAT('Rua ', i, ', Bairro ', i)::TEXT AS address,
    CASE WHEN i % 3 = 0 THEN TRUE ELSE FALSE END AS smoker,
    CONCAT('(11) 9', LPAD(i::TEXT, 4, '0'), '-', LPAD(i::TEXT, 4, '0'))::TEXT AS contact_number,
    '2023-01-01'::DATE AS registration_date
FROM generate_series(1, 50) AS s(i);

-- Populando a Tabela Doctors
INSERT INTO Doctors (name, specialty, years_of_experience, current_hospital)
SELECT
    CONCAT('Médico_', i),
    CASE WHEN i % 3 = 0 THEN 'Cardiologia'
         WHEN i % 3 = 1 THEN 'Pneumologia'
         ELSE 'Clínico Geral' END,
    i % 30,
    CONCAT('Hospital_', i)
FROM generate_series(1, 50) AS i;

-- Populando a Tabela Treatments
INSERT INTO Treatments (treatment_type, cost, active)
SELECT
    CONCAT('Tratamento_', i),
    i * 100.0,
    CASE WHEN i % 2 = 0 THEN TRUE ELSE FALSE END
FROM generate_series(1, 50) AS i;

-- Populando a Tabela Diagnoses
INSERT INTO Diagnoses (diagnosis_code, diagnosis_name, risk_factor)
VALUES
    ('D01', 'Diabetes', 'Obesidade'),
    ('D02', 'Hipertensão', 'Fumante'),
    ('D03', 'Doença Cardíaca', 'Colesterol Elevado'),
    ('D04', 'Asma', 'Histórico Familiar'),
    ('D05', 'Câncer de Pulmão', 'Fumante');

-- Populando a Tabela Medical_Records
INSERT INTO Medical_Records (patient_id, diagnosis_code, treatment_id, doctor_id, visit_date, severity, outcome)
SELECT
    (i % 50) + 1,
    CASE WHEN i % 5 = 0 THEN 'D01'
         WHEN i % 5 = 1 THEN 'D02'
         WHEN i % 5 = 2 THEN 'D03'
         WHEN i % 5 = 3 THEN 'D04'
         ELSE 'D05' END,
    (i % 50) + 1,
    (i % 50) + 1,
    '2023-01-01'::DATE + (i % 365),
    (i % 2) + 1,
    CASE WHEN i % 4 = 0 THEN 1 ELSE 0 END
FROM generate_series(1, 50) AS i;
