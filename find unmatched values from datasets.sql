EXEC sp_databases
USE [compare];

-- Using sp_rename to rename the columns
EXEC sp_rename 'AgentData.[Agent Name]', 'AgentName', 'COLUMN';
EXEC sp_rename 'OTANal.[Agent Name]', 'AgentName', 'COLUMN';


--unmatched IATA and PCC values between table [AgentDataa] and [OTAnal]
	SELECT 
    a.AgentName,
    a.IATA AS AgentData_IATA,
    a.PCC AS AgentData_PCC,
    o.IATA AS OTAnal_IATA,
    o.PCC AS OTAnal_PCC
FROM 
    AgentData a
FULL OUTER JOIN 
    OTAnal o ON a.AgentName = o.AgentName
WHERE 
    a.IATA IS NULL OR o.IATA IS NULL OR a.PCC IS NULL OR o.PCC IS NULL

--filter out all the null values
SELECT 
    AD.AgentName,
    AD.IATA AS AgentData_IATA,
    OA.IATA AS OTAnal_IATA,
    AD.PCC AS AgentData_PCC,
    OA.PCC AS OTAnal_PCC
FROM 
    AgentData AD
JOIN 
    OTAnal OA ON AD.AgentName = OA.AgentName
WHERE 
    (AD.IATA IS NOT NULL AND OA.IATA IS NOT NULL AND AD.IATA != OA.IATA)
    OR 
    (AD.PCC IS NOT NULL AND OA.PCC IS NOT NULL AND AD.PCC != OA.PCC);



--unmatched "IATA" and "PCC" values with similar agent names(same first world) between table [AgentData] & [OTAnal]

WITH SimilarAgentNames AS (
    SELECT
        AD.AgentName AS AgentName_AgentData,
        OA.AgentName AS AgentName_OTAnal
    FROM
        AgentData AD
    JOIN
        OTAnal OA ON LEFT(AD.AgentName, CHARINDEX(' ', AD.AgentName + ' ') - 1) 
		= LEFT(OA.AgentName, CHARINDEX(' ', OA.AgentName + ' ') - 1)
)

SELECT 
    SAN.AgentName_AgentData,
    SAN.AgentName_OTAnal,
    AD.IATA AS AgentData_IATA,
    OA.IATA AS OTAnal_IATA,
    AD.PCC AS AgentData_PCC,
    OA.PCC AS OTAnal_PCC
FROM 
    SimilarAgentNames SAN
JOIN 
    AgentData AD ON SAN.AgentName_AgentData = AD.AgentName
JOIN 
    OTAnal OA ON SAN.AgentName_OTAnal = OA.AgentName
WHERE 
    (AD.IATA IS NOT NULL AND OA.IATA IS NOT NULL AND AD.IATA != OA.IATA)
    OR 
    (AD.PCC IS NOT NULL AND OA.PCC IS NOT NULL AND AD.PCC != OA.PCC);



--unmatched "IATA" and "PCC" values with similar agent names between table [AgentData] & [tourLUC]

WITH SimilarAgentNames AS (
    SELECT
        AD.AgentName AS AgentName_AgentData,
        OA.AgentName AS AgentName_tourLUC
    FROM
        AgentData AD
    JOIN
        tourLUC OA ON LEFT(AD.AgentName, CHARINDEX(' ', AD.AgentName + ' ') - 1) 
		= LEFT(OA.AgentName, CHARINDEX(' ', OA.AgentName + ' ') - 1)
)

SELECT 
    SAN.AgentName_AgentData,
    SAN.AgentName_tourLUC,
    AD.IATA AS AgentData_IATA,
    OA.IATA AS tourLUC_IATA,
    AD.PCC AS AgentData_PCC,
    OA.PCC AS tourLUC_PCC
FROM 
    SimilarAgentNames SAN
JOIN 
    AgentData AD ON SAN.AgentName_AgentData = AD.AgentName
JOIN 
    tourLUC OA ON SAN.AgentName_tourLUC = OA.AgentName
WHERE 
    (AD.IATA IS NOT NULL AND OA.IATA IS NOT NULL AND AD.IATA != OA.IATA)
    OR 
    (AD.PCC IS NOT NULL AND OA.PCC IS NOT NULL AND AD.PCC != OA.PCC);


--unmatched IATA and PCC values without duplicates between table [AgentData] and [tourLUC],
--and fix the issue of Conversion failed when converting the nvarchar value to data type int.

WITH SimilarAgentNames AS (
    SELECT
        AD.AgentName AS AgentName_AgentData,
        OA.AgentName AS AgentName_tourLUC
    FROM
        AgentData AD
    JOIN
        tourLUC OA ON LEFT(AD.AgentName, CHARINDEX(' ', AD.AgentName + ' ') - 1) = LEFT(OA.AgentName, CHARINDEX(' ', OA.AgentName + ' ') - 1)
)

SELECT DISTINCT
    SAN.AgentName_AgentData,
    SAN.AgentName_tourLUC,
    AD.IATA AS AgentData_IATA,
    OA.IATA AS tourLUC_IATA,
    AD.PCC AS AgentData_PCC,
    OA.PCC AS tourLUC_PCC
FROM 
    SimilarAgentNames SAN
JOIN 
    AgentData AD ON SAN.AgentName_AgentData = AD.AgentName
JOIN 
    tourLUC OA ON SAN.AgentName_tourLUC = OA.AgentName
WHERE 
    (
        (AD.IATA IS NOT NULL AND OA.IATA IS NOT NULL AND TRY_CAST(AD.IATA AS NVARCHAR(MAX)) != TRY_CAST(OA.IATA AS NVARCHAR(MAX)))
        OR 
        (AD.PCC IS NOT NULL AND OA.PCC IS NOT NULL AND TRY_CAST(AD.PCC AS NVARCHAR(MAX)) != TRY_CAST(OA.PCC AS NVARCHAR(MAX)))
    );
