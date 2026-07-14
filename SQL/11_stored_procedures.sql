/*
====================================================================
Project        : Healthcare Provider & Claims Analytics
File           : 11_stored_procedures.sql
Version        : 1.0
Author         : Satish Mudari
Database       : PostgreSQL
Schema         : healthcare

Description:
This script creates reusable PostgreSQL Stored Procedures
to automate common healthcare business operations.

Topics Covered:
• CREATE PROCEDURE
• INSERT
• UPDATE
• DELETE
• Transaction Management

====================================================================
*/

SET search_path TO healthcare;

/*
=========================================================
Procedure 1: Update Doctor Salary

Business Purpose:
Updates the salary of a doctor.
=========================================================
*/

CREATE OR REPLACE PROCEDURE sp_update_doctor_salary
(
    IN p_doctor_id INT,
    IN p_new_salary NUMERIC
)
LANGUAGE plpgsql
AS
$$
BEGIN

    UPDATE doctors
    SET salary = p_new_salary
    WHERE doctor_id = p_doctor_id;

END;
$$;

CALL sp_update_doctor_salary(10,2500000);

/*
=========================================================
Procedure 2: Update Appointment Status
=========================================================
*/

CREATE OR REPLACE PROCEDURE sp_update_appointment_status
(
    IN p_appointment_id INT,
    IN p_status VARCHAR
)
LANGUAGE plpgsql
AS
$$
BEGIN

    UPDATE appointments
    SET appointment_status = p_status
    WHERE appointment_id = p_appointment_id;

END;
$$;

CALL sp_update_appointment_status(50,'Completed');

/*
=========================================================
Procedure 3: Update Claim Status
=========================================================
*/

CREATE OR REPLACE PROCEDURE sp_update_claim_status
(
    IN p_claim_id INT,
    IN p_status VARCHAR
)
LANGUAGE plpgsql
AS
$$
BEGIN

    UPDATE claims
    SET claim_status = p_status
    WHERE claim_id = p_claim_id;

END;
$$;

CALL sp_update_claim_status(100,'Approved');

/*
=========================================================
Procedure 4: Salary Increment
=========================================================
*/

CREATE OR REPLACE PROCEDURE sp_increment_salary
(
    IN p_percentage NUMERIC
)
LANGUAGE plpgsql
AS
$$
BEGIN

    UPDATE doctors
    SET salary = salary + (salary * p_percentage / 100);

END;
$$;

CALL sp_increment_salary(5);

/*
=========================================================
Procedure 5: Delete Cancelled Appointments
=========================================================
*/

CREATE OR REPLACE PROCEDURE sp_delete_cancelled_appointments()
LANGUAGE plpgsql
AS
$$
BEGIN

    DELETE
    FROM appointments
    WHERE appointment_status='Cancelled';

END;
$$;

/*
=========================================================
Procedure 6: Update Payment Status
=========================================================
*/

CREATE OR REPLACE PROCEDURE sp_update_payment_status
(
    IN p_payment_id INT,
    IN p_status VARCHAR
)
LANGUAGE plpgsql
AS
$$
BEGIN

    UPDATE payments
    SET payment_status = p_status
    WHERE payment_id = p_payment_id;

END;
$$;

/*
=========================================================
Procedure 7: Update Patient City
=========================================================
*/

CREATE OR REPLACE PROCEDURE sp_update_patient_city
(
    IN p_patient_id INT,
    IN p_city VARCHAR
)
LANGUAGE plpgsql
AS
$$
BEGIN

    UPDATE patients
    SET city = p_city
    WHERE patient_id = p_patient_id;

END;
$$;

/*
=========================================================
Procedure 8: Update Hospital Contact
=========================================================
*/

CREATE OR REPLACE PROCEDURE sp_update_hospital_phone
(
    IN p_hospital_id INT,
    IN p_phone VARCHAR
)
LANGUAGE plpgsql
AS
$$
BEGIN

    UPDATE hospitals
    SET phone = p_phone
    WHERE hospital_id = p_hospital_id;

END;
$$;

/*
=========================================================
Procedure 9: Update Treatment Cost
=========================================================
*/

CREATE OR REPLACE PROCEDURE sp_update_treatment_cost
(
    IN p_treatment_id INT,
    IN p_cost NUMERIC
)
LANGUAGE plpgsql
AS
$$
BEGIN

    UPDATE treatments
    SET treatment_cost = p_cost
    WHERE treatment_id = p_treatment_id;

END;
$$;

/*
=========================================================
Procedure 10: Update Insurance Provider Name
=========================================================
*/

CREATE OR REPLACE PROCEDURE sp_update_provider_name
(
    IN p_provider_id INT,
    IN p_name VARCHAR
)
LANGUAGE plpgsql
AS
$$
BEGIN

    UPDATE insurance_providers
    SET provider_name = p_name
    WHERE provider_id = p_provider_id;

END;
$$;