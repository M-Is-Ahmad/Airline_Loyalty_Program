
-- Campaign adoption by salary categories with percentage of total new members
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