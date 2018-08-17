-- Part I – Working with an existing database

-- Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.
        SELECT * FROM employee;
-- Task – Select all records from the Employee table where last name is King.
        SELECT * FROM employee WHERE lastname = 'King';
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
        SELECT * FROM employee WHERE firstname = 'Andrew' AND reportsto IS NULL;
-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
        SELECT * FROM album	ORDER BY title DESC;
-- Task – Select first name from Customer and sort result set in ascending order by city
        SELECT firstname, city FROM customer ORDER BY city ASC;
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
        INSERT INTO genre(genreid, name) VALUES (26, 'Folk'),(27, 'Punk');
-- Task – Insert two new records into Employee table
        INSERT INTO employee (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email)
	VALUES (9, 'Wayne', 'Bruce', 'SuperHero', null, '1939-02-19', '1965-08-13', '1007 Mountain Drive', 'Gotham City', 'Gotham', 'USA', 53556, '(555)555-5555', '(222)222-2222','notbatman@gmail.com'), 
	(10, 'Allen', 'Barry', 'CSI/SuperHero', 1, '1989-03-23', '2015-10-23', '44 Running Place', 'Central City', 'Indiana', 'USA', 53556, '(414)876-9621', '(847)134-7621','nottheflash@gmail.com')
-- Task – Insert two new records into Customer table
         INSERT INTO customer(customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid)
	 VALUES (60, 'Felix', 'Durr', 'Alpha Beta', '1212 Froe Street', 'Charleston', 'West Virginia', 'USA', 25301, '(304)-341-1082', '(304)-231-1042', 'EugeneRBeltran@teleworm.us', 2 ),
               (61, 'Trajan', 'Bogner', 'Dream Home Real Estate Service', '105 Banana Lane', 'Licking', 'Missouri', 'USA', 65542, '(123)456-7890', '(222)333-4444', 'TrajanBogner@teleworm.us', 4 )
-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
         SELECT * FROM customer WHERE customerid = 32 UPDATE customer SET firstname = 'Robert', lastname = 'Walter' WHERE customerid = 32;
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
         UPDATE artist SET name = 'CCR' WHERE artistid = 76;
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
        SELECT * FROM invoice WHERE billingaddress LIKE 'T%'
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
        SELECT * FROM invoice WHERE total BETWEEN 15 AND 50 ORDER BY total;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
        SELECT * FROM employee WHERE hiredate BETWEEN '2003-06-01' and '2004-03-01' ORDER BY hiredate;
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
         DELETE FROM invoiceline WHERE invoiceid IN
        (SELECT invoiceid FROM invoice WHERE customerid IN
        (SELECT  customerid FROM customer WHERE firstname = 'Robert' AND lastname = 'Walter'));
        DELETE FROM invoice WHERE customerid IN
        (SELECT  customerid FROM customer WHERE firstname = 'Robert' AND lastname = 'Walter');
        DELETE FROM customer WHERE firstname = 'Robert' AND lastname = 'Walter';
-- SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
        CREATE OR REPLACE FUNCTION my_time()
        RETURNS TIME AS $$
	BEGIN
	RETURN current_time;
	END;
        $$ LANGUAGE plpgsql;
        SELECT my_time();
-- Task – create a function that returns the length of a mediatype from the mediatype table
        CREATE OR REPLACE FUNCTION my_mediatype(name_type VARCHAR(120))
        RETURNS VARCHAR AS $$
        BEGIN
        RETURN LENGTH(name_type);
        END;
        $$ LANGUAGE plpgsql;
        SELECT my_mediatype(name) FROM mediatype;
-- 3.2 System Defined Aggregate Functions

-- Task – Create a function that returns the average total of all invoices
        CREATE OR REPLACE FUNCTION my_total()
        RETURNS NUMERIC AS $$
	BEGIN
	RETURN AVG(total) FROM invoice;
	END;
        $$ LANGUAGE plpgsql; 
        SELECT my_total();
-- Task – Create a function that returns the most expensive track
        CREATE OR REPLACE FUNCTION most_expensive()
        RETURNS NUMERIC AS $$
	BEGIN
	RETURN MAX(unitprice) FROM track;
	END;
        $$ LANGUAGE plpgsql;
        SELECT most_expensive();
-- 3.3 User Defined Scalar Functions

-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
        CREATE OR REPLACE FUNCTION invoiceline_avg()
        RETURNS NUMERIC AS $$
	BEGIN
	RETURN AVG(unitprice) FROM invoiceline;
	END;
        $$ LANGUAGE plpgsql;
        SELECT invoiceline_avg();

-- 3.4 User Defined Table Valued Functions

-- Task – Create a function that returns all employees who are born after 1968.
        CREATE OR REPLACE FUNCTION born_after_1968()
        RETURNS SETOF employee AS $$
	BEGIN
	RETURN QUERY SELECT * FROM employee WHERE birthdate >= '1968-01-01';
	END;
        $$ LANGUAGE plpgsql;
        SELECT born_after_1968();
-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.

-- 4.1 Basic Stored Procedure

-- Task – Create a stored procedure that selects the first and last names of all the employees.
        CREATE OR REPLACE FUNCTION employee_names()
        RETURNS TABLE(first_name VARCHAR(20), last_name VARCHAR(20)) AS $$
	BEGIN
	RETURN QUERY SELECT firstname, lastname FROM employee;
	END;
        $$ LANGUAGE plpgsql;
        SELECT employee_names();
-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
        CREATE OR REPLACE FUNCTION update_employee () RETURNS NUMERIC(10, 2) AS $$
        RETURNS list NUMERIC(10, 2);
        BEGIN
   	UPDATE employee
	SET firstname = 'Hal', lastname = 'Jordan'
	WHERE employeeid = 1; 
	RETURN list;
        END;
        $$ LANGUAGE plpgsql;
        SELECT update_employee();
-- Task – Create a stored procedure that returns the managers of an employee.
        CREATE OR REPLACE FUNCTION employee_manager()
        RETURNS TABLE (first_name VARCHAR, last_name VARCHAR, reports_to INTEGER, employee_id INTEGER, managers_first_name VARCHAR, managers_last_name VARCHAR)
        AS $$
        BEGIN
        RETURN QUERY 
        SELECT a.firstname, a.lastname, a.reportsto, b.employeeid, b.firstname, b.lastname FROM employee a, employee b 
	WHERE a.reportsto = b.employeeid;
        END;
        $$ LANGUAGE plpgsql;
        SELECT employee_manager();
-- 4.3 Stored Procedure Output Parameters
 
-- Task – Create a stored procedure that returns the name and company of a customer.
        CREATE OR REPLACE FUNCTION customer_company()
        RETURNS TABLE (first_name VARCHAR, last_name VARCHAR, company_name VARCHAR) AS $$
        BEGIN
        RETURN QUERY 
	SELECT firstname, lastname, company FROM customer;
        END
        $$ LANGUAGE plpgsql;
        SELECT customer_company();
-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.

-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).

-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
        CREATE OR REPLACE FUNCTION add_customer(customer_id INTEGER,first_name VARCHAR, last_name VARCHAR, customer_email VARCHAR)
	RETURNS void AS $$
	BEGIN
	  INSERT INTO customer (customerid, firstname, lastname, email) VALUES (customer_id, first_name, last_name, customer_email);
	END;
	$$ LANGUAGE plpgsql
        SELECT add_customer(62, "Oliver", "Queen", "greenarrow@gmail.com")
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
        CREATE TABLE employee_log(new_employeeid VARCHAR(20), new_firstname VARCHAR(20), new_lastname VARCHAR(20));
        CREATE OR REPLACE FUNCTION employee_log_trig_fun()
        RETURNS TRIGGER AS $$
          BEGIN
            IF(TG_OP = 'INSERT') THEN
            INSERT INTO employee_log (new_employeeid, new_firstname, new_lastname) VALUES (NEW.employeeid, NEW.lastname, NEW.firstname);
          END IF;
        RETURN NEW; 
          END;
        $$ LANGUAGE plpgsql;
        CREATE TRIGGER employee_trigger
        AFTER INSERT ON employee
        FOR EACH ROW
        EXECUTE PROCEDURE employee_trig();

-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
        CREATE TABLE album_log(old_albumid VARCHAR(20), new_albumid VARCHAR(20),old_title VARCHAR(20), new_title VARCHAR(20), old_artistid VARCHAR(20), new_artistid VARCHAR(20));

        CREATE OR REPLACE FUNCTION album_update() RETURNS TRIGGER AS $$
        BEGIN
        IF(TG_OP = 'UPDATE') THEN
        INSERT INTO album_log (old_albumid, new_albumid, old_title, new_title, old_artistid, new_artistid) VALUES (OLD.albumid, NEW.albumid, OLD.title, NEW.title, OLD.artistid, NEW.artistid);
        END IF;
        RETURN NEW; 
        END;
        $$ LANGUAGE plpgsql;
        
        CREATE TRIGGER update_album_trig
        AFTER UPDATE ON album
        FOR EACH ROW
        EXECUTE PROCEDURE update_album_trig();

-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
        CREATE OR REPLACE FUNCTION delete_customer() RETURNS TRIGGER AS $$
        BEGIN
        IF(TG_OP = 'DELETE') THEN
        DELETE FROM customer 
        WHERE customerid = '23';
        END;
        $$ LANGUAGE plpgsql;
        CREATE TRIGGER delete_trigger AFTER INSERT ON customer
        FOR EACH ROW EXECUTE PROCEDURE delete_customer();
-- 6.2 INSTEAD OF
-- Task – Create an instead of trigger that restricts the deletion of any invoice that is priced over 50 dollars.
        CREATE OR REPLACE FUNCTION restrict_invoice_del() RETURNS TRIGGER AS $$
        BEGIN
        IF(TG_OP = 'DELETE' AND invoice <=50);
        END;
        $$ LANGUAGE plpgsql;
        CREATE TRIGGER restrict_del BEFORE DELETE ON invoice
        FOR EACH ROW EXECUTE PROCEDURE restrict_del();
-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
        SELECT customer.firstname, customer.lastname, invoice.invoiceid FROM customer INNER JOIN invoice ON customer.customerid = invoice.customerid
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
        SELECT customer.customerid, customer.firstname, customer.lastname, invoice.invoiceid, invoice.total 
        FROM customer 
        FULL OUTER JOIN invoice ON customer.customerid = invoice.customerid
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
        SELECT album.title, artist.name FROM album RIGHT JOIN artist ON artist.artistid = album.artistid
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
        SELECT * FROM album CROSS JOIN artist ORDER BY artist.name ASC
-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
        SELECT A.firstname AS firstname1, B.firstname AS firstname2, A.reportsto
        FROM employee A, employee B
        WHERE A.firstname <> B.firstname








