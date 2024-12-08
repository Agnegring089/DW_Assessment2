-- Configurar o schema DW
SET search_path = dw;

-- Consulta 1: Custo total dos tratamentos por endereço e ano
SELECT
    p.address AS endereco_paciente,
    d.year AS ano,
    SUM(f.cost) AS custo_total
FROM FactMedicalRecords f
JOIN DimPatient p ON f.patient_sk = p.patient_sk
JOIN DimDate d ON f.date_sk = d.date_sk
GROUP BY p.address, d.year
ORDER BY p.address, d.year;

-- Consulta 2: Pacientes fumantes por fator de risco
SELECT
    diag.risk_factor AS fator_de_risco,
    COUNT(DISTINCT f.patient_sk) AS total_pacientes_fumantes
FROM FactMedicalRecords f
JOIN DimPatient p ON f.patient_sk = p.patient_sk
JOIN DimDiagnosis diag ON f.diagnosis_sk = diag.diagnosis_sk
WHERE p.smoker = TRUE
GROUP BY diag.risk_factor
ORDER BY diag.risk_factor;

-- Consulta 3: Médicos com menor taxa de sucesso
SELECT
    doc.name AS nome_medico,
    doc.years_of_experience AS anos_experiencia,
    (CAST(SUM(f.outcome) AS DECIMAL(10,2)) / COUNT(*)) AS taxa_sucesso
FROM FactMedicalRecords f
JOIN DimDoctor doc ON f.doctor_sk = doc.doctor_sk
GROUP BY doc.name, doc.years_of_experience
ORDER BY taxa_sucesso ASC

