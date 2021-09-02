# Sql Database queries

* Note that the SQL keywords are case-insensitive. It means that `SELECT` is equivalent to `select` or `Select`
* Exercises
    * Get the customers having same first name.
    * Get the customers having same last name.
    * Get the customers having first name less than equal to 5 letters

## Select query
* Query syntax
    ```sql
        SELECT
            select_list
        FROM
            table_name;
    ```
* First, specify the `select_list` than can be a column or a list of columns in a table from which you want to retrieve data.
* If you specify a list of columns, you need to place a comma (,) between two columns to separate them
* The `select_list` may also contain expressions or literal values.
* Second, specify the name of the table from which you want to query data after the `FROM` keyword.
* For Example,
    ```sql
        SELECT first_name FROM customer;
    ```
    ```sql
        SELECT first_name, last_name, email FROM customer;
    ```
    ```sql
        SELECT * FROM customer;
    ```
    ```sql
        SELECT first_name || ' ' || last_name, email FROM customer;
    ```
    > NOTE : `||` is concatenate operator.
    ```sql
        SELECT 5 * 3;
    ```
    > NOTE : `5 * 3` is an expression 

## Columns Alias

* A column alias allows you to assign a column or an expression in the select list of a `SELECT` statment a temporary name.
* The column alias exists temporarily during the execution of the query.
* Query syntax
    ```sql
        SELECT column_name AS alias_name
        FROM table_name;
    ```
    * In this syntax, the `column_name` is assigned an alias `alias_name`. The `AS` keyword is optional so you can omit it like this:
    ```sql
        SELECT column_name alias_name
        FROM table_name;
    ```
    * The following syntax illustrates how to set an alias for an expression in the SELECT clause:
    ```sql
        SELECT expression AS alias_name
        FROM table_name;
    ```
* For example,
    ```sql
        SELECT first_name, last_name FROM customer;
    ```
    ```sql
        SELECT first_name, last_name AS surname FROM customer;
    ```
    ```sql
        SELECT first_name, last_name surname FROM customer;
    ```
    ```sql
        SELECT first_name || ' ' || last_name  AS full_name FROM customer;
    ```
    ```sql
        SELECT first_name || ' ' || last_name  "full name" FROM customer;
    ```
    > NOTE : If a column alias contains one or more spaces, we need to surround it with double quotes.

## Order By Clause

* When you query from a table, the `SELECT` statement returns rows in an unspecified order. To Sort the rows of the result set, you use the `ORDER BY` clause in the select command.
* The `ORDER BY` clause allows you to sort rows returned by a `SELECT` clause in ascending or descending order based on a sort expression.
* Query Syntax
    ```sql
        SELECT 
            select_list
        FROM
            table_name
        ORDER BY
            sort expression [ASC|DESC],
            ...
            sort expression [ASC|DESC];
    ```
    * First, specify a sort expression, which can be a column or an expression, that you want to sort after the `ORDER BY` keywords. 
    * If you want to sort the result set based on multiple columns or expressions, you need to place a comma (,) between two columns or expressions to separate them.
    * Second, you use the `ASC` option to sort rows in ascending order and the `DESC` option to sort rows in descending order.
    * If you omit the `ASC` or `DESC` option, the `ORDER BY` uses `ASC` by default.
    * PostgreSQL evaluates the clauses in the `SELECT` statment in the following order: 
        ```sql
            FROM -> SELECT -> ORDER BY 
        ```
    * Due to the order of evaluation, if you have a column alias in the `SELECT` clause, you can use it in the `ORDER BY` clause.
* For example,
    ```sql
        SELECT first_name, last_name FROM customer ORDER BY first_name ASC;
    ```
    ```sql
        SELECT first_name, last_name FROM customer ORDER BY first_name;
    ```
    ```sql
        SELECT first_name, last_name FROM customer ORDER BY last_name DESC;
    ```
    ```sql
        SELECT first_name, last_name FROM customer ORDER BY first_name ASC, last_name DESC;
    ```
    ```sql
        SELECT first_name, LENGTH(first_name) len FROM customer ORDER BY len Desc;
    ```
* In the database world, `NULL` is a marker that indicates the missing data or the data is unknown at the time of recording.
* When you sort rows that contains `NULL`, you can specify the order of `NULL` with other non-null values by using the `NULLS FIRST` or `NULLS LAST` option of the `ORDER BY` clause:
    ```sql
        ORDER BY sort_expresssion [ASC | DESC] [NULLS FIRST | NULLS LAST]
    ```
    * For Example,
        ```sql
            -- create a new table
            CREATE TABLE sort_demo(
                num INT
            );

            -- insert some data
            INSERT INTO sort_demo(num)
            VALUES(1),(2),(3),(null);

            SELECT num
            FROM sort_demo
            ORDER BY num;
        ```
        ```sql
            SELECT num
            FROM sort_demo
            ORDER BY num NULLS LAST;

            SELECT num
            FROM sort_demo
            ORDER BY num NULLS FIRST;

            SELECT num
            FROM sort_demo
            ORDER BY num DESC;

            SELECT num
            FROM sort_demo
            ORDER BY num DESC NULLS LAST;
        ```
## Distinct clause

* The `DISTINCT` is used in the `SELECT` statement to remove duplicate rows from a result set.
* The `DISTINCT` clause keeps one row for each group of duplicates.
* The `DISTINCT` clause can be applied to one or more columns in the select list of the `SELECT` statement.
* Query Syntax
    ```sql
        SELECT
            DISTINCT column1
        FROM
            table_name;
    ```
    * In this statement, the values in the column1 column are used to evaluate the duplicate.
    ```sql
        SELECT
            DISTINCT column1, column2
        FROM
            table_name;
    ```
    * In this case, the combination of values in both column1 and column2 columns will be used for evaluating the duplicate.
    ```sql
        SELECT
            DISTINCT ON (column1) column_alias,
            column2
        FROM
            table_name
        ORDER BY
            column1,
            column2;
    ```
    * PostgreSQL also provides the `DISTINCT ON` (expression) to keep the “first” row of each group of duplicates using the above syntax.
* It is a good practice to always use the `ORDER BY` clause with the `DISTINCT ON`(expression) to make the result set predictable.
* Notice that the `DISTINCT` ON expression must match the leftmost expression in the `ORDER BY` clause.
* For example,
    ```sql
        CREATE TABLE distinct_demo (
            id serial NOT NULL PRIMARY KEY,
            bcolor VARCHAR,
            fcolor VARCHAR
        );

        INSERT INTO distinct_demo (bcolor, fcolor)
        VALUES
            ('red', 'red'),
            ('red', 'red'),
            ('red', NULL),
            (NULL, 'red'),
            ('red', 'green'),
            ('red', 'blue'),
            ('green', 'red'),
            ('green', 'blue'),
            ('green', 'green'),
            ('blue', 'red'),
            ('blue', 'green'),
            ('blue', 'blue');

        SELECT
            id,
            bcolor,
            fcolor
        FROM
            distinct_demo ;
    ```
    * The following statement selects unique values in the bcolor column from the t1 table and sorts the result set in alphabetical order by using the `ORDER BY` clause.

    ```sql
        SELECT DISTINCT bcolor FROM distinct_demo ORDER BY bcolor;
    ```

    ```sql
        SELECT DISTINCT bcolor, fcolor FROM distinct_demo ORDER BY bcolor, fcolor;
    ```
    ```sql
        SELECT DISTINCT ON (bcolor) bcolor, fcolor FROM distinct_demo  ORDER BY bcolor, fcolor;
    ```
    * In above query the distinct is applied on only `bcolor` field while the other field names are for display.