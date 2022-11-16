# SQL JOIN

## Learning Goals

- Use the INNER JOIN clause to combine rows from multiple tables based on the foreign key value
- Use the OUTER JOIN clause to include rows having null values in the foreign key

## Introduction

We often need to get data from multiple tables.  The SQL  `JOIN` clause is used to
combine rows from two or more tables. There are different types of joins.  `INNER JOIN` combines
tables based on matching the foreign key in one table with the primary key of another table.  Rows
where the foreign key is null are not included in the result. The `OUTER JOIN` also combines
based on matching the foreign key and primary key, but the result will include rows with null foreign key values.

## Pet Entity Relationship Diagram

We will extend the pet database to store data about visits to the vet.
The data model relationships are as follows:

- A pet has one owner. An owner may own several pets.
  - The `pet` table has a foreign key `owner_id` to the `owner` table.
- A pet may visit a vet many times.  A vet may be visited by many pets.
- The `visit` entity represents the many-to-many relationship between
  pets and vets. Each `visit` also stores the date and diagnosis.
  - The `visit` table has a foreign key `pet_id` to the `pet` table.
  - The `visit` table has a foreign key `vet_id` to the `vet` table.

![pet erd](https://curriculum-content.s3.amazonaws.com/6036/sql-join/pet_erd.png)  

## (Code Along - Use PostgreSQL pgAdmin to write the code in this lesson)
## Database Setup

1. [Fork and clone this lesson](https://github.com/learn-co-curriculum/java-mod-5-sql-join).
   The lesson contains the file `create_vetdb.sql`.
2. Create a new database in **pgAdmin** named `vet`. Select the `vet` database and open the query tool.
3. Click on the Open File icon in the Query Tool toolbar. 
   Navigate to the appropriate folder and select `create_vetdb.sql`, then press Open.      
   Press the Execute button to run the statements to create and populate 4 tables (owner, pet, vet, visit).
4. Close the current connection by closing the tab on the query tool toolbar, and then open a new query
   tool connection (so you don't overwrite create_vetdb.sql).    
5. Query each table and confirm the table contents:

![owner table](https://curriculum-content.s3.amazonaws.com/6036/sql-join/owner.png)

![pet table](https://curriculum-content.s3.amazonaws.com/6036/sql-join/pet.png)

![vet table](https://curriculum-content.s3.amazonaws.com/6036/sql-join/vet.png)

![visit table](https://curriculum-content.s3.amazonaws.com/6036/sql-join/visit.png)


So far, the queries we've written selected data from one table. But
what if we need to get data from multiple tables?  For example, suppose
we want to write a query to show each pet's name, species, breed, age, along with
their owner's name and phone number:

![example join result](https://curriculum-content.s3.amazonaws.com/6036/sql-join/petowner_example.png)

For each row in the `pet` table, we need a way to add the pet owner's name and phone number.
Fortunately, SQL has a way of combining rows from different tables based on foreign keys.


## SQL INNER JOIN

SQL uses the INNER JOIN operator to combine rows from two or more tables based on 
having the same values in one or more columns, which is specified with an ON operator.

The general syntax for the `INNER JOIN` statement is shown below.  Normally we preface each column with the table
as `table_name.column_name` to avoid conflicts with identically named columns:

```sql
SELECT *
FROM table_name1 INNER JOIN table_name2 ON table_name1.column_1 = table_name2.column_2;
```

For example, assume we have tables `A` and `B` as shown below.
An inner join will combine their rows based on matching values in column `z`.

![image inner join](https://curriculum-content.s3.amazonaws.com/6036/java-mod-5-sql-join/inner_join.png)

- The join operation creates a new table, shown on the right.
- The table contains columns from both `A` and `B`.
- Table `A` and `B` contain 2 rows with matching values for `z`,
  thus the new table contains two rows.

NOTE: The column names do not have to be identical in the ON clause, we can join two tables on
any pair of columns.  In general, we will match a foreign key column in one table
to the primary key column in another table.


## Joining `pet` and `owner`

The `pet` table includes the foreign key `owner_id`.
We will use an `INNER JOIN` to combine the rows from the `pet` and `owner` tables based on matching
the foreign key column `owner_id` in `pet` with the corresponding primary key column `id`  in `owner`.

```sql
SELECT *
FROM pet INNER JOIN owner ON pet.owner_id = owner.id ;
```

Type the `INNER JOIN` statement into the query tool panel and execute the statement to view the result.

![pet owner join pgadmin](https://curriculum-content.s3.amazonaws.com/6036/sql-join/petownerjoin_pgadmin.png)

The result listed above shows 2 columns named `id` (1st and 7th data column) along with 2
columns named `name` (2nd and 8th data column).  While the query tool panel does not display
table names in the column headings, each column produced by the query is prefaced with
the table name as shown below.
The first 6 columns in each row (id, name, species, breed, age, owner_id) come from the `pet` table,
while the last 3 columns (id, name, phone) come from the `owner` table. Each row
is the result of matching the foreign  key column `pet.owner_id` to the primary key column `owner.id`
(highlighted with a red border).

![pet owner join pgadmin](https://curriculum-content.s3.amazonaws.com/6036/sql-join/petownerjoin.png)

There are 5 rows in the `pet` table that have a non-null value in the `owner_id`
foreign key column, thus the query produces 5 rows as a result.

We can refine the query to display a subset of columns. 

```sql
SELECT pet.name, pet.species, pet.breed, pet.age, owner.name, owner.phone
FROM pet INNER JOIN owner ON pet.owner_id = owner.id ;
```

This query produces: 

![example join result](https://curriculum-content.s3.amazonaws.com/6036/sql-join/petowner_example.png)


Note that the table name can be omitted if the name of the column is unique
to one table, such as `species`, `breed`, `age`, and `phone`.  Since
both tables have a `name` column, they must be referred
to using `pet.name` and `owner.name`.  The previous query could be rewritten as:

```sql
SELECT pet.name, species, breed, age, owner.name, phone
FROM pet INNER JOIN owner ON pet.owner_id = owner.id ;
```



## Combining JOIN with other SQL clauses

A query that joins tables can also include `WHERE`, `GROUP BY`, `ORDER BY`, or any aggregate function call.
For example, we might want to refine the previous query to only display data about cats:

```sql
SELECT pet.name, breed, age, owner.name, phone
FROM pet INNER JOIN owner ON pet.owner_id = owner.id 
WHERE species = 'cat';
```

The query results in 3 rows, one for each cat in the `pet` table:

![join with where clause](https://curriculum-content.s3.amazonaws.com/6036/sql-join/join_where.png)
 
Notice the `WHERE` clause tests the `species` column, even though the `SELECT` statement does not include `species`.
The different clauses in the query are executed in this sequence:

1. FROM pet INNER JOIN owner ON pet.owner_id = owner.id
2. WHERE species = 'cat'
3. SELECT pet.name, breed, age, owner.name, phone

The `WHERE` clause executes over the result of the table join, which includes the `species` column.
The `SELECT` statement that limits which columns to display is done after the `WHERE` clause picked the
appropriate rows for cats.


We could also use grouping and aggregate functions with tables that are joined:

```sql
SELECT owner.name, owner.phone, count(*)
FROM pet INNER JOIN owner ON pet.owner_id = owner.id
WHERE species = 'cat'
GROUP BY owner.id
ORDER BY count;
```

The query shows the number of cats per owner:

![join with other clauses](https://curriculum-content.s3.amazonaws.com/6036/sql-join/joinother.png)



## Joining `pet` and `visit`

We need a query to display information about each pet and their visits to the vet:

![pet visit result](https://curriculum-content.s3.amazonaws.com/6036/sql-join/pet_visit_result.png)

The query needs data from the  `pet` (name, species) and `visit` (visit date, diagnosis) tables.
The `visit` table has a foreign key `pet_id` that references the `pet` table's `id` primary key.
The tables are joined using the foreign key.
The result contains one row for each row in the `visit` table, with the corresponding `pet` columns added to the row.


```sql
SELECT *
FROM visit INNER JOIN pet ON visit.pet_id = pet.id ;
```

![visit pet join](https://curriculum-content.s3.amazonaws.com/6036/sql-join/visit_pet_join.png)

```sql
SELECT pet.name, pet.species, visit.visit_date, visit.diagnosis
FROM visit INNER JOIN pet ON visit.pet_id = pet.id ;
```

![pet visit result](https://curriculum-content.s3.amazonaws.com/6036/sql-join/pet_visit_result.png)

We can omit the table names since the column names are unique:

```sql
SELECT name, species, visit_date, diagnosis
FROM visit INNER JOIN pet ON visit.pet_id = pet.id ;
```

## Joining `pet` and `visit` and `vet`

We can join any number of tables as long as there are foreign keys linking them together.
For example, we might want to show information about the vet that treated a particular pet:

```sql
SELECT *
FROM visit INNER JOIN pet ON visit.pet_id = pet.id 
           INNER JOIN vet ON visit.vet_id = vet.id;
```

Notice each row contains `visit` columns, followed by `pet` columns, followed by `vet` columns.

![visit join pet join vet](https://curriculum-content.s3.amazonaws.com/6036/sql-join/visit_pet_vet.png)


We can even join all 4 tables to include the owner so the vet's office can call them with the diagnosis:

```sql
SELECT *
FROM visit INNER JOIN pet ON visit.pet_id = pet.id 
           INNER JOIN vet ON visit.vet_id = vet.id
		   INNER JOIN owner ON pet.owner_id = owner.id;
```

We'd probably only want to display a subset of the columns:

```sql
SELECT pet.name, pet.species, owner.name, owner.phone, vet.name, visit.visit_date, visit.diagnosis
FROM visit INNER JOIN pet ON visit.pet_id = pet.id 
           INNER JOIN vet ON visit.vet_id = vet.id
		   INNER JOIN owner ON pet.owner_id = owner.id;
```

![join 4 tables](https://curriculum-content.s3.amazonaws.com/6036/sql-join/join_4_tables.png)


## OUTER JOIN (LEFT, RIGHT)

Let's return to our original example of an `INNER JOIN`.
An `INNER JOIN` only includes rows from tables `A` and `B` that match values in their respective `z` columns.

![image inner join](https://curriculum-content.s3.amazonaws.com/6036/java-mod-5-sql-join/inner_join.png)


We can use a different type of join called a `LEFT OUTER JOIN`, which can be shortened to `LEFT JOIN`,
to include every row in table `A`, even if there is not a matching row in table `B`.

The image below shows the result of the `LEFT JOIN` operator for tables `A` and `B`. Note
the result includes a row for every row in table `A` (the table on the left of the JOIN operator).
There are `null` values in the columns `B.z` and `B.y` for the last row, since table `B` does not have
a row with `z = 3`.

![image left join](https://curriculum-content.s3.amazonaws.com/6036/java-mod-5-sql-join/left_join.png)

SQL also has a `RIGHT JOIN` operator that includes every row in the table on the right
of the JOIN operator, which is table `B` in the example below. There are `null` values
in the columns `A.x` and `A.z` for the middle row, since table `A` does not have
a row with `z = 4`.

![image right join](https://curriculum-content.s3.amazonaws.com/6036/java-mod-5-sql-join/right_join.png)



Let's see how to use a `LEFT JOIN` with the pet database.
We will add another row into the `pet` table.  We don't know the age or owner
for the cat named `meowie`.  

Execute the following code in **pgAdmin**:

```sql
INSERT INTO pet (id, name, species, breed) VALUES (6, 'Meowie', 'cat', 'Calico');
```

Query the table to confirm the new row.  Notice the `owner_id` and `age` columns are null
for the new pet named `Meowie`:

![null pet columns](https://curriculum-content.s3.amazonaws.com/6036/sql-join/nullpet.png)

If we join `pet` and `owner`, the result does not include a row for `Meowie` since the
foreign key column `owner_id` is null.  The `INNER JOIN` only includes rows having a value
in the foreign key column:

```sql
SELECT *
FROM pet INNER JOIN owner ON pet.owner_id = owner.id;
```

![inner join omits null](https://curriculum-content.s3.amazonaws.com/6036/sql-join/innerjoin_null_omitted.png)

However, suppose we want to display **every** pet, along with their owner information *if there is an owner*.



For our `pet` and `owner` tables, the query would be:

```sql
SELECT *
FROM pet LEFT OUTER JOIN owner ON pet.owner_id = owner.id;
```

The result includes a row for `Meowie`, with null values in the owner columns.  Note: We can
omit the word "OUTER" and just use `LEFT JOIN`:


![left join result](https://curriculum-content.s3.amazonaws.com/6036/sql-join/leftjoin.png)

## Conclusion

We often need data from two or more tables.  The `INNER JOIN` operator allows us to combine table rows
based on the foreign and primary keys. Only rows containing a value in the foreign key
column are included in the result.  The `OUTER JOIN` operator can be used to
include rows with null values in the foreign key.



## Resources

- [Join Visualization Cheatsheet](https://github.com/amartinson193/SQL_Checkered_Flag_Join_Diagrams/blob/main/checkered_flag_diagram_pg1.png)  
- [PostgreSQL JOIN documentation](https://www.postgresql.org/docs/current/tutorial-join.html)    
- [PostgreSQL JOIN tutorial](https://www.tutorialspoint.com/postgresql/postgresql_using_joins.htm)    
- [W3School JOIN tutorial](https://www.w3schools.com/sql/sql_join.asp)   
