# Joining Multiple Tables

## Joins
* PostgreSQL join is used to combine columns from one (self-join) or more tables based on the values of the common columns between related tables.
* The common columns are typically the primary key columns of the first table and foreign key columns of the second table.
* PostgreSQL supports `inner join`, `left join`, `right join`, `full outer join`, `cross join`, `natural join`, and a special kind of join called `self-join`.
* For example, `INNER JOIN`
    ```sql
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
    ```
    * The `inner join` examines each row in the first table (`basket_a`). It compares the value in the `fruit_a` column with the value in the `fruit_b` column of each row in the second table (`basket_b`). If these values are equal, the inner join creates a new row that contains columns from both tables and adds this new row the result set.
* For example, `LEFT JOIN`
    ```sql
        SELECT a, fruit_a, b, fruit_b FROM basket_a LEFT JOIN basket_b ON fruit_a = fruit_b;
    ```
    * The `left join` starts selecting data from the left table. It compares values in the `fruit_a` column with the values in the `fruit_b` column in the `basket_b` table.
    * If these values are equal, the `left join` creates a new row that contains columns of both tables and adds this new row to the result set. (see the row `#1` and `#2` in the result set).
    * In case the values do not equal, the `left join` also creates a new row that contains columns from both tables and adds it to the result set. However, it fills the columns of the right table (`basket_b`) with null. (see the row #3 and #4 in the result set).
    ```sql
        SELECT a, fruit_a, b, fruit_b FROM basket_a LEFT JOIN basket_b ON fruit_a = fruit_b WHERE b IS NULL 
    ```
* For Example, `RIGHT JOIN`
    ```sql
        SELECT a, fruit_a, b, fruit_b FROM basket_a RIGHT JOIN basket_b ON fruit_a = fruit_b;
    ```
    * The `right join` is a reversed version of the left join. The right join starts selecting data from the right table. It compares each value in the `fruit_b` column of every row in the right table with each value in the `fruit_a` column of every row in the `basket_a` table.
    * If these values are equal, the right join creates a new row that contains columns from both tables.
    * In case these values are not equal, the right join also creates a new row that contains columns from both tables. However, it fills the columns in the left table with `NULL`.
    ```sql
        SELECT a, fruit_a, b, fruit_b FROM basket_a RIGHT JOIN basket_b ON fruit_a = fruit_b WHERE a IS NULL;
    ```
* For Example, `FULL OUTER JOIN`
    * The `full outer join` or `full join` returns a result set that contains all rows from both left and right tables, with the matching rows from both sides if available. In case there is no match, the columns of the table will be filled with `NULL`.
    ```sql
        SELECT a, fruit_a, b, fruit_b FROM basket_a FULL OUTER JOIN basket_b ON fruit_a = fruit_b;
    ```
    ```sql
        SELECT a, fruit_a, b, fruit_b FROM basket_a FULL OUTER JOIN basket_b ON fruit_a = fruit_b WHERE a IS NULL OR b IS NULL;
    ```
## Table Aliases
* Table aliases temporarily assign tables new names during the execution of a query.
* Query Syntax :
    ```sql
        table_name AS alias_name;
    ```
    * In this syntax, the `table_name` is assigned an alias as `alias_name`. Similar to column aliases, the `AS` keyword is optional. It means that you omit the `AS` keyword like this:
    ```sql
        table_name AS alias_name;
    ```
* Applications for table aliases :
    1. Using table aliases for the long table name to make queries more readable
        * If you must qualify a column name with a long table name, you can use a table alias to save some typing and make your query more readable.
        * For example, instead of using the following expression in a query:
            ```sql
                a_very_long_table_name.column_name
            ```
            * we can assign the table `a_very_long_table_name` an alias like this:
            ```sql
                a_very_long_table_name AS alias
            ```
            * And reference the `column_name` in the table `a_very_long_table_name` using the table alias:
            ```sql
                alias.column_name
            ```
    2. Using table aliases in join clauses
        ```sql
            SELECT c.customer_id, first_name, amount, payment_date FROM customer c
                INNER JOIN payment p 
                    ON p.customer_id = c.customer_id
                ORDER BY 
                    payment_date DESC;
        ```
    3. Using table aliases in self-join
        ```sql
            SELECT
                e.first_name employee,
                m .first_name manager
            FROM
                employee e
            INNER JOIN employee m 
                ON m.employee_id = e.manager_id
            ORDER BY manager;
        ```
## INNER JOIN
* Consider,
    ```sql
        SELECT
            pka,
            c1,
            pkb,
            c2
        FROM
            A
        INNER JOIN B ON pka = fka;
    ```
    *  To join table `A` with the table `B`, you follow these steps :
        * First, specify columns from both tables that you want to select data in the `SELECT` clause.
        * Second, specify the main table i.e. table `A` in the `FROM` clause.
        * Third, speicfy the second table(table `B`) in the `INNER JOIN` clause and provide a join condition after the `ON` keyword.
    * How the `INNER JOIN` works.
        * For each row in the table `A`, inner join compares the value in the `pka` column with the value in the `fka` column of every row in the table `B` :
            - If these values are equal, the inner join creates a new row that contains all columns of both tables and add it to the result set.
            - In case these values are not equal, the inner join ignores them and moves to the next row.
* For example,
    ```sql
        SELECT customer.customer_id, first_name, last_name, amount, payment_date FROM customer
            INNER JOIN payment
                ON payment.customer_id = customer.customer_id
            ORDER BY
                payment_date;
    ```
    * The following query returns the same result. However, it uses table aliases :
    ```sql
        SELECT c.customer_id, first_name, last_name, amount, payment_date FROM customer c
            INNER JOIN payment p
                ON p.customer_id = c.customer_id
            ORDER BY
                payment_date;
    ```
    * Since both tables have the same customer_id column, you can use the `USING` syntax:
    ```sql
        SELECT c.customer_id, first_name, last_name, amount, payment_date FROM customer c
            INNER JOIN payment p USING(customer_id)
            ORDER BY
                payment_date;
    ```
    * Using PostgreSQL `INNER JOIN` to join three tables :
    ```sql
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
    ```

## LEFT JOIN

* Consider,
    * Each row in the table `A` may have zero or many corresponding rows in the table `B` while each row in the table `B` has one and only one corresponding row in the table `A`.
    * To select data from the table `A` that may or may not have corresponding rows in the table `B`, you use the `LEFT JOIN` clause.
    ```sql
        SELECT
            pka,
            c1,
            pkb,
            c2
        FROM
            A
        LEFT JOIN B ON pka = fka;
    ```
    * To join the table A with the table B table using a left join, you follow these steps:
        * First, specify the columns in both tables from which you want to select data in the `SELECT` clause.
        * Second, specify the left table (table `A`) in the `FROM` clause.
        * Third, specify the right table (table `B`) in the `LEFT JOIN` clause and the join condition after the `ON` keyword.
* For example,
    ```sql 
        SELECT film.film_id, title, inventory_id
            FROM film
        LEFT JOIN inventory
            ON inventory.film_id = film.film_id
        ORDER BY title;
    ```
    * When a row from the `film` table does not have a matching row in the `inventory` table, the value of the `inventory_id` column of this row is `NULL`.
    ```sql
        SELECT film.film_id, title, inventory_id
            FROM film
        LEFT JOIN inventory
            ON inventory.film_id = film.film_id
        WHERE inventory.film_id IS NULL
        ORDER BY title;
    ```
    * The following statement returns the same result. The difference is that it uses the table aliases to make the query more concise:
    ```sql
        SELECT f.film_id, title, inventory_id
            FROM film f
        LEFT JOIN inventory i
            ON i.film_id = f.film_id
        WHERE i.film_id IS NULL
        ORDER BY title;
    ```
    * If both tables have the same column name used in the `ON` clause, you can use the `USING` syntax like this:
    ```sql
        SELECT f.film_id, title, inventory_id
            FROM film f
        LEFT JOIN inventory i USING (film_id)
        WHERE i.film_id IS NULL
        ORDER BY title;
    ```
* This technique is useful when you want to select rows from one table that do not have matching rows in another table.

## Right Join

* Consider,
    ```sql
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
    ```
    * A film can have zero or many reviews and a review belongs to zero or one film. The `film_id` column in the `films` references the `film_id` column in the `film_reviews` table.
    * The following statement uses the `RIGHT JOIN` to select data from the films and film_reviews tables:
    ```sql
        SELECT review, title FROM films
            RIGHT JOIN film_reviews 
                ON film_reviews.film_id = films.film_id;
    ```
    * Because the joined column has the same name (film_id), you can use the USING syntax in the join predicate like this:
    ```sql
        SELECT review, title FROM films
            RIGHT JOIN film_reviews USING (film_id)
    ```
    * To find the rows from the right table that does not have any corresponding rows in the left table, you add a `WHERE` clause like this:
    ```sql
        SELECT review, title FROM films
            RIGHT JOIN film_reviews using (film_id)
            WHERE title IS NULL;
    ```