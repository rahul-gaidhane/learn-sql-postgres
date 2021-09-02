# Section 2 : Filtering Data

## Where
* The `SELECT` statement returns all rows from one or more columns in a table. To select rows that satisfy a specified condition, we use a `WHERE` clause.
* Query Syntax
    ```sql
        SELECT select_list
        FROM table_name
        WHERE condition
        ORDER BY sort_expression
    ```
* The `WHERE` clause appears right after the `FROM` clause of the `SELECT` statement, The `WHERE` clause uses the `condition` to filter the rows returned from the `SELECT` clause.

* The `condition` must evaluate to `true`, `false`, or `unknown`. It can be a boolean expression or a combination of boolean expressions using the `AND` and `OR` operators.

* PostgreSQL evaluates the `WHERE` clause after the `FROM` clause and before the `SELECT` and `ORDER BY` clause:
    ```
        FROM -> WHERE -> SELECT -> ORDER BY
    ```
* If you use column aliases in the `SELECT` clause, you cannot use them in the `WHERE` clause.

* For example,
    ```sql
        SELECT last_name, first_name FROM customer WHERE first_name = 'Jamie';
    ```
    ```sql
        SELECT last_name, first_name FROM customer WHERE first_name = 'Jamie' AND last_name = 'Rice';
    ```
    ```sql
        SELECT first_name, last_name FROM customer WHERE last_name = 'Rodriguez' OR first_name = 'Adam';
    ```
    ```sql
        SELECT first_name, last_name FROM customer WHERE first_name IN ('Ann', 'Anne', 'Annie');
    ```
    ```sql
        SELECT first_name, last_name FROM customer WHERE first_name LIKE 'Ann%';
    ```
    ```sql
        SELECT first_name, LENGTH(first_name) name_length FROM customer 
	        WHERE first_name LIKE 'A%' AND LENGTH(first_name) BETWEEN 3 AND 5 ORDER BY name_length;
    ```
    ```sql
        SELECT first_name, last_name FROM customer WHERE first_name LIKE 'Bra%' AND last_name <> 'Motley';
    ```

## LIMIT Clause

* `LIMIT` is an optional clause of the `SELECT` statement that constrains the number of rows returned by the query.
*  Query Syntax :
    ```sql
        SELECT select_list
        FROM table_name
        ORDER BY sort_expression
        LIMIT row_count
    ```
    * The statment returns the `row_count` generated by the query.
    * If `row_count` is zero, the query returns an empty set.
    * In case, `row_count` is `NULL`, the query returns the same result set as it does not have the `LIMIT` clause.
    * In case you want to skip a number of rows before returning the `row_count` rows, you can use `OFFSET` clause placed after the `LIMIT` clause as the following statement:
    ```sql
        SELECT select_list
        FROM table_name
        LIMIT row_count OFFSET row_to_skip;
    ```
    * The statement first skips `row_to_skip` rows before returning `row_count` rows generated by the query.
    * If `row_to_skip` is zero, the statement will work like it doesn’t have the `OFFSET` clause.
    * Because a table may store rows in an unspecified order, when you use the `LIMIT` clause, you should always use the `ORDER BY` clause to control the row order. If you don’t use the `ORDER BY` clause, you may get a result set with the unspecified order of rows.
* For example,
    ```sql
        SELECT film_id, title, release_year FROM film ORDER BY film_id LIMIT 5;
    ```
    ```sql
        SELECT film_id, title, release_year FROM film ORDER BY film_id LIMIT 4 OFFSET 3;
    ```
    ```sql
        SELECT film_id, title, rental_rate FROM film ORDER BY rental_rate DESC LIMIT 10;
    ```
## Fetch Clause

* To constrain the number of rows returned by a query, you often use the `LIMIT` clause. The `LIMIT` clause is widely used by many relational database management systems such as MySQL, H2, and HSQLDB. However, the `LIMIT` clause is not a SQL-standard.
* To conform with the SQL standard, PostgreSQL supports the `FETCH` clause to retrieve a number of rows returned by a query. Note that the `FETCH` clause was introduced in SQL:2008.
* Query Syntax :
    ```sql
        OFFSET start { ROW | ROWS }
        FETCH {FIRST | NEXT} [row_count] {ROW | ROWS} ONLY
    ```
    * `ROW` is the synonym for `ROWS`, `FIRST` is the synonym for `NEXT`. SO you can use them interchangeably.
    * The start is an integer that must be zero or positive. By default, it is zero if the `OFFSET` clause is not specified. In case the start is greater than the number of rows in the result set, no rows are returned;
    * The `row_count` is 1 or greater. By default, the default value of `row_count` is 1 if you do not specify it explicitly.
* Because the order of rows stored in the table is unspecified, you should always use the `FETCH` clause with the `ORDER BY` clause to make the order of rows in the returned result set consistent.
* Note that the `OFFSET` clause must come before the `FETCH` clause in SQL:2008. However, `OFFSET` and `FETCH` clauses can appear in any order in PostgreSQL
* For example,
    ```sql
        SELECT film_id, title FROM film ORDER BY title FETCH FIRST ROW ONLY;
    ```
    ```sql
        SELECT film_id, title FROM film ORDER BY title FETCH FIRST 5 ROW ONLY;
    ```
    ```sql
        SELECT film_id, title FROM film ORDER BY title OFFSET 5 ROWS FETCH FIRST 5 ROW ONLY;
    ```
## IN operator

* `IN` operator is used in the `WHERE` clause to check if a value matches any value in a list of values.
* Query Syntax :
    ```sql
        value IN (value1, value2, ...)
    ```
    * The `IN` operator returns true if the value matches any value in the list i.e., value1, value2, ...
    * The list of values can be a list of literal values such as numbers, strings or a result of a SELECT statement like below:
        ```sql
            value IN (SELECT column_name FROM table_name);
        ``` 
        * The query inside the parentheses is called a subquery, which is a query nested inside another query.
* For example,
    ```sql
        SELECT customer_id, rental_id, return_date 
        FROM rental 
        WHERE customer_id IN (1, 2) 
        ORDER BY return_date DESC
    ```
    * Query below is equivalent to query above but it is using `OR` and `=` operator.
    ```sql
        SELECT customer_id, rental_id, return_date
        FROM rental
        WHERE customer_id = 1 OR customer_id = 2
        ORDER BY return_date DESC
    ```
    * The query that uses the `IN` operator is shorter and more readable than the query that uses equal (=) and `OR` operators. In addition, PostgreSQL executes the query with the `IN` operator much faster than the same query that uses a list of `OR` operators.
    ```sql
        SELECT customer_id, rental_id, return_date
        FROM rental
        WHERE customer_id NOT IN (1,2);
    ```
    * Query below is equivalent to query above but it is using `AND` and `<>` operator.
    ```sql
        SELECT customer_id, rental_id, return_date
        FROM rental
        WHERE customer_id <> 1 AND customer_id <> 2;
    ```
    ```sql
        SELECT customer_id
        FROM rental
        WHERE CAST (return_date AS DATE) = '2005-05-27'
        ORDER BY customer_id;
    ```
    ```sql
        SELECT customer_id, first_name, last_name
        FROM customer
        WHERE customer_id IN (
                        SELECT customer_id
                        FROM rental
                        WHERE CAST (return_date AS DATE) = '2005-05-27'
                    )
        ORDER BY customer_id;
    ```

## BETWEEN operator

* `BETWEEN` operator is used to match a value against a range of values.
* Query Syntax
    ```sql
        value BETWEEN low and high;
    ```
    * If the `value` is greater than or equal to the `low` value and less than or equal to the `high` value, the expression returns true, otherwise, it returns false.
    * You can rewrite the BETWEEN operator by using the greater than or equal ( >=) or less than or equal ( <=) operators like this:
    ```sql
        value >= low and value <= high
    ```
    * If you want to check if a value is out of a range, you combine the NOT operator with the BETWEEN operator as follows:
    ```sql
        value NOT BETWEEN low AND high;
    ```
    * The following expression is equivalent to the expression that uses the NOT and BETWEEN operators:
    ```sql
        value < low OR value > high
    ```
* For example,
    ```sql
        SELECT customer_id, payment_id, amount
        FROM payment
        WHERE amount BETWEEN 8 AND 9; 
    ```
    ```sql
        SELECT customer_id, payment_id, amount
        FROM payment
        WHERE amount NOT BETWEEN 8 AND 9;
    ```
    ```sql
        SELECT customer_id, payment_id, amount, payment_date
        FROM payment
        WHERE payment_date BETWEEN '2007-02-07' AND '2007-02-15';
    ```

## Like Operator

* `LIKE` operator is used to match a given `pattern` in a given column.
* Query Syntax :
    ```sql
        value LIKE pattern
    ```
    * The expression returns true if the `value` matches the `pattern`.
    * To negate the `LIKE` operator, you use the `NOT` operator as follows:
    ```sql
        value NOT LIKE pattern
    ```
    * The `NOT LIKE` operator returns true when the value does not match the `pattern`.
    * For example,
        ```sql
            SELECT first_name, last_name FROM customer WHERE first_name LIKE 'Jen%';
        ```
        * Notice that the `WHERE` clause contains a special expression: the `first_name`, the `LIKE` operator and a string that contains a percent sign (%). The string 'Jen%' is a `pattern`.
        * The query returns rows whose values in the first_name column begin with Jen and may be followed by any sequence of characters. This technique is called pattern matching.
        * You construct a pattern by combining literal values with wildcard characters and use the `LIKE` or `NOT LIKE` operator to find the matches. PostgreSQL provides you with two wildcards:
            - Percent sign ( %) matches any sequence of zero or more characters.
            - Underscore sign ( _)  matches any single character.
    * If the pattern does not contain any wildcard character, the `LIKE` operator behaves like the equal ( =) operator.
* For Example,
    ```sql 
        SELECT
            'foo' LIKE 'foo',
            'foo' LIKE 'f%',
            'foo' LIKE '_o_',
            'bar' LIKE 'b_';
    ```
    * How it works.
        - The first expression returns true because the foopattern does not contain any wildcard character so the `LIKE` operator acts like the equal (=) operator.
        - The second expression returns true because it matches any string that begins with the letter f and followed by any number of characters.
        - The third expression returns true because the pattern ( _o_) matches any string that begins with any single character, followed by the letter o and ended with any single character.
        - The fourth expression returns false because the pattern  b_ matches any string that begins with the letter  b and followed by any single character.
    ```sql
        SELECT first_name, last_name FROM customer WHERE first_name LIKE '%er%' ORDER BY first_name;
    ```
    ```sql
        SELECT first_name, last_name FROM customer WHERE first_name LIKE '_her%' ORDER BY first_name;
    ```
    * we can combine the percent ( %) with underscore ( _) to construct a pattern above.
    ```sql
        SELECT first_name, last_name FROM customer WHERE first_name NOT LIKE 'Jen%' ORDER BY first_name;
    ```
    * The above query uses the `NOT LIKE` operator to find customers whose first names do not begin with Jen.
    ```sql
        SELECT first_name, last_name FROM customer WHERE first_name ILIKE 'BAR%';
    ```
    * PostgreSQL supports the `ILIKE` operator that works like the `LIKE` operator. In addition, the `ILIKE` operator matches value case-insensitively.
    * The `BAR%` pattern matches any string that begins with BAR, Bar, BaR, etc. If you use the `LIKE` operator instead, the query will not return any row.

## IS NULL operator

* In the database world, `NULL` means missing information or not applicable. 
* `NULL` is not a value, therefore, you cannot compare it with any other values like numbers or strings. 
* The comparison of NULL with a value will always result in `NULL`, which means an unknown result.
* In addition, `NULL` is not equal to `NULL` so the following expression returns `NULL`
    ```sql
        NULL = NULL
    ```
* Consider an example,
    * Assuming that you have a contacts table that stores the first name, last name, email, and phone number of contacts. 
    * At the time of recording the contact, you may not know the contact’s phone number.
    * To deal with this, you define the `phone` column as a nullable column and insert `NULL` into the `phone` column when you save the contact information.
    ```sql
        CREATE TABLE contacts(
            id INT GENERATED BY DEFAULT AS IDENTITY,
            first_name VARCHAR(50) NOT NULL,
            last_name VARCHAR(50) NOT NULL,
            email VARCHAR(255) NOT NULL,
            phone VARCHAR(15),
            PRIMARY KEY (id)
        );
        
        -- The following statement inserts two contacts, one has a phone number and the other does not
        INSERT INTO contacts(first_name, last_name, email, phone)
            VALUES ('John','Doe','john.doe@example.com',NULL),
                ('Lily','Bush','lily.bush@example.com','(408-234-2764)');

        -- To find the contact who does not have a phone number you may come up with the following statement:
        SELECT id, first_name, last_name, email, phone FROM contacts WHERE phone = NULL;
    ```
    * The statement returns no row. This is because the expression phone = NULL in the `WHERE` clause always returns false.
    * Even though there is a NULL in the phone column, the expression NULL = NULL returns false. This is because NULL is not equal to any value even itself.
    * To check whether a value is NULL or not, you use the IS NULL operator instead
        ```sql
            value IS NULL
        ```
        - The expression returns true if the value is NULL or false if it is not.
    * So to get the contact who does not have any phone number stored in the phone column, you use the following statement instead:
        ```sql
            SELECT id, first_name, last_name, email, phone FROM contacts WHERE phone IS NULL;
        ```
    * To check if a value is not NULL, you use the IS NOT NULL operator:
        ```sql
            value IS NOT NULL
        ```
        - The expression returns true if the value is not NULL or false if the value is NULL.
    * For example, to find the contact who does have a phone number, you use the following statement:
        ```sql
            SELECT id, first_name, last_name, email, phone FROM contacts WHERE phone IS NOT NULL;
        ```