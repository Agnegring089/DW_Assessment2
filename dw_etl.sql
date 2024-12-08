-- Configurar schema DW
SET search_path = dw;

-- 1. Carregar DimDate
INSERT INTO DimDate (full_date, year, month, day)
SELECT DISTINCT m.visit_date,
       EXTRACT(YEAR FROM m.visit_date)::INT,
       EXTRACT(MONTH FROM m.visit_date)::INT,
       EXTRACT(DAY FROM m.visit_date)::INT
FROM oltp.Medical_Records m
WHERE m.visit_date IS NOT NULL
ON CONFLICT DO NOTHING;

-- 2. Carregar DimPatient
INSERT INTO DimPatient (patient_id, name, date_of_birth, gender, address, smoker)
SELECT DISTINCT p.patient_id, p.name, p.date_of_birth, p.gender, p.address, p.smoker
FROM oltp.Patients p
ON CONFLICT DO NOTHING;

-- 3. Carregar DimDoctor (SCD Tipo 2)
-- Primeira carga inicial
INSERT INTO DimDoctor (doctor_id, name, specialty, years_of_experience, current_hospital, row_effective_date)
SELECT DISTINCT d.doctor_id, d.name, d.specialty, d.years_of_experience, d.current_hospital, CURRENT_DATE
FROM oltp.Doctors d
ON CONFLICT DO NOTHING;

-- 4. Carregar DimTreatment
INSERT INTO DimTreatment (treatment_id, treatment_type, cost, active)
SELECT DISTINCT t.treatment_id, t.treatment_type, t.cost, t.active
FROM oltp.Treatments t
ON CONFLICT DO NOTHING;

-- 5. Carregar DimDiagnosis
INSERT INTO DimDiagnosis (diagnosis_code, diagnosis_name, risk_factor)
SELECT DISTINCT diag.diagnosis_code, diag.diagnosis_name, diag.risk_factor
FROM oltp.Diagnoses diag
ON CONFLICT DO NOTHING;

UPDATE dw.DimDoctor
SET row_effective_date = '1900-01-01'
WHERE doctor_id BETWEEN 1 AND 50;

-- 6. Carregar FactMedicalRecords
INSERT INTO FactMedicalRecords (date_sk, patient_sk, doctor_sk, treatment_sk, diagnosis_sk, severity, outcome, cost)
SELECT
    d.date_sk, -- Lookup na DimDate
    p.patient_sk, -- Lookup na DimPatient
    doc.doctor_sk, -- Lookup na DimDoctor (considerando SCD Tipo 2)
    tr.treatment_sk, -- Lookup na DimTreatment
    diag.diagnosis_sk, -- Lookup na DimDiagnosis
    m.severity, -- Severidade do atendimento
    m.outcome, -- Resultado do tratamento
    tr.cost -- Custo do tratamento (aditivo)
FROM oltp.medical_records m
JOIN DimDate d ON d.full_date = m.visit_date
JOIN DimPatient p ON p.patient_id = m.patient_id
JOIN DimDoctor doc ON doc.doctor_id = m.doctor_id
                  AND m.visit_date BETWEEN doc.row_effective_date AND doc.row_expiration_date
JOIN DimTreatment tr ON tr.treatment_id = m.treatment_id
JOIN DimDiagnosis diag ON diag.diagnosis_code = m.diagnosis_code
ON CONFLICT DO NOTHING;
