-- NETFLIX PROJECT
-- basic schema

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix 
(
      show_id VARCHAR(6),
	  type   VARCHAR(10),
	  title   VARCHAR(150),
	  director VARCHAR(208),
	  casts   VARCHAR(1000),
	  country  VARCHAR(150),
	  date_added VARCHAR(50),
	  release_year  INT,
	  rating  VARCHAR(10),
	  duration  VARCHAR(15),
	  listed_in	 VARCHAR(100),
	  description  VARCHAR(250)
);

SELECT * FROM netflix;

-- BASIC ANALYSIS FOR SELF-CLEARENCE

SELECT 
COUNT(*) AS TOTAL_CONTENT
FROM netflix;


SELECT
  (SELECT COUNT(DISTINCT listed_in) FROM netflix) AS types_of_movies,
  (SELECT COUNT(DISTINCT type) FROM netflix) AS type_of_content;

	 
SELECT    
DISTINCT listed_in
FROM netflix;

SELECT COUNT(listed_in)
FROM netflix
WHERE listed_in = 'Dramas, Horror Movies, Sci-Fi & Fantasy';

SELECT COUNT(listed_in)
FROM netflix
WHERE listed_in = 'Action & Adventure, Anime Features, International Movies';

SELECT * FROM netflix;

                                                     
										--  Business Problems and Solutions
													

--Count the Number of Movies vs TV Shows

SELECT 
    type,
    COUNT(*) AS Total_count
FROM netflix
GROUP BY 1;

--Find the Most Common Rating for Movies and TV Shows

SELECT 
     type,
	 rating
FROM
(
   SELECT 
     type,           
	 rating,         
	 COUNT(*),
	 RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking                 
   FROM netflix
   GROUP BY 1,2
   
) AS T1
WHERE
    ranking = 1;

-- List All Movies Released in a Specific Year (e.g., 2020)

SELECT  type,
       release_year,
	   title
FROM netflix
WHERE release_year = 2020
      AND  
	  type = 'Movie';


--Find the Top 5 Countries with the Most Content on Netflix

SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;

-- Identify the Longest Movie

select *
FROM netflix
WHERE 
     type = 'Movie'
	 AND
	 duration = (SELECT MAX(duration)
	             FROM netflix);


--Find Content Added in the Last 5 Years

SELECT *
FROM netflix
WHERE 
    TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';   


--Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT type ,
       title,
       director
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

-----------------------------------------

SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';


-- List All TV Shows with More Than 5 Seasons

SELECT type,
       title,
       SPLIT_PART(duration, ' ', 1) AS the_seasons
FROM netflix
WHERE type = 'TV Show'
      AND 
      SPLIT_PART(duration, ' ', 1):: NUMERIC > 5;

-- Count the Number of Content Items in Each Genre


SELECT 
     UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS Genre,
     COUNT(show_id) AS totla_content
FROM netflix
GROUP BY 1;

--.Find each year and the average numbers of content release in India on netflix.


TOTAL CONTENT (333+10+203+95+189+142) = 927
SELECT COUNT(*) FROM netflix WHERE country = 'India';


SELECT 
     EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD , YYYY')) AS year,
	 COUNT(*),
	 ROUND(
	 COUNT(*)::NUMERIC/(SELECT 
	                     COUNT(*) 
						 FROM netflix 
						 WHERE country = 'India')::NUMERIC * 100)
						 AS  average_content
FROM netflix
WHERE country = 'India'
GROUP BY 1;

--List All Movies that are Documentaries

SELECT type,
       listed_in,
	   title
FROM netflix
WHERE listed_in LIKE '%Documentaries%'
AND
type = 'Movie';

--Find All Content Without a Director

SELECT * 
FROM netflix
WHERE director IS NULL;

--Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * 
FROM netflix
WHERE 
    casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


--Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India


SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;	

--Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords


SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;














