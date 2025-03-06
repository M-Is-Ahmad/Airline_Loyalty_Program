
-- Impact on flights booked during summer (June, July, August 2018) by new members
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
