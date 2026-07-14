/*
====================================================================
Project        : Healthcare Provider & Claims Analytics
File           : 04_import_csv.sql
Version        : 1.0
Author         : Satish Mudari
Database       : PostgreSQL
Schema         : healthcare

Description:
This script documents the bulk import process for loading CSV
datasets into the Healthcare Provider & Claims Analytics database.

Data Source:
CSV files generated using Python (Faker + Pandas)

Execution Order:
1. hospitals
2. departments
3. doctors
4. patients
5. appointments
6. diagnoses
7. treatments
8. prescriptions
9. insurance_providers
10. insurance_policies
11. claims
12. payments

Note:
For this project, the CSV files were imported using the
pgAdmin Import/Export Wizard.

The COPY commands below are provided as a reference for
automated or production deployments.

====================================================================
*/

SET search_path TO healthcare;

/*
====================================================================
Project        : Healthcare Provider & Claims Analytics
File           : 04_import_csv.sql
Version        : 1.0
Author         : Satish Mudari
Database       : PostgreSQL
Schema         : healthcare

Description:
This script documents the CSV import process for loading the
Healthcare Provider & Claims Analytics dataset into PostgreSQL.

Data Source:
- Dataset generated using Python (Pandas, Faker, NumPy)
- CSV files imported using the pgAdmin Import/Export Wizard

Pre-Import Data Preparation:
- The 'created_at' column was intentionally excluded from
  hospitals.csv because the database table automatically
  populates this field using the DEFAULT CURRENT_TIMESTAMP
  constraint during data insertion.

General Import Settings:
---------------------------------------------------------
Format      : CSV
Encoding    : UTF-8
Delimiter   : ,
Header      : Yes
Quote       : "
Escape      : "

Import Order:
---------------------------------------------------------
1. hospitals
2. departments
3. doctors
4. patients
5. appointments
6. diagnoses
7. treatments
8. prescriptions
9. insurance_providers
10. insurance_policies
11. claims
12. payments

Post-Import Validation:
- Verify row counts for all tables.
- Validate foreign key relationships.
- Check for duplicate primary keys.
- Ensure successful completion before executing SQL queries.

====================================================================
*/

