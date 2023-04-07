
-- IMDB PROJECT QUERIES-------

CREATE OR REPLACE VIEW Q1(title_type,Count)
AS SELECT T.title_type, COUNT(*)
FROM Titles AS T
GROUP BY T.title_type
ORDER BY T.title_type ASC;

SELECT * FROM Q1;


CREATE OR REPLACE VIEW Q2(Job, Count)
AS SELECT P.job_category, COUNT(*)
FROM Principals AS P
GROUP BY P.job_category
ORDER BY P.job_category ASC;

SELECT * FROM Q2;

CREATE OR REPLACE VIEW Q3(Genre,Count)
AS SELECT G.genre, COUNT(G.genre) AS Count
FROM Title_genres AS G, Titles AS T
WHERE T.title_id = G.title_id
AND T.title_type = 'movie'
GROUP BY genre
ORDER BY Count DESC;

SELECT * FROM Q3;


CREATE OR REPLACE VIEW  Q4(runtime_minutes, title_type, primary_title) AS
SELECT runtime_minutes, title_type, primary_title
FROM Titles WHERE runtime_minutes > (10*60)
ORDER BY runtime_minutes DESC, title_type ASC;

SELECT * FROM Q4 LIMIT 10;


CREATE OR REPLACE VIEW Q5(Number_of_actors)
AS SELECT COUNT(DISTINCT N.name_id) AS Number_of_actors
FROM Name_worked_as AS N
WHERE N.profession IN ('actor','actress');

SELECT * FROM Q5;


CREATE OR REPLACE VIEW Q6(Number_of_movies)
AS SELECT COUNT(DISTINCT T.title_id) AS Number_of_movies
FROM Titles AS T
WHERE T.title_type IN ('movie','video');

SELECT * FROM Q6;


CREATE OR REPLACE VIEW Q7(Earliest,Latest)
AS SELECT LEAST(MIN(T.start_year), MIN(T.end_year)) AS Earliest,
GREATEST(MAX(T.start_year), MAX(T.end_year)) AS Latest
FROM Titles AS T;

SELECT * FROM Q7;


CREATE OR REPLACE VIEW Q8(Year, Number_of_movies)
AS SELECT T.start_year, COUNT(*) AS  Number_of_movies
FROM Titles AS T
WHERE T.title_type IN ('movie','video')
GROUP BY T.start_year
HAVING T.start_year BETWEEN 1990 AND 2019
ORDER BY T.start_year ASC;

SELECT * FROM Q8;


CREATE OR REPLACE VIEW Q9(name_id,name_,number_of_films)
AS SELECT N.name_id, N.name_, COUNT(*) AS number_of_films
FROM Names_ AS N, Had_role AS H, Titles AS T
WHERE H.role_ LIKE 'James Bond'
AND T.title_type LIKE 'movie'
AND T.title_id = H.title_id
AND N.name_id = H.name_id
GROUP BY N.name_id;

SELECT * FROM Q9;


CREATE OR REPLACE VIEW Q10(number_of_JB_actors)
AS SELECT COUNT(DISTINCT name_id) AS number_of_JB_actors
FROM Q9;

SELECT * FROM Q10;

CREATE OR REPLACE VIEW Q11(name_,title_id,primary_title,start_year)
AS SELECT Q9.name_, T.title_id, T.primary_title, T.start_year
FROM Q9, Titles AS T, Had_role AS H
WHERE Q9.name_id = H.name_id
AND H.role_ LIKE 'James Bond'
AND T.title_id = H.title_id
AND T.title_type LIKE 'movie'
ORDER BY T.start_year DESC;

SELECT * FROM Q11;


CREATE OR REPLACE VIEW Q12(start_year, title_type, primary_title, role_)
AS SELECT DISTINCT T.start_year, T.title_type, T.primary_title, H.role_
FROM Titles AS T, Had_role AS H
WHERE T.title_id = H.title_id
AND H.role_ <> 'Himself'
AND T.title_type IN ('movie','video')
AND H.name_id = (
  SELECT N.name_id
  FROM Names_ AS N
  WHERE N.name_ LIKE 'Don Wilson' AND N.birth_year = 1954)
ORDER BY T.start_year ASC;

SELECT * FROM Q12;


CREATE OR REPLACE VIEW Q13(role_,Count)
AS SELECT Q12.role_, COUNT(*) AS Count
FROM Q12
GROUP BY Q12.role_
HAVING Count >=2;

SELECT * FROM Q13;


CREATE OR REPLACE VIEW Q14(primary_title,role_)
AS SELECT Q12.primary_title, Q12.role_
FROM Q12, Q13
WHERE Q12.role_ = Q13.role_;

SELECT * FROM Q14;

CREATE OR REPLACE VIEW Q15(title_id,primary_title,average_rating)
AS SELECT T.title_id, T.primary_title, R.average_rating
FROM Titles AS T, Title_ratings AS R
WHERE T.title_id = R.title_id
AND T.title_type = 'movie'
AND R.num_votes > 100000
ORDER BY R.average_rating DESC
LIMIT 250;

SELECT * FROM Q15 LIMIT 15;

CREATE OR REPLACE VIEW Q16(name_id,name_,Count)
AS SELECT H.name_id, N.name_, COUNT(*) AS Count
FROM Q15, Titles AS T, Names_ AS N, Had_role AS H
WHERE Q15.title_id = T.title_id
AND T.title_id = H.title_id
AND N.name_id = H.name_id
GROUP BY H.name_id
ORDER BY Count DESC
LIMIT 10;

SELECT * FROM Q16;

CREATE OR REPLACE VIEW Q17(name_,role_)
AS SELECT N.name_, H.role_
FROM Titles AS T, Had_role AS H, Names_ AS N
WHERE T.primary_title LIKE 'Back to the Future'
AND T.title_type LIKE 'movie'
AND T.title_id = H.title_id
AND H.name_id = N.name_id;

SELECT * FROM Q17;

CREATE OR REPLACE VIEW Q18(primary_title,average_rating)
AS SELECT T.primary_title, R.average_rating
FROM Titles AS T, Title_ratings AS R
WHERE T.primary_title REGEXP '^Back to the Future.*'
AND T.title_id = R.title_id
AND T.title_type = 'movie';

SELECT * FROM Q18;


CREATE OR REPLACE VIEW Q19(primary_title,average_rating)
AS SELECT T.primary_title, R.average_rating
FROM Titles AS T, Title_ratings AS R
WHERE T.primary_title REGEXP '^Trancers.*'
AND T.title_id = R.title_id
AND T.title_type IN ('movie','video');

SELECT * FROM Q19;

CREATE OR REPLACE VIEW Q20(start_year,Number_of_horror_movies)
AS SELECT T.start_year, COUNT(DISTINCT T.title_id) AS Number_of_horror_movies
FROM Titles AS T, Title_genres AS G
WHERE T.title_id = G.title_id
AND G.genre = 'Horror'
AND T.title_type IN ('movie','video')
AND (T.start_year % 4) = 0
GROUP BY T.start_year
ORDER BY T.start_year DESC;

SELECT * FROM Q20;


CREATE OR REPLACE VIEW Q21(season_number,episode_number,primary_title)
AS SELECT E.season_number, E.episode_number, T2.primary_title
FROM Titles AS T1, Titles AS T2, Episode_belongs_to AS E
WHERE T1.primary_title = 'Fawlty Towers'
AND T1.title_type = 'tvSeries'
AND T1.title_id = E.parent_tv_show_title_id
AND T2.title_type = 'tvEpisode'
AND T2.title_id = E.episode_title_id
ORDER BY E.season_number, E.episode_number;

SELECT * FROM Q21;


CREATE OR REPLACE VIEW Q22(season_number,episode_number,primary_title,average_rating)
AS SELECT E.season_number, E.episode_number, T2.primary_title, R.average_rating
FROM Titles AS T1, Titles AS T2, Episode_belongs_to AS E, Title_ratings AS R
WHERE T1.primary_title = 'The X-Files'
AND T1.title_type = 'tvSeries'
AND T1.title_id = E.parent_tv_show_title_id
AND T2.title_type = 'tvEpisode'
AND T2.title_id = E.episode_title_id
AND T2.title_id = R.title_id
ORDER BY E.season_number, E.episode_number;

SELECT * FROM Q22;


CREATE OR REPLACE VIEW Q23(season_number,episode_number,primary_title,average_rating)
AS SELECT Q22.season_number, Q22.episode_number, Q22.primary_title, Q22.average_rating
FROM Q22
WHERE Q22.average_rating = (SELECT MAX(Q22.average_rating) FROM Q22);

SELECT * FROM Q23;


CREATE OR REPLACE VIEW Q24(season_number,Number_of_episodes,Average_of_ep_average_ratings)
AS SELECT Q22.season_number, COUNT(*) AS Number_of_episodes, AVG(Q22.average_rating) AS Average_of_ep_average_ratings
FROM Q22
GROUP BY Q22.season_number
ORDER BY Q22.season_number;

SELECT * FROM Q24;
