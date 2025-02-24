# 📊 Walmart Sales Data Analysis Project

## 📌 **Project Overview**

This project provides an in-depth analysis of a Walmart sales dataset using **Power BI**, **Python (EDA)**, and **SQL**. The primary goal is to uncover key insights, visualize sales trends, and address crucial business problems.

---

## 🛠 **Tools & Technologies Used**

- **Power BI:** For creating interactive dashboards and data visualization.
- **Python:** For Exploratory Data Analysis (EDA) using libraries such as **pandas**.
- **SQL:** For solving business problems by querying sales data.

---

## 🔍 **Exploratory Data Analysis (EDA)**

- **Data Cleaning:** Handled missing values, corrected data types (especially date and time), and removed duplicates.
- **Descriptive Analysis:** Analyzed distribution of sales, ratings, profit margins, and quantity sold.

---

## 💡 **Power BI Dashboards**

### 1️⃣ **Sales Overview Dashboard**

**Insights:**

- Total sales, total quantity sold, average rating, and total profit.
- Sales trends over time (daily, monthly).
- Top-performing cities and branches by total sales and profit.
- Profit margin comparison across categories.

**Visuals Used:**

- KPI cards (Total Sales, Profit, Quantity).
- Line chart (Sales trend over time).
- Bar chart (Sales by city and branch).
- Pie chart (Sales distribution by category).

---
![Screenshot 2025-02-24 215901](https://github.com/user-attachments/assets/29129612-aada-4021-90e4-daca8c68875f)

### 2️⃣ **Branch & City Performance Dashboard**

**Insights:**

- Sales and profit per branch and city.
- Customer rating trends by branch.
- Best time for sales in each city.
- Top-selling product categories in each city.

**Visuals Used:**

- Clustered bar chart (Branch-wise sales comparison).
- Heat map (City-wise sales performance).
- Donut chart (Category contribution per branch).
- Scatter chart (Ratings vs. Profit margin).

---

## 🏢 **Business Problems & SQL Solutions**

### 🔹 **1. Different Payment Methods and Number of Transactions**

```sql
SELECT payment_method, COUNT(*) AS no_payments, SUM(quantity) AS no_qty_sold
FROM sales_data
GROUP BY payment_method;
```

**Insight:** Shows popular payment methods and corresponding quantity sold.

---

### 🔹 **2. Highest Rated Category in Each Branch**

```sql
SELECT branch, category, avg_rating FROM (
    SELECT branch, category, AVG(rating) AS avg_rating,
           RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank
    FROM sales_data
    GROUP BY branch, category
) WHERE rank = 1;
```

**Insight:** Identifies top-rated product categories for each branch.

---

### 🔹 **3. Busiest Day for Each Branch**

```sql
SELECT branch, TO_CHAR(date,'Day') AS Day_name, COUNT(*) AS no_transactions
FROM sales_data
GROUP BY branch, Day_name
ORDER BY no_transactions DESC;
```

**Insight:** Determines the peak sales day for each branch.

---

### 🔹 **4. Total Quantity Sold per Payment Method**

```sql
SELECT payment_method, SUM(quantity) AS no_qty_sold
FROM sales_data
GROUP BY payment_method;
```

**Insight:** Shows which payment methods yield the most quantity sold.

---

### 🔹 **5. Rating Statistics for Each City**

```sql
SELECT city, category, MIN(rating) AS min_rating, MAX(rating) AS max_rating, AVG(rating) AS avg_rating
FROM sales_data
GROUP BY city, category;
```

**Insight:** Summarizes average, minimum, and maximum product ratings per city and category.

---

### 🔹 **6. Total Profit per Category**

```sql
SELECT category, SUM(total) AS total_revenue, SUM(total * profit_margin) AS profit
FROM sales_data
GROUP BY category
ORDER BY profit DESC;
```

**Insight:** Highlights the most profitable categories based on total revenue and profit.

---

### 🔹 **7. Most Common Payment Method per Branch**

```sql
WITH cte AS (
    SELECT branch, payment_method, COUNT(*) AS total_trans,
           RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank
    FROM sales_data
    GROUP BY branch, payment_method
)
SELECT * FROM cte WHERE rank = 1;
```

**Insight:** Shows the preferred payment method for each branch.

---

### 🔹 **8. Sales Shift Analysis (Morning, Afternoon, Evening)**

```sql
SELECT branch,
       CASE
           WHEN EXTRACT(HOUR FROM time) < 12 THEN 'Morning'
           WHEN EXTRACT(HOUR FROM time) BETWEEN 12 AND 17 THEN 'Afternoon'
           ELSE 'Evening'
       END AS day_time,
       COUNT(*) AS total_invoices
FROM sales_data
GROUP BY branch, day_time
ORDER BY branch, total_invoices DESC;
```

**Insight:** Breaks down sales performance by time of day for each branch.

---

### 🔹 **9. Branches with Highest Revenue Decrease Ratio (YoY)**

```sql
WITH revenue_2022 AS (
    SELECT branch, SUM(total) AS revenue
    FROM sales_data
    WHERE EXTRACT(YEAR FROM date) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT branch, SUM(total) AS revenue
    FROM sales_data
    WHERE EXTRACT(YEAR FROM date) = 2023
    GROUP BY branch
)
SELECT ls.branch, ls.revenue AS last_year_revenue, cs.revenue AS cr_year_revenue,
       ROUND(((ls.revenue - cs.revenue) * 1.0 / ls.revenue) * 100, 2) AS rev_dec_ratio
FROM revenue_2022 AS ls
JOIN revenue_2023 AS cs ON ls.branch = cs.branch
WHERE ls.revenue > cs.revenue
ORDER BY rev_dec_ratio DESC;
```

**Insight:** Identifies the top 5 branches with the largest revenue drop compared to the previous year.

---

## 🎯 **Key Insights & Takeaways**

- 📈 **Branch B** had the highest overall sales and profit.
- 💳 **E-wallet** emerged as the most preferred payment method.
- 🌆 **City Y** consistently received the best customer ratings.
- 🕒 **Afternoon shift** saw the most sales across all branches.
- 📉 **Branch D** showed a significant year-over-year revenue decline, requiring further analysis.

---

## 🚀 **Conclusion**

This comprehensive analysis using Power BI, Python, and SQL provided actionable insights into Walmart's sales performance. The dashboards enable dynamic exploration of sales trends, customer preferences, and operational efficiency. Further improvements can include predictive sales modeling and customer segmentation analysis using machine learning techniques.

---

## 🔗 **Future Scope**

- 📊 Predictive sales forecasting using time-series models.
- 💡 Advanced customer segmentation using clustering algorithms.
- 🏬 Supply chain optimization and inventory forecasting.
- 📈 Real-time sales dashboard integration for live business monitoring.

---

*🔒 This project demonstrates the power of data-driven decisions in optimizing business processes and enhancing sales strategies.*

