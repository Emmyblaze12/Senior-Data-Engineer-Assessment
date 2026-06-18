# Senior-Data-Engineer-Assessment
Technical Screening Assessment for Senior Data Engineer (Power BI Contract)
## Name
Emmanuel Ajagba

## About Me

I am a Data Engineer with experience building and supporting enterprise data solutions across banking and FMCG environments.

My experience includes:

- Oracle and SQL Server development
- ETL pipeline design and optimization
- SAP data integration
- Power BI, SSRS and business intelligence reporting
- Data warehouse design and dimensional modelling
- SQL performance tuning and automation

This assessment demonstrates my approach to security, data warehousing and deployment automation.

## Overview

This repository contains my solutions to the mandatory technical screening assessment.

### Tasks Completed

1. Advanced DAX Dynamic Row-Level Security (RLS)
2. T-SQL Slowly Changing Dimension (SCD Type 2)
3. PowerShell Deployment Automation


## Task 1

Location:

/Task1/Dynamic_RLS.md

Demonstrates dynamic row-level security using USERPRINCIPALNAME() and PATHCONTAINS().


## Task 2

Location:

/Task2/SCD_Type2.sql

Implements SCD Type 2 processing for an asset register.

Features:

- New record detection
- Change detection
- Historical tracking
- Effective dating
- Current record flagging

## Task 3

Location:

/Task3/Deployment_Automation.ps1

Demonstrates deployment automation through a REST API using PowerShell.


## Assumptions

- Employee hierarchy maintained through PATH()
- Authentication integrated with Active Directory
- AssetID serves as business key
- REST API endpoint exposed by BI platform
