 
 # Airline Loyalty Program SQL Analysis
This analysis focuses on the customer loyalty program data for Northern Lights Air (NLA), a fictitious Canadian airline. NLA launched a promotional campaign between February and April 2018, aimed at improving loyalty program enrollments. 

## 🧠 Key Analysis Areas

The key areas analyzed in this project include, but not limited to::

1. **Impact of the Promotion on Loyalty Program Memberships**: Analyzing changes in the number of enrollments before and after the campaign.
2. **Campaign Adoption by Demographics**: Identifying whether certain customer demographics (e.g., age, gender, salary) were more likely to join the program during the campaign.
3. **Flight Activity During Summer Months**: Assessing the impact of the promotion on flight activity, particularly during the summer months (June - August 2018).
4. **Customer Lifetime Value (CLV)**: Analyzing the CLV of customers who joined during the campaign versus those who joined earlier.
5. **Geographic Patterns**: Identifying which provinces and cities saw higher enrollment rates during the campaign period.

## 🧑‍💻 Data Overview

The dataset consists of two main tables:

1. **Customer_Flight_Activity**: Contains records of customer flight activity, including flight distances, points accumulated, and redeemed points.
2. **Customer_Loyalty_History**: Contains demographic information such as country, province, city, salary, and enrollment/cancellation details.

## 📌Queries Overview

The following SQL queries are used to answer different analysis questions based on the dataset:

### **1. What was the net new member count during the Feb-Apr 2018 promotion?** 
- **🔍Query**: Calculates gross enrollments, cancellations, and net new members during the campaign period.
- **🎯Purpose**: Evaluates the promotion’s effectiveness by balancing signups against cancellations.

```sql
SELECT
    COUNT(DISTINCT CASE WHEN Enrollment_Year = 2018 AND Enrollment_Month BETWEEN 2 AND 4 THEN Loyalty_Number END) AS gross_new_members,
    COUNT(DISTINCT CASE WHEN Cancellation_Year = 2018 AND Cancellation_Month BETWEEN 2 AND 4 THEN Loyalty_Number END) AS cancellations_during_campaign,
    COUNT(DISTINCT CASE WHEN Enrollment_Year = 2018 AND Enrollment_Month BETWEEN 2 AND 4 THEN Loyalty_Number END) -
    COUNT(DISTINCT CASE WHEN Cancellation_Year = 2018 AND Cancellation_Month BETWEEN 2 AND 4 THEN Loyalty_Number END) AS net_new_members
FROM
    Customer_Loyalty_History
WHERE
    (Enrollment_Year = 2018 AND Enrollment_Month BETWEEN 2 AND 4) OR
    (Cancellation_Year = 2018 AND Cancellation_Month BETWEEN 2 AND 4);
```

###  **2. How do gender and education level influence new member signups during the Feb-Apr 2018 promotion?** 
- **🔍Query**: Groups new members by gender and education level, counting distinct enrollments.
- **🎯Purpose**: Identifies demographic trends to refine targeting strategies for future campaigns.

```sql
SELECT
    Gender,
    Education,
    COUNT(DISTINCT Loyalty_Number ) AS new_members
FROM
    Customer_Loyalty_History
WHERE
    Enrollment_Year = 2018 AND Enrollment_Month BETWEEN 2 AND 4
GROUP BY
    Gender, Education
ORDER BY
    new_members DESC;
```
###  **3. How did salary levels impact campaign adoption during the Feb-Apr 2018 promotion?** 
- **🔍Query**: Categorizes new members by salary range, calculates their count, and computes their percentage of total new members.
- **🎯Purpose**: Evaluates campaign adoption across income-based demographic segments to refine targeting strategies.

```sql
SELECT
    CASE
        WHEN Salary < 40000 THEN 'Low Salary'
        WHEN Salary BETWEEN 40000 AND 100000 THEN 'Medium Salary'
        WHEN Salary > 100000 THEN 'High Salary'
        ELSE 'N.A'
    END AS Salary_Category,
    COUNT(DISTINCT Loyalty_Number) AS new_members,
    ROUND(
        (COUNT(DISTINCT Loyalty_Number) * 100.0) /
        (SELECT COUNT(DISTINCT Loyalty_Number) 
         FROM Customer_Loyalty_History 
         WHERE Enrollment_Year = 2018 AND Enrollment_Month BETWEEN 2 AND 4), 
        2
    ) AS percentage_of_total_new_members
FROM
    Customer_Loyalty_History
WHERE
    Enrollment_Year = 2018 AND Enrollment_Month BETWEEN 2 AND 4
GROUP BY
    Salary_Category
ORDER BY
    new_members DESC;
```
###  **4. What was the impact on flights booked during summer (June, July, August 2018) by new members vs. others?** 
- **🔍Query**: Compares total flights booked during summer 2018 by new members (enrolled Feb-Apr 2018) and other members.
- **🎯Purpose**: Measures the contribution of new members to summer flight bookings to assess campaign effectiveness in driving engagement.

```sql
SELECT
    SUM(CASE WHEN clh.Enrollment_Year = 2018 AND clh.Enrollment_Month BETWEEN 2 AND 4
             AND cfa.Year = 2018 AND cfa.Month IN (6, 7, 8) THEN cfa.Total_Flights ELSE 0 END) AS summer_flights_by_new_members,
    SUM(CASE WHEN NOT (clh.Enrollment_Year = 2018 AND clh.Enrollment_Month BETWEEN 2 AND 4)
             AND cfa.Year = 2018 AND cfa.Month IN (6, 7, 8) THEN cfa.Total_Flights ELSE 0 END) AS summer_flights_by_others
FROM
    Customer_Loyalty_History clh
JOIN
    Customer_Flight_Activity cfa
ON
    clh.Loyalty_Number = cfa.Loyalty_Number;
```

###  **5. How does flyer behavior (distance flown) impact loyalty program retention?**
- **🔍Query**: Groups members by flight distance categories, calculates active/canceled membership percentages.
- **🎯Purpose**: Reveals retention trends to target incentives for low-engagement or high-churn segments.
```sql
WITH FlightSummary AS (
    SELECT 
        cf.Loyalty_Number,
        SUM(cf.Distance) AS total_distance_flown,
        ch.Cancellation_Year
    FROM Customer_Loyalty_History ch
    JOIN Customer_Flight_Activity cf ON ch.Loyalty_Number = cf.Loyalty_Number
    GROUP BY cf.Loyalty_Number, ch.Cancellation_Year
)
SELECT 
    CASE 
        WHEN total_distance_flown < 5000 THEN 'Low Flyers (<5K km)'
        WHEN total_distance_flown BETWEEN 5000 AND 20000 THEN 'Moderate Flyers (5K-20K km)'
        ELSE 'Frequent Flyers (>20K km)'
    END AS flyer_category,
    COUNT(DISTINCT Loyalty_Number) AS customer_count,
    ROUND(100.0 * COUNT(CASE WHEN Cancellation_Year IS NULL THEN 1 END) / COUNT(DISTINCT Loyalty_Number), 2) AS active_members_percentage,
    ROUND(100.0 * COUNT(CASE WHEN Cancellation_Year IS NOT NULL THEN 1 END) / COUNT(DISTINCT Loyalty_Number), 2) AS canceled_members_percentage
FROM FlightSummary
GROUP BY flyer_category
ORDER BY customer_count DESC;
```
###  **6. What are the points accumulated and redeemed associated with customer retention?** 
- **🔍Query**: Calculates total points accumulated and redeemed by customers, comparing active members (no cancellation) to those who canceled their membership. It also computes the percentage of points relative to the overall totals.
- **🎯Purpose**: Analyzes the correlation between points activity (accumulation and redemption) and customer retention to identify engagement patterns among loyal customers.

```sql
WITH TotalPoints AS (
    SELECT
        ch.Cancellation_Year,
        SUM(cf.Points_Accumulated) AS total_points_accumulated,
        SUM(cf.Points_Redeemed) AS total_points_redeemed
    FROM
        Customer_Loyalty_History ch
    JOIN
        Customer_Flight_Activity cf ON ch.Loyalty_Number = cf.Loyalty_Number
    GROUP BY
        ch.Cancellation_Year
),
GrandTotal AS (
    SELECT
        SUM(cf.Points_Accumulated) AS grand_total_accumulated,
        SUM(cf.Points_Redeemed) AS grand_total_redeemed
    FROM
        Customer_Loyalty_History ch
    JOIN
        Customer_Flight_Activity cf ON ch.Loyalty_Number = cf.Loyalty_Number
)
SELECT
    tp.Cancellation_Year,
    tp.total_points_accumulated,
    tp.total_points_redeemed,
    ROUND(
        (CAST(tp.total_points_accumulated AS NUMERIC) / 
         NULLIF((SELECT grand_total_accumulated FROM GrandTotal), 0)) * 100, 
        2
    ) AS accumulated_percentage,
    ROUND(
        (CAST(tp.total_points_redeemed AS NUMERIC) / 
         NULLIF((SELECT grand_total_redeemed FROM GrandTotal), 0)) * 100, 
        2
    ) AS redeemed_percentage
FROM
    TotalPoints tp
WHERE
    tp.Cancellation_Year IS NULL -- Active members, no cancellation
    OR tp.Cancellation_Year >= 2017;
```

###  **7. How does flyer behavior (distance flown) impact loyalty program retention?** 
- **🔍Query**: Categorizes members by total distance flown, then calculates the percentage of active and canceled memberships for each category.
- **🎯Purpose**: Identifies retention trends among different flyer types to tailor engagement strategies for low, moderate, and frequent flyers.

```sql
WITH FlightSummary AS (
    SELECT 
        cf.Loyalty_Number,
        SUM(cf.Distance) AS total_distance_flown,
        ch.Cancellation_Year
    FROM Customer_Loyalty_History ch
    JOIN Customer_Flight_Activity cf ON ch.Loyalty_Number = cf.Loyalty_Number
    GROUP BY cf.Loyalty_Number, ch.Cancellation_Year
)
SELECT 
    CASE 
        WHEN total_distance_flown < 5000 THEN 'Low Flyers (<5K km)'
        WHEN total_distance_flown BETWEEN 5000 AND 20000 THEN 'Moderate Flyers (5K-20K km)'
        ELSE 'Frequent Flyers (>20K km)'
    END AS flyer_category,
    COUNT(DISTINCT Loyalty_Number) AS customer_count,
    ROUND(100.0 * COUNT(CASE WHEN Cancellation_Year IS NULL THEN 1 END) / COUNT(DISTINCT Loyalty_Number), 2) AS active_members_percentage,
    ROUND(100.0 * COUNT(CASE WHEN Cancellation_Year IS NOT NULL THEN 1 END) / COUNT(DISTINCT Loyalty_Number), 2) AS canceled_members_percentage
FROM FlightSummary
GROUP BY flyer_category
ORDER BY customer_count DESC;
```

###  **8. Did certain provinces or cities see higher enrollment rates during the campaign?** 
- **🔍Query**: Groups enrollments by province and city, counting total enrollments during the Feb-Apr 2018 campaign period.
- **🎯Purpose**: Identifies geographic regions with the highest enrollment activity to inform targeted marketing efforts and resource allocation.

```sql
SELECT
    ch.Province,
    ch.City,
    COUNT(DISTINCT ch.Loyalty_Number) AS total_enrollments
FROM
    Customer_Loyalty_History ch
JOIN
    Customer_Flight_Activity cf
ON
    ch.Loyalty_Number = cf.Loyalty_Number
WHERE
    ch.Enrollment_Year = 2018 -- Focus on the campaign year (2018)
    AND ch.Enrollment_Month BETWEEN 2 AND 4 -- Focus on the campaign months (Feb - Apr)
GROUP BY
    ch.Province, ch.City
ORDER BY
    total_enrollments DESC;
```
###  **9. How did the CLV of customers who joined during the campaign compare to those who joined earlier? What are the average CLVs for customers from different provinces or cities?** 
- **🔍Query**: Groups customers by province, city, and enrollment period (during vs. before the campaign), then calculates the average Customer Lifetime Value (CLV) for each group.
- **🎯Purpose**: Compares the CLV of customers who joined during the campaign to those who joined earlier and identifies geographic regions with the highest average CLV to guide targeted marketing strategies.

```sql
SELECT
    ch.Province,
    ch.City,
    CASE 
        WHEN ch.Enrollment_Year = 2018 AND ch.Enrollment_Month BETWEEN 2 AND 4 THEN 'During Campaign'
        ELSE 'Before Campaign'
    END AS enrollment_period,
    ROUND(AVG(ch.CLV),0) AS average_clv
FROM
    Customer_Loyalty_History ch
WHERE
    ch.CLV IS NOT NULL -- Ensure CLV values are present
GROUP BY
    ch.Province, ch.City, enrollment_period
ORDER BY
    enrollment_period DESC, average_clv DESC;
```

###  **10. How did the total flight distance change after the campaign compared to before?**  
- **🔍Query** Segments customer flight activity into pre-campaign and post-campaign periods, then calculates the total distance traveled in each period. It also determines the change in total distance between these periods.  
- **🎯Purpose**: Measures the long-term impact of the campaign by comparing flight distances before and after its completion. This helps assess whether the campaign led to sustained behavioral changes, filtering out short-term promotional spikes during the campaign period.  

```sql
SELECT
    ROUND(SUM(CASE
                WHEN cf.Year < 2018 OR (cf.Year = 2018 AND cf.Month < 2) THEN cf.Distance
                ELSE 0
              END), 0) AS Pre_Campaign_Total_Distance,
    ROUND(SUM(CASE
                WHEN cf.Year > 2018 OR (cf.Year = 2018 AND cf.Month >= 2) THEN cf.Distance
                ELSE 0
              END), 0) AS Post_Campaign_Total_Distance,
    ROUND(SUM(CASE
                WHEN cf.Year > 2018 OR (cf.Year = 2018 AND cf.Month >= 2) THEN cf.Distance
                ELSE 0
              END) - 
    SUM(CASE
                WHEN cf.Year < 2018 OR (cf.Year = 2018 AND cf.Month < 2) THEN cf.Distance
                ELSE 0
              END), 0) AS Campaign_Growth
FROM
    Customer_Flight_Activity cf
JOIN
    Customer_Loyalty_History ch
ON
    cf.Loyalty_Number = ch.Loyalty_Number;
```
## 📊 Conclusion

From this analysis, we will draw meaningful conclusions about the effectiveness of the promotional campaign. Specifically, we aim to identify whether the campaign led to an increase in loyalty program enrollments, if certain demographic groups were more responsive to the campaign, and whether it had a significant effect on customer flight activity. Additionally, we will examine how the promotion influenced customer lifetime value (CLV) and identify geographic regions that showed higher enrollment rates.

## 🎯 Target Audience

This analysis is aimed at:

- **Marketing Teams**: To understand the effectiveness of promotional campaigns in terms of enrollment rates and customer engagement.
- **Airline Management**: To assess how promotional efforts are impacting customer loyalty and overall flight bookings.

## 📌Additional Notes
- The analysis was conducted using [PostgreSQL](https://www.postgresql.org/), a powerful relational database management system, which provided the necessary tools for querying and analyzing the dataset.
- The source of the dataset is from [Maven Analytics](https://mavenanalytics.io/). Special thanks to Maven Analytics for providing this valuable resource for data analysis and insight generation.