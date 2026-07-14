/*
====================================================================
Project        : Healthcare Provider & Claims Analytics
File           : 07_intermediate_queries.sql
Version        : 1.0
Author         : Satish Mudari
Database       : PostgreSQL
Schema         : healthcare

Description:
This script contains intermediate SQL queries that solve
real-world healthcare business problems using joins,
aggregations, CASE expressions, HAVING, and subqueries.

Topics Covered:
• INNER JOIN
• LEFT JOIN
• GROUP BY
• HAVING
• CASE
• Aggregate Functions
• Subqueries

====================================================================
*/

SET search_path TO healthcare;

/*
=========================================================
Query 1: Display Doctors with Their Departments

Business Problem:
Hospital management wants to know which department
each doctor belongs to.

SQL Concepts Used:
- INNER JOIN
=========================================================
*/

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.specialization,
    dp.department_name
FROM doctors d
INNER JOIN departments dp
ON d.department_id = dp.department_id
ORDER BY dp.department_name;

/*
=========================================================
Query 2: Departments with Hospital Names

Business Problem:
Management wants to know which departments belong
to each hospital.

SQL Concepts Used:
- INNER JOIN
=========================================================
*/

SELECT
    dp.department_name,
    h.hospital_name,
    h.city
FROM departments dp
INNER JOIN hospitals h
ON dp.hospital_id = h.hospital_id
ORDER BY h.hospital_name;

/*
=========================================================
Query 3: Number of Doctors in Each Department

Business Problem:
Hospital administration wants to know how many
doctors work in each department.

SQL Concepts Used:
- INNER JOIN
- GROUP BY
=========================================================
*/

SELECT
    dp.department_name,
    COUNT(d.doctor_id) AS total_doctors
FROM departments dp
INNER JOIN doctors d
ON dp.department_id = d.department_id
GROUP BY dp.department_name
ORDER BY total_doctors DESC;

/*
=========================================================
Query 4: Doctors with More Than 30 Appointments

Business Problem:
Identify busy doctors handling a high number
of appointments.

SQL Concepts Used:
- INNER JOIN
- GROUP BY
- HAVING
=========================================================
*/

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    COUNT(a.appointment_id) AS total_appointments
FROM doctors d
INNER JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
HAVING COUNT(a.appointment_id) > 30
ORDER BY total_appointments DESC;

/*
=========================================================
Query 5: Top 10 Busiest Doctors

Business Problem:
Hospital management wants to identify the doctors
handling the highest number of appointments.

SQL Concepts Used:
- INNER JOIN
- GROUP BY
- ORDER BY
- LIMIT
=========================================================
*/

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.specialization,
    COUNT(a.appointment_id) AS total_appointments
FROM doctors d
INNER JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.specialization
ORDER BY total_appointments DESC
LIMIT 10;

/*
=========================================================
Query 6: Top 10 Doctors by Consultation Revenue

Business Problem:
Finance wants to identify the doctors generating
the highest consultation revenue.

SQL Concepts Used:
- INNER JOIN
- SUM()
=========================================================
*/

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.specialization,
    SUM(a.consultation_fee) AS total_revenue
FROM doctors d
INNER JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.specialization
ORDER BY total_revenue DESC
LIMIT 10;

/*
=========================================================
Query 7: Hospital-wise Number of Departments

Business Problem:
Management wants to know how many departments
are available in each hospital.

SQL Concepts Used:
- INNER JOIN
- GROUP BY
=========================================================
*/

SELECT
    h.hospital_name,
    COUNT(dp.department_id) AS total_departments
FROM hospitals h
INNER JOIN departments dp
ON h.hospital_id = dp.hospital_id
GROUP BY h.hospital_name
ORDER BY total_departments DESC;

/*
=========================================================
Query 8: Hospital-wise Number of Doctors

Business Problem:
Management wants to identify hospitals with
the largest medical workforce.

SQL Concepts Used:
- INNER JOIN
- GROUP BY
=========================================================
*/

SELECT
    h.hospital_name,
    COUNT(d.doctor_id) AS total_doctors
FROM hospitals h
INNER JOIN departments dp
ON h.hospital_id = dp.hospital_id
INNER JOIN doctors d
ON dp.department_id = d.department_id
GROUP BY h.hospital_name
ORDER BY total_doctors DESC;

/*
=========================================================
Query 9: Hospital-wise Total Appointments

Business Problem:
Hospital management wants to know the workload
handled by each hospital.

SQL Concepts Used:
- Multiple INNER JOINs
- GROUP BY
=========================================================
*/

SELECT
    h.hospital_name,
    COUNT(a.appointment_id) AS total_appointments
FROM hospitals h
INNER JOIN departments dp
ON h.hospital_id = dp.hospital_id
INNER JOIN doctors d
ON dp.department_id = d.department_id
INNER JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY h.hospital_name
ORDER BY total_appointments DESC;

/*
=========================================================
Query 10: Hospital-wise Consultation Revenue

Business Problem:
Finance wants to know which hospitals generate
the highest consultation revenue.

SQL Concepts Used:
- SUM()
- INNER JOIN
=========================================================
*/

SELECT
    h.hospital_name,
    SUM(a.consultation_fee) AS total_revenue
FROM hospitals h
INNER JOIN departments dp
ON h.hospital_id = dp.hospital_id
INNER JOIN doctors d
ON dp.department_id = d.department_id
INNER JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY h.hospital_name
ORDER BY total_revenue DESC;

/*
=========================================================
Query 11: Average Doctor Salary by Department

Business Problem:
HR wants to compare the average salaries
across departments.

SQL Concepts Used:
- AVG()
- GROUP BY
=========================================================
*/

SELECT
    dp.department_name,
    ROUND(AVG(d.salary),2) AS average_salary
FROM departments dp
INNER JOIN doctors d
ON dp.department_id = d.department_id
GROUP BY dp.department_name
ORDER BY average_salary DESC;

/*
=========================================================
Query 12: Departments with More Than 40 Doctors

Business Problem:
Management wants to identify departments
requiring additional resources.

SQL Concepts Used:
- GROUP BY
- HAVING
=========================================================
*/

SELECT
    dp.department_name,
    COUNT(d.doctor_id) AS total_doctors
FROM departments dp
INNER JOIN doctors d
ON dp.department_id = d.department_id
GROUP BY dp.department_name
HAVING COUNT(d.doctor_id) > 40
ORDER BY total_doctors DESC;

/*
=========================================================
Query 13: Number of Appointments by Doctor Specialization

Business Problem:
Identify which medical specialties handle
the highest patient volume.

SQL Concepts Used:
- GROUP BY
=========================================================
*/

SELECT
    d.specialization,
    COUNT(a.appointment_id) AS total_appointments
FROM doctors d
INNER JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY d.specialization
ORDER BY total_appointments DESC;

/*
=========================================================
Query 14: Average Consultation Fee by Doctor Specialization

Business Problem:
Management wants to compare consultation
charges across specialties.

SQL Concepts Used:
- AVG()
=========================================================
*/

SELECT
    d.specialization,
    ROUND(AVG(a.consultation_fee),2) AS average_fee
FROM doctors d
INNER JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY d.specialization
ORDER BY average_fee DESC;

/*
=========================================================
Query 15: Top 10 Patients with Highest Number of Visits

Business Problem:
Hospital management wants to identify
frequent visitors for loyalty programs
and chronic disease management.

SQL Concepts Used:
- GROUP BY
- COUNT()
- LIMIT
=========================================================
*/

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    COUNT(a.appointment_id) AS total_visits
FROM patients p
INNER JOIN appointments a
ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
ORDER BY total_visits DESC
LIMIT 10;

/*
=========================================================
Query 16: Top 10 Hospitals by Consultation Revenue

Business Problem:
The finance team wants to identify the hospitals
that generate the highest consultation revenue.

SQL Concepts Used:
- INNER JOIN
- GROUP BY
- SUM()
- LIMIT
=========================================================
*/

SELECT
    h.hospital_name,
    SUM(a.consultation_fee) AS total_revenue
FROM hospitals h
INNER JOIN departments dp
    ON h.hospital_id = dp.hospital_id
INNER JOIN doctors d
    ON dp.department_id = d.department_id
INNER JOIN appointments a
    ON d.doctor_id = a.doctor_id
GROUP BY h.hospital_name
ORDER BY total_revenue DESC
LIMIT 10;

/*
=========================================================
Query 17: Department with Highest Revenue

Business Problem:
Management wants to identify the department
that generates the highest consultation revenue.

SQL Concepts Used:
- INNER JOIN
- GROUP BY
- SUM()
=========================================================
*/

SELECT
    dp.department_name,
    SUM(a.consultation_fee) AS total_revenue
FROM departments dp
INNER JOIN doctors d
    ON dp.department_id = d.department_id
INNER JOIN appointments a
    ON d.doctor_id = a.doctor_id
GROUP BY dp.department_name
ORDER BY total_revenue DESC;

/*
=========================================================
Query 18: Top 10 Doctors by Completed Appointments

Business Problem:
Identify doctors who have completed the
highest number of appointments.

SQL Concepts Used:
- GROUP BY
- WHERE
=========================================================
*/

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    COUNT(a.appointment_id) AS completed_appointments
FROM doctors d
INNER JOIN appointments a
    ON d.doctor_id = a.doctor_id
WHERE a.appointment_status = 'Completed'
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY completed_appointments DESC
LIMIT 10;

/*
=========================================================
Query 19: Appointment Status by Hospital

Business Problem:
Management wants to analyze appointment
statuses for every hospital.

SQL Concepts Used:
- Multiple INNER JOINs
- GROUP BY
=========================================================
*/

SELECT
    h.hospital_name,
    a.appointment_status,
    COUNT(*) AS total_appointments
FROM hospitals h
INNER JOIN departments dp
    ON h.hospital_id = dp.hospital_id
INNER JOIN doctors d
    ON dp.department_id = d.department_id
INNER JOIN appointments a
    ON d.doctor_id = a.doctor_id
GROUP BY
    h.hospital_name,
    a.appointment_status
ORDER BY
    h.hospital_name,
    total_appointments DESC;

/*
=========================================================
Query 20: Average Experience by Department

Business Problem:
HR wants to compare the average years of
experience across departments.

SQL Concepts Used:
- AVG()
=========================================================
*/

SELECT
    dp.department_name,
    ROUND(AVG(d.experience_years),2) AS avg_experience
FROM departments dp
INNER JOIN doctors d
    ON dp.department_id = d.department_id
GROUP BY dp.department_name
ORDER BY avg_experience DESC;

/*
=========================================================
Query 21: Patients with More Than 10 Visits

Business Problem:
Identify frequent patients who may require
long-term care programs.

SQL Concepts Used:
- GROUP BY
- HAVING
=========================================================
*/

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    COUNT(a.appointment_id) AS total_visits
FROM patients p
INNER JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
HAVING COUNT(a.appointment_id) > 10
ORDER BY total_visits DESC;

/*
=========================================================
Query 22: Insurance Provider with Most Policies

Business Problem:
Identify the insurance company covering
the highest number of patients.

SQL Concepts Used:
- GROUP BY
=========================================================
*/

SELECT
    ip.provider_name,
    COUNT(pol.policy_id) AS total_policies
FROM insurance_providers ip
INNER JOIN insurance_policies pol
    ON ip.provider_id = pol.provider_id
GROUP BY ip.provider_name
ORDER BY total_policies DESC;

/*
=========================================================
Query 23: Insurance Claim Approval Summary

Business Problem:
The insurance team wants to compare
approved, pending, and rejected claims.

SQL Concepts Used:
- GROUP BY
=========================================================
*/

SELECT
    claim_status,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount
FROM claims
GROUP BY claim_status
ORDER BY total_claims DESC;

/*
=========================================================
Query 24: Payment Method Revenue

Business Problem:
Finance wants to know how much revenue
is received through each payment method.

SQL Concepts Used:
- GROUP BY
- SUM()
=========================================================
*/

SELECT
    payment_method,
    SUM(payment_amount) AS total_revenue
FROM payments
GROUP BY payment_method
ORDER BY total_revenue DESC;

/*
=========================================================
Query 25: Top 10 Most Common Diagnoses

Business Problem:
Hospital management wants to identify the
most frequently diagnosed medical conditions.

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
ORDER BY total_cases DESC
LIMIT 10;

/*
=========================================================
Query 26: Categorize Doctors by Experience

Business Problem:
HR wants to classify doctors based on their
years of experience.

SQL Concepts Used:
- CASE
=========================================================
*/

SELECT
    doctor_id,
    first_name,
    last_name,
    experience_years,
    CASE
        WHEN experience_years < 5 THEN 'Junior'
        WHEN experience_years BETWEEN 5 AND 15 THEN 'Mid-Level'
        WHEN experience_years BETWEEN 16 AND 25 THEN 'Senior'
        ELSE 'Expert'
    END AS experience_level
FROM doctors
ORDER BY experience_years DESC;

/*
=========================================================
Query 27: Categorize Consultation Fees

Business Problem:
Finance wants to classify appointments based
on consultation fee.

SQL Concepts Used:
- CASE
=========================================================
*/

SELECT
    appointment_id,
    consultation_fee,
    CASE
        WHEN consultation_fee <= 700 THEN 'Low'
        WHEN consultation_fee <= 1200 THEN 'Medium'
        ELSE 'High'
    END AS fee_category
FROM appointments
ORDER BY consultation_fee DESC;

/*
=========================================================
Query 28: Patients With Insurance

Business Problem:
Identify patients who have an active
insurance policy.

SQL Concepts Used:
- INNER JOIN
=========================================================
*/

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    ip.provider_name
FROM patients p
INNER JOIN insurance_policies pol
    ON p.patient_id = pol.patient_id
INNER JOIN insurance_providers ip
    ON pol.provider_id = ip.provider_id
ORDER BY p.patient_id;

/*
=========================================================
Query 29: Patients Without Insurance

Business Problem:
Identify patients who do not have any
insurance policy.

SQL Concepts Used:
- LEFT JOIN
=========================================================
*/

SELECT
    p.patient_id,
    p.first_name,
    p.last_name
FROM patients p
LEFT JOIN insurance_policies pol
    ON p.patient_id = pol.patient_id
WHERE pol.patient_id IS NULL
ORDER BY p.patient_id;

/*
=========================================================
Query 30: Doctors Without Appointments

Business Problem:
Identify doctors who have not handled
any appointments.

SQL Concepts Used:
- LEFT JOIN
=========================================================
*/

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name
FROM doctors d
LEFT JOIN appointments a
    ON d.doctor_id = a.doctor_id
WHERE a.doctor_id IS NULL;

/*
=========================================================
Query 31: Departments Without Doctors

Business Problem:
Identify departments that currently have
no doctors assigned.

SQL Concepts Used:
- LEFT JOIN
=========================================================
*/

SELECT
    dp.department_id,
    dp.department_name
FROM departments dp
LEFT JOIN doctors d
    ON dp.department_id = d.department_id
WHERE d.department_id IS NULL;

/*
=========================================================
Query 32: Average Salary by Experience Level

Business Problem:
HR wants to compare average salaries
across different experience levels.

SQL Concepts Used:
- CASE
- GROUP BY
=========================================================
*/

SELECT
    CASE
        WHEN experience_years < 5 THEN 'Junior'
        WHEN experience_years BETWEEN 5 AND 15 THEN 'Mid-Level'
        WHEN experience_years BETWEEN 16 AND 25 THEN 'Senior'
        ELSE 'Expert'
    END AS experience_level,
    ROUND(AVG(salary),2) AS average_salary
FROM doctors
GROUP BY experience_level
ORDER BY average_salary DESC;

/*
=========================================================
Query 33: Revenue Category by Appointment

Business Problem:
Finance wants to classify appointments
based on revenue generated.

SQL Concepts Used:
- CASE
=========================================================
*/

SELECT
    appointment_id,
    consultation_fee,
    CASE
        WHEN consultation_fee >= 1500 THEN 'Premium'
        WHEN consultation_fee >= 1000 THEN 'Standard'
        ELSE 'Basic'
    END AS revenue_category
FROM appointments;

/*
=========================================================
Query 34: Claim Approval Percentage

Business Problem:
Insurance management wants to know the
percentage of approved claims.

SQL Concepts Used:
- CASE
- COUNT
=========================================================
*/

SELECT
    ROUND(
        100.0 * COUNT(CASE WHEN claim_status = 'Approved' THEN 1 END)
        / COUNT(*),
        2
    ) AS approval_percentage
FROM claims;

/*
=========================================================
Query 35: Payment Success Rate

Business Problem:
Finance wants to know the payment
success rate.

SQL Concepts Used:
- CASE
=========================================================
*/

SELECT
    ROUND(
        100.0 * COUNT(CASE WHEN payment_status = 'Completed' THEN 1 END)
        / COUNT(*),
        2
    ) AS payment_success_rate
FROM payments;