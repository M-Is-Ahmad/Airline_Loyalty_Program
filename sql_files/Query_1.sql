-- What was the net new member count during the Feb-Apr 2018 promotion?
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

