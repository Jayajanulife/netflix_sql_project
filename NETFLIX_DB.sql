--Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
 show_id VARCHAR(6),	
 type	VARCHAR(10),
 title	VARCHAR(300),
 director	VARCHAR(300),
 country	VARCHAR(100),
 date_added	VARCHAR(50),
 release_year	INT,
 rating	VARCHAR(10),
 duration	VARCHAR(15),
 listed_in VARCHAR(100)
);



SELECT * FROM netflix;


SELECT 
  COUNT(*) as total_content
FROM netflix;


SELECT
    DISTINCT type
FROM netflix;

SELECT * FROM netflix;

-- 15 Business Problems

--1. Count the numbetr of Movies vs TV Shows

SELECT
 type,
 COUNT(*) as total_content
FROM netflix
GROUP By type

--2. Find the most common rating for movies and Tv shows
SELECT
 type,
 rating
 FROM
(
SELECT 
  type,
  rating,
  COUNT(*),
 --rating,
  RANK() OVER(PARTITION By type ORDER BY COUNT(*)DESC)as ranking
FROM netflix
GROUP BY 1,2
--ORDER BY 1, 3 DESC
) as t1
WHERE
   ranking=1
--3. List all Movies released in a specific year(e.g.,2020)

--filter 2020
--moVIES

SELECT * FROM netflix
WHERE
 type='Movie'
 AND
 release_year=2020


 --4.Find the top 5 countries with the most content on Netflix


SELECT 
   UNNEST(STRING_TO_ARRAY(country,','))as new_country,
   COUNT(show_id)as total_content
FROM netflix 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


--5. Identify the longest movie?

SELECT * FROM netflix
WHERE
  TYPE ='Movie'
  AND
  duration=(SELECT MAX(duration) FROM netflix)


--6.Find content added in the last 5 years

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'MM/DD/YYYY') >= CURRENT_DATE - INTERVAL '5 years';
  SELECT CURRENT_DATE - INTERVAL '5 years'
  
SELECT * FROM netflix

--7. Find all the Movies/TV shows by director 'Rajiv Chilaka' 

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

8.List all TV shows with more than 5 seasons

SELECT 
  *
FROM netflix
WHERE
     type = 'TV Show'
	 AND
  SPLIT_PART(duration,' ',1):: numeric>5

9.Count thenumber of content itemS IN each genre

SELECT
   unnest (STRING_TO_ARRAY(listed_in, ','))as genre,
   count(show_id)as total_content
FROM netflix  
group by 1

--10.Find each year and average numbers of contents releades by India on Netflix .
--Return top 5 with highest avg content release!

SELECT
     EXTRACT (YEAR FROM TO_DATE(date_added,'MM/DD/YYYY')) as YEAR,
	COUNT(*)AS yearly_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country='India')::numeric* 100
	,2)as avg_content_per_year
	FROM netflix
WHERE country='India'
GROUP BY 1

--11.List all the movies that are documentries

select * from netflix
where 
    listed_in ilike '%documentaries%'

--12. Find all the content without director
select * from netflix
where
   director= 'Not Given'

13. Find how many movies actor'Salmankhan' appeared in last 10 years!

select * from netflix

14. Find the top 10 movies


SELECT title, duration
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(split_part(duration, ' ', 1) AS INTEGER) DESC
LIMIT 10;

SELECT title, release_year, duration
FROM netflix
WHERE type = 'TV Show'
ORDER BY release_year DESC, CAST(split_part(duration, ' ', 1) AS INTEGER) DESC
LIMIT 10;
