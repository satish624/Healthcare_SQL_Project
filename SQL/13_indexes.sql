/*
====================================================================
Project        : Healthcare Provider & Claims Analytics
File           : 13_indexes.sql
Version        : 1.0
Author         : Satish Mudari
Database       : PostgreSQL
Schema         : healthcare

Description:
This script creates indexes to optimize query performance
for frequently searched and joined columns.

Topics Covered:
• CREATE INDEX
• Composite Index
• Unique Index
• Performance Optimization
• EXPLAIN ANALYZE

Dependencies:
- 03_create_tables.sql

====================================================================
*/

SET search_path TO healthcare;

/*
=========================================================
Index 1

Business Purpose:
Speeds up searches for doctors by specialization.

=========================================================
*/

CREATE INDEX idx_doctors_specialization

ON doctors(specialization);

/*
=========================================================
Index 2

Business Purpose:
Optimizes appointment searches by date.

=========================================================
*/

CREATE INDEX idx_appointments_date

ON appointments(appointment_date);

/*
=========================================================
Index 3

Business Purpose:
Improves joins between Patients and Appointments.

=========================================================
*/

CREATE INDEX idx_appointments_patient

ON appointments(patient_id);

/*
=========================================================
Index 4

Business Purpose:
Improves doctor-wise appointment analysis.

=========================================================
*/

CREATE INDEX idx_appointments_doctor

ON appointments(doctor_id);

/*
=========================================================
Index 5

Business Purpose:
Speeds up joins between Doctors and Departments.

=========================================================
*/

CREATE INDEX idx_doctors_department

ON doctors(department_id);

/*
=========================================================
Index 6

Business Purpose:
Optimizes joins between Hospitals and Departments.

=========================================================
*/

CREATE INDEX idx_departments_hospital

ON departments(hospital_id);

/*
=========================================================
Index 7

Business Purpose:
Optimizes insurance provider lookups.

=========================================================
*/

CREATE INDEX idx_policies_provider

ON insurance_policies(provider_id);

/*
=========================================================
Index 8

Business Purpose:
Speeds up joins between Policies and Claims.

=========================================================
*/

CREATE INDEX idx_claims_policy

ON claims(policy_id);


/*
=========================================================
Index 9

Composite Index

Business Purpose:
Optimizes queries filtering appointments
by Doctor and Appointment Date.

=========================================================
*/

CREATE INDEX idx_doctor_date

ON appointments
(
    doctor_id,
    appointment_date
);

/*
=========================================================
Index 10

Composite Index

Business Purpose:
Optimizes patient appointment history queries.

=========================================================
*/

CREATE INDEX idx_patient_date

ON appointments
(
    patient_id,
    appointment_date
);

/*
=========================================================
Verification

Display all indexes created
for Healthcare schema.

=========================================================
*/

SELECT

schemaname,

tablename,

indexname

FROM pg_indexes

WHERE schemaname='healthcare'

ORDER BY tablename;


/*
=========================================================
Performance Test

Business Purpose:
Analyze query execution plan.

=========================================================
*/

EXPLAIN ANALYZE

SELECT *

FROM appointments

WHERE doctor_id = 100;

