--- Create a Table for Employee

CREATE TABLE Employee (
    AGENT_ID VARCHAR(10),
    AGENT_NAME VARCHAR(50),
    DATE_OF_JOINING DATE,
    ADDRESS_LINE1 VARCHAR(100),
    CITY VARCHAR(50),
    STATE VARCHAR(2),
    POSTAL_CODE VARCHAR(10),
    EMP_ROUTING_NUMBER VARCHAR(20),
    EMP_ACCT_NUMBER VARCHAR(20)
);
--- Copy Employee csv file

copy Employee from 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PostgreSQL 16\Data\employee_data.csv' CSV header ;

select * from employee

--- Create a Table for Insurance_data

CREATE TABLE Insurance_Data (
    TXN_DATE_TIME TIMESTAMP,
    TRANSACTION_ID VARCHAR(20),
    CUSTOMER_ID VARCHAR(20),
    POLICY_NUMBER VARCHAR(20),
    POLICY_EFF_DT DATE,
    LOSS_DT DATE,
    REPORT_DT DATE,
    INSURANCE_TYPE VARCHAR(20),
    PREMIUM_AMOUNT DECIMAL(10, 3),
    CLAIM_AMOUNT DECIMAL(10, 3),
    CUSTOMER_NAME VARCHAR(100),
    ADDRESS_LINE1 VARCHAR(100),
    CITY VARCHAR(50),
    STATE VARCHAR(2),
    POSTAL_CODE VARCHAR(10),
    SSN VARCHAR(15),
    MARITAL_STATUS CHAR(3),
    AGE INT,
    TENURE INT,
    EMPLOYMENT_STATUS CHAR(5),
    NO_OF_FAMILY_MEMBERS INT,
    RISK_SEGMENTATION VARCHAR(5),
    HOUSE_TYPE VARCHAR(10),
    SOCIAL_CLASS CHAR(5),
    ROUTING_NUMBER VARCHAR(30),
    ACCT_NUMBER VARCHAR(20),
    CUSTOMER_EDUCATION_LEVEL VARCHAR(20),
    CLAIM_STATUS CHAR(5),
    INCIDENT_SEVERITY VARCHAR(20),
    AUTHORITY_CONTACTED VARCHAR(20),
    ANY_INJURY INT,
    POLICE_REPORT_AVAILABLE INT,
    INCIDENT_STATE CHAR(10),
    INCIDENT_CITY VARCHAR(50),
    INCIDENT_HOUR_OF_THE_DAY INT,
    AGENT_ID VARCHAR(10),
    VENDOR_ID VARCHAR(10)
);

--- Copy Insurance_Data csv file

copy Insurance_Data from 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PostgreSQL 16\Data\insurance_data.csv' CSV header ;

select * from insurance_data

--- Create a Table for Vendor


CREATE TABLE Vendor (
    VENDOR_ID VARCHAR(10),
    VENDOR_NAME VARCHAR(100),
    ADDRESS_LINE1 VARCHAR(100),
    CITY VARCHAR(50),
    STATE CHAR(5),
    POSTAL_CODE VARCHAR(10)
);

--- Copy Vendor csv file

copy Vendor from 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PostgreSQL 16\Data\vendor_data.csv' CSV header ;

select * from vendor

---- Employee Queries


/* Find Employees with the Same Address

This query identifies employees who share the same address and postal code, 
indicating potential roommates or coworkers.
*/

SELECT E1.AGENT_ID AS EMPLOYEE1_ID, E1.AGENT_NAME AS EMPLOYEE1_NAME,
       E2.AGENT_ID AS EMPLOYEE2_ID, E2.AGENT_NAME AS EMPLOYEE2_NAME,
       E1.ADDRESS_LINE1, E1.POSTAL_CODE
FROM Employee E1
JOIN Employee E2 ON E1.ADDRESS_LINE1 = E2.ADDRESS_LINE1
                AND E1.POSTAL_CODE = E2.POSTAL_CODE
WHERE E1.AGENT_ID < E2.AGENT_ID;


/*  Count the Number of Employees by State

This query counts the number of employees in 
each state and presents the results in descending order of employee count.
*/

SELECT STATE, COUNT(*) AS EMPLOYEE_COUNT
FROM Employee
GROUP BY STATE
ORDER BY EMPLOYEE_COUNT DESC;

/*This query determines the last joining date 
in the organization IN each year.*/

SELECT EXTRACT(YEAR FROM DATE_OF_JOINING) AS JOINING_YEAR, 
MAX(DATE_OF_JOINING) AS LAST_DATE_JOINED
FROM Employee
GROUP BY JOINING_YEAR
ORDER BY JOINING_YEAR;


---- Insurance data Queries

/*States with the Highest Total Claim Amount
This query identifies the state with the highest total claim amount.*/

SELECT INCIDENT_STATE, INCIDENT_SEVERITY,
SUM(CLAIM_AMOUNT) AS TOTAL_CLAIM_AMOUNT
FROM Insurance_Data
GROUP BY INCIDENT_STATE, INCIDENT_SEVERITY
ORDER BY TOTAL_CLAIM_AMOUNT DESC
LIMIT 10;


/* Total Premium Amount by Insurance Type and Incident Severity IN EACH STATE

This query calculates the total premium amount for each 
combination of insurance type and incident severity.
*/

SELECT INSURANCE_TYPE, INCIDENT_SEVERITY, INCIDENT_STATE, 
SUM(PREMIUM_AMOUNT) AS TOTAL_PREMIUM_AMOUNT
FROM Insurance_Data
GROUP BY INSURANCE_TYPE, INCIDENT_SEVERITY, INCIDENT_STATE
ORDER BY TOTAL_PREMIUM_AMOUNT DESC
LIMIT 12;


--- Incident Severity with the average claim amount

SELECT INCIDENT_SEVERITY, AVG(CLAIM_AMOUNT) AS AVERAGE_CLAIM_AMOUNT
FROM Insurance_Data
GROUP BY INCIDENT_SEVERITY;

---- Customers Who Reported Incidents with the Highest Severity

SELECT CUSTOMER_ID, CUSTOMER_NAME, INCIDENT_SEVERITY, INCIDENT_STATE, 
INCIDENT_HOUR_OF_THE_DAY, CLAIM_AMOUNT
FROM Insurance_Data
WHERE INCIDENT_SEVERITY = (SELECT MAX(INCIDENT_SEVERITY) FROM Insurance_Data)
limit 10;



/* Customers with Suspicious Claims
customers who have made claims with unusually high claim amounts 
compared to their average premium amount.*/

SELECT a.CUSTOMER_ID, a.CUSTOMER_NAME, AVG(a.PREMIUM_AMOUNT) AS AVERAGE_PREMIUM,
       MAX(a.CLAIM_AMOUNT) AS MAX_CLAIM_AMOUNT
FROM Insurance_Data a
GROUP BY a.CUSTOMER_ID, a.CUSTOMER_NAME
HAVING MAX(a.CLAIM_AMOUNT) > 2 * AVG(a.PREMIUM_AMOUNT)
limit 20;

--- Identify Customers with Unusual Claim Patterns

SELECT a.CUSTOMER_ID, a.CUSTOMER_NAME, a.INSURANCE_TYPE, 
a.INCIDENT_SEVERITY, a.LOSS_DT, a.INCIDENT_HOUR_OF_THE_DAY
FROM Insurance_Data a
WHERE a.INCIDENT_HOUR_OF_THE_DAY < 7 OR a.INCIDENT_HOUR_OF_THE_DAY > 20;

---- Detect Unusual Claims for Customers with Low Premiums

SELECT a.CUSTOMER_ID, a.CUSTOMER_NAME, a.PREMIUM_AMOUNT, a.CLAIM_AMOUNT
FROM Insurance_Data a
WHERE a.PREMIUM_AMOUNT < 100 AND a.CLAIM_AMOUNT > 5000;

---- Find late reporting based on risk segmentation.

SELECT RISK_SEGMENTATION, COUNT(*) AS LATE_REPORTS
FROM Insurance_Data
WHERE EXTRACT(DAY FROM AGE(REPORT_DT, LOSS_DT)) > 7
GROUP BY RISK_SEGMENTATION;


--- Identify incidents with high claim amounts where the authority contacted is unusual

SELECT * 
FROM Insurance_Data
WHERE CLAIM_AMOUNT > 2 * PREMIUM_AMOUNT
AND AUTHORITY_CONTACTED NOT IN ('Police', 'Fire', 'Ambulance');

--- Late Reporting of Severe Incidents by Authority Contacted

SELECT AUTHORITY_CONTACTED, COUNT(*) AS LATE_REPORTS
FROM Insurance_Data
WHERE INCIDENT_SEVERITY = 'Major Loss' AND 
EXTRACT(DAY FROM AGE(REPORT_DT, LOSS_DT)) > 4
GROUP BY AUTHORITY_CONTACTED;

--- High-Value Claims with Injuries by Social Class

SELECT SOCIAL_CLASS, COUNT(*) AS HIGH_CLAIMS_WITH_INJURIES
FROM Insurance_Data
WHERE CLAIM_AMOUNT > 10000 AND ANY_INJURY = 1
GROUP BY SOCIAL_CLASS;


--- Supicious Claims by Age and Insurance Type: A FOR ACCEPTED AND D FOR DENIED

SELECT AGE, INSURANCE_TYPE, COUNT(*) AS SUSPICIOUS_CLAIMS
FROM Insurance_Data
WHERE CLAIM_STATUS = 'D' AND CLAIM_AMOUNT > 20000
GROUP BY AGE, INSURANCE_TYPE;

select * from insurance_data



--- Vendor Queries

--- This query lists vendors who share the same address, 
--- indicating potential shared locations.

SELECT V1.VENDOR_ID AS VENDOR1_ID, V1.VENDOR_NAME AS VENDOR1_NAME,
       V2.VENDOR_ID AS VENDOR2_ID, V2.VENDOR_NAME AS VENDOR2_NAME,
       V1.ADDRESS_LINE1, V1.CITY, V1.POSTAL_CODE
FROM Vendor V1
JOIN Vendor V2 ON V1.ADDRESS_LINE1 = V2.ADDRESS_LINE1
              AND V1.CITY = V2.CITY
              AND V1.POSTAL_CODE = V2.POSTAL_CODE
WHERE V1.VENDOR_ID < V2.VENDOR_ID;

---- Total Number of Vendors in Each State

SELECT STATE, COUNT(*) AS VENDOR_COUNT
FROM Vendor
GROUP BY STATE;

----  Vendors located in cities with a high number of fraudulent activities.

SELECT a.VENDOR_ID, a.VENDOR_NAME, a.CITY, a.STATE
FROM Vendor a
WHERE a.CITY IN (
    SELECT CITY
    FROM Employee b
    WHERE b.AGENT_ID IS NOT NULL
);


/*JOINS*/

/* List the employees who have handled claims with the highest premium amounts */

SELECT a.AGENT_NAME, b.PREMIUM_AMOUNT
FROM Employee a
INNER JOIN Insurance_Data b ON a.AGENT_ID = b.AGENT_ID
ORDER BY PREMIUM_AMOUNT DESC
LIMIT 10;

---  Find the total number of claim amount handled by each employee

SELECT a.AGENT_NAME, count(b.CLAIM_AMOUNT) AS TotalClaimAmount
FROM Employee a
INNER JOIN Insurance_Data b ON a.AGENT_ID = b.AGENT_ID
GROUP BY a.AGENT_NAME
ORDER BY TotalClaimAmount DESC
limit 20;

---- Employees and vendors who have the same postal code, state, and city

SELECT a.AGENT_NAME AS EmployeeName, b.VENDOR_NAME AS VendorName, a.POSTAL_CODE, a.STATE, a.CITY
FROM Employee a
LEFT JOIN Vendor b ON a.POSTAL_CODE = b.POSTAL_CODE AND a.STATE = b.STATE AND a.CITY = b.CITY
WHERE b.VENDOR_ID IS NOT NULL;


/* This query will return the names of employees and vendors 
who share the same POSTAL_CODE and CITY. 
It's a common way to identify potential 
collusion based on geographic proximity. 
*/

SELECT a.AGENT_NAME, b.VENDOR_NAME
FROM Employee a
LEFT JOIN Vendor b ON a.POSTAL_CODE = b.POSTAL_CODE AND a.CITY = b.CITY
WHERE b.VENDOR_ID IS NOT NULL;
