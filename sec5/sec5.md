# Set Operations

## Union Operator

* The `UNION` operator combines result sets of two or more `SELECT` statements into a single result set.
* Query Syntax,
    ```sql
        SELECT select_list_1 FROM table_expression_1 
        UNION
        SELECT select_list_2 FROM table_expression_2
    ```
    * To combine result sets of two queries using the `UNION` operator, the queries must conform to the following order :
        * The number and the order of the columns in the select list of both the queries must be the same.
        * The data types must be compatible.
    * The `UNION` operator removes all duplicate rows from the combined data set. To retain the duplicate rows, you use the `UNION ALL` instead.
    *  The `UNION` operator may place the rows from the result set of the first query before, after, or between the rows from the result set of the second query.
    * To sort rows in the final result set, you use the `ORDER BY` clause in the second query.
* For example,
    ```sql
        DROP TABLE IF EXISTS top_rated_films;
        CREATE TABLE top_rated_films(
            title VARCHAR NOT NULL,
            release_year SMALLINT
        );

        DROP TABLE IF EXISTS most_popular_films;
        CREATE TABLE most_popular_films(
            title VARCHAR NOT NULL,
            release_year SMALLINT
        );

        INSERT INTO top_rated_films(title, release_year) VALUES
            ('The Shawshank Redemption',1994),
            ('The Godfather',1972),
            ('12 Angry Men',1957);
        
        INSERT INTO most_popular_films(title, release_year) VALUES
            ('An American Pickle',2020),
            ('The Godfather',1972),
            ('Greyhound',2020);
        
        SELECT * FROM top_rated_films;

        SELECT * FROM most_popular_films;
    ```
    * Simple PostgreSQL `UNION` example
        ```sql
            SELECT * FROM top_rated_films
            UNION
            SELECT * FROM most_popular_films;
        ```
        * The result set includes five rows in the result set because the `UNION` operator removes one duplicate row.
    * PostgreSQL `UNION ALL` example
        ```sql
            SELECT * FROM top_rated_films
            UNION ALL
            SELECT * FROM most_popular_films;
        ```
        * In this example, the duplicate row is retained in the result set.
    * PostgreSQL `UNION ALL` with `ORDER BY` clause example
        ```sql
            SELECT * FROM top_rated_films
            UNION ALL
            SELECT * FROM most_popular_films
            ORDER BY title;
        ```
        * If you place the `ORDER BY` clause at the end of each query, the combined result set will not be sorted as you expected. Because when `UNION` operator combines the sorted result sets from each query, it does not guarantee the order of rows in the final result set.

## Intersect Operator

* Like the `UNION` and `EXCEPT` operators, the PostgreSQL `INTERSECT` operator combines result sets of two or more `SELECT` statements into a single result set.
* The `INTERSECT` operator returns any rows that are availabel in both result sets.
* Query Syntax,
    ```sql
        SELECT select_list FROM A INTERSECT SELECT select_list FROM B;
    ```
    * To use the `INTERSECT` operator, the columns that appear in the `SELECT` statements must follow the folowing rules:
        * The number of columns and their order in the `SELECT` clauses must be the same.
        * The `data types` of the columns must be compatible.
* If you want to sort the result set returned by the `INTERSECT` operator, you place the `ORDER BY` at the final query in the query list like this:
```sql
    SELECT select_list FROM A INTERSECT SELECT select_list FROM B ORDER BY sort_expression;
```
* For Example,
    ```sql
        SELECT * FROM most_popular_films INTERSECT SELECT * FROM top_rated_films;
    ```

## Except Operator

* `EXCEPT` operator returns rows by comparing the result sets of two or more queries.
* The `EXCEPT` operator returns distinct rows from the first (left) query that are not in the output of the second (right) query.
* Query Syntax,
    ```sql
        SELECT select_list FROM A EXCEPT SELECT select_list FROM B;
    ```
    * The queries that involve in the `EXCEPT` need to follow these rules:
        * The number of columns and their orders must be the same in the two queries.
        * The data types of the respective columns must be compatible.
* For Example,
    * The following statement uses the `EXCEPT` operator to find the top-rated films that are not popular:
    ```sql
        SELECT * FROM top_rated_films
        EXCEPT
        SELECT * FROM most_popular_filsm;
    ```
    * The following statement uses the `ORDER BY` clause in the query to sort result sets returned by the `EXCEPT` operator:
    ```sql
        SELECT * FROM top_rated_films
        EXCEPT
        SELECT * FROM most_popular_filsm
        ORDER BY title;
    ```