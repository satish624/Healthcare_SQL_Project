/*
====================================================================
Project        : Healthcare Provider & Claims Analytics
File           : 06_basic_queries.sql
Version        : 1.0
Author         : Satish Mudari
Database       : PostgreSQL
Schema         : healthcare

Description:
This script contains basic SQL queries used to answer
business questions related to hospitals, patients,
doctors, appointments and insurance.

Topics Covered:
• SELECT
• DISTINCT
• WHERE
• ORDER BY
• LIMIT
• BETWEEN
• IN
• LIKE
• IS NULL
• Aliases

====================================================================
*/

SET search_path TO healthcare;

/*
=========================================================
Query 1: List All Hospitals

Business Problem:
The management team wants to view all hospitals
available in the healthcare network.

SQL Concepts Used:
- SELECT
- ORDER BY
=========================================================
*/

SELECT
    hospital_id,
    hospital_name,
    city,
    state
FROM hospitals
ORDER BY hospital_name;

/*
=========================================================
Query 2: Display All Departments

Business Problem:
Management wants to see every department available
across all hospitals.

SQL Concepts Used:
- SELECT
- ORDER BY
=========================================================
*/

SELECT
    department_id,
    hospital_id,
    department_name,
    floor_number
FROM departments
ORDER BY department_name;

/*
=========================================================
Query 3: List All Doctors

Business Problem:
Display all doctors with their specialization and
years of experience.

SQL Concepts Used:
- SELECT
- ORDER BY
=========================================================
*/

SELECT
    doctor_id,
    first_name,
    last_name,
    specialization,
    experience_years
FROM doctors
ORDER BY experience_years DESC;

/*
=========================================================
Query 4: Find Doctors with More Than 20 Years Experience

Business Problem:
Hospital administration wants to identify highly
experienced doctors.

SQL Concepts Used:
- WHERE
=========================================================
*/

SELECT
    doctor_id,
    first_name,
    last_name,
    specialization,
    experience_years
FROM doctors
WHERE experience_years > 20
ORDER BY experience_years DESC;

/*
=========================================================
Query 5: Display All Female Patients

Business Problem:
Retrieve all female patient records.

SQL Concepts Used:
- WHERE
=========================================================
*/

SELECT
    patient_id,
    first_name,
    last_name,
    gender,
    city
FROM patients
WHERE gender = 'Female'
ORDER BY first_name;

/*
=========================================================
Query 6: Find Patients Registered in the Last One Year

Business Problem:
Management wants to identify recently registered patients
for follow-up programs.

SQL Concepts Used:
- WHERE
- CURRENT_DATE
- INTERVAL
=========================================================
*/

SELECT
    patient_id,
    first_name,
    last_name,
    registration_date
FROM patients
WHERE registration_date >= CURRENT_DATE - INTERVAL '1 year'
ORDER BY registration_date DESC;


/*
=========================================================
Query 7: List All Completed Appointments

Business Problem:
Retrieve all appointments that have been successfully
completed.

SQL Concepts Used:
- WHERE
=========================================================
*/

SELECT
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    appointment_status
FROM appointments
WHERE appointment_status = 'Completed';

/*
=========================================================
Query 8: Find Doctors Specializing in Cardiology

Business Problem:
Display all doctors working as Cardiologists.

SQL Concepts Used:
- WHERE
=========================================================
*/

SELECT
    doctor_id,
    first_name,
    last_name,
    specialization
FROM doctors
WHERE specialization = 'Cardiologist';

/*
=========================================================
Query 9: Display Patients with Blood Group 'O+'

Business Problem:
Hospital staff needs a list of O+ blood donors.

SQL Concepts Used:
- WHERE
=========================================================
*/

SELECT
    patient_id,
    first_name,
    last_name,
    blood_group,
    city
FROM patients
WHERE blood_group = 'O+';

/*
=========================================================
Query 10: Find Hospitals Located in Hyderabad

Business Problem:
Management wants to view all hospitals operating
in Hyderabad.

SQL Concepts Used:
- WHERE
=========================================================
*/

SELECT
    hospital_name,
    city,
    state
FROM hospitals
WHERE city = 'Hyderabad';

/*
=========================================================
Query 11: Display Top 10 Highest Paid Doctors

Business Problem:
Identify the highest-paid doctors in the organization.

SQL Concepts Used:
- ORDER BY
- LIMIT
=========================================================
*/

SELECT
    doctor_id,
    first_name,
    last_name,
    specialization,
    salary
FROM doctors
ORDER BY salary DESC
LIMIT 10;

/*
=========================================================
Query 12: Find Patients Born Between 1990 and 2000

Business Problem:
Retrieve patients born during a specified period.

SQL Concepts Used:
- BETWEEN
=========================================================
*/

SELECT
    patient_id,
    first_name,
    last_name,
    date_of_birth
FROM patients
WHERE date_of_birth
BETWEEN '1990-01-01'
AND '2000-12-31';

/*
=========================================================
Query 13: Display Doctors with Salary Greater Than 20 Lakhs

Business Problem:
Identify doctors earning more than ₹20,00,000 annually.

SQL Concepts Used:
- WHERE
=========================================================
*/

SELECT
    doctor_id,
    first_name,
    last_name,
    salary
FROM doctors
WHERE salary > 2000000
ORDER BY salary DESC;

/*
=========================================================
Query 14: Find Appointments with Consultation Fee Above ₹1000

Business Problem:
Identify premium consultations.

SQL Concepts Used:
- WHERE
=========================================================
*/

SELECT
    appointment_id,
    patient_id,
    doctor_id,
    consultation_fee
FROM appointments
WHERE consultation_fee > 1000
ORDER BY consultation_fee DESC;

/*
=========================================================
Query 15: Display Distinct Cities Where Patients Live

Business Problem:
Management wants to know the geographical distribution
of patients.

SQL Concepts Used:
- DISTINCT
=========================================================
*/

SELECT DISTINCT
    city
FROM patients
ORDER BY city;

/*
=========================================================
Query 16: Total Number of Doctors

Business Problem:
The HR department wants to know the total number
of doctors employed across the healthcare network.

SQL Concepts Used:
- COUNT()
=========================================================
*/

SELECT COUNT(*) AS total_doctors
FROM doctors;

/*
=========================================================
Query 17: Total Number of Registered Patients

Business Problem:
Hospital management wants to know the total number
of registered patients.

SQL Concepts Used:
- COUNT()
=========================================================
*/

SELECT COUNT(*) AS total_patients
FROM patients;

/*
=========================================================
Query 18: Appointment Status Summary

Business Problem:
Management wants to monitor appointment completion
and cancellation rates.

SQL Concepts Used:
- GROUP BY
- COUNT()
=========================================================
*/

SELECT
    appointment_status,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY appointment_status
ORDER BY total_appointments DESC;

/*
=========================================================
Query 19: Doctors by Specialization

Business Problem:
Hospital administration wants to know how many
doctors belong to each specialization.

SQL Concepts Used:
- GROUP BY
- COUNT()
=========================================================
*/

SELECT
    specialization,
    COUNT(*) AS total_doctors
FROM doctors
GROUP BY specialization
ORDER BY total_doctors DESC;

/*
=========================================================
Query 20: Blood Group Distribution

Business Problem:
The blood bank wants to understand the distribution
of patient blood groups.

SQL Concepts Used:
- GROUP BY
=========================================================
*/

SELECT
    blood_group,
    COUNT(*) AS total_patients
FROM patients
GROUP BY blood_group
ORDER BY total_patients DESC;

/*
=========================================================
Query 21: Average Doctor Salary

Business Problem:
Finance wants to calculate the average annual salary
of doctors.

SQL Concepts Used:
- AVG()
=========================================================
*/

SELECT
    ROUND(AVG(salary),2) AS average_salary
FROM doctors;

/*
=========================================================
Query 22: Highest Consultation Fee

Business Problem:
Management wants to identify the maximum consultation
fee charged across all appointments.

SQL Concepts Used:
- MAX()
=========================================================
*/

SELECT
    MAX(consultation_fee) AS highest_fee
FROM appointments;

/*
=========================================================
Query 23: Lowest Consultation Fee

Business Problem:
Identify the minimum consultation fee charged.

SQL Concepts Used:
- MIN()
=========================================================
*/

SELECT
    MIN(consultation_fee) AS lowest_fee
FROM appointments;

/*
=========================================================
Query 24: Total Consultation Revenue

Business Problem:
Finance wants to calculate the total revenue
generated from consultation fees.

SQL Concepts Used:
- SUM()
=========================================================
*/

SELECT
    SUM(consultation_fee) AS total_revenue
FROM appointments;

/*
=========================================================
Query 25: Average Consultation Fee

Business Problem:
Management wants to know the average consultation
fee charged across appointments.

SQL Concepts Used:
- AVG()
=========================================================
*/

SELECT
    ROUND(AVG(consultation_fee),2) AS average_consultation_fee
FROM appointments;


/*
=========================================================
Query 26: Top 10 Highest Revenue Appointments

Business Problem:
Finance wants to identify the appointments that
generated the highest consultation revenue.

SQL Concepts Used:
- ORDER BY
- LIMIT
=========================================================
*/

SELECT
    appointment_id,
    patient_id,
    doctor_id,
    consultation_fee
FROM appointments
ORDER BY consultation_fee DESC
LIMIT 10;

/*
=========================================================
Query 27: Total Number of Hospitals by State

Business Problem:
Management wants to know the hospital distribution
across different states.

SQL Concepts Used:
- GROUP BY
=========================================================
*/

SELECT
    state,
    COUNT(*) AS total_hospitals
FROM hospitals
GROUP BY state
ORDER BY total_hospitals DESC;

/*
=========================================================
Query 28: Patients Registered Each Year

Business Problem:
Hospital administration wants to analyze patient
registration trends over the years.

SQL Concepts Used:
- EXTRACT()
- GROUP BY
=========================================================
*/

SELECT
    EXTRACT(YEAR FROM registration_date) AS registration_year,
    COUNT(*) AS total_patients
FROM patients
GROUP BY registration_year
ORDER BY registration_year;

/*
=========================================================
Query 29: Doctors with More Than 25 Years of Experience

Business Problem:
Identify senior doctors eligible for leadership roles.

SQL Concepts Used:
- WHERE
=========================================================
*/

SELECT
    doctor_id,
    first_name,
    last_name,
    specialization,
    experience_years
FROM doctors
WHERE experience_years > 25
ORDER BY experience_years DESC;

/*
=========================================================
Query 30: Appointments Scheduled Today

Business Problem:
Front desk staff wants today's appointment list.

SQL Concepts Used:
- CURRENT_DATE
=========================================================
*/

SELECT
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    appointment_status
FROM appointments
WHERE DATE(appointment_date) = CURRENT_DATE;

/*
=========================================================
Query 31: Average Treatment Cost

Business Problem:
Finance wants to calculate the average cost of treatments.

SQL Concepts Used:
- AVG()
=========================================================
*/

SELECT
    ROUND(AVG(treatment_cost),2) AS average_treatment_cost
FROM treatments;.

/*
=========================================================
Query 32: Most Common Diagnosis

Business Problem:
Hospital management wants to identify the most
frequently diagnosed medical condition.

SQL Concepts Used:
- GROUP BY
- COUNT()
=========================================================
*/

SELECT
    diagnosis_name,
    COUNT(*) AS total_cases
FROM diagnoses
GROUP BY diagnosis_name
ORDER BY total_cases DESC;

/*
=========================================================
Query 33: Insurance Providers by Number of Policies

Business Problem:
Determine which insurance companies have the
largest number of active policyholders.

SQL Concepts Used:
- GROUP BY
=========================================================
*/

SELECT
    provider_id,
    COUNT(*) AS total_policies
FROM insurance_policies
GROUP BY provider_id
ORDER BY total_policies DESC;

/*
=========================================================
Query 34: Payment Method Distribution

Business Problem:
Finance wants to understand customer payment
preferences.

SQL Concepts Used:
- GROUP BY
=========================================================
*/

SELECT
    payment_method,
    COUNT(*) AS total_transactions
FROM payments
GROUP BY payment_method
ORDER BY total_transactions DESC;

/*
=========================================================
Query 35: Claim Status Summary

Business Problem:
Insurance department wants to monitor claim
approval performance.

SQL Concepts Used:
- GROUP BY
=========================================================
*/

SELECT
    claim_status,
    COUNT(*) AS total_claims
FROM claims
GROUP BY claim_status
ORDER BY total_claims DESC;