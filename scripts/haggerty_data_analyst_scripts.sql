-- The dataset for this exercise has been derived from the `Indeed Data Scientist/Analyst/Engineer` [dataset](https://www.kaggle.com/elroyggj/indeed-dataset-data-scientistanalystengineer) on kaggle.com. 

-- Before beginning to answer questions, take some time to review the data dictionary and familiarize yourself with the data that is contained in each column.

-- #### Provide the SQL queries and answers for the following questions/tasks using the data_analyst_jobs table you have created in PostgreSQL:

--1.	How many rows are in the data_analyst_jobs table?

SELECT COUNT (*)
FROM data_analyst_jobs;

--Answer: 1793

--2.	Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?

SELECT *
FROM data_analyst_jobs
LIMIT 10;

--Answer: ExxonMobil

--3.	How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?

Select COUNT (location)
FROM data_analyst_jobs
WHERE location='TN';

SELECT COUNT (location)
FROM data_analyst_jobs
WHERE location='KY';

SELECT COUNT (location)
FROM data_analyst_jobs
WHERE location='TN' 
OR location='KY';
--Answer: Tennessee Locations=21 / Kentucky Locations=6 / Tennessee OR Kentucky=27

--4.	How many postings in Tennessee have a star rating above 4?

SELECT COUNT (star_rating)
FROM data_analyst_jobs
WHERE location='TN'
AND star_rating>4;

--Answer: 3

--5.	How many postings in the dataset have a review count between 500 and 1000?

SELECT COUNT (review_count)
FROM data_analyst_jobs
WHERE review_count BETWEEN '500' AND '1000';

--Answer: 151

--6.	Show the average star rating for companies in each state. The output should show the state as `state` and the average rating for the state as `avg_rating`. Which state shows the highest average rating?

SELECT location AS state, 
	AVG(star_rating) AS avg_rating
FROM data_analyst_jobs
WHERE location IS NOT NULL 
AND star_rating IS NOT NULL
GROUP BY location
ORDER BY avg_rating DESC;

--ANSWER: NE (Nebraska)

--7.	Select unique job titles from the data_analyst_jobs table. How many are there?

SELECT DISTINCT(title)
FROM data_analyst_jobs;

--Answer: 881
--Answer Shows Job Titles w/ 881 Rows

SELECT COUNT(DISTINCT title)
FROM data_analyst_jobs;

--Answer: 881
--Answer Shows as Numeric Count Only

-- 8.	How many unique job titles are there for California companies?

SELECT location AS state, 
	COUNT(DISTINCT title) AS job_titles
FROM data_analyst_jobs
WHERE location='CA'
GROUP BY location;

--ANSWER: 230

-- 9.	Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. How many companies are there with more that 5000 reviews across all locations?

SELECT DISTINCT company, 
	location, 
	review_count, 
	star_rating
FROM data_analyst_jobs
WHERE review_count>5000
ORDER BY company ASC;
--Thinking my way thru the problem...

SELECT DISTINCT company, 
	AVG(star_rating) AS avg_star_rating, 
	SUM(review_count)AS sum_review_count
FROM data_analyst_jobs
WHERE review_count>5000
GROUP BY company;

--ANSWER: 41 Companies w/ >5000 Reviews Across All Locations. 

-- 10.	Add the code to order the query in #9 from highest to lowest average star rating. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating?

SELECT DISTINCT company, 
	AVG(star_rating) AS avg_star_rating, 
	SUM(review_count)AS sum_review_count
FROM data_analyst_jobs
	WHERE review_count>5000
	GROUP BY company
	ORDER BY avg_star_rating DESC, 
	sum_review_count DESC;
	
--ANSWER: 6X Companies had an Average Star Rating of 4.199999809 (Kaiser Permanente, Microsoft, American Express, Nike, General Motors, and Unilever), of the 6X Companies: Kaiser Permanente had the Highest Sum for Review Count with 122460 Reviews. 

-- 11.	Find all the job titles that contain the word ‘Analyst’. How many different job titles are there? 

SELECT DISTINCT title
FROM data_analyst_jobs
WHERE title LIKE '%Analyst%'
ORDER BY title ASC;

--754 Different Job Titles Containing 'Analyst'
--See Below....Search for 'Analyst' does not take Case Sensitivity into Account

SELECT DISTINCT title
FROM data_analyst_jobs
WHERE title LIKE '%ANALYST%'
OR title LIKE '%analyst%'
ORDER BY title ASC;

--Utilizing 'ANALYST' or 'analyst' Returns an Additional 20 Records

SELECT DISTINCT title
FROM data_analyst_jobs
WHERE title LIKE '%Analyst%'
OR title LIKE '%ANALYST%'
OR title LIKE '%analyst%'
ORDER BY title ASC;

--ANSWER: 774 Different Job Titles Containing 'Analyst', 'ANALYST', or 'analyst'.


-- 12.	How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common?

SELECT title
FROM data_analyst_jobs
WHERE title NOT LIKE '%Analyst%'
	AND title NOT LIKE '%ANALYST%'
	AND title NOT LIKE '%analyst%'
	AND title NOT LIKE '%Analytics%'
	AND title NOT LIKE '%ANALYTICS%'
	AND title NOT LIKE '%analytics%'
ORDER BY title ASC;

--ANSWER: 4X different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’. Each of the 4 titles contains the 'Tableau'.

--Using OR vs AND for the Above Statement Returns all 1793 Rows and Negates the NOT LIKE Filter...I Need a Better Understanding of WHY????



-- **BONUS:**
-- You want to understand which jobs requiring SQL are hard to fill. Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks. 
--  - Disregard any postings where the domain is NULL. 
--  - Order your results so that the domain with the greatest number of `hard to fill` jobs is at the top. 
--   - Which three industries are in the top 4 on this list? How many jobs have been listed for more than 3 weeks for each of the top 4?