

-- Now we are cleaning our data 
--Let's start by identifying and  removing the duplicates 

WITH Sheet1$CTE as(

Select *,
ROW_NUMBER() OVER (PARTITION BY [Start Station ID]
                                      ,[Start Station Name]
	                                  ,[End Station ID]
                                      ,[End Station Name]
									   ,[Bike ID]
									   ,[Birth Year] 
									   ORDER BY [Start Station ID]
									   ) AS rowNumber
FROM [PortfolioProject].[dbo].[Sheet1$]
)
 DELETE
FROM Sheet1$CTE
WHERE rowNumber > 1


--Now let's display our new table with no duplicates 
SELECT*
FROM [PortfolioProject].[dbo].[Sheet1$]

-- Now we're going to calculate th	e MEAN, Mnimum and Maximum of Trip duration and Age

select  AVG([Trip_Duration_in_min]) As averageTripDuration, AVG(Age) as averageAge
FROM [PortfolioProject].[dbo].[Sheet1$]

--Minimum

select  MIN([Trip_Duration_in_min]) As minimuTripDuration, MIN(Age) as MinimumAge
FROM [PortfolioProject].[dbo].[Sheet1$]

--MAXIMUM
select  MAX([Trip_Duration_in_min]) As MaximumTripDuration, Max(Age) as MaximumAge
FROM [PortfolioProject].[dbo].[Sheet1$]

--Now our maximum values are unrealistic, therefore we have to do more data cleaning to remove the outlieres 
--Identifying the outlier
SELECT [Trip_Duration_in_min],[Age] 
FROM [PortfolioProject].[dbo].[Sheet1$]
ORDER BY [Trip_Duration_in_min],[Age] 

--Deleting the outlier
SELECT  [Trip_Duration_in_min],[Age] 

FROM [PortfolioProject].[dbo].[Sheet1$]
WHERE [Trip_Duration_in_min] = 6515
 
DELETE [PortfolioProject].[dbo].[Sheet1$]
WHERE [Trip_Duration_in_min] = 6515

--Now we are creating a displaying the top 20 pickup locations

WITH Sheet1$CTE AS (
SELECT [Start Station Name], COUNT([Start Station Name]) AS TotalStation

FROM [PortfolioProject].[dbo].[Sheet1$]
GROUP BY [Start Station Name]

)
SELECT top 20([Start Station Name]),TotalStation
FROM Sheet1$CTE
Order by TotalStation DESC

 --nNow we are checking how Trip duration varies across different age groups

 SELECT [Age Groups],AVG(CONVERT(INT,[Trip_Duration_in_min])) as AverageDuration_in_min
FROM  [PortfolioProject].[dbo].[Sheet1$]
Group by [Age Groups]

--Now we want to check which age group rent the most bikes 


 SELECT [Age Groups],count(*) as TotalRentalCount
FROM  [PortfolioProject].[dbo].[Sheet1$]
Group by [Age Groups]
Order by TotalRentalCount DESC

--Now we want to check how Bike Rentals varry across two different user groups( one_time_user and Subscriber) on different days of the weel.


 CREATE TABLE #Temp_Subscribers 
 (Weekdays varchar(50),
 Subscribers int 
 )

 INSERT INTO #Temp_Subscribers 
 
 SELECT [Weekday],count([User Type]) as Subscribers

FROM  [PortfolioProject].[dbo].[Sheet1$] OneT
WHERE [User Type] = 'Subscriber'
Group by [Weekday]

CREATE TABLE #Temp_OneTimeUser 
 (Weekdays varchar(50),
 One_Time_User int 
 )

 INSERT INTO #Temp_OneTimeUser 
 
 SELECT [Weekday],count([User Type]) as OneTimeUser

FROM  [PortfolioProject].[dbo].[Sheet1$] OneT
WHERE [User Type] = 'One-time user'
Group by [Weekday]

SELECT  Ones.Weekdays,Ones.One_Time_User,Subs.Subscribers
FROM #Temp_OneTimeUser Ones
JOIN #Temp_Subscribers Subs
 ON Ones.Weekdays = Subs.Weekdays
 ORDER BY Weekdays
