# Grouping Data

## GROUP BY
* The `GroupBy` clause divides the rows returned from the `SELECT` statements into groups. For each group, you can apply an aggregate function e.g.,  `SUM()` to calculate the sum of items or `COUNT()` to get the number of items in the groups.
* Query Syntax,
    ```sql
        SELECT column_1, column_2, ..., aggregate_function(column_3)
        FROM table_name
        GROUP BY column_1, column_2, ...;  
    ```
    * First, select the columns that you want to group e.g., `column1` and `column2`, and column that you want to apply an aggregate function (`column3`).
    * Second, list the columns that you want to group in the `GROUP BY` clause.
* The statement clause divides the rows by the values of the columns specified in the `GROUP BY` clause and calculates a value for each group.
* It’s possible to use other clauses of the `SELECT` statement with the `GROUP BY` clause.
* PostgreSQL evaluates the `GROUP BY` clause after the `FROM` and `WHERE` clauses and before the `HAVING`, `SELECT`, `DISTINCT`, `ORDER BY` and `LIMIT` clauses.
    ```
        FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT
    ```
* For example,
    * Using PostgreSQL GROUP BY without an aggregate function example
        * You can use the `GROUP BY` clause without applying an aggregate function. The following query gets data from the payment table and groups the result by customer id.
        ```sql
            SELECT customer_id FROM payment GROUP BY customer_id;
        ```
        * In this case, the `GROUP BY` works like the `DISTINCT` clause that removes duplicate rows from the result set.
    * Using PostgreSQL GROUP BY with SUM() function example
        * The `GROUP BY` clause is useful when it is used in conjunction with an aggregate function.
        * For example, to select the total amount that each customer has been paid, you use the `GROUP BY` clause to divide the rows in the `payment` table into groups grouped by customer id. For each group, you calculate the total amounts using the `SUM()` function.
        * The following query uses the `GROUP BY` clause to get total amount that each customer has been paid:
        ```sql
            SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id;
        ```
        * The `GROUP BY` clause sorts the result set by customer id and adds up the amount that belongs to the same customer. Whenever the `customer_id` changes, it adds the row to the returned result set.
        * The following statement uses the `ORDER BY` clause with `GROUP BY` clause to sort the groups: 
        ```sql
            SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC;
        ```
    * Using PostgreSQL GROUP BY clause with the JOIN clause
        * The following statement uses the `GROUP BY` clause with the `INNER JOIN` clause to get the total amount paid by each customer.
        ```sql
            SELECT first_name || ' ' || last_name full_name, SUM(amount) amount FROM payment
            INNER JOIN customer USING (customer_id)
            GROUP BY full_name
            ORDER BY amount DESC;
        ```
    * Using PostgreSQL GROUP BY with COUNT() function example
        * To find the number of payment transactions that each staff has been processed, you group the rows in the `payment` table by the values in the `staff_id` column and use the `COUNT()` function to get the number of transactions
        ```sql
            SELECT staff_id, COUNT(payment_id) FROM payment GROUP BY staff_id;
        ```
        * The `GROUP BY` clause divides the rows in the payment into groups and groups them by value in the `staff_id` column. For each group, it returns the number of rows by using the `COUNT()` function.
    * Using PostgreSQL `GROUP BY` with multiple columns
        * The following example uses multiple columns in the `GROUP BY` clause:
        ```sql
            SELECT customer_id, staff_id, SUM(amount) FROM payment GROUP BY staff_id, customer_id ORDER BY customer_id;
        ```
    * Using PostgreSQL GROUP BY clause with date column
        * The `payment_date` is a timestamp column. To group payments by dates, you use the `DATE()` function to convert timestamps to dates first and then group payments by the result date:
        ```sql
            SELECT DATE(payment_date) paid_date, SUM(amount) sum
            FROM payment
            GROUP BY DATE(payment_date)
        ```

## HAVING

* The `HAVING` clause specifies a search condition for a group or an aggregate. The `HAVING` clause is often used with the `GROUP BY` clause to filter groups or aggregates based on a specified condition.
* Query Syntax
    ```sql
        SELECT column1, aggregate_function(column2) FROM table_name GROUP BY column1 HAVING condition
    ```
    * In this syntax, the group by clause returns rows grouped by the `column1`. The `HAVING` clause specifies a condition to filter the groups.
    * It’s possible to add other clauses of the `SELECT` statement such as `JOIN`, `LIMIT`, `FETCH` etc.
    * PostgreSQL evaluates the `HAVING` clause after the `FROM`, `WHERE`, `GROUP BY`, and before the `SELECT`, `DISTINCT`, `ORDER BY` and `LIMIT` clauses.
    ```
        FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT
    ```
    * Since the `HAVING` clause is evaluated before the `SELECT` clause, you cannot use column aliases in the `HAVING` clause. Because at the time of evaluating the `HAVING` clause, the column aliases specified in the `SELECT` clause are not available.
* HAVING vs WHERE
    * The `WHERE` clause allows you to filter rows based on a specified condition. However, the `HAVING` clause allows you to filter groups of rows according to a specified condition.
    * In other words, the `WHERE` clause is applied to rows while the `HAVING` clause is applied to groups of rows.
* For example,
    * Using PostgreSQL HAVING clause with SUM function example
        ```sql
            SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id;
        ```
        * The following statement adds the `HAVING` clause to select the only customers who have been spending more than 200:
        ```sql
            SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id HAVING SUM(amount) > 200; 
        ```
    * PostgreSQL HAVING clause with COUNT example
        * The following query uses the GROUP BY clause to find the number of customers per store:
        ```sql
            SELECT store_id, COUNT(customer_id) FROM customer GROUP BY store_id;
        ```
        * The following statement adds the `HAVING` clause to select the store that has more than 300 customers:
        ```sql
            SELECT store_id, COUNT(customer_id) FROM customer GROUP BY store_id HAVING COUNT(customer_id) > 300;
        ```