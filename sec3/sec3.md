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

## Self Join

* A self-join is a regular join that joins a table to itself. In practice, you typically use a self-join to query hierarchical data or to compare rows within the same table.
* Query Syntax,
    ```sql
        SELECT select_list FROM table_name t1
            INNER JOIN table_name t2 ON join_predicate;
    ```
    * In this syntax, the `table_name` is joined to itself using the `INNER JOIN` clause.
    * Also, you can use the `LEFT JOIN` or `RIGHT JOIN` clause to join table to itself like this:
    ```sql  
        SELECT select_list FROM table_name t1
            LEFT JOIN table_name t2 ON join_predicate;
    ```
* For example,
    * Querying hierarchical data example
        ```sql
            CREATE TABLE employee (
                employee_id INT PRIMARY KEY,
                first_name VARCHAR (255) NOT NULL,
                last_name VARCHAR (255) NOT NULL,
                manager_id INT,
                FOREIGN KEY (manager_id) 
                REFERENCES employee (employee_id) 
                ON DELETE CASCADE
            );

            INSERT INTO employee (employee_id, first_name, last_name, manager_id)
            VALUES
                (1, 'Windy', 'Hays', NULL),
                (2, 'Ava', 'Christensen', 1),
                (3, 'Hassan', 'Conner', 1),
                (4, 'Anna', 'Reeves', 2),
                (5, 'Sau', 'Norman', 2),
                (6, 'Kelsie', 'Hays', 3),
                (7, 'Tory', 'Goff', 3),
                (8, 'Salley', 'Lester', 3);

            SELECT * FROM Employee;
        ```
        * The following query uses the self-join to find who reports to whom
        ```sql
            SELECT
                e.first_name || ' ' || e.last_name employee,
                m.first_name || ' ' || m.last_name manager
            FROM
                employee e
            INNER JOIN employee m ON m.employee_id = e.manager_id
            ORDER BY manager;
        ```
        * Notice that the top manager does not appear on the output
        * To include the top manager in the result set, you use the `LEFT JOIN` instead of `INNER JOIN` clause as shown in the following query:
        ```sql
            SELECT 
                e.first_name || ' ' || e.last_name employee,
                m.first_name || ' ' || m.last_name manager
            FROM
                employee e
            LEFT JOIN employee m ON m.employee_id = e.manager_id
            ORDER BY manager;
        ```
    * Comparing the rows with the same table
        ```sql
            SELECT
                f1.title, f2.title, f1.length
            FROM
                film f1
            INNER JOIN film f2
                ON f1.film_id <> f2.film_id AND f1.length = f2.length;
        ```

## Full Outer Join

* Query Syntax,
    ```sql
        SELECT * FROM A
        FULL [OUTER] JOIN B ON A.id = B.id
    ```
    * In this syntax, the `OUTER` keyword is optional.
    * The full outer join combines the results of both left join and right join.
    * If the rows in the joined table do not match, the full outer join sets NULL values for every column of the table that does not have the matching row.
    * If a row from one table matches a row in another table, the result row will contain columns populated from columns of rows from both tables.
* For Example,
    * First, create two new tables for the demonstration: `employees` and `departments`:
    ```sql
        DROP TABLE IF EXISTS departments;
        DROP TABLE IF EXISTS employees;

        CREATE TABLE departments (
            department_id serial PRIMARY KEY,
            department_name VARCHAR(255) NOT NULL
        );

        CREATE TABLE employees (
            employee_id serial PRIMARY KEY,
            employee_name VARCHAR(255),
            department_id INTEGER
        );

        INSERT INTO departments (department_name)
        VALUES
            ('Sales'),
            ('Marketing'),
            ('HR'),
            ('IT'),
            ('Production');
        
        INSERT INTO employees (
            employee_name,
            department_id
        ) VALUES
            ('Bette Nicholson', 1),
            ('Christian Gable', 1),
            ('Joe Swank', 2),
            ('Fred Costner', 3),
            ('Sandra Kilmer', 4),
            ('Julia Mcqueen', NULL);
    ```
    ```sql
        SELECT employee_name, department_name
            FROM employees e
        FULL OUTER JOIN departments d
            ON d.department_id = e.department_id;
    ```
    * The result set includes every employee who belongs to a department and every department which have an employee. In addition, it includes every employee who does not belong to a department and every department that does not have an employee.
    * To find the department that does not have any employees, you use a `WHERE` clause as follows:
    ```sql
        SELECT employee_name, department_name
            FROM employees e
        FULL OUTER JOIN departments d
            ON d.department_id = e.department_id
        WHERE employee_name IS NULL;
    ```
    * The result shows that the Production department does not have any employees.
    * To find the employee who does not belong to any department, you check for the `NULL` of the `department_name` in the `WHERE` clause as the following statement:
    ```sql
        SELECT employee_name, department_name
            FROM employees e
        FULL OUTER JOIN departments d
            ON d.department_id = e.department_id
        WHERE department_name IS NULL;
    ```

## Cross Join

* A `Cross Join` clause allows you to produce a cartesian product of rows in two or more tables.
* Different from other join clauses such as `LEFT JOIN`  or `INNER JOIN`, the `CROSS JOIN` clause does not have a join predicate.
* Query Syntax,
    ```sql
        SELECT select_list FROM T1 CROSS JOIN T2;
    ```
    * The following statement is equivalent to the above statement:
    ```sql
        SELECT select_list FROM T1, T2;
    ```
    * Also, you can use an `INNER JOI`N clause with a condition that always evaluates to `true` to simulate the cross join:
    ```sql
        SELECT select_list FROM T1 INNER JOIN T2 ON true;
    ```
* For example,
    ```sql
        DROP TABLE IF EXISTS T1;
        CREATE TABLE T1 (label CHAR(1) PRIMARY KEY);

        DROP TABLE IF EXISTS T2;
        CREATE TABLE T2 (score INT PRIMARy KEY);

        INSERT INTO T1(label) VALUES ('A'), ('B');

        INSERT INTO T2(score) VALUES (1), (2), (3);
    ```
    * The following statement uses the `CROSS JOIN` operator to join the table T1 with the table T2
    ```sql
        SELECT * FROM T1 CROSS JOIN T2;
    ```

## Natural Join

* A natural join is a join that creates an implicit join based on the same column names in the joined tables.
* A natural join can be an inner join, left join, or right join.
* If you do not specify a join explicitly e.g., `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, PostgreSQL will use the `INNER JOIN` by default.
* If you use the asterisk (*) in the select list, the result will contain the following columns:
    * All the common columns, which are the columns from both tables that have the same name.
    * Every column from both tables, which is not a common column.
* Query Syntax,
    ```sql
        SELECT select_list FROM T1 NATURAL [INNER, LEFT, RIGHT] JOIN T2;
    ```
* For Example,
    ```sql
        DROP TABLE IF EXISTS categories;
        CREATE TABLE categories (
            category_id serial PRIMARY KEY,
            category_name VARCHAR (255) NOT NULL
        );

        DROP TABLE IF EXISTS products;
        CREATE TABLE products (
            product_id serial PRIMARY KEY,
            product_name VARCHAR (255) NOT NULL,
            category_id INT NOT NULL,
            FOREIGN KEY (category_id) REFERENCES categories (category_id)
        );
    ```
    * Each category has zero or many products and each product belongs to one and only one category.
    * The `category_id` column in the `products` table is the foreign key that references to the primary key of the `categories` table. The `category_id` is the common column that we will use to perform the natural join.
    ```sql
        INSERT INTO categories (category_name)
        VALUES
            ('Smart Phone'),
            ('Laptop'),
            ('Tablet');

        INSERT INTO products (product_name, category_id)
        VALUES
            ('iPhone', 1),
            ('Samsung Galaxy', 1),
            ('HP Elite', 2),
            ('Lenovo Thinkpad', 2),
            ('iPad', 3),
            ('Kindle Fire', 3);
    ```
    * The following statement uses the `NATURAL JOIN` clause to join the `products` table with the `categories` table:
    ```sql
        SELECT * FROM products NATURAL JOIN categories;
    ```
    * The above statement is equivalent to the following statement that uses the `INNER JOIN` clause.
    ```sql
        SELECT	* FROM products
            INNER JOIN categories USING (category_id);
    ```
    * The convenience of the `NATURAL JOIN` is that it does not require you to specify the join clause because it uses an implicit join clause based on the common column.
    * However, you should avoid using the NATURAL JOIN whenever possible because sometimes it may cause an unexpected result.
    * For example, See the following city and country tables from the sample database:
    ```sql
        City
            - city_id
            - city
            - country_id
            - last_update
        
        Country
            - country_id
            - country
            - last_update
    ```
    * Both tables have the same `country_id` column so you can use the `NATURAL JOIN` to join these tables as follows:
    ```sql
        SELECT * FROM city NATURAL JOIN country;
    ```
    * The query returns an empty result set.
    * The reason is that both tables also have another common column called `last_update`, which cannot be used for the join. However, the `NATURAL JOIN` clause just uses the `last_update` column.