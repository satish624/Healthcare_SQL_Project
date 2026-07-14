/*
====================================================================
Project        : Healthcare Provider & Claims Analytics
File           : 10_functions.sql
Version        : 1.0
Author         : Satish Mudari
Database       : PostgreSQL
Schema         : healthcare

Description:
This script creates reusable PostgreSQL functions
for reporting, analytics, and business calculations.

Topics Covered:
• CREATE FUNCTION
• Scalar Functions
• Table-Valued Functions
• Business Logic

====================================================================
*/

SET search_path TO healthcare;

/*
=========================================================
Function 1: Get Doctor Revenue

Business Purpose:
Returns the total consultation revenue generated
by a doctor.
=========================================================
*/

CREATE OR REPLACE FUNCTION fn_doctor_revenue
(
    p_doctor_id INT
)

RETURNS NUMERIC

LANGUAGE plpgsql

AS
$$

DECLARE

v_revenue NUMERIC;

BEGIN

SELECT

COALESCE(SUM(consultation_fee),0)

INTO v_revenue

FROM appointments

WHERE doctor_id=p_doctor_id;

RETURN v_revenue;

END;

$$;

SELECT fn_doctor_revenue(10);

/*
=========================================================
Function 2: Patient Total Visits
=========================================================
*/

CREATE OR REPLACE FUNCTION fn_patient_visits
(
    p_patient_id INT
)

RETURNS INT

LANGUAGE plpgsql

AS
$$

DECLARE

v_total INT;

BEGIN

SELECT

COUNT(*)

INTO v_total

FROM appointments

WHERE patient_id=p_patient_id;

RETURN v_total;

END;

$$;

SELECT fn_patient_visits(100);

/*
=========================================================
Function 3: Experience Category
=========================================================
*/

CREATE OR REPLACE FUNCTION fn_experience_level
(
    p_years INT
)

RETURNS VARCHAR(20)

LANGUAGE plpgsql

AS
$$

BEGIN

RETURN

CASE

WHEN p_years<5 THEN 'Junior'

WHEN p_years BETWEEN 5 AND 15 THEN 'Mid-Level'

WHEN p_years BETWEEN 16 AND 25 THEN 'Senior'

ELSE 'Expert'

END;

END;

$$;

SELECT fn_experience_level(18);

/*
=========================================================
Function 4: Calculate Patient Age
=========================================================
*/

CREATE OR REPLACE FUNCTION fn_patient_age
(
    p_dob DATE
)

RETURNS INT

LANGUAGE plpgsql

AS
$$

BEGIN

RETURN

EXTRACT(YEAR FROM AGE(CURRENT_DATE,p_dob));

END;

$$;

SELECT

patient_id,

first_name,

fn_patient_age(date_of_birth)

FROM patients

LIMIT 10;

/*
=========================================================
Function 5: Average Consultation Fee
=========================================================
*/

CREATE OR REPLACE FUNCTION fn_average_fee()

RETURNS NUMERIC

LANGUAGE plpgsql

AS
$$

DECLARE

v_avg NUMERIC;

BEGIN

SELECT

AVG(consultation_fee)

INTO v_avg

FROM appointments;

RETURN ROUND(v_avg,2);

END;

$$;

SELECT fn_average_fee();

/*
=========================================================
Function 6: Hospital Total Revenue

Business Purpose:
Returns the total consultation revenue generated
by a specific hospital.
=========================================================
*/

CREATE OR REPLACE FUNCTION fn_hospital_revenue
(
    p_hospital_id INT
)

RETURNS NUMERIC

LANGUAGE plpgsql

AS
$$

DECLARE

v_revenue NUMERIC;

BEGIN

SELECT

COALESCE(SUM(a.consultation_fee),0)

INTO v_revenue

FROM hospitals h

JOIN departments dp
ON h.hospital_id=dp.hospital_id

JOIN doctors d
ON dp.department_id=d.department_id

JOIN appointments a
ON d.doctor_id=a.doctor_id

WHERE h.hospital_id=p_hospital_id;

RETURN v_revenue;

END;

$$;

SELECT fn_hospital_revenue(1);

/*
=========================================================
Function 7: Insurance Claims Count
=========================================================
*/

CREATE OR REPLACE FUNCTION fn_provider_claims
(
    p_provider_id INT
)

RETURNS INTEGER

LANGUAGE plpgsql

AS
$$

DECLARE

v_claims INT;

BEGIN

SELECT

COUNT(c.claim_id)

INTO v_claims

FROM insurance_policies p

JOIN claims c
ON p.policy_id=c.policy_id

WHERE p.provider_id=p_provider_id;

RETURN v_claims;

END;

$$;

SELECT fn_provider_claims(2);

/*
=========================================================
Function 8: Total Payments Received
=========================================================
*/

CREATE OR REPLACE FUNCTION fn_total_payments()

RETURNS NUMERIC

LANGUAGE plpgsql

AS
$$

DECLARE

v_total NUMERIC;

BEGIN

SELECT

SUM(payment_amount)

INTO v_total

FROM payments;

RETURN v_total;

END;

$$;

SELECT fn_total_payments();

/*
=========================================================
Function 9: Doctor Appointment Count
=========================================================
*/

CREATE OR REPLACE FUNCTION fn_doctor_appointments
(
    p_doctor_id INT
)

RETURNS INTEGER

LANGUAGE plpgsql

AS
$$

DECLARE

v_count INT;

BEGIN

SELECT

COUNT(*)

INTO v_count

FROM appointments

WHERE doctor_id=p_doctor_id;

RETURN v_count;

END;

$$;

SELECT fn_doctor_appointments(10);

/*
=========================================================
Function 10: Insurance Approval Rate
=========================================================
*/

CREATE OR REPLACE FUNCTION fn_claim_approval_rate()

RETURNS NUMERIC

LANGUAGE plpgsql

AS
$$

DECLARE

v_rate NUMERIC;

BEGIN

SELECT

ROUND(

100.0 *

COUNT(
CASE
WHEN claim_status='Approved'
THEN 1
END
)

/

COUNT(*),

2

)

INTO v_rate

FROM claims;

RETURN v_rate;

END;

$$;

SELECT fn_claim_approval_rate();

