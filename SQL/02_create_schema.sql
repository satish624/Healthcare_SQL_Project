/*
====================================================================
Project        : Healthcare Provider & Claims Analytics
File           : 02_create_schema.sql
Version        : 1.0
Author         : Satish Mudari
Database       : PostgreSQL
Schema         : healthcare

Description:
Creates the healthcare schema used to organize all database objects.

Dependencies:
- healthcare_db must already exist.

Execution Order:
1. 01_create_database.sql
2. 02_create_schema.sql

Revision History:
--------------------------------------------------------------------
Version | Date       | Description
--------------------------------------------------------------------
1.0     | 09-07-2026 | Initial schema creation
====================================================================
*/

-- Create Schema
CREATE SCHEMA healthcare;

-- Set the default schema
SET search_path TO healthcare;