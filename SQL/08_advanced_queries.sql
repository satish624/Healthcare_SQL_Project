/*
====================================================================
Project        : Healthcare Provider & Claims Analytics
File           : 08_advanced_queries.sql
Version        : 1.0
Author         : Satish Mudari
Database       : PostgreSQL
Schema         : healthcare

Description:
This script contains advanced SQL queries designed to solve
complex business problems using CTEs, Window Functions,
Subqueries, Ranking Functions and Analytical SQL techniques.

Topics Covered:
• Common Table Expressions (CTEs)
• Window Functions
• ROW_NUMBER()
• RANK()
• DENSE_RANK()
• LAG()
• LEAD()
• Subqueries
• Correlated Subqueries
• Advanced Business Analytics

====================================================================
*/

SET search_path TO healthcare;

/*
=========================================================
Query 1: Top 10 Highest Revenue Doctors

Business Problem:
The finance department wants to identify
the doctors generating the highest consultation
revenue.

SQL Concepts Used:
• CTE
• SUM()
• ORDER BY
=========================================================
*/

WITH doctor_revenue AS
(
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
)
SELECT *
FROM doctor_revenue
ORDER BY total_revenue DESC
LIMIT 10;

/*
=========================================================
Query 2: Rank Doctors by Revenue

Business Problem:
Management wants to rank doctors based on
consultation revenue.

SQL Concepts Used:
• Window Function
• RANK()
=========================================================
*/

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.specialization,

    SUM(a.consultation_fee) AS total_revenue,

    RANK() OVER
    (
        ORDER BY SUM(a.consultation_fee) DESC
    ) AS revenue_rank

FROM doctors d

INNER JOIN appointments a
ON d.doctor_id = a.doctor_id

GROUP BY
d.doctor_id,
d.first_name,
d.last_name,
d.specialization;

/*
=========================================================
Query 3: Highest Revenue Doctor in Each Specialization

Business Problem:
Management wants to identify the best-performing
doctor within every specialization.

SQL Concepts Used:
• ROW_NUMBER()
• CTE
=========================================================
*/

WITH doctor_revenue AS
(
SELECT

d.doctor_id,

d.first_name,

d.last_name,

d.specialization,

SUM(a.consultation_fee) total_revenue,

ROW_NUMBER() OVER
(
PARTITION BY specialization

ORDER BY SUM(a.consultation_fee) DESC

) row_num

FROM doctors d

JOIN appointments a

ON d.doctor_id=a.doctor_id

GROUP BY

d.doctor_id,

d.first_name,

d.last_name,

d.specialization

)

SELECT *

FROM doctor_revenue

WHERE row_num=1;


/*
=========================================================
Query 4: Second Highest Paid Doctor

Business Problem:
HR wants to identify the second highest-paid
doctor in the organization.

SQL Concepts Used:
• DENSE_RANK()
=========================================================
*/

WITH salary_rank AS
(
SELECT

doctor_id,

first_name,

last_name,

salary,

DENSE_RANK() OVER
(
ORDER BY salary DESC
)

AS salary_rank

FROM doctors
)

SELECT *

FROM salary_rank

WHERE salary_rank=2;

/*
=========================================================
Query 5: Monthly Consultation Revenue Trend

Business Problem:
Finance wants to analyze monthly consultation
revenue trends.

SQL Concepts Used:
• DATE_TRUNC()
• GROUP BY
=========================================================
*/

SELECT

DATE_TRUNC('month',appointment_date)

AS month,

SUM(consultation_fee)

AS revenue

FROM appointments

GROUP BY month

ORDER BY month;

/*
=========================================================
Query 6: Rank Doctors by Salary

Business Problem:
The HR department wants to rank doctors based
on their annual salary.

SQL Concepts Used:
• Window Function
• RANK()
=========================================================
*/

SELECT
    doctor_id,
    first_name,
    last_name,
    specialization,
    salary,

    RANK() OVER
    (
        ORDER BY salary DESC
    ) AS salary_rank

FROM doctors;

/*
=========================================================
Query 7: Dense Rank Doctors by Experience

Business Problem:
Hospital management wants to rank doctors based
on years of experience without skipping rank values.

SQL Concepts Used:
• DENSE_RANK()
=========================================================
*/

SELECT
    doctor_id,
    first_name,
    last_name,
    experience_years,

    DENSE_RANK() OVER
    (
        ORDER BY experience_years DESC
    ) AS experience_rank

FROM doctors;

/*
=========================================================
Query 8: Assign Row Numbers to Patients

Business Problem:
Generate a sequential row number for every patient.

SQL Concepts Used:
• ROW_NUMBER()
=========================================================
*/

SELECT

    ROW_NUMBER() OVER
    (
        ORDER BY patient_id
    ) AS row_no,

    patient_id,
    first_name,
    last_name,
    city

FROM patients;

/*
=========================================================
Query 9: Top 3 Highest Paid Doctors in Each Specialization

Business Problem:
HR wants to identify the highest paid doctors
within every specialization.

SQL Concepts Used:
• ROW_NUMBER()
• PARTITION BY
=========================================================
*/

WITH ranked_doctors AS
(
    SELECT

        doctor_id,
        first_name,
        last_name,
        specialization,
        salary,

        ROW_NUMBER() OVER
        (
            PARTITION BY specialization
            ORDER BY salary DESC
        ) AS row_num

    FROM doctors
)

SELECT *

FROM ranked_doctors

WHERE row_num <= 3

ORDER BY specialization, salary DESC;

/*
=========================================================
Query 10: Compare Doctor Salary with Average Salary

Business Problem:
HR wants to compare every doctor's salary
with the overall average salary.

SQL Concepts Used:
• Window Function
• AVG() OVER()
=========================================================
*/

SELECT

    doctor_id,
    first_name,
    last_name,
    salary,

    ROUND(AVG(salary) OVER (),2) AS average_salary,

    salary -
    ROUND(AVG(salary) OVER (),2)
    AS salary_difference

FROM doctors

ORDER BY salary DESC;

/*
=========================================================
Query 11: Previous Appointment Date

Business Problem:
Find the previous appointment for each patient.

SQL Concepts Used:
• LAG()
=========================================================
*/

SELECT

    patient_id,

    appointment_id,

    appointment_date,

    LAG(appointment_date)
    OVER
    (
        PARTITION BY patient_id
        ORDER BY appointment_date
    ) AS previous_appointment

FROM appointments;

/*
=========================================================
Query 12: Next Appointment Date

Business Problem:
Display the next scheduled appointment
for each patient.

SQL Concepts Used:
• LEAD()
=========================================================
*/

SELECT

    patient_id,

    appointment_id,

    appointment_date,

    LEAD(appointment_date)
    OVER
    (
        PARTITION BY patient_id
        ORDER BY appointment_date
    ) AS next_appointment

FROM appointments;

/*
=========================================================
Query 13: Running Consultation Revenue

Business Problem:
Finance wants to monitor cumulative
consultation revenue over time.

SQL Concepts Used:
• SUM() OVER()
=========================================================
*/

SELECT

    appointment_date,

    consultation_fee,

    SUM(consultation_fee)
    OVER
    (
        ORDER BY appointment_date
    ) AS running_revenue

FROM appointments;

/*
=========================================================
Query 14: Monthly Running Revenue

Business Problem:
Track cumulative consultation revenue
within each month.

SQL Concepts Used:
• PARTITION BY
=========================================================
*/

SELECT

    appointment_date,

    consultation_fee,

    SUM(consultation_fee)
    OVER
    (
        PARTITION BY DATE_TRUNC('month', appointment_date)
        ORDER BY appointment_date
    ) AS monthly_running_total

FROM appointments;

/*
=========================================================
Query 15: Highest Paid Doctor in Every Department

Business Problem:
Hospital management wants to identify
the highest-paid doctor in each department.

SQL Concepts Used:
• ROW_NUMBER()
• PARTITION BY
=========================================================
*/

WITH ranked_salary AS
(
    SELECT

        d.doctor_id,
        d.first_name,
        d.last_name,
        d.salary,
        dp.department_name,

        ROW_NUMBER() OVER
        (
            PARTITION BY dp.department_name
            ORDER BY d.salary DESC
        ) AS row_num

    FROM doctors d

    INNER JOIN departments dp
    ON d.department_id = dp.department_id
)

SELECT *

FROM ranked_salary

WHERE row_num = 1

ORDER BY salary DESC;

/*
=========================================================
Query 16: Top 5 Hospitals by Monthly Revenue

Business Problem:
Management wants to identify the top-performing
hospitals each month based on consultation revenue.

SQL Concepts Used:
• CTE
• SUM()
• DATE_TRUNC()
• RANK()
=========================================================
*/

WITH monthly_revenue AS
(
    SELECT

        h.hospital_name,

        DATE_TRUNC('month',a.appointment_date) AS month,

        SUM(a.consultation_fee) AS revenue

    FROM hospitals h

    INNER JOIN departments dp
        ON h.hospital_id = dp.hospital_id

    INNER JOIN doctors d
        ON dp.department_id = d.department_id

    INNER JOIN appointments a
        ON d.doctor_id = a.doctor_id

    GROUP BY
        h.hospital_name,
        DATE_TRUNC('month',a.appointment_date)
)

SELECT *

FROM
(
    SELECT
        *,
        RANK() OVER
        (
            PARTITION BY month
            ORDER BY revenue DESC
        ) AS revenue_rank
    FROM monthly_revenue
) ranked

WHERE revenue_rank <= 5

ORDER BY month, revenue_rank;

/*
=========================================================
Query 17: Doctor Performance Scorecard

Business Problem:
Management wants to evaluate each doctor's
overall performance.

SQL Concepts Used:
• GROUP BY
• COUNT()
• SUM()
• AVG()
=========================================================
*/

SELECT

    d.doctor_id,

    d.first_name,

    d.last_name,

    d.specialization,

    COUNT(a.appointment_id) AS total_appointments,

    SUM(a.consultation_fee) AS total_revenue,

    ROUND(AVG(a.consultation_fee),2) AS average_fee

FROM doctors d

INNER JOIN appointments a

ON d.doctor_id = a.doctor_id

GROUP BY

d.doctor_id,

d.first_name,

d.last_name,

d.specialization

ORDER BY total_revenue DESC;

/*
=========================================================
Query 18: Hospital Performance Dashboard

Business Problem:
Generate a KPI dashboard for every hospital.

SQL Concepts Used:
• Multiple JOINs
• COUNT()
• SUM()
=========================================================
*/

SELECT

    h.hospital_name,

    COUNT(DISTINCT d.doctor_id) AS total_doctors,

    COUNT(a.appointment_id) AS total_appointments,

    SUM(a.consultation_fee) AS total_revenue

FROM hospitals h

INNER JOIN departments dp
ON h.hospital_id=dp.hospital_id

INNER JOIN doctors d
ON dp.department_id=d.department_id

INNER JOIN appointments a
ON d.doctor_id=a.doctor_id

GROUP BY h.hospital_name

ORDER BY total_revenue DESC;

/*
=========================================================
Query 19: Monthly Appointment Trend

Business Problem:
Hospital management wants to monitor
appointment trends every month.

SQL Concepts Used:
• DATE_TRUNC()
=========================================================
*/

SELECT

DATE_TRUNC('month',appointment_date)

AS month,

COUNT(*) AS total_appointments

FROM appointments

GROUP BY month

ORDER BY month;

/*
=========================================================
Query 20: Appointment Cancellation Rate

Business Problem:
Identify hospitals having the highest
appointment cancellation percentage.

SQL Concepts Used:
• CASE
• SUM()
=========================================================
*/

SELECT

    h.hospital_name,

    COUNT(*) AS total_appointments,

    SUM(
        CASE
            WHEN a.appointment_status='Cancelled'
            THEN 1
            ELSE 0
        END
    ) AS cancelled,

    ROUND(

        100.0*

        SUM(
            CASE
                WHEN a.appointment_status='Cancelled'
                THEN 1
                ELSE 0
            END
        )

        /

        COUNT(*),

        2

    ) AS cancellation_percentage

FROM hospitals h

INNER JOIN departments dp
ON h.hospital_id=dp.hospital_id

INNER JOIN doctors d
ON dp.department_id=d.department_id

INNER JOIN appointments a
ON d.doctor_id=a.doctor_id

GROUP BY h.hospital_name

ORDER BY cancellation_percentage DESC;

/*
=========================================================
Query 21: Revenue Contribution by Specialization

Business Problem:
Finance wants to know which medical
specializations contribute the most revenue.

SQL Concepts Used:
• SUM()
• GROUP BY
=========================================================
*/

SELECT

d.specialization,

SUM(a.consultation_fee) AS revenue

FROM doctors d

JOIN appointments a

ON d.doctor_id=a.doctor_id

GROUP BY d.specialization

ORDER BY revenue DESC;

/*
=========================================================
Query 22: Average Visits Per Patient

Business Problem:
Management wants to understand
patient engagement.

SQL Concepts Used:
• CTE
=========================================================
*/

WITH patient_visits AS
(
SELECT

patient_id,

COUNT(*) total_visits

FROM appointments

GROUP BY patient_id
)

SELECT

ROUND(AVG(total_visits),2)

AS average_visits

FROM patient_visits;

/*
=========================================================
Query 23: Patients with Above Average Visits

Business Problem:
Identify highly engaged patients who visit
more frequently than the average patient.

SQL Concepts Used:
• CTE
• Subquery
=========================================================
*/

WITH patient_visits AS
(
SELECT

patient_id,

COUNT(*) total_visits

FROM appointments

GROUP BY patient_id
)

SELECT *

FROM patient_visits

WHERE total_visits>

(
SELECT AVG(total_visits)

FROM patient_visits
)

ORDER BY total_visits DESC;

/*
=========================================================
Query 24: Insurance Approval Rate by Provider

Business Problem:
Compare claim approval rates across
insurance providers.

SQL Concepts Used:
• CASE
• GROUP BY
=========================================================
*/

SELECT

ip.provider_name,

ROUND(

100.0*

COUNT(

CASE

WHEN c.claim_status='Approved'

THEN 1

END

)

/COUNT(*),

2

)

AS approval_rate

FROM insurance_providers ip

JOIN insurance_policies p

ON ip.provider_id=p.provider_id

JOIN claims c

ON p.policy_id=c.policy_id

GROUP BY ip.provider_name

ORDER BY approval_rate DESC;

/*
=========================================================
Query 25: Executive KPI Dashboard

Business Problem:
Provide a one-page executive summary
of key healthcare metrics.

SQL Concepts Used:
• Scalar Subqueries
=========================================================
*/

SELECT

(SELECT COUNT(*) FROM hospitals) AS total_hospitals,

(SELECT COUNT(*) FROM doctors) AS total_doctors,

(SELECT COUNT(*) FROM patients) AS total_patients,

(SELECT COUNT(*) FROM appointments) AS total_appointments,

(SELECT SUM(consultation_fee) FROM appointments) AS total_revenue,

(SELECT AVG(consultation_fee) FROM appointments) AS average_fee;

/*
=========================================================
Query 26: Top 5 Patients by Total Spending

Business Problem:
Finance wants to identify patients who have
spent the most on consultation fees.

SQL Concepts Used:
• GROUP BY
• SUM()
• ORDER BY
=========================================================
*/

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    SUM(a.consultation_fee) AS total_spent
FROM patients p
INNER JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
ORDER BY total_spent DESC
LIMIT 5;

/*
=========================================================
Query 27: Doctor with Highest Average Consultation Fee

Business Problem:
Identify doctors charging the highest
average consultation fee.

SQL Concepts Used:
• AVG()
=========================================================
*/

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    ROUND(AVG(a.consultation_fee),2) AS average_fee
FROM doctors d
INNER JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY average_fee DESC
LIMIT 10;

/*
=========================================================
Query 28: Revenue Share by Hospital

Business Problem:
Determine each hospital's percentage
contribution to total consultation revenue.

SQL Concepts Used:
• Window Function
=========================================================
*/

WITH hospital_revenue AS
(
SELECT
    h.hospital_name,
    SUM(a.consultation_fee) AS revenue
FROM hospitals h
JOIN departments dp
ON h.hospital_id = dp.hospital_id
JOIN doctors d
ON dp.department_id = d.department_id
JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY h.hospital_name
)

SELECT
    hospital_name,
    revenue,
    ROUND(
        revenue * 100.0 /
        SUM(revenue) OVER (),
        2
    ) AS revenue_percentage
FROM hospital_revenue
ORDER BY revenue DESC;

/*
=========================================================
Query 29: Longest Gap Between Visits

Business Problem:
Identify patients who have long gaps
between appointments.

SQL Concepts Used:
• LAG()
=========================================================
*/

SELECT
    patient_id,
    appointment_date,
    appointment_date -
    LAG(appointment_date)
    OVER
    (
        PARTITION BY patient_id
        ORDER BY appointment_date
    ) AS gap_between_visits
FROM appointments;

/*
=========================================================
Query 30: Highest Revenue Department
Within Every Hospital

SQL Concepts Used:
• ROW_NUMBER()
• PARTITION BY
=========================================================
*/

WITH department_revenue AS
(
SELECT

h.hospital_name,

dp.department_name,

SUM(a.consultation_fee) revenue,

ROW_NUMBER() OVER
(
PARTITION BY h.hospital_name
ORDER BY SUM(a.consultation_fee) DESC
)
AS rn

FROM hospitals h

JOIN departments dp
ON h.hospital_id=dp.hospital_id

JOIN doctors d
ON dp.department_id=d.department_id

JOIN appointments a
ON d.doctor_id=a.doctor_id

GROUP BY
h.hospital_name,
dp.department_name
)

SELECT *

FROM department_revenue

WHERE rn=1;

/*
=========================================================
Query 31: Month-over-Month Revenue Growth

Business Problem:
Finance wants to compare monthly revenue
with the previous month.

SQL Concepts Used:
• LAG()
=========================================================
*/

WITH monthly_revenue AS
(
SELECT

DATE_TRUNC('month',appointment_date)
AS month,

SUM(consultation_fee)
AS revenue

FROM appointments

GROUP BY month
)

SELECT

month,

revenue,

LAG(revenue)
OVER
(
ORDER BY month
)
AS previous_month,

revenue -
LAG(revenue)
OVER
(
ORDER BY month
)
AS revenue_growth

FROM monthly_revenue;

/*
=========================================================
Query 32: Revenue Quartiles

Business Problem:
Divide doctors into four groups
based on consultation revenue.

SQL Concepts Used:
• NTILE()
=========================================================
*/

SELECT

d.doctor_id,

d.first_name,

d.last_name,

SUM(a.consultation_fee)
AS revenue,

NTILE(4)
OVER
(
ORDER BY SUM(a.consultation_fee) DESC
)
AS revenue_quartile

FROM doctors d

JOIN appointments a
ON d.doctor_id=a.doctor_id

GROUP BY
d.doctor_id,
d.first_name,
d.last_name;

/*
=========================================================
Query 33: Top Revenue Doctor
Within Every Hospital

SQL Concepts Used:
• CTE
• ROW_NUMBER()
=========================================================
*/

WITH ranked_doctors AS
(
SELECT

h.hospital_name,

d.first_name,

d.last_name,

SUM(a.consultation_fee)
AS revenue,

ROW_NUMBER()
OVER
(
PARTITION BY h.hospital_name
ORDER BY SUM(a.consultation_fee) DESC
)
AS rn

FROM hospitals h

JOIN departments dp
ON h.hospital_id=dp.hospital_id

JOIN doctors d
ON dp.department_id=d.department_id

JOIN appointments a
ON d.doctor_id=a.doctor_id

GROUP BY
h.hospital_name,
d.first_name,
d.last_name
)

SELECT *

FROM ranked_doctors

WHERE rn=1;

/*
=========================================================
Query 34: Salary Comparison with Department Average

Business Problem:
Compare each doctor's salary against
their department's average salary.

SQL Concepts Used:
• AVG() OVER(PARTITION BY)
=========================================================
*/

SELECT

doctor_id,

first_name,

last_name,

salary,

ROUND(
AVG(salary)
OVER
(
PARTITION BY department_id
),
2
)
AS department_average

FROM doctors;

/*
=========================================================
Query 35: Executive Business Summary

Business Problem:
Generate overall healthcare KPIs.

SQL Concepts Used:
• Scalar Subqueries
=========================================================
*/

SELECT

(SELECT COUNT(*) FROM hospitals) AS hospitals,

(SELECT COUNT(*) FROM doctors) AS doctors,

(SELECT COUNT(*) FROM patients) AS patients,

(SELECT COUNT(*) FROM appointments) AS appointments,

(SELECT COUNT(*) FROM claims) AS claims,

(SELECT SUM(payment_amount) FROM payments) AS payments_received,

(SELECT SUM(claim_amount) FROM claims) AS claims_requested;