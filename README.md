# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/Nitish-Das12/netflix_project_sql/blob/main/netflix%20logo.jpg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.


## Objectives

- Analyse Total Content Available
- Identify Variety in Genre and Content Type
- Explore All Unique Genre Combinations
- Count Specific Genre Groupings
- Perform Exploratory View of All Data

## Schema

```PostgreSQL

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
```

## Business Problems and Solutions


### 1 Count the Number of Movies vs TV Shows

```PostgreSQL
SELECT 
    type,
    COUNT(*) AS Total_count
FROM netflix
GROUP BY 1;

```
### 2. Find the Most Common Rating for Movies and TV Shows

```PostgreSQL
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

```
### 3. List All Movies Released in a Specific Year (e.g., 2020)

```PostgreSQL
SELECT  type,
       release_year,
	   title
FROM netflix
WHERE release_year = 2020
      AND  
	  type = 'Movie';


```   
### 4. Find the Top 5 Countries with the Most Content on Netflix    

```PostgreSQL
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

```
### 5. Identify the Longest Movie

```PostgreSQL
select *
FROM netflix
WHERE 
     type = 'Movie'
	 AND
	 duration = (SELECT MAX(duration)
	             FROM netflix);


```
 ### 6. Find Content Added in the Last 5 Years

```PostgreSQL
SELECT *
FROM netflix
WHERE 
    TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';  

```
### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```PostgreSQL
SELECT type ,
       title,
       director
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

---------------------------------------------------------------

SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```

### 8. List All TV Shows with More Than 5 Seasons

```PostgreSQL
SELECT type,
       title,
       SPLIT_PART(duration, ' ', 1) AS the_seasons
FROM netflix
WHERE type = 'TV Show'
      AND 
      SPLIT_PART(duration, ' ', 1):: NUMERIC > 5;

```      
### 9. Count the Number of Content Items in Each Genre

```PostgreSQL
SELECT 
     UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS Genre,
     COUNT(show_id) AS totla_content
FROM netflix
GROUP BY 1;

```
### 10.Find each year and the average numbers of content release in India on netflix. 

```PostgreSQL
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

```
### 11. List All Movies that are Documentaries

```PostgreSQL
SELECT type,
       listed_in,
	   title
FROM netflix
WHERE listed_in LIKE '%Documentaries%'
AND
type = 'Movie';

```
### 12. Find All Content Without a Director

```PostgreSQL
SELECT * 
FROM netflix
WHERE director IS NULL;

```
### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```PostgreSQL
SELECT * 
FROM netflix
WHERE 
    casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
```

 ### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```PostgreSQL
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;	
```

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```PostgreSQL
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
```

## 📌 Conclusion

This project demonstrates how powerful **SQL** can be when used to analyze large datasets like the Netflix catalog. Using **PostgreSQL**, we explored and queried the dataset to extract valuable insights about Netflix’s global content offerings.

### 🔍 Key Insights:

* 📊 **Total Content Volume**: Thousands of titles analyzed, including both **Movies** and **TV Shows**.
* 🎬 **Content Types**: **Movies** dominate the platform, but **TV Shows** have shown significant year-over-year growth.
* 🎭 **Genre Diversity**: Over **400+ unique genre combinations** were discovered. Popular genres include *Dramas*, *Comedies*, *Action & Adventure*, and *International Shows*.
* 🌍 **Geographical Focus**: Countries like **India**, **USA**, and **UK** contribute significantly to the platform's catalog.
* 📅 **Time Trend Analysis**: Using the `date_added` column, we visualized year-wise content addition trends, especially around events like the 2020 global lockdown.
* 🔬 **Genre Frequency Analysis**: With the use of `UNNEST` and `STRING_TO_ARRAY`, we broke down genre combinations into individual genres to measure popularity more precisely.

---

## 🚀 Final Thoughts

* This project shows how **SQL can serve as a complete data analysis tool**, capable of generating insights without the need for advanced software.
* **PostgreSQL's built-in functions** (`TO_DATE`, `EXTRACT`, `UNNEST`) enabled us to handle date parsing, genre extraction, and grouping efficiently.
* The structure of the queries can be reused for other datasets with similar structures.

### 📈 Potential Extensions

* 📊 Build interactive visualizations using **Power BI**, **Tableau**, or **Python (Pandas/Seaborn)**.
* 🎯 Create dashboards for tracking Netflix content trends.
* 🤖 Integrate with **IMDB or TMDB API** to analyze ratings, runtimes, or directors.
* 🧠 Develop a **recommendation system** based on genre similarity and popularity.

---











