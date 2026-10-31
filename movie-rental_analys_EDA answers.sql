create schema movie_rental_analytics;

SET search_path TO movie_rental_analytics;

-- EDA questions
-- 1.What are the purchasing patterns of new customers versus repeat customers?

-- Repeat customers: who rented the most
SELECT customer_id, COUNT(*) AS rentals FROM rental GROUP BY customer_id ORDER BY rentals DESC ;

-- New customers: first rental in June 2005 or later
SELECT customer_id, MIN(rental_date) AS first_rental FROM rental GROUP BY customer_id HAVING MIN(rental_date) >= '2005-06-01';

-- 2.Which films have the highest rental rates and are most in demand?
SELECT f.title, f.rental_rate, COUNT(*) AS times_rented
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title, f.rental_rate
ORDER BY times_rented DESC ;

-- 3.Are there correlations between staff performance and customer satisfaction?
SELECT staff_id, COUNT(*) AS rentals FROM rental GROUP BY staff_id;
SELECT staff_id, SUM(amount) AS revenue FROM payment GROUP BY staff_id;

-- 4.Are there seasonal trends in customer behavior across different locations?
SELECT i.store_id, to_char(r.rental_date, 'YYYY-MM') AS month, COUNT(*) AS rentals
FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY i.store_id, month ORDER BY month, i.store_id;

-- 5.Are certain language films more popular among specific customer segments?
SELECT l.name, COUNT(f.film_id) AS films FROM language l LEFT JOIN film f ON f.language_id = l.language_id GROUP BY l.name;

-- 6.How does customer loyalty impact sales revenue over time?
SELECT to_char(payment_date, 'YYYY-MM') AS month, SUM(amount) AS revenue FROM payment GROUP BY month ORDER BY month;
SELECT customer_id, COUNT(*) AS payments, SUM(amount) AS total_spent FROM payment GROUP BY customer_id ORDER BY total_spent DESC LIMIT 5;

SELECT x.tier, count(*) AS customers, sum(x.spent) AS revenue
FROM (SELECT customer_id, sum(amount) AS spent,
        CASE WHEN count(*) >= 30 THEN 'Loyal (30+)' WHEN count(*) >= 25 THEN 'Medium (25-29)' ELSE 'Low (<25)' END AS tier
      FROM payment GROUP BY customer_id) x
GROUP BY x.tier ORDER BY 3 DESC;

-- 7.Are certain film categories more popular in specific locations?
SELECT co.country, c.name AS category, COUNT(*) AS rentals
FROM rental r
JOIN customer cu ON r.customer_id = cu.customer_id
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE co.country IN ('India', 'China')
GROUP BY co.country, c.name ORDER BY co.country, rentals DESC;

-- 8.How does the availability and knowledge of staff affect customer ratings?
SELECT staff_id, EXTRACT(HOUR FROM rental_date) AS hour, COUNT(*) AS rentals FROM rental GROUP BY staff_id, hour ORDER BY rentals DESC ;

-- 9.How does the proximity of stores to customers impact rental frequency?
SELECT cu.store_id, COUNT(DISTINCT cu.customer_id) AS customers, COUNT(*) AS rentals
FROM rental r JOIN customer cu ON r.customer_id = cu.customer_id
GROUP BY cu.store_id;

-- 10.Do specific film categories attract different age groups of customers?
SELECT f.rating, COUNT(*) AS rentals
FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film f ON i.film_id = f.film_id
GROUP BY f.rating ORDER BY rentals DESC;

-- 11.What are the demographics and preferences of the highest-spending customers?
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM payment p JOIN customer c ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- 12.How does the availability of inventory impact customer satisfaction and repeat business?
SELECT i.film_id, COUNT(DISTINCT i.inventory_id) AS copies, COUNT(r.rental_id) AS rentals
FROM inventory i LEFT JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY i.film_id ORDER BY copies DESC;

SELECT COUNT(*) AS films_with_no_copy FROM film WHERE film_id NOT IN (SELECT film_id FROM inventory);

-- 13.What are the busiest hours or days for each store location, and how does it impact staffing requirements?
SELECT i.store_id, to_char(r.rental_date, 'Day') AS day, COUNT(*) AS rentals
FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY i.store_id, day ORDER BY i.store_id, rentals DESC;

SELECT EXTRACT(HOUR FROM rental_date) AS hour, COUNT(*) AS rentals FROM rental GROUP BY hour ORDER BY rentals DESC;

-- 14.What are the cultural or demographic factors that influence customer preferences in different locations?
SELECT co.country, COUNT(*) AS customers
FROM customer cu
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY co.country ORDER BY customers DESC;

-- 15.How does the availability of films in different languages impact customer satisfaction and rental frequency?
SELECT l.name, COUNT(f.film_id) AS films FROM language l LEFT JOIN film f ON f.language_id = l.language_id GROUP BY l.name;
