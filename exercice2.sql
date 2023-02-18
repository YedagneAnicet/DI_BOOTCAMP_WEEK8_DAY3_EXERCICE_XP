--Use UPDATE to change the language of some films. Make sure that you use valid languages.UPDATE films
SET language_id = 10
WHERE film_id = 4;
-- Which foreign keys (references) are defined for the customer table? How does this affect the way in which we INSERT into the customer table?
/*
 we have store_id and address_id. We will be obliged to make a join to the different tables whose keys are foreign in the client table which are : Address and payment  */
-- We created a new table called customer_review. Drop this table. Is this an easy step, or does it need extra checking?
DROP TABLE IF EXIST customer_review;
-- It's an easy step to drop this table
-- Find out how many rentals are still outstanding (ie. have not been returned to the store yet).
SELECT COUNT(*) AS num_outstanding_rentals
FROM rental
WHERE return_date IS NULL;
-- Find the 30 most expensive movies which are outstanding (ie. have not been returned to the store yet)
SELECT film.title,
    rental.rental_date,
    rental.return_date,
    film.rental_rate
FROM rental
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON inventory.film_id = film.film_id
WHERE rental.return_date IS NULL
ORDER BY film.rental_rate DESC
LIMIT 30;
-- 6- Your friend is at the store, and decides to rent a movie. He knows he wants to see 4 movies, but he can’t remember their names. Can you help him find which movies he wants to rent? The 1st film : The film is about a sumo wrestler, and one of the actors is Penelope Monroe..
SELECT title
FROM film
WHERE description LIKE '%sumo wrestler%'
    AND (
        actor_id IN (
            SELECT actor_id
            FROM actor
            WHERE first_name = 'Penelope'
                AND last_name = 'Monroe'
        )
        OR film_id IN (
            SELECT film_id
            FROM film_actor
            WHERE actor_id IN (
                    SELECT actor_id
                    FROM actor
                    WHERE first_name = 'Penelope'
                        AND last_name = 'Monroe'
                )
        )
    );
-- The 2nd film : A short documentary (less than 1 hour long), rated “R”.
SELECT title
FROM film
WHERE length < 60
    AND rating = 'R';
--The 3rd film : A film that his friend Matthew Mahan rented. He paid over $4.00 for the rental, and he returned it between the 28th of July and the 1st of August, 2005.
SELECT f.title
FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN customer c ON r.customer_id = c.customer_id
WHERE c.first_name = 'Matthew'
    AND c.last_name = 'Mahan'
    AND r.rental_rate > 4.00
    AND r.return_date BETWEEN '2005-07-28' -- The 4th film : His friend Matthew Mahan watched this film, as well. It had the word “boat” in the title or description, and it looked like it was a very expensive DVD to replace.
SELECT f.title,
    f.rental_rate,
    COUNT(*) AS num_rentals
FROM film AS f
    JOIN inventory AS i ON f.film_id = i.film_id
    JOIN rental AS r ON i.inventory_id = r.inventory_id
    JOIN customer AS c ON r.customer_id = c.customer_id
WHERE c.first_name = 'Matthew'
    AND c.last_name = 'Mahan'
    AND (
        f.title LIKE '%boat%'
        OR f.description LIKE '%boat%'
    )
    AND r.rental_date >= '2005-07-28'
    AND r.rental_date <= '2005-08-01'
    AND r.return_date IS NULL
GROUP BY f.title,
    f.rental_rate
ORDER BY f.rental_rate DESC
LIMIT 1;