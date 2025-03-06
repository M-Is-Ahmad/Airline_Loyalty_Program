-- Create the database
CREATE DATABASE customer_loyalty_db;

/*
DROP TABLE Customer_Loyalty_History CASCADE;
DROP TABLE Customer_Flight_Activity CASCADE;
*/

SELECT current_database();
-- Table 1: Customer_Loyalty_History
CREATE TABLE Customer_Loyalty_History (
    Loyalty_Number VARCHAR(50) PRIMARY KEY,
    Country VARCHAR(100),
    Province VARCHAR(100),
    City VARCHAR(100),
    Postal_Code VARCHAR(20),
    Gender VARCHAR(10),
    Education VARCHAR(50),
    Salary DECIMAL(15,2),
    Marital_Status VARCHAR(10),
    Loyalty_Card VARCHAR(10),
    CLV DECIMAL(15,2),
    Enrollment_Type VARCHAR(20),
    Enrollment_Year INT,
    Enrollment_Month INT,
    Cancellation_Year INT,
    Cancellation_Month INT
);

-- Table 2: Customer_Flight_Activity
CREATE TABLE Customer_Flight_Activity (
    Loyalty_Number VARCHAR(50),
    Year INT,
    Month INT,
    Total_Flights INT,
    Distance DECIMAL(10,2),
    Points_Accumulated INT,
    Points_Redeemed INT,
    Dollar_Cost_Points_Redeemed DECIMAL(10,2),
    FOREIGN KEY (Loyalty_Number) REFERENCES Customer_Loyalty_History (Loyalty_Number)
);

ALTER TABLE Customer_Flight_Activity
DROP CONSTRAINT customer_flight_activity_pkey;




\copy Customer_Loyalty_History FROM 'C:\Users\Mohammad\Documents\SQL Projects (Github)\Airline_Loyalty_Program\csv files\Customer_Loyalty_History.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
\copy Customer_Flight_Activity FROM 'C:\Users\Mohammad\Documents\SQL Projects (Github)\Airline_Loyalty_Program\csv files\Customer_Flight_Activity.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');


/* ERROR (1) I faced:
{invalid input syntax for type integer: "42187.5"}

The Fix is:
*/
ALTER TABLE Customer_Flight_Activity 
ALTER COLUMN Points_Accumulated TYPE NUMERIC(10,2);





/* ERROR (2): 
ERROR:  duplicate key value violates unique constraint "customer_flight_activity_pkey"
DETAIL:  Key (loyalty_number)=(100590) already exists.
The Fix:
*/
-- Step 1 
SELECT conname, conrelid::regclass AS table_name
FROM pg_constraint
WHERE confrelid = 'customer_flight_activity'::regclass;

--Step 2
ALTER TABLE customer_loyalty_history 
DROP CONSTRAINT customer_loyalty_history_loyalty_number_fkey;
-- Step 3

ALTER TABLE Customer_Flight_Activity 
DROP CONSTRAINT customer_flight_activity_pkey;
-- Step 4

ALTER TABLE Customer_Flight_Activity 
ADD CONSTRAINT customer_flight_activity_pkey PRIMARY KEY (loyalty_number, year, month);

-- Step 5

ALTER TABLE customer_loyalty_history 
ADD CONSTRAINT customer_loyalty_history_fkey FOREIGN KEY (loyalty_number, year, month) 
REFERENCES Customer_Flight_Activity (loyalty_number, year, month);






SELECT COUNT(*) FROM customer_flight_activity
SELECT  COUNT(*) FROM customer_loyalty_history
