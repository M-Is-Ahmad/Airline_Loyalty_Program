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

