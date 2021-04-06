-- Lab | SQL 3.03 SOLUTIONS
-- Instructions
USE sakila;
-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(inventory_id) FROM sakila.inventory
WHERE film_id IN (
	SELECT film_id FROM (
	SELECT title, film_id 
    FROM film
	WHERE title = 'Hunchback Impossible') sub1
) 

SELECT COUNT(film_id) AS tot_H
FROM inventory
WHERE film_id = '439'

-- List all films whose length is longer than the average of all the films.

SELECT * FROM film
WHERE title IN (
SELECT title FROM (
	SELECT avg(length) AS Average, title
	FROM sakila.film
	GROUP BY title
	HAVING film.length > 115.27) sub1
)
#would like to discuss in class how to set the average as the trashold

-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT COUNT(DISTINCT actor_id) FROM sakila.film_actor
WHERE film_id IN (
	SELECT film_id 
    FROM (
		SELECT film_id, title 
		FROM sakila.film
		WHERE title = 'Alone Trip')
    sub1
);

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title AS List_of_Family_Movies FROM film
JOIN film_category
USING (film_id)
JOIN category c
USING (category_id)
WHERE name = 'Family'

-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT * FROM city
WHERE city IN (
	SELECT city 
    FROM (
		SELECT COUNT(city) AS Tot_c
		FROM sakila.city
		) sub1
);


-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT CONCAT(first_name,' ', last_name) AS Most_prolific_Actor_or_Actress, title Movies_played FROM film
JOIN film_actor
USING (film_id)
JOIN actor
USING (actor_id)
WHERE CONCAT(first_name,' ', last_name) =
(SELECT CONCAT(first_name,' ', last_name) AS Actor FROM actor
JOIN film_actor
USING (actor_id)
JOIN film
USING (film_id)
GROUP BY Actor 
ORDER BY COUNT(title) DESC
LIMIT 1);

-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT SUM(amount), customer_id AS Customer, first_name, last_name 
FROM customer
JOIN payment
USING (customer_id)
GROUP BY customer
ORDER BY SUM(amount) DESC
LIMIT 1;

-- Customers who spent more than the average payments.
SELECT avg(amount), customer_id AS Customer, first_name, last_name 
FROM customer
JOIN payment
USING (customer_id)
GROUP BY customer
ORDER BY avg(amount) DESC
