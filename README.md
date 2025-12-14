# 📊 Banking Customer Churn Analysis using SQL

## Project Overview

Customer churn is a critical challenge in the banking industry, as losing customers directly impacts revenue and long-term growth. This project analyzes **banking customer churn data** using **PostgreSQL** to uncover patterns, risk factors, and actionable business insights.

The goal is to identify **why customers leave**, **which segments are most at risk**, and **what business strategies can help reduce churn**.

---

## 🗂 Dataset Description

The dataset contains demographic, financial, and behavioral information of bank customers.

**Key attributes include:**

* Customer demographics (Age, Gender, Geography)
* Financial indicators (Balance, Estimated Salary, Credit Score)
* Engagement metrics (Tenure, Number of Products, Active Membership)
* Churn flag (`Exited`: 1 = Churned, 0 = Retained)

---

## 🛠 Tech Stack

* **Database:** PostgreSQL 18
* **Language:** SQL
* **Tools:** pgAdmin
* **Concepts Used:**

  * Data Cleaning & Validation
  * Aggregations & Grouping
  * CASE statements
  * CTEs (Common Table Expressions)
  * Window Functions

---

## 🧱 Database Schema

```sql
CREATE TABLE bank_churn (
    row_number INT,
    customer_id INT,
    surname VARCHAR(50),
    credit_score INT,
    geography VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    tenure INT,
    balance NUMERIC(15,2),
    num_of_products INT,
    has_cr_card SMALLINT,
    is_active_member SMALLINT,
    estimated_salary NUMERIC(15,2),
    exited SMALLINT
);
```

---

## 🧹 Data Cleaning & Validation Steps

Before analysis, the data was validated to ensure accuracy:

* Checked total number of records
* Verified **NULL values** in critical columns
* Validated **binary columns** (Exited, Has Credit Card, Active Member)
* Checked for **duplicate customer IDs**
* Inspected outliers and invalid values (negative balance, age ranges)
* Reviewed distinct categories for geography and gender

These steps ensured the dataset was **analysis-ready**.

---

## 📈 Business Questions Answered

### 1. Overall Churn Rate

* What percentage of customers have exited the bank?

### 2. Churn Rate by Geography

* Which regions have the highest customer churn?

### 3. Churn by Age Group

* Which age group is most likely to churn?

### 4. Active vs Inactive Customers

* Do inactive members churn more than active ones?

### 5. Gender-wise Churn Analysis

* Is churn behavior different across genders?

### 6. Balance Comparison (Churned vs Retained)

* Are high-value customers leaving the bank?

### 7. Number of Products vs Churn

* How does product holding affect churn?

### 8. Credit Card Ownership Impact

* Do customers with credit cards churn less?

### 9. Tenure-based Churn Buckets

* Are new or long-term customers more likely to churn?

### 10. High-Value Churned Customers

* Identify churned customers with balance > 100,000

### 11. High-Risk Customer Segments (CTE)

* Segment customers by geography, age group, and activity status

### 12. Inactive Churn Percentage

* What percentage of churned customers were inactive?

### 13. Geography Ranking (Window Function)

* Rank regions based on churn rate

### 14. High-Risk Customer Identification

* Identify customers at high churn risk based on multiple conditions

### 15. Salary Analysis of Churned Customers

* Compare estimated salary of churned customers by geography

---

## 💡 Key Insights

* Inactive customers show significantly higher churn rates
* Certain geographies consistently rank higher in churn
* Customers with higher balances are also churning, posing revenue risk
* Older customers (>45) with high balances and inactivity are at highest risk

---

## 📊 Business Value

This analysis helps banks:

* Proactively identify **high-risk customers**
* Design **targeted retention strategies**
* Protect **high-value customer segments**
* Improve customer engagement and lifetime value

---

## 🚀 Future Enhancements

* Integrate with **Power BI** for interactive dashboards
* Add **predictive churn modeling** using Python
* Automate churn monitoring with scheduled queries

---

## 📌 How to Use This Project

1. Clone the repository
2. Load the dataset into PostgreSQL
3. Execute the SQL scripts in sequence
4. Analyze outputs and derive insights

---

## 👤 Author

**Ayushri Kasture**
Aspiring Data Analyst | SQL | PostgreSQL | Data Analytics

---

⭐ If you find this project useful, feel free to star the repository!
