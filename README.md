# 🚲 Bike Shop Rental & Sales Analysis

![SQL](https://img.shields.io/badge/Language-SQL-blue)
![Database](https://img.shields.io/badge/Database-MySQL-orange)
![Status](https://img.shields.io/badge/Status-Completed-success)

## 📌 Project Overview
This project analyzes the database of a bike rental shop to help the owner optimize inventory, design pricing strategies, and track revenue streams. The repository contains the full database schema, sample data, and advanced SQL analysis scripts.

## 📂 Repository Structure
The project files are organized as follows:

| Folder/File | Description |
| :--- | :--- |
| **Sql_Script.sql/** | Directory containing all source code. |
| ├── `schema_creation & insertion.sql` | Contains DDL (CREATE) and DML (INSERT) statements to build the database. |
| ├── `solution.sql` | Contains the analytical queries solving key business problems. |

## 🗄️ Database Schema
The database consists of five relational tables: `customer`, `bike`, `rental`, `membership`, and `membership_type`.

### Entity Relationship Diagram (ERD)
```mermaid
erDiagram
    CUSTOMER ||--o{ RENTAL : "makes"
    CUSTOMER ||--o{ MEMBERSHIP : "purchases"
    BIKE ||--o{ RENTAL : "is rented in"
    MEMBERSHIP_TYPE ||--|{ MEMBERSHIP : "defines"
    
    CUSTOMER {
        int id PK
        string name
        string email
    }
    BIKE {
        int id PK
        string model
        string category
        decimal price_per_hour
        decimal price_per_day
        string status
    }
    RENTAL {
        int id PK
        int customer_id FK
        int bike_id FK
        timestamp start_timestamp
        int duration
        decimal total_paid
    }
    MEMBERSHIP {
        int id PK
        int membership_type_id FK
        int customer_id FK
        date start_date
        date end_date
        decimal total_paid
    }
    MEMBERSHIP_TYPE {
        int id PK
        string name
        string description
        decimal price
    }
```

## 🔍 Analysis Highlights

### 1. 🏷️ Seasonal Pricing Strategy
**Problem:** The shop needs a winter pricing model to boost sales.
**Logic:** * **Electric Bikes:** 10% off hourly, 20% off daily.
* **Mountain Bikes:** 20% off hourly, 50% off daily.
* **Others:** 50% off everything.

```sql
SELECT 
    id, category, 
    price_per_hour AS old_hourly,
    CASE 
        WHEN Category = 'electric' THEN price_per_hour * 0.90 
        WHEN Category = 'mountain bike' THEN price_per_hour * 0.80
        ELSE price_per_hour * 0.50
    END AS new_hourly,
    price_per_day AS old_daily,
    CASE 
        WHEN Category = 'electric' THEN price_per_day * 0.80 
        WHEN Category = 'mountain bike' THEN price_per_day * 0.50
        ELSE price_per_day * 0.50 
    END AS new_daily
FROM bike;
```

### 2. 👥 Customer Segmentation
**Problem:** Segment customers based on rental frequency to identify VIPs.
**Segments:**
* **High:** > 10 rentals
* **Medium:** 5 - 10 rentals
* **Low:** < 5 rentals

```sql
WITH Count_rent AS (
    SELECT
        c.name,
        COUNT(r.bike_id) AS Total_rentals 
    FROM customer c 
    LEFT JOIN rental r ON r.customer_id = c.id
    GROUP BY c.name 
)
SELECT
    CASE 
        WHEN Total_rentals > 10 THEN 'more than 10' 
        WHEN Total_rentals BETWEEN 5 AND 10 THEN 'between 5 and 10' 
        WHEN Total_rentals < 5 THEN 'less than 5'
    END AS rental_count_category,
    COUNT(*) AS Total_customers
FROM Count_rent
GROUP BY rental_count_category;
```

### 3. 🚲 Fleet Availability
**Problem:** Determine the current status of the bike fleet.
**Insight:** Uses pivot logic to count available vs. rented vs. out-of-service bikes per category.

```sql
SELECT 
    Category,
    COUNT(*) as Total_Fleet,
    COUNT(CASE WHEN status = 'available' THEN 1 END) As Available_Count,
    COUNT(CASE WHEN status = 'rented' THEN 1 END) As Rented_Count,
    COUNT(CASE WHEN status = 'out of service' THEN 1 END) As Out_of_Service_Count
FROM bike 
GROUP BY Category;
```

## 🚀 How to Run

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/yourusername/bike-shop-analysis.git](https://github.com/yourusername/bike-shop-analysis.git)
    ```
2.  **Initialize Database:**
    * Open your SQL client (MySQL Workbench, DBeaver, etc.).
    * Navigate to the `Sql_Script.sql` folder.
    * Run `schema_creation & insertion.sql`. This will drop existing tables and create the new schema with data.
3.  **Run Analysis:**
    * Execute `solution.sql` to generate the insights and reports.

## 🛠️ Tech Stack
* **Database:** MySQL
* **Concepts Used:** * **DDL/DML:** Table creation and data insertion.
    * **Aggregations:** `GROUP BY`, `COUNT`, `SUM`.
    * **Complex Logic:** `CASE` statements for pricing and pivoting.
    * **Joins:** `LEFT JOIN` to include customers with zero rentals.
    * **CTEs:** For readable segmentation logic.
