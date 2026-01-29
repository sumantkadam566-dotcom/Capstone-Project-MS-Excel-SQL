CREATE DATABASE BankChurn;
USE BankChurn;

SELECT COUNT(*) FROM customerchurnrecords;
SELECT * FROM customerchurnrecords LIMIT 10;

SELECT COUNT(*) AS TotalCustomers
FROM customerchurnrecords;

SELECT 
    CASE 
        WHEN Exited = 0 THEN 'Not Churned' WHEN Exited = 1 THEN 'Churned'END AS ChurnStatus,
COUNT(*) AS CustomerCount
FROM customerchurnrecords
GROUP BY Exited;

SELECT AVG(CreditScore) AS AverageCreditScore
FROM customerchurnrecords;


SELECT 
    Geography,
    COUNT(*) AS CustomerCount
FROM customerchurnrecords
GROUP BY Geography;

SELECT 
    Gender,
    COUNT(*) AS CustomerCount
FROM customerchurnrecords
GROUP BY Gender;


SELECT COUNT(*) AS ZeroBalanceCustomers
FROM customerchurnrecords
WHERE Balance = 0;

SELECT AVG(Balance) AS AvgBalanceChurned
FROM customerchurnrecords
WHERE Exited = 1;


SELECT Geography,
COUNT(*) AS TotalCustomers,
SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent
FROM customerchurnrecords
GROUP BY Geography ORDER BY ChurnRatePercent DESC;


SELECT AVG(Tenure) AS AvgTenure_NotChurned
FROM customerchurnrecords WHERE Exited = 0;


SELECT CustomerId, Surname, EstimatedSalary, Exited
FROM customerchurnrecords
WHERE Exited = 1
ORDER BY EstimatedSalary DESC
LIMIT 5;


SELECT COUNT(*) AS ActiveMembers_MoreThan2Products
FROM customerchurnrecords
WHERE IsActiveMember = 1
AND NumOfProducts > 2;
  
SELECT 
CASE 
WHEN IsActiveMember = 1 THEN 'Active' WHEN IsActiveMember = 0 THEN 'Inactive'
END AS MemberStatus,
AVG(Balance) AS AvgBalance FROM customerchurnrecords GROUP BY IsActiveMember;


SELECT Gender,
AVG(EstimatedSalary) AS AvgEstimatedSalary
FROM customerchurnrecords GROUP BY Gender;

SELECT Tenure,
COUNT(*) AS ChurnedCustomers
FROM customerchurnrecords WHERE Exited = 1 GROUP BY Tenure ORDER BY Tenure;


SELECT  NumOfProducts,
COUNT(*) AS TotalCustomers,
SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent
FROM customerchurnrecords GROUP BY NumOfProducts ORDER BY NumOfProducts;


SELECT 
CASE 
WHEN Age BETWEEN 18 AND 30 THEN '18-30' WHEN Age BETWEEN 31 AND 45 THEN '31-45'
WHEN Age BETWEEN 46 AND 60 THEN '46-60' ELSE '61+' END AS AgeGroup,
COUNT(*) AS TotalCustomers, SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent
FROM customerchurnrecords GROUP BY AgeGroup ORDER BY AgeGroup;

SELECT Geography, Gender,
COUNT(*) AS TotalCustomers,
SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent
FROM customerchurnrecords GROUP BY Geography, Gender ORDER BY ChurnRatePercent DESC;

SELECT Geography,
AVG(CreditScore) AS AvgCreditScore_Churned,
AVG(Balance) AS AvgBalance_Churned
FROM customerchurnrecords WHERE Exited = 1 GROUP BY Geography ORDER BY Geography;

SELECT CustomerId, Surname, Geography, Gender, Age, Balance, CreditScore, NumOfProducts, IsActiveMember,
EstimatedSalary
FROM customerchurnrecords WHERE Exited = 1 ORDER BY Balance DESC LIMIT 10;


SELECT 
ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent_NoCreditCard
FROM customerchurnrecords WHERE HasCrCard = 0;

SELECT  CustomerId, Surname, Geography, Gender, Age, Balance, CreditScore, NumOfProducts, IsActiveMember, 
EstimatedSalary
FROM customerchurnrecords
WHERE Balance > (SELECT AVG(Balance) FROM customerchurnrecords WHERE Exited = 1)
ORDER BY Balance DESC;



WITH Overall AS (SELECT 
ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS OverallChurnRate
FROM customerchurnrecords)
SELECT c.Geography,
COUNT(*) AS TotalCustomers,
SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent,
o.OverallChurnRate,
CASE 
WHEN ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) > o.OverallChurnRate 
THEN 'Above Overall'
ELSE 'Below Overall'
END AS Comparison
FROM customerchurnrecords c
CROSS JOIN Overall o
GROUP BY c.Geography, o.OverallChurnRate
ORDER BY ChurnRatePercent DESC;
