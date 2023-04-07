CREATE DATABASE IMDb;


USE IMDb;


ALTER DATABASE IMDb CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;



CREATE TABLE Titles (
  title_id 			  VARCHAR(255) NOT NULL, 
  title_type 			VARCHAR(50),
  primary_title 	TEXT,
  original_title 	TEXT,
  is_adult 			  BOOLEAN,
  start_year			INTEGER,
  end_year 			  INTEGER, 
  runtime_minutes	INTEGER

);

CREATE TABLE Title_ratings (
  title_id 			  VARCHAR(255) NOT NULL,
  average_rating	FLOAT,
  num_votes			  INTEGER
);

CREATE TABLE Aliases (
  title_id          VARCHAR(255) NOT NULL, 
  ordering          INTEGER NOT NULL, 
  title             TEXT NOT NULL,
  region				    CHAR(4),
  language          CHAR(4),
  is_original_title	BOOLEAN
);

CREATE TABLE Alias_types (
  title_id      VARCHAR(255) NOT NULL,
  ordering			INTEGER NOT NULL,
  type				  VARCHAR(255) NOT NULL
);

CREATE TABLE ALias_attributes (
  title_id			VARCHAR(255) NOT NULL,
  ordering			INTEGER NOT NULL,
  attribute			VARCHAR(255) NOT NULL 
);

CREATE TABLE Episode_belongs_to (
  episode_title_id          VARCHAR(255) NOT NULL,
  parent_tv_show_title_id   VARCHAR(255) NOT NULL,
  season_number             INTEGER,
  episode_number            INTEGER
);

CREATE TABLE Title_genres (
  title_id    VARCHAR(255) NOT NULL,
  genre				VARCHAR(255) NOT NULL
);



CREATE TABLE Names_ (
  name_id       VARCHAR(255) NOT NULL,
  name_         VARCHAR(255) NOT NULL, 
  birth_year    SMALLINT, 
  death_year    SMALLINT 
);

CREATE TABLE Name_worked_as (
  name_id       VARCHAR(255) NOT NULL,
  profession    VARCHAR(255) NOT NULL
);



CREATE TABLE Had_role (
  title_id      VARCHAR(255) NOT NULL,
  name_id       VARCHAR(255) NOT NULL,
  role_         TEXT NOT NULL
);

CREATE TABLE Known_for (
  name_id       VARCHAR(255) NOT NULL,
  title_id      VARCHAR(255) NOT NULL
);

CREATE TABLE Directors (
  title_id      VARCHAR(255) NOT NULL,
  name_id       VARCHAR(255) NOT NULL
);

CREATE TABLE Writers (
  title_id      VARCHAR(255) NOT NULL,
  name_id       VARCHAR(255) NOT NULL
);

CREATE TABLE Principals (
  title_id      VARCHAR(255) NOT NULL,
  ordering      TINYINT NOT NULL,
  name_id       VARCHAR(255) NOT NULL,
  job_category  VARCHAR(255),
  job           TEXT
);