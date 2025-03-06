


/*SELECT
    ch.Cancellation_Year,
    SUM(cf.Points_Accumulated) AS total_points_accumulated,
    SUM(cf.Points_Redeemed) AS total_points_redeemed
FROM
    Customer_Loyalty_History ch
JOIN
    Customer_Flight_Activity cf ON ch.Loyalty_Number = cf.Loyalty_Number
GROUP BY
    ch.Cancellation_Year
HAVING
    ch.Cancellation_Year IS NULL -- Active members, no cancellation
    OR ch.Cancellation_Year >= 2017; 
*/

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