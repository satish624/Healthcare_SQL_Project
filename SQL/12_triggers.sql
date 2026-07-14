/*
====================================================================
Project        : Healthcare Provider & Claims Analytics
File           : 12_triggers.sql
Version        : 2.0
Author         : Satish Mudari
Database       : PostgreSQL
Schema         : healthcare

Description:
This script creates an enterprise-grade audit logging
system using a single reusable trigger function.

Features:
• Generic Audit Trigger
• AFTER UPDATE Triggers
• Audit Logging
• Reusable Design
• Production-Ready

Topics Covered:
• CREATE FUNCTION
• CREATE TRIGGER
• TG_TABLE_NAME
• TG_OP
• Dynamic Audit Logging

Dependencies:
- 01_create_database.sql
- 02_create_schema.sql
- 03_create_tables.sql

====================================================================
*/

SET search_path TO healthcare;

/*
=========================================================
Step 1

Create Audit Log Table

Business Purpose:
Stores every UPDATE operation performed
on important business tables.

=========================================================
*/

CREATE TABLE audit_log
(
    audit_id SERIAL PRIMARY KEY,

    table_name VARCHAR(100) NOT NULL,

    operation_type VARCHAR(20) NOT NULL,

    record_id INT NOT NULL,

    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*
Step-2 Verifying 
*/

SELECT *

FROM information_schema.columns

WHERE table_schema='healthcare'

AND table_name='audit_log'

ORDER BY ordinal_position;

/*
=========================================================
Step 3

Generic Audit Trigger Function

Business Purpose:
Logs UPDATE operations performed
on different tables.

=========================================================
*/

CREATE OR REPLACE FUNCTION fn_audit_log()

RETURNS TRIGGER

LANGUAGE plpgsql

AS
$$

DECLARE

    v_record_id INT;

BEGIN

    /*
    Determine Primary Key
    */

    CASE TG_TABLE_NAME

        WHEN 'doctors' THEN

            v_record_id := NEW.doctor_id;

        WHEN 'patients' THEN

            v_record_id := NEW.patient_id;

        WHEN 'appointments' THEN

            v_record_id := NEW.appointment_id;

        WHEN 'claims' THEN

            v_record_id := NEW.claim_id;

        WHEN 'payments' THEN

            v_record_id := NEW.payment_id;

        WHEN 'departments' THEN

            v_record_id := NEW.department_id;

        WHEN 'hospitals' THEN

            v_record_id := NEW.hospital_id;

        WHEN 'insurance_providers' THEN

            v_record_id := NEW.provider_id;

    END CASE;

    INSERT INTO audit_log
    (
        table_name,
        operation_type,
        record_id
    )

    VALUES
    (
        TG_TABLE_NAME,
        TG_OP,
        v_record_id
    );

    RETURN NEW;

END;

$$;

/*
=========================================================
Doctor Trigger
=========================================================
*/

CREATE TRIGGER trg_doctor_update

AFTER UPDATE

ON doctors

FOR EACH ROW

EXECUTE FUNCTION fn_audit_log();

/*
=========================================================
Patient Trigger
=========================================================
*/

CREATE TRIGGER trg_patient_update

AFTER UPDATE

ON patients

FOR EACH ROW

EXECUTE FUNCTION fn_audit_log();

/*
=========================================================
Appointment Trigger
=========================================================
*/

CREATE TRIGGER trg_appointment_update

AFTER UPDATE

ON appointments

FOR EACH ROW

EXECUTE FUNCTION fn_audit_log();

/*
=========================================================
Claim Trigger
=========================================================
*/

CREATE TRIGGER trg_claim_update

AFTER UPDATE

ON claims

FOR EACH ROW

EXECUTE FUNCTION fn_audit_log();

/*
=========================================================
Payment Trigger
=========================================================
*/

CREATE TRIGGER trg_payment_update

AFTER UPDATE

ON payments

FOR EACH ROW

EXECUTE FUNCTION fn_audit_log();

/*
=========================================================
Hospital Trigger
=========================================================
*/

CREATE TRIGGER trg_hospital_update

AFTER UPDATE

ON hospitals

FOR EACH ROW

EXECUTE FUNCTION fn_audit_log();

/*
=========================================================
Department Trigger
=========================================================
*/

CREATE TRIGGER trg_department_update

AFTER UPDATE

ON departments

FOR EACH ROW

EXECUTE FUNCTION fn_audit_log();

/*
=========================================================
Insurance Provider Trigger
=========================================================
*/

CREATE TRIGGER trg_provider_update

AFTER UPDATE

ON insurance_providers

FOR EACH ROW

EXECUTE FUNCTION fn_audit_log();

/*
=========================================================
Verification

Doctor
=========================================================
*/

UPDATE doctors

SET salary = salary + 500

WHERE doctor_id = 10;

SELECT *
FROM audit_log;

/* 
Patients
*/

UPDATE patients

SET city='Hyderabad'

WHERE patient_id=200;

SELECT *
FROM audit_log
ORDER BY audit_id DESC;