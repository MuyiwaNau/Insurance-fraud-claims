# Insurance-fraud-claims

Insurance fraud entails collaborating to file dishonest or exaggerated claims related to property damage or personal injuries after an accident. Typical instances include deliberately orchestrating accidents (staged accidents), fabricating injury claims by individuals who weren't present at the accident scene (phantom passengers), and grossly inflating personal injury claims.

# Contents

**Employee data**
- `AGENT_ID`: Unique identifier for the employee (Agent ID).
- `AGENT_NAME`: Name of the employee.
- `DATE_OF_JOINING`: Date when the employee joined the organization.
- `ADDRESS_LINE1`: Employee's address (Line 1).
- `CITY`: City where the employee resides.
- `STATE`: State abbreviation where the employee resides.
- `POSTAL_CODE`: Postal code of the employee's location.
- `EMP_ROUTING_NUMBER`: Routing number for the employee's bank account.
- `EMP_ACCT_NUMBER`: Account number for the employee's bank account.


# Project Overview
  Project Description:
  In this project, I created a data analysis project to detect insurance fraud claims that involves several steps. Below is a structured project plan that combines Excel, SQL, Python, and Tableau to detect and analyze potentially fraudulent insurance claims.
  
  **Project Steps:**
  
  **Step 1: Data Collection**
  
  - Gather historical insurance claims data from your organization or a relevant source. This data should include information about claims, policyholders, incidents, and claim details.
  
  **Step 2: Data Preprocessing**
  
  - Clean the raw data in Excel, removing duplicates, handling missing values, and ensuring consistency.

  **Step 3: Data Exploration and Analysis (Python)**
  
  - Import the preprocessed data into Python for exploratory data analysis (EDA).
  - Use Python libraries like Pandas, Matplotlib, and Seaborn to:
      - Visualize claim trends, such as claim amounts, incident types, and time trends.
      - Calculate descriptive statistics for key variables.
      - Identify potential outliers and anomalies in the data.
  - Conduct statistical tests and visualizations to identify patterns that may indicate fraud.

  **Step 4: Data Transformation and SQL**
  - Create an SQL database to store the clean and preprocessed data.
  - Use SQL to:
    - Normalize the data by creating appropriate tables for policyholders, claims, incidents, etc.
    - Perform joins to link related data.
    - Calculate metrics, such as the total claim amount for each policyholder.
  - Filter and subset data for specific analysis needs.
  **Step 5: Fraud Detection (Python)**

  **Step 6: Data Visualization (Tableau)**
  - Connect Tableau to your SQL database.
  - Create interactive dashboards and reports that provide insights into fraud patterns.
  - Visualize the results of the fraud detection model and display fraud indicators.
  - Use Tableau to communicate the findings effectively with stakeholders.

  **Step 7: Reporting**
  - Document your analysis methodology, SQL queries, and critical findings.
  - Created a concise report or presentation that highlights the project's significance and the value it brings to the retail business.


![image](https://github.com/MuyiwaNau/Insurance-fraud-claims/assets/34709932/1806e862-f392-460b-a14e-494cb8eacce4)

![image](https://github.com/MuyiwaNau/Insurance-fraud-claims/assets/34709932/bc88b31d-8e81-44b7-8315-e35252292218)

![image](https://github.com/MuyiwaNau/Insurance-fraud-claims/assets/34709932/b4eaa2e7-904b-4ff9-96df-3b9fa027ecc4)



# Data Sources

- Employee Data - this is the master data of the employee ( a.k.a agents or adjusters ) working on the insurance claims.
- Vendor Data - this is the master data of the vendor who assists the insurance company in investigating the claims.
- Insurance Data - this is the Claim-level transaction details submitted by the customer to the insurance company for reimbursement.
 

# Tools
- Excel - Data Cleaning
- PostGresSQL Server - Data Analysis
- Python/Jupyter
- Tableau - Creating reports

 
# Data Analysis
Include some exciting code/features worked with

**Top 10 Customers ID with the Highest Total Spend:**

    SELECT SOCIAL_CLASS, COUNT(*) AS HIGH_CLAIMS_WITH_INJURIES
    FROM Insurance_Data
    WHERE CLAIM_AMOUNT > 10000 AND ANY_INJURY = 1
    GROUP BY SOCIAL_CLASS;

**Top 3 Insurance Type where we are getting most insurance claims in amounts**

        insurance_type =pd.DataFrame(df.groupby('INSURANCE_TYPE')
                 ['CLAIM_AMOUNT'].sum()).sort_values(by='CLAIM_AMOUNT', ascending=False).head(3)
    insurance_type.columns = ['COUNT']
    insurance_type['INSURANCE_TYPE'] = insurance_type.index
    insurance_type.reset_index(drop= True, inplace= True) # dropping the index column
    insurance_type

# Results/Findings
The analysis results are summarized as follows:

- Suspicious Claims by Age and Insurance Type: A FOR ACCEPTED AND D FOR DENIED.
- List the employees who have handled claims with the highest premium amounts
- Find late reporting based on risk segmentation
- Identify Customers with Unusual Claim Patterns
- Customers Who Reported Incidents with the Highest Severity
- Total Claims Amount for Each Risk Segmentation in each City

# Recommendations
Based on the analysis, we recommend the following actions:

- Consider implementing more advanced fraud detection models to identify complex patterns based on historical data and emerging fraud tactics.
- Ensure that customers reporting incidents with the highest severity receive timely and appropriate support. This may involve prioritizing their claims and providing necessary assistance promptly.
- Late reporting can increase costs, so addressing this issue is essential.
  

# References
- SQL for Businesses
- Tableau
- Microsoft Excel
- Python

