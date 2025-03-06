SELECT
    CASE
        WHEN cf.Year < 2018 OR (cf.Year = 2018 AND cf.Month <2) THEN 'Pre-Campaign Period'
        ELSE 'Post-Campaign Period'
    END AS Period,
    ROUND(SUM(cf.Distance),0) AS total_distance,
FROM
    Customer_Flight_Activity cf
JOIN
    Customer_Loyalty_History ch
ON
    cf.Loyalty_Number = ch.Loyalty_Number
--WHERE 
--    (cf.Year > 2018 OR (cf.Year = 2018 AND cf.Month > 4)) -- Post-campaign period after April 2018
GROUP BY
    period;

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

