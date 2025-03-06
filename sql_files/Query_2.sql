-- Campaign adoption by demographic categories (e.g., gender, education)
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








