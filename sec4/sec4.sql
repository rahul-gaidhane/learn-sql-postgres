SELECT customer_id FROM payment GROUP BY customer_id;

SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id;

SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC;

SELECT first_name || ' ' || last_name full_name, SUM(amount) amount FROM payment
INNER JOIN customer USING (customer_id)
GROUP BY full_name
ORDER BY amount DESC;

SELECT staff_id, COUNT(payment_id) FROM payment GROUP BY staff_id;

SELECT customer_id, staff_id, SUM(amount) FROM payment GROUP BY staff_id, customer_id 
ORDER BY customer_id;

SELECT DATE(payment_date) paid_date, SUM(amount) sum FROM payment GROUP BY DATE(payment_date);

SELECT customer_id, SUM(amount) as amount FROM payment GROUP BY customer_id ORDER BY amount DESC;

SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id HAVING SUM(amount) > 200;

SELECT store_id, COUNT(customer_id) FROM customer GROUP BY store_id;

SELECT store_id, COUNT(customer_id) FROM customer GROUP BY store_id HAVING COUNT(customer_id) > 300;
