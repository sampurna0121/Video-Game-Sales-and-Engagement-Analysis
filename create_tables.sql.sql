CREATE DATABASE videogames_db;

CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    title TEXT,
    release_date DATE,
    team TEXT,
    rating FLOAT,
    times_listed INTEGER,
    number_of_reviews INTEGER,
    genres TEXT,
    summary TEXT,
    reviews TEXT,
    plays INTEGER,
    playing INTEGER,
    backlogs INTEGER,
    wishlist INTEGER
);

CREATE TABLE games_metadata (
    id SERIAL PRIMARY KEY,
    title TEXT,
    release_date DATE,
    team TEXT,
    rating FLOAT,
    times_listed FLOAT,
    number_of_reviews FLOAT,
    genres TEXT,
    summary TEXT,
    reviews TEXT,
    plays FLOAT,
    playing FLOAT,
    backlogs FLOAT,
    wishlist FLOAT,
    release_year INT
);

CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name TEXT UNIQUE
);

CREATE TABLE platforms (
    platform_id SERIAL PRIMARY KEY,
    platform_name TEXT UNIQUE
);

CREATE TABLE publishers (
    publisher_id SERIAL PRIMARY KEY,
    publisher_name TEXT UNIQUE
);

CREATE TABLE vgsales (
    id SERIAL PRIMARY KEY,
    rank INTEGER,
    name TEXT,
    year INTEGER,
    na_sales FLOAT,
    eu_sales FLOAT,
    jp_sales FLOAT,
    other_sales FLOAT,
    global_sales FLOAT,
    genre_id INTEGER REFERENCES genres(genre_id),
    platform_id INTEGER REFERENCES platforms(platform_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id)
);

-- Run these in pgAdmin or use SQLAlchemy
CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name TEXT UNIQUE NOT NULL
);

CREATE TABLE platforms (
    platform_id SERIAL PRIMARY KEY,
    platform_name TEXT UNIQUE NOT NULL
);

CREATE TABLE publishers (
    publisher_id SERIAL PRIMARY KEY,
    publisher_name TEXT UNIQUE NOT NULL
);







-- Genres
INSERT INTO genres (genre_name)
SELECT DISTINCT "Genre" FROM vgsales
ON CONFLICT (genre_name) DO NOTHING;

-- Platforms
INSERT INTO platforms (platform_name)
SELECT DISTINCT "Platform" FROM vgsales
ON CONFLICT (platform_name) DO NOTHING;

-- Publishers
INSERT INTO publishers (publisher_name)
SELECT DISTINCT "Publisher" FROM vgsales
ON CONFLICT (publisher_name) DO NOTHING;

ALTER TABLE vgsales
ADD COLUMN genre_id INT,
ADD COLUMN platform_id INT,
ADD COLUMN publisher_id INT;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'vgsales';


ALTER TABLE vgsales
ADD COLUMN genre_id INT,
ADD COLUMN platform_id INT;

UPDATE vgsales v
SET genre_id = g.genre_id
FROM genres g
WHERE v."Genre" = g.genre_name;

UPDATE vgsales v
SET platform_id = p.platform_id
FROM platforms p
WHERE v."Platform" = p.platform_name;

UPDATE vgsales v
SET publisher_id = pub.publisher_id
FROM publishers pub
WHERE v."Publisher" = pub.publisher_name;


ALTER TABLE vgsales
DROP COLUMN "Genre",
DROP COLUMN "Platform",
DROP COLUMN "Publisher";

SELECT COUNT(*) FROM vgsales WHERE genre_id IS NULL OR platform_id IS NULL OR publisher_id IS NULL;

SELECT v."Name", g.genre_name, p.platform_name, pub.publisher_name, v."Global_Sales"
FROM vgsales v
JOIN genres g ON v.genre_id = g.genre_id
JOIN platforms p ON v.platform_id = p.platform_id
JOIN publishers pub ON v.publisher_id = pub.publisher_id
LIMIT 10;

