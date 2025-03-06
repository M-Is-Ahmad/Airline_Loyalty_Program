-- How does flyer behavior (distance flown) impact loyalty program retention?
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

