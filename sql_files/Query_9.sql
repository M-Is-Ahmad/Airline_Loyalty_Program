-- How did the CLV of customers who joined during the campaign compare to those who joined earlier?
SELECT
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
    enrollment_period;
-- What are the average CLVs for customers from different provinces or cities?
SELECT
    ch.Province,
    ch.City,
    ROUND(AVG(ch.CLV),0) AS average_clv
FROM
    Customer_Loyalty_History ch
WHERE
    ch.CLV IS NOT NULL -- Ensure CLV values are present
GROUP BY
    ch.Province, ch.City
ORDER BY
    average_clv DESC;

-- Conmbine the both previous 2 queries 

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
