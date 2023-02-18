-- Get a list of all film languages.
SELECT name
FROM language;
--Get a list of all films joined with their languages – select the following details : film title, description, and language name. Try your query with different joins:
------Get all films, even if they don’t have languages.
SELECT film.title,
    film.description,
    language.name
FROM film
    LEFT JOIN language ON film.language_id = language.language_id;
------ Get all languages, even if there are no films in those languages.
SELECT film.title,
    film.description,
    language.name
FROM film
    RIGHT JOIN language ON film.language_id = language.language_id;
--Create a new table called new_film with the following columns : id, name. Add some new films to the table.
CREATE TABLE new_film (
    id SERIAL PRIMARY KEY,
,
    name VARCHAR(255) NOT NULL,
);
INSERT INTO new_film (name)
VALUES ('Jack Bauer'),
('DUCOBU') -- 4- Create a new table called customer_review, which will contain film reviews that customers will make:
    -------- review_id – a primary key, non null, auto-increment.
    CREATE TABLE customer_review (
        review_id SERIAL,
        film_id INT,
        language_id INT NOT NULL,
        title VARCHAR(255) NOT NULL,
        score INT NOT NULL,
        review_text TEXT NOT NULL,
        last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY(film_id),
        CONSTRAINT fk_film FOREIGN KEY(film_id) REFERENCES new_film(id) ON DELETE CASCADE,
        UNIQUE (language_id),
        CONSTRAINT fk_language FOREIGN KEY (language_id) REFERENCES language(language_id)
    );
-------- Add 2 movie reviews. Make sure you link them to valid objects in the other tables.
INSERT INTO customer_review (film_id, language_id, title, score, review_text)
VALUES (1, 1, 'BON FILM', 9, 'jaime ce film');
INSERT INTO customer_review (film_id, language_id, title, score, review_text)
VALUES (
        2,
        2,
        'top',
        8,
        'ce film est top mais se bat pas trop dedans haha'
    );