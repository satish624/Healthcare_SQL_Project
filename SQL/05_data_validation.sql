/*
====================================================================
Project        : Healthcare Provider & Claims Analytics
File           : 05_data_validation.sql
Version        : 1.0
Author         : Satish Mudari
Database       : PostgreSQL
Schema         : healthcare

Description:
This script validates the imported data by checking row counts,
duplicate primary keys, NULL values, foreign key integrity,
and business rule consistency before analysis.

Dependencies:
- 01_create_database.sql
- 02_create_schema.sql
- 03_create_tables.sql
- 04_import_csv.sql

====================================================================
*/

SET search_path TO healthcare;

/*
=========================================================
Query 1: Verify Total Records in Each Table
Purpose:
Checks whether all CSV files were imported successfully.
=========================================================
*/

SELECT 'Hospitals' AS table_name, COUNT(*) AS total_records FROM hospitals
UNION ALL
SELECT 'Departments', COUNT(*) FROM departments
UNION ALL
SELECT 'Doctors', COUNT(*) FROM doctors
UNION ALL
SELECT 'Patients', COUNT(*) FROM patients
UNION ALL
SELECT 'Appointments', COUNT(*) FROM appointments
UNION ALL
SELECT 'Diagnoses', COUNT(*) FROM diagnoses
UNION ALL
SELECT 'Treatments', COUNT(*) FROM treatments
UNION ALL
SELECT 'Prescriptions', COUNT(*) FROM prescriptions
UNION ALL
SELECT 'Insurance Providers', COUNT(*) FROM insurance_providers
UNION ALL
SELECT 'Insurance Policies', COUNT(*) FROM insurance_policies
UNION ALL
SELECT 'Claims', COUNT(*) FROM claims
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments;

/*
=========================================================
Query 2: Check for Duplicate Hospital IDs
Purpose:
Ensures every hospital has a unique primary key.
=========================================================
*/

SELECT
    hospital_id,
    COUNT(*) AS duplicate_count
FROM hospitals
GROUP BY hospital_id
HAVING COUNT(*) > 1;

/*
=========================================================
Query 3: Check for Duplicate Department IDs
=========================================================
*/

SELECT
    department_id,
    COUNT(*) AS duplicate_count
FROM departments
GROUP BY department_id
HAVING COUNT(*) > 1;

/*
=========================================================
Query 4: Check for Duplicate Doctor IDs
=========================================================
*/

SELECT
    doctor_id,
    COUNT(*) AS duplicate_count
FROM doctors
GROUP BY doctor_id
HAVING COUNT(*) > 1;

/*
=========================================================
Query 5: Check for Duplicate Patient IDs
=========================================================
*/

SELECT
    patient_id,
    COUNT(*) AS duplicate_count
FROM patients
GROUP BY patient_id
HAVING COUNT(*) > 1;

/*
=========================================================
Query 6: Check for Duplicate Appointment IDs

Purpose:
Ensures that every appointment has a unique Appointment ID.

Expected Result:
0 Rows
=========================================================
*/

SELECT
    appointment_id,
    COUNT(*) AS duplicate_count
FROM appointments
GROUP BY appointment_id
HAVING COUNT(*) > 1;

/*
=========================================================
Query 7: Check for Duplicate Policy Numbers

Purpose:
Ensures that every insurance policy number is unique.

Expected Result:
0 Rows
=========================================================
*/

SELECT
    policy_number,
    COUNT(*) AS duplicate_count
FROM insurance_policies
GROUP BY policy_number
HAVING COUNT(*) > 1;

/*
=========================================================
Query 8: Check for NULL Values in Hospitals

Purpose:
Checks whether any mandatory fields contain NULL values.
=========================================================
*/

SELECT *
FROM hospitals
WHERE hospital_name IS NULL
   OR city IS NULL
   OR state IS NULL;

/*
=========================================================
Query 9: Departments Without Hospitals

Purpose:
Verifies that every department belongs to a valid hospital.

Expected Result:
0 Rows
=========================================================
*/

SELECT
    d.department_id,
    d.department_name
FROM departments d
LEFT JOIN hospitals h
       ON d.hospital_id = h.hospital_id
WHERE h.hospital_id IS NULL;

/*
=========================================================
Query 10: Doctors Without Departments

Purpose:
Verifies that every doctor belongs to a valid department.

Expected Result:
0 Rows
=========================================================
*/

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name
FROM doctors d
LEFT JOIN departments dp
       ON d.department_id = dp.department_id
WHERE dp.department_id IS NULL;

/*
=========================================================
Query 11: Appointments Without Patients

Purpose:
Ensures that every appointment references a valid patient.

Expected Result:
0 Rows
=========================================================
*/

SELECT
    a.appointment_id
FROM appointments a
LEFT JOIN patients p
       ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

/*
=========================================================
Query 12: Appointments Without Doctors

Purpose:
Ensures that every appointment references a valid doctor.

Expected Result:
0 Rows
=========================================================
*/

SELECT
    a.appointment_id
FROM appointments a
LEFT JOIN doctors d
       ON a.doctor_id = d.doctor_id
WHERE d.doctor_id IS NULL;

/*
=========================================================
Query 13: Claims Without Policies

Purpose:
Ensures that every insurance claim is linked to
a valid insurance policy.

Expected Result:
0 Rows
=========================================================
*/

SELECT
    c.claim_id
FROM claims c
LEFT JOIN insurance_policies p
       ON c.policy_id = p.policy_id
WHERE p.policy_id IS NULL;

/*
=========================================================
Query 14: Payments Without Appointments

Purpose:
Ensures that every payment belongs to
a valid appointment.

Expected Result:
0 Rows
=========================================================
*/

SELECT
    p.payment_id
FROM payments p
LEFT JOIN appointments a
       ON p.appointment_id = a.appointment_id
WHERE a.appointment_id IS NULL;

/*
=========================================================
Query 15: Check Invalid Appointment Status

Purpose:
Ensures appointment_status contains only valid values.

Expected Result:
0 Rows
=========================================================
*/

SELECT *
FROM appointments
WHERE appointment_status NOT IN
(
    'Scheduled',
    'Completed',
    'Cancelled'
);

/*
=========================================================
Query 16: Check Invalid Claim Status

Purpose:
Ensures claim_status contains only valid values.

Expected Result:
0 Rows
=========================================================
*/

SELECT *
FROM claims
WHERE claim_status NOT IN
(
    'Pending',
    'Approved',
    'Rejected'
);

/*
=========================================================
Query 17: Check Invalid Payment Status

Purpose:
Ensures payment_status contains only valid values.

Expected Result:
0 Rows
=========================================================
*/

SELECT *
FROM payments
WHERE payment_status NOT IN
(
    'Completed',
    'Pending',
    'Failed'
);

/*
=========================================================
Query 18: Patients Registered in the Future

Purpose:
Ensures registration dates are not greater than today's date.

Expected Result:
0 Rows
=========================================================
*/

SELECT *
FROM patients
WHERE registration_date > CURRENT_DATE;


/*
=========================================================
Query 19: Check Negative Financial Values

Purpose:
Ensures all monetary values are positive.

Expected Result:
0 Rows
=========================================================
*/

SELECT *
FROM treatments
WHERE treatment_cost < 0

UNION ALL

SELECT
    NULL,
    NULL,
    NULL,
    claim_amount,
    NULL
FROM claims
WHERE claim_amount < 0

UNION ALL

SELECT
    NULL,
    NULL,
    NULL,
    payment_amount,
    NULL
FROM payments
WHERE payment_amount < 0;

/*
=========================================================
Query 20: Data Validation Summary

Purpose:
Displays the total number of records loaded into each table.

Expected Result:
Row counts should match the imported CSV files.
=========================================================
*/

SELECT 'Hospitals' AS table_name, COUNT(*) AS total_records FROM hospitals
UNION ALL
SELECT 'Departments', COUNT(*) FROM departments
UNION ALL
SELECT 'Doctors', COUNT(*) FROM doctors
UNION ALL
SELECT 'Patients', COUNT(*) FROM patients
UNION ALL
SELECT 'Appointments', COUNT(*) FROM appointments
UNION ALL
SELECT 'Diagnoses', COUNT(*) FROM diagnoses
UNION ALL
SELECT 'Treatments', COUNT(*) FROM treatments
UNION ALL
SELECT 'Prescriptions', COUNT(*) FROM prescriptions
UNION ALL
SELECT 'Insurance Providers', COUNT(*) FROM insurance_providers
UNION ALL
SELECT 'Insurance Policies', COUNT(*) FROM insurance_policies
UNION ALL
SELECT 'Claims', COUNT(*) FROM claims
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments
ORDER BY table_name;