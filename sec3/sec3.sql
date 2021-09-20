CREATE TABLE basket_a (a INT PRIMARY KEY, fruit_a VARCHAR (100) NOT NULL);

CREATE TABLE basket_b (b INT PRIMARY KEY, fruit_b VARCHAR (100) NOT NULL);

INSERT INTO basket_a (a, fruit_a) VALUES
	(1, 'Apple'),
	(2, 'Orange'),
	(3, 'Banana'),
	(4, 'Cucumber');
        
INSERT INTO basket_b (b, fruit_b) VALUES
	(1, 'Orange'),
	(2, 'Apple'),
	(3, 'Watermelon'),
	(4, 'Pear');
	
SELECT * FROM basket_a;
SELECT * FROM basket_b;

SELECT a, fruit_a, b, fruit_b FROM basket_a 
	INNER JOIN basket_b
		ON fruit_a = fruit_b;

SELECT a, fruit_a, b, fruit_b FROM basket_a 
	LEFT JOIN basket_b 
		ON fruit_a = fruit_b;
		
SELECT a, fruit_a, b, fruit_b FROM basket_a 
	LEFT JOIN basket_b 
		ON fruit_a = fruit_b 
			WHERE b IS NULL;
			
SELECT a, fruit_a, b, fruit_b FROM basket_a 
	LEFT OUTER JOIN basket_b 
		ON fruit_a = fruit_b;

SELECT a, fruit_a, b, fruit_b FROM basket_a 
	RIGHT JOIN basket_b 
		ON fruit_a = fruit_b;

SELECT a, fruit_a, b, fruit_b FROM basket_a 
	RIGHT JOIN basket_b 
		ON fruit_a = fruit_b 
			WHERE a IS NULL;

SELECT a, fruit_a, b, fruit_b FROM basket_a 
	FULL OUTER JOIN basket_b 
		ON fruit_a = fruit_b;

SELECT a, fruit_a, b, fruit_b FROM basket_a 
	FULL OUTER JOIN basket_b 
		ON fruit_a = fruit_b 
			WHERE a IS NULL OR b IS NULL;

SELECT customer.customer_id, first_name, last_name, amount, payment_date FROM customer
        INNER JOIN payment
            ON payment.customer_id = customer.customer_id
        ORDER BY
            payment_date;

SELECT c.customer_id, first_name, last_name, amount, payment_date FROM customer c
        INNER JOIN payment p
            ON p.customer_id = c.customer_id
        ORDER BY
            payment_date;
			
SELECT c.customer_id, first_name, last_name, amount, payment_date FROM customer c
        INNER JOIN payment p USING(customer_id)
        ORDER BY
            payment_date;

SELECT 
	c.customer_id, 
	c.first_name customer_first_name,
	c.last_name customer_last_name,
	s.first_name staff_first_name,
	s.last_name staff_last_name,
	amount,
	payment_date
FROM customer c
INNER JOIN payment p
	ON p.customer_id = c.customer_id
INNER JOIN staff s
	ON p.staff_id = s.staff_id
ORDER BY payment_date;


SELECT film.film_id, title, inventory_id
	FROM film
LEFT JOIN inventory
	ON inventory.film_id = film.film_id
ORDER BY title;

SELECT film.film_id, title, inventory_id
	FROM film
LEFT JOIN inventory
	ON inventory.film_id = film.film_id
WHERE inventory.film_id IS NULL
ORDER BY title;

SELECT f.film_id, title, inventory_id
	FROM film f
LEFT JOIN inventory i
	ON i.film_id = f.film_id
WHERE i.film_id IS NULL
ORDER BY title;

SELECT f.film_id, title, inventory_id
	FROM film f
LEFT JOIN inventory i USING (film_id)
WHERE i.film_id IS NULL
ORDER BY title;

DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS film_reviews;

CREATE TABLE films(
   film_id SERIAL PRIMARY KEY,
   title varchar(255) NOT NULL
);

INSERT INTO films(title)
VALUES('Joker'),
      ('Avengers: Endgame'),
      ('Parasite');

CREATE TABLE film_reviews(
   review_id SERIAL PRIMARY KEY,
   film_id INT,
   review VARCHAR(255) NOT NULL	
);

INSERT INTO film_reviews(film_id, review)
VALUES(1, 'Excellent'),
      (1, 'Awesome'),
      (2, 'Cool'),
      (NULL, 'Beautiful');
	
SELECT * FROM films;
SELECT * FROM film_reviews;

SELECT review, title FROM films
	RIGHT JOIN film_reviews 
   		ON film_reviews.film_id = films.film_id;

SELECT review, title FROM films
	RIGHT JOIN film_reviews USING (film_id)
			
SELECT review, title FROM films
	RIGHT JOIN film_reviews using (film_id)
	WHERE title IS NULL;