/*
====================================================================
Project        : Healthcare Provider & Claims Analytics
File           : 09_views.sql
Version        : 1.0
Author         : Satish Mudari
Database       : PostgreSQL
Schema         : healthcare

Description:
This script creates reusable SQL Views for reporting,
analytics, dashboards, and business intelligence.

Topics Covered:
• CREATE VIEW
• Business Reporting
• Dashboard Views
• Analytics Views

====================================================================
*/

SET search_path TO healthcare;

/*
=========================================================
View 1: Doctor Performance Summary

Business Purpose:
Provides doctor-wise appointment count,
consultation revenue and average consultation fee.
=========================================================
*/

CREATE OR REPLACE VIEW vw_doctor_performance AS

SELECT

    d.doctor_id,

    d.first_name,

    d.last_name,

    d.specialization,

    COUNT(a.appointment_id) AS total_appointments,

    SUM(a.consultation_fee) AS total_revenue,

    ROUND(AVG(a.consultation_fee),2) AS average_fee

FROM doctors d

LEFT JOIN appointments a

ON d.doctor_id=a.doctor_id

GROUP BY

d.doctor_id,

d.first_name,

d.last_name,

d.specialization;

/*
=========================================================
View 2: Hospital Performance

Business Purpose:
Displays hospital-wise KPIs.
=========================================================
*/

CREATE OR REPLACE VIEW vw_hospital_performance AS

SELECT

h.hospital_name,

COUNT(DISTINCT d.doctor_id) total_doctors,

COUNT(a.appointment_id) total_appointments,

SUM(a.consultation_fee) total_revenue

FROM hospitals h

JOIN departments dp
ON h.hospital_id=dp.hospital_id

JOIN doctors d
ON dp.department_id=d.department_id

JOIN appointments a
ON d.doctor_id=a.doctor_id

GROUP BY h.hospital_name;

/*
=========================================================
View 3: Patient Visit Summary
=========================================================
*/

CREATE OR REPLACE VIEW vw_patient_summary AS

SELECT

p.patient_id,

p.first_name,

p.last_name,

COUNT(a.appointment_id) total_visits,

SUM(a.consultation_fee) total_spent

FROM patients p

LEFT JOIN appointments a

ON p.patient_id=a.patient_id

GROUP BY

p.patient_id,

p.first_name,

p.last_name;

/*
=========================================================
View 4: Insurance Dashboard
=========================================================
*/

CREATE OR REPLACE VIEW vw_insurance_summary AS

SELECT

ip.provider_name,

COUNT(c.claim_id) total_claims,

SUM(c.claim_amount) total_claim_amount

FROM insurance_providers ip

JOIN insurance_policies p
ON ip.provider_id=p.provider_id

JOIN claims c
ON p.policy_id=c.policy_id

GROUP BY ip.provider_name;

/*
=========================================================
View 5: Appointment Dashboard
=========================================================
*/

CREATE OR REPLACE VIEW vw_appointment_dashboard AS

SELECT

appointment_status,

COUNT(*) total_appointments,

SUM(consultation_fee) total_revenue

FROM appointments

GROUP BY appointment_status;

/*
=========================================================
View 6: Monthly Revenue
=========================================================
*/

CREATE OR REPLACE VIEW vw_monthly_revenue AS

SELECT
    DATE_TRUNC('month', appointment_date) AS revenue_month,
    SUM(consultation_fee) AS revenue
FROM appointments
GROUP BY DATE_TRUNC('month', appointment_date)
ORDER BY DATE_TRUNC('month', appointment_date);

/*
=========================================================
View 7: Department Revenue
=========================================================
*/

CREATE OR REPLACE VIEW vw_department_revenue AS

SELECT

dp.department_name,

SUM(a.consultation_fee) revenue

FROM departments dp

JOIN doctors d
ON dp.department_id=d.department_id

JOIN appointments a
ON d.doctor_id=a.doctor_id

GROUP BY dp.department_name;

/*
=========================================================
View 8: Payment Summary
=========================================================
*/

CREATE OR REPLACE VIEW vw_payment_summary AS

SELECT

payment_method,

payment_status,

COUNT(*) total_transactions,

SUM(payment_amount) total_amount

FROM payments

GROUP BY

payment_method,

payment_status;

/*
=========================================================
View 9: Top Doctors
=========================================================
*/

CREATE OR REPLACE VIEW vw_top_doctors AS

SELECT *

FROM vw_doctor_performance

ORDER BY total_revenue DESC;

/*
=========================================================
View 10: Executive Dashboard
=========================================================
*/

CREATE OR REPLACE VIEW vw_executive_dashboard AS

SELECT

(SELECT COUNT(*) FROM hospitals) hospitals,

(SELECT COUNT(*) FROM doctors) doctors,

(SELECT COUNT(*) FROM patients) patients,

(SELECT COUNT(*) FROM appointments) appointments,

(SELECT SUM(consultation_fee) FROM appointments) revenue,

(SELECT SUM(payment_amount) FROM payments) payments;

/*
=========================================================
View Verification
=========================================================
*/

SELECT * FROM vw_doctor_performance LIMIT 10;

SELECT * FROM vw_hospital_performance;

SELECT * FROM vw_patient_summary LIMIT 10;

SELECT * FROM vw_insurance_summary;

SELECT * FROM vw_appointment_dashboard;

SELECT * FROM vw_monthly_revenue;

SELECT * FROM vw_department_revenue;

SELECT * FROM vw_payment_summary;

SELECT * FROM vw_top_doctors LIMIT 10;

SELECT * FROM vw_executive_dashboard;