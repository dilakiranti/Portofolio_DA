--1. Identify the top 10 customers and their email so we can reward them
SELECT CONCAT (first_name,' ', last_name) AS full_name, SUM (amount) AS total_payment, email
FROM customer c
INNER JOIN payment p ON p.customer_id=c.customer_id
GROUP BY full_name, email
ORDER BY total_payment DESC
LIMIT 10

--2. Identify the bottom 10 customers and their emails
SELECT CONCAT (first_name,' ', last_name) AS full_name, SUM (amount) AS total_payment, email
FROM customer c
INNER JOIN payment p ON p.customer_id=c.customer_id
GROUP BY full_name, email
ORDER BY total_payment ASC
LIMIT 10


--3. What are the most profitable movie genres (ratings)? 
SELECT category.name AS Genre,SUM(payment.amount) AS total_payment, COUNT(customer.customer_id) AS total_demanded 
FROM category
INNER JOIN film_category ON category.category_id=film_category.category_id
INNER JOIN film ON film_category.film_id=film.film_id
INNER JOIN inventory ON film_category.film_id=inventory.film_id
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
INNER JOIN customer ON rental.customer_id=customer.customer_id
INNER JOIN payment ON rental.rental_id=payment.rental_id
GROUP BY Genre
ORDER BY total_payment DESC
LIMIT 1

--4. How many rented movies were returned late, early, and on time?
WITH tempo AS (
	SELECT *, date_part ('day', return_date - rental_date) AS date_difference
	FROM rental)
,
tempo2 AS (
	SELECT rental_duration, date_difference,
	CASE
		WHEN rental_duration > date_difference THEN 'returned early'
		WHEN rental_duration = date_difference THEN 'returned on time'
		ELSE 'returned late'
	END AS status_of_return
	FROM film f
	INNER JOIN inventory i ON f.film_id = i.film_id 
	INNER JOIN tempo t ON i.inventory_id = t.inventory_id)

SELECT status_of_return, COUNT(*) AS total_of_rental
FROM tempo2
GROUP BY status_of_return
ORDER BY total_of_rental DESC;

--5. What is the customer base in the countries where we have a presence?
SELECT country, COUNT(customer_id) AS total_customer
FROM country 
INNER JOIN city ON country.country_id=city.country_id
INNER JOIN address ON city.city_id=address.city_id
INNER JOIN customer ON address.address_id=customer.address_id
GROUP BY country
ORDER BY total_customer DESC

--6. Which country is the most profitable for the business?
SELECT country, SUM(amount) AS total_payment
FROM country
INNER JOIN city ON country.country_id=city.country_id
INNER JOIN address ON city.city_id=address.city_id
INNER JOIN customer ON address.address_id=customer.address_id
INNER JOIN payment ON customer.customer_id=payment.customer_id
GROUP BY country
ORDER BY total_payment DESC
LIMIT 1

--7. What is the average rental rate per movie genre (rating)?
SELECT category.name AS Genre, AVG(rental_rate)
FROM category
INNER JOIN film_category ON category.category_id=film_category.category_id
INNER JOIN film ON film_category.film_id=film.film_id
GROUP BY Genre
ORDER BY AVG(rental_rate) DESC



