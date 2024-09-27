--To show all data
select * from healthcare_data

--Add unique column to table
ALTER TABLE healthcare_data
ADD id INT NOT NULL IDENTITY(1,1) PRIMARY KEY;

--Count Patients by Admission Type
select admission_type, count(*) No_of_patients from healthcare_data
group by admission_type

--Top 5 Hospitals by Total Billing
select top 5 hospital, sum(Billing_Amount) total_amount from healthcare_data
group by hospital
order by total_amount desc

--Patients Admitted for a Specific Condition in the Last Year
select name, age, medical_condition, date_of_admission, doctor from healthcare_data
where medical_condition = 'Cancer' and date_of_admission >= DATEADD(YEAR, -1, GETDATE());

--Calculate the Average Age of Patients by Gender
select gender, avg(age) Avg_age from healthcare_data
group by gender

--Find high paying patient
select Name, Age, Doctor,Hospital, Insurance_provider, Medical_condition, Billing_amount from healthcare_data
where  Billing_Amount >  50000
order by Billing_Amount desc

--Patients Discharged with Specific Medications
select name, age, medication,  discharge_date from healthcare_data
where medication = 'Aspirin'

--Count of Patients Grouped by Blood Type
select blood_type, count(*) from healthcare_data
group by blood_type
order by blood_type

--Longest Hospital Stay by Patient
select name, age, Medical_condition, datediff(day, date_of_admission, discharge_date) Days_stayed
from healthcare_data
order by Days_stayed desc

-- Insurance Provider Billing Summary
select insurance_provider,count(*) Total_patients, sum(billing_amount) Total_amount
from healthcare_data
group by insurance_provider

---Create CTE and store abnoraml patient in that cte and retrive Name
WITH Abnormal_patients AS (
    SELECT name, age, test_results
    FROM healthcare_data
    WHERE test_results = 'abnormal'
)
SELECT name, age, 
FROM Abnormal_patients;

--Total and average billing amount with insurance provider for each hospital for past 6 months
SELECT 
    Hospital,
	    Insurance_Provider,
    SUM(Billing_Amount) AS TotalBilling,
    AVG(Billing_Amount) AS AvgBilling,
    COUNT(*) AS PatientsByInsurance
FROM healthcare_data
WHERE Date_Of_Admission >= DATEADD(MONTH, -6, GETDATE())
GROUP BY Hospital, Insurance_Provider
ORDER BY TotalBilling DESC;

--Patient Care Efficiency and Discharge Analysis
SELECT 
    Name,
    Doctor,
    DATEDIFF(DAY, Date_Of_Admission, Discharge_Date) AS TotalStayDays,
    Medication,
    Discharge_Date,
    CASE 
        WHEN DATEDIFF(DAY, Date_Of_Admission, Discharge_Date) > 15 THEN 'Long Stay'
        ELSE 'Normal Stay'
    END AS StayType
FROM healthcare_data
WHERE Discharge_Date >= DATEADD(YEAR, -1, GETDATE()) -- Last year
ORDER BY TotalStayDays DESC;