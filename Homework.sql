-- 1a. Display the first and last names of all actors from the table actor
SELECT first_name, last_name
FROM sakila.actor;

-- 1b. Display the first and last name of each actor in a single colummn in upper case letters
SELECT concat(first_name, ' ', last_name)
FROM sakila.actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you only know the first name, "Joe."
-- What is one query you would use to obtain this information?

SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN
SELECT first_name, last_name
FROM sakila.actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time order the rows by last name, and first name, in that order.

SELECT last_name, first_name
FROM sakila.actor
WHERE last_name LIKE "%LI%";

-- 2d. Using IN, display the country_id and country columns of the following countriesL 
-- Afghanistan, Bangladesh, and China

SELECT country_id, country
FROM sakila.country
WHERE country IN('Afghanistan', 'Bangladesh', 'China');

-- 3a. create a column in the table actor named description and use the data type BLOB 
ALTER TABLE sakila.actor
	ADD description BLOB;
    
-- 3b. Delete description column.

ALTER TABLE sakila.actor
	DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT 
	last_name,
    COUNT(*) AS 'num'
FROM sakila.actor
GROUP BY
	last_name;
-- 4b. List last names of actors and the number of actors who have the last name, but only for names that are shared by at least two actors
SELECT 
	last_name,
    COUNT(*) AS 'num'
FROM sakila.actor

GROUP BY 
	last_name HAVING num > 1;

    

-- 4c. The actor Harpo Williams was accidentially entered into the actor table as GROUCH WILLIAMS
-- Write a query to fix the record.

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

SELECT first_name, last_name
FROM actor
WHERE first_name = 'HARPO';
-- 4d. Perhaps we were too hasty in changing GROUCH to HARPO. It turns out that GROUCH was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCH.as
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

SELECT first_name, last_name
FROM actor
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to create it (see hint)

SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address of each staff members. Use tables STAFF and ADDRESS.

SELECT first_name, last_name, address
FROM sakila.staff a 
	INNER JOIN sakila.address b
		ON a.address_id=b.address_id;
        
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT first_name, last_name, a.staff_id, sum(amount) as total_amount
FROM sakila.payment a
	INNER JOIN sakila.staff b
		ON a.staff_id=b.staff_id
WHERE payment_date LIKE '2005-08%'
GROUP BY a.staff_id;



-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT title, sum(actor_id) as number_of_actors
FROM sakila.film_actor a
	INNER JOIN sakila.film b
		ON a.film_id=b.film_id
GROUP BY a.film_id;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system
-- HELP!
SELECT a.film_id, title, COUNT(inventory_id) as "number_in_inventory" 
FROM sakila.inventory a
	INNER JOIN sakila.film b
		ON a.film_id=b.film_id
GROUP BY inventory_id HAVING title ='HUNCHBACK IMPOSSIBLE';


-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically be last name.as
SELECT last_name, a.customer_id, sum(amount) as "total_amount" 
FROM sakila.payment a
	INNER JOIN sakila.customer b
		ON a.customer_id=b.customer_id
GROUP BY a.customer_id
ORDER BY last_name ASC;
	

-- 7a. Use subqueries to display the titles of movies starting wth the letters K and Q whose language is English.
SELECT title
FROM sakila.film
WHERE title LIKE "K%" OR title like "Q%" AND
language_id IN
	(SELECT language_id
    FROM sakila.language
    WHERE name = "ENGLISH");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id in
	(SELECT actor_id
    FROM sakila.film_actor
    WHERE film_id in
		(SELECT film_id
        FROM sakila.film
		WHERE title = 'Alone Trip')
        );
-- 7c. you will need the names and email addresses of all Canadian customers. Use joins to  retrieve this information.

SELECT first_name, last_name, email
FROM sakila.customer a
	INNER JOIN sakila.address b
		ON a.address_id=b.address_id
			INNER JOIN sakila.city c
				ON b.city_id=c.city_id
					INNER JOIN sakila.country d
						ON c.country_id=d.country_id
WHERE country = "Canada";

-- 7d. Identify all movies categorized as family films.

SELECT title, name
FROM sakila.film a
	INNER JOIN sakila.film_category b
		ON a.film_id=b.film_id
			INNER JOIN sakila.category c
				ON b.category_id=c.category_id
WHERE c.name = "Family";
-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(a.inventory_id) as "times_rented"
FROM sakila.rental a
	INNER JOIN sakila.inventory b
		ON a.inventory_id=b.inventory_id
			INNER JOIN sakila.film c
				ON b.film_id=c.film_id
GROUP BY title
ORDER BY times_rented DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store_id, sum(amount) as "total_revenue"
FROM sakila.store a
	INNER JOIN sakila.payment b
		ON a.manager_staff_id=b.staff_id
GROUP BY store_id;
-- 7g. Write a query to display for each store its store ID, city, and country
SELECT store_id, city, country
FROM sakila.store a
	INNER JOIN sakila.address b
		ON a.address_id=b.address_id
			INNER JOIN sakila.city c
				ON b.city_id=c.city_id
					INNER JOIN sakila.country d
						ON c.country_id=d.country_id;
-- 7h. List the top five genres in gross revenue in descending order. (see hint)
SELECT a.name, sum(amount) AS "gross_revenue"
FROM sakila.category a
	INNER JOIN sakila.film_category b
		ON a.category_id=b.category_ID
			INNER JOIN sakila.inventory c
				ON b.film_id=c.film_id
					INNER JOIN sakila.rental d
						ON c.inventory_id=d.inventory_id
							INNER JOIN sakila.payment e
								ON d.rental_id=e.rental_id
GROUP BY a.name
ORDER BY gross_revenue DESC LIMIT 5;

-- 8a. Create a view of 7h.

CREATE VIEW top_five_genres AS
	SELECT a.name, sum(amount) AS "gross_revenue"
	FROM sakila.category a
	INNER JOIN sakila.film_category b
		ON a.category_id=b.category_ID
			INNER JOIN sakila.inventory c
				ON b.film_id=c.film_id
					INNER JOIN sakila.rental d
						ON c.inventory_id=d.inventory_id
							INNER JOIN sakila.payment e
								ON d.rental_id=e.rental_id
GROUP BY a.name
ORDER BY gross_revenue DESC LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;
-- 8c. You find that you no longer need to view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;
