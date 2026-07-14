
/*
====================================================================
Project     : Healthcare Provider & Claims Analytics
File Name   : 03_create_tables.sql
Author      : Satish Mudari
Database    : PostgreSQL
Schema      : healthcare
Created On  : 09-07-2026

Description :
This script creates all relational tables required for the
Healthcare Provider & Claims Analytics database.

Dependencies:
- healthcare_db must exist.
- healthcare schema must be created before executing this script.

====================================================================
*/
SET search_path TO healthcare;
/*
=========================================================
TABLE: hospitals
Purpose:
Stores information about hospitals in the healthcare network.
=========================================================
*/

CREATE TABLE healthcare.hospitals (
    hospital_id SERIAL PRIMARY KEY,
    hospital_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    established_year INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*
=========================================================
TABLE: departments
Purpose:
Stores departments available in each hospital and links
every department to its respective hospital.
=========================================================
*/

CREATE TABLE healthcare.departments (
    department_id SERIAL PRIMARY KEY,
    hospital_id INT NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    floor_number INT,
    head_of_department VARCHAR(100),

    CONSTRAINT fk_hospital
        FOREIGN KEY (hospital_id)
        REFERENCES healthcare.hospitals(hospital_id)
);

/*
=========================================================
TABLE: doctors
Purpose:
Stores doctor profiles, specialization, experience,
salary, and department assignment.
=========================================================
*/

CREATE TABLE healthcare.doctors (
    doctor_id SERIAL PRIMARY KEY,
    department_id INT NOT NULL,

    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,

    specialization VARCHAR(100) NOT NULL,

    experience_years INT CHECK (experience_years >= 0),

    salary DECIMAL(10,2) CHECK (salary > 0),

    phone VARCHAR(15) UNIQUE,

    email VARCHAR(100) UNIQUE,

    joining_date DATE,

    CONSTRAINT fk_department
        FOREIGN KEY (department_id)
        REFERENCES healthcare.departments(department_id)
);

/*
=========================================================
TABLE: patients
Purpose:
Stores patient demographic information, contact details,
blood group, and registration information.
=========================================================
*/

CREATE TABLE healthcare.patients (
    patient_id SERIAL PRIMARY KEY,

    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,

    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),

    date_of_birth DATE NOT NULL,

    blood_group VARCHAR(5),

    phone VARCHAR(15) UNIQUE,

    email VARCHAR(100) UNIQUE,

    address TEXT,

    city VARCHAR(50),

    state VARCHAR(50),

    registration_date DATE DEFAULT CURRENT_DATE
);

/*
=========================================================
TABLE: appointments
Purpose:
Stores appointment details between patients and doctors,
including appointment status, consultation fee, and remarks.
=========================================================
*/

CREATE TABLE healthcare.appointments (
    appointment_id SERIAL PRIMARY KEY,

    patient_id INT NOT NULL,

    doctor_id INT NOT NULL,

    appointment_date TIMESTAMP NOT NULL,

    appointment_status VARCHAR(20)
        CHECK (appointment_status IN ('Scheduled','Completed','Cancelled')),

    consultation_fee DECIMAL(10,2),

    remarks TEXT,

    CONSTRAINT fk_patient
        FOREIGN KEY (patient_id)
        REFERENCES healthcare.patients(patient_id),

    CONSTRAINT fk_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES healthcare.doctors(doctor_id)
);

/*
=========================================================
TABLE: diagnoses
Purpose:
Stores medical diagnoses recorded during patient appointments,
including diagnosis code and clinical notes.
=========================================================
*/

CREATE TABLE healthcare.diagnoses (
    diagnosis_id SERIAL PRIMARY KEY,

    appointment_id INT NOT NULL,

    diagnosis_name VARCHAR(150) NOT NULL,

    diagnosis_code VARCHAR(20),

    diagnosis_date DATE NOT NULL,

    notes TEXT,

    CONSTRAINT fk_appointment_diagnosis
        FOREIGN KEY (appointment_id)
        REFERENCES healthcare.appointments(appointment_id)
);

/*
=========================================================
TABLE: treatments
Purpose:
Stores treatment information associated with each diagnosis,
including treatment cost and treatment date.
=========================================================
*/

CREATE TABLE healthcare.treatments (
    treatment_id SERIAL PRIMARY KEY,

    diagnosis_id INT NOT NULL,

    treatment_name VARCHAR(150) NOT NULL,

    treatment_cost DECIMAL(10,2) CHECK (treatment_cost >= 0),

    treatment_date DATE NOT NULL,

    CONSTRAINT fk_diagnosis_treatment
        FOREIGN KEY (diagnosis_id)
        REFERENCES healthcare.diagnoses(diagnosis_id)
);

/*
=========================================================
TABLE: prescriptions
Purpose:
Stores prescribed medications, dosage information,
duration, and patient instructions for each appointment.
=========================================================
*/

CREATE TABLE healthcare.prescriptions (
    prescription_id SERIAL PRIMARY KEY,

    appointment_id INT NOT NULL,

    medicine_name VARCHAR(100) NOT NULL,

    dosage VARCHAR(50),

    duration_days INT CHECK (duration_days > 0),

    instructions TEXT,

    CONSTRAINT fk_appointment_prescription
        FOREIGN KEY (appointment_id)
        REFERENCES healthcare.appointments(appointment_id)
);

/*
=========================================================
TABLE: insurance_providers
Purpose:
Stores insurance company information, including provider
name and contact details.
=========================================================
*/

CREATE TABLE healthcare.insurance_providers (
    provider_id SERIAL PRIMARY KEY,

    provider_name VARCHAR(100) NOT NULL UNIQUE,

    contact_number VARCHAR(15),

    email VARCHAR(100),

    headquarters VARCHAR(100)
);

/*
=========================================================
TABLE: insurance_policies
Purpose:
Stores insurance policy details for patients, including
coverage amount, validity period, and insurance provider.
=========================================================
*/

CREATE TABLE healthcare.insurance_policies (
    policy_id SERIAL PRIMARY KEY,

    patient_id INT NOT NULL,

    provider_id INT NOT NULL,

    policy_number VARCHAR(50) UNIQUE NOT NULL,

    coverage_amount DECIMAL(12,2) NOT NULL,

    start_date DATE NOT NULL,

    end_date DATE NOT NULL,

    CONSTRAINT fk_policy_patient
        FOREIGN KEY (patient_id)
        REFERENCES healthcare.patients(patient_id),

    CONSTRAINT fk_policy_provider
        FOREIGN KEY (provider_id)
        REFERENCES healthcare.insurance_providers(provider_id)
);

/*
=========================================================
TABLE: claims
Purpose:
Stores insurance claim records submitted for appointments,
including claim amount, approval status, and reimbursement.
=========================================================
*/

CREATE TABLE healthcare.claims (
    claim_id SERIAL PRIMARY KEY,

    policy_id INT NOT NULL,

    appointment_id INT NOT NULL,

    claim_amount DECIMAL(12,2) NOT NULL,

    approved_amount DECIMAL(12,2),

    claim_status VARCHAR(20)
        CHECK (claim_status IN ('Pending','Approved','Rejected')),

    claim_date DATE NOT NULL,

    CONSTRAINT fk_claim_policy
        FOREIGN KEY (policy_id)
        REFERENCES healthcare.insurance_policies(policy_id),

    CONSTRAINT fk_claim_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES healthcare.appointments(appointment_id)
);

/*
=========================================================
TABLE: payments
Purpose:
Stores payment transactions for appointments, including
payment method, payment status, and payment date.
=========================================================
*/

CREATE TABLE healthcare.payments (
    payment_id SERIAL PRIMARY KEY,

    appointment_id INT NOT NULL,

    payment_amount DECIMAL(12,2) NOT NULL,

    payment_method VARCHAR(20)
        CHECK (payment_method IN ('Cash','Card','UPI','Insurance')),

    payment_date DATE NOT NULL,

    payment_status VARCHAR(20)
        CHECK (payment_status IN ('Pending','Completed','Failed')),

    CONSTRAINT fk_payment_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES healthcare.appointments(appointment_id)
);

-- All tables created
--hospitals
--├── departments
--├── doctors
--├── patients
--├── appointments
--├── diagnoses
--├── treatments
--├── prescriptions
--├── insurance_providers
--├── insurance_policies
--├── claims
--└── payments