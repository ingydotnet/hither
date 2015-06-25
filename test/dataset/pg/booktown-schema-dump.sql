--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: booktown; Type: COMMENT; Schema: -; Owner: ingy
--

COMMENT ON DATABASE booktown IS 'The Book Town Database.';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: add_shipment(integer, text); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION add_shipment(integer, text) RETURNS timestamp with time zone
    LANGUAGE plpgsql
    AS $_$
  DECLARE
    customer_id ALIAS FOR $1;
    isbn ALIAS FOR $2;
    shipment_id INTEGER;
    right_now timestamp;
  BEGIN
    right_now := 'now';
    SELECT INTO shipment_id id FROM shipments ORDER BY id DESC;
    shipment_id := shipment_id + 1;
    INSERT INTO shipments VALUES ( shipment_id, customer_id, isbn, right_now );
    RETURN right_now;
  END;
$_$;


ALTER FUNCTION public.add_shipment(integer, text) OWNER TO ingy;

--
-- Name: add_two_loop(integer, integer); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION add_two_loop(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
  DECLARE
 
     -- Declare aliases for function arguments.
 
    low_number ALIAS FOR $1;
    high_number ALIAS FOR $2;
 
     -- Declare a variable to hold the result.
 
    result INTEGER = 0;
 
  BEGIN
 
    WHILE result != high_number LOOP
      result := result + 1;
    END LOOP;
 
    RETURN result;
  END;
$_$;


ALTER FUNCTION public.add_two_loop(integer, integer) OWNER TO ingy;

--
-- Name: audit_test(); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION audit_test() RETURNS opaque
    LANGUAGE plpgsql
    AS $$
    BEGIN   
       
      IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN

         NEW.user_aud := current_user;
         NEW.mod_time := 'NOW';

        INSERT INTO inventory_audit SELECT * FROM inventory WHERE prod_id=NEW.prod_id;
              
      RETURN NEW; 

      ELSE if TG_OP = 'DELETE' THEN
        INSERT INTO inventory_audit SELECT *, current_user, 'NOW' FROM inventory WHERE prod_id=OLD.prod_id;

      RETURN OLD;
      END IF;
     END IF;
    END;
$$;


ALTER FUNCTION public.audit_test() OWNER TO ingy;

--
-- Name: books_by_subject(text); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION books_by_subject(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
  DECLARE
    sub_title ALIAS FOR $1;
    sub_id INTEGER;
    found_text TEXT :='';
  BEGIN
      SELECT INTO sub_id id FROM subjects WHERE subject = sub_title;
      RAISE NOTICE 'sub_id = %',sub_id;
      IF sub_title = 'all' THEN
        found_text := extract_all_titles();
        RETURN found_text;
      ELSE IF sub_id  >= 0 THEN
          found_text := extract_title(sub_id);
          RETURN  '
' || sub_title || ':
' || found_text;
        END IF;
    END IF;
    RETURN 'Subject not found.';
  END;
$_$;


ALTER FUNCTION public.books_by_subject(text) OWNER TO ingy;

--
-- Name: check_book_addition(); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION check_book_addition() RETURNS opaque
    LANGUAGE plpgsql
    AS $$
  DECLARE 
    id_number INTEGER;
    book_isbn TEXT;
  BEGIN

    SELECT INTO id_number id FROM customers WHERE id = NEW.customer_id; 

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Invalid customer ID number.';  
    END IF;

    SELECT INTO book_isbn isbn FROM editions WHERE isbn = NEW.isbn; 

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Invalid ISBN.'; 
    END IF; 

    UPDATE stock SET stock = stock -1 WHERE isbn = NEW.isbn; 

    RETURN NEW; 
  END;
$$;


ALTER FUNCTION public.check_book_addition() OWNER TO ingy;

--
-- Name: check_shipment_addition(); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION check_shipment_addition() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
     -- Declare a variable to hold the customer ID.
    id_number INTEGER;
 
     -- Declare a variable to hold the ISBN.
    book_isbn TEXT;
  BEGIN
 
     -- If there is an ID number that matches the customer ID in
     -- the new table, retrieve it from the customers table.
    SELECT INTO id_number id FROM customers WHERE id = NEW.customer_id;
 
     -- If there was no matching ID number, raise an exception.
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Invalid customer ID number.';
    END IF;
 
     -- If there is an ISBN that matches the ISBN specified in the
     -- new table, retrieve it from the editions table.
    SELECT INTO book_isbn isbn FROM editions WHERE isbn = NEW.isbn;
 
     -- If there is no matching ISBN, raise an exception.
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Invalid ISBN.';
    END IF;
 
    -- If the previous checks succeeded, update the stock amount
    -- for INSERT commands.
    IF TG_OP = 'INSERT' THEN
       UPDATE stock SET stock = stock -1 WHERE isbn = NEW.isbn;
    END IF;
 
    RETURN NEW;
  END;
$$;


ALTER FUNCTION public.check_shipment_addition() OWNER TO ingy;

--
-- Name: compound_word(text, text); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION compound_word(text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
     DECLARE
       -- defines an alias name for the two input values
       word1 ALIAS FOR $1;
       word2 ALIAS FOR $2;
     BEGIN
       -- displays the resulting joined words
       RETURN word1 || word2;
     END;
  $_$;


ALTER FUNCTION public.compound_word(text, text) OWNER TO ingy;

--
-- Name: count_by_two(integer); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION count_by_two(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
     DECLARE
          userNum ALIAS FOR $1;
          i integer;
     BEGIN
          i := 1;
          WHILE userNum[1] < 20 LOOP
                i = i+1; 
                return userNum;              
          END LOOP;
          
     END;
   $_$;


ALTER FUNCTION public.count_by_two(integer) OWNER TO ingy;

--
-- Name: double_price(double precision); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION double_price(double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $_$
  DECLARE
  BEGIN
    return $1 * 2;
  END;
$_$;


ALTER FUNCTION public.double_price(double precision) OWNER TO ingy;

--
-- Name: extract_all_titles(); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION extract_all_titles() RETURNS text
    LANGUAGE plpgsql
    AS $$
  DECLARE
    sub_id INTEGER;
    text_output TEXT = ' ';
    sub_title TEXT;
    row_data books%ROWTYPE;
  BEGIN
    FOR i IN 0..15 LOOP
      SELECT INTO sub_title subject FROM subjects WHERE id = i;
      text_output = text_output || '
' || sub_title || ':
';

      FOR row_data IN SELECT * FROM books
        WHERE subject_id = i  LOOP

        IF NOT FOUND THEN
          text_output := text_output || 'None.
';
        ELSE
          text_output := text_output || row_data.title || '
';
        END IF;

      END LOOP;
    END LOOP;
    RETURN text_output;
  END;
$$;


ALTER FUNCTION public.extract_all_titles() OWNER TO ingy;

--
-- Name: extract_all_titles2(); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION extract_all_titles2() RETURNS text
    LANGUAGE plpgsql
    AS $$
  DECLARE
    sub_id INTEGER;
    text_output TEXT = ' ';
    sub_title TEXT;
    row_data books%ROWTYPE;
  BEGIN
    FOR i IN 0..15 LOOP
      SELECT INTO sub_title subject FROM subjects WHERE id = i;
      text_output = text_output || '
' || sub_title || ':
';

      FOR row_data IN SELECT * FROM books
        WHERE subject_id = i  LOOP

        text_output := text_output || row_data.title || '
';

      END LOOP;
    END LOOP;
    RETURN text_output;
  END;
$$;


ALTER FUNCTION public.extract_all_titles2() OWNER TO ingy;

--
-- Name: extract_title(integer); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION extract_title(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
  DECLARE
    sub_id ALIAS FOR $1;
    text_output TEXT :='
';
    row_data RECORD;
  BEGIN
    FOR row_data IN SELECT * FROM books
    WHERE subject_id = sub_id ORDER BY title  LOOP
      text_output := text_output || row_data.title || '
';
    END LOOP;
    RETURN text_output;
  END;
$_$;


ALTER FUNCTION public.extract_title(integer) OWNER TO ingy;

--
-- Name: first(); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION first() RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
       DecLarE
        oNe IntEgER := 1;
       bEGiN
        ReTUrn oNE;       
       eNd;
$$;


ALTER FUNCTION public.first() OWNER TO ingy;

--
-- Name: get_author(integer); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION get_author(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
  DECLARE
 
    -- Declare an alias for the function argument,
    -- which should be the id of the author.
    author_id ALIAS FOR $1;
 
    -- Declare a variable that uses the structure of
    -- the authors table.
    found_author authors%ROWTYPE;
 
  BEGIN
 
    -- Retrieve a row of author information for
    -- the author whose id number matches
    -- the argument received by the function.
    SELECT INTO found_author * FROM authors WHERE id = author_id;
 
    -- Return the first
    RETURN found_author.first_name || ' ' || found_author.last_name;
 
  END;
$_$;


ALTER FUNCTION public.get_author(integer) OWNER TO ingy;

--
-- Name: get_author(text); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION get_author(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
  DECLARE
 
      -- Declare an alias for the function argument,
      -- which should be the first name of an author.
     f_name ALIAS FOR $1;
 
       -- Declare a variable with the same type as
       -- the last_name field of the authors table.
     l_name authors.last_name%TYPE;
 
  BEGIN
 
      -- Retrieve the last name of an author from the
      -- authors table whose first name matches the
      -- argument received by the function, and
      -- insert it into the l_name variable.
     SELECT INTO l_name last_name FROM authors WHERE first_name = f_name;
 
       -- Return the first name and last name, separated
       -- by a space.
     return f_name || ' ' || l_name;
 
  END;
$_$;


ALTER FUNCTION public.get_author(text) OWNER TO ingy;

--
-- Name: get_customer_id(text, text); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION get_customer_id(text, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
  DECLARE
 
    -- Declare aliases for user input.
    l_name ALIAS FOR $1;
    f_name ALIAS FOR $2;
 
    -- Declare a variable to hold the customer ID number.
    customer_id INTEGER;
 
  BEGIN
 
    -- Retrieve the customer ID number of the customer whose first and last
    --  name match the values supplied as function arguments.
    SELECT INTO customer_id id FROM customers
      WHERE last_name = l_name AND first_name = f_name;
 
    -- Return the ID number.
    RETURN customer_id;
  END;
$_$;


ALTER FUNCTION public.get_customer_id(text, text) OWNER TO ingy;

--
-- Name: get_customer_name(integer); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION get_customer_name(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
  DECLARE
  
    -- Declare aliases for user input.
    customer_id ALIAS FOR $1;
    
    -- Declare variables to hold the customer name.
    customer_fname TEXT;
    customer_lname TEXT;
  
  BEGIN
  
    -- Retrieve the customer first and last name for the customer whose
    -- ID matches the value supplied as a function argument.
    SELECT INTO customer_fname, customer_lname 
                first_name, last_name FROM customers
      WHERE id = customer_id;
    
    -- Return the name.
    RETURN customer_fname || ' ' || customer_lname;
  END;
$_$;


ALTER FUNCTION public.get_customer_name(integer) OWNER TO ingy;

--
-- Name: givename(); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION givename() RETURNS opaque
    LANGUAGE plpgsql
    AS $$
 DECLARE
   tablename text;
 BEGIN
   
   tablename = TG_RELNAME; 
   INSERT INTO INVENTORY values (123, tablename);
   return old;
 END;
$$;


ALTER FUNCTION public.givename() OWNER TO ingy;

--
-- Name: html_linebreaks(text); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION html_linebreaks(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
  DECLARE
    formatted_string text := '';
  BEGIN
    FOR i IN 0 .. length($1) LOOP
      IF substr($1, i, 1) = '
' THEN
        formatted_string := formatted_string || '<br>';
      ELSE
        formatted_string := formatted_string || substr($1, i, 1);
      END IF;
    END LOOP;
    RETURN formatted_string;
  END;
$_$;


ALTER FUNCTION public.html_linebreaks(text) OWNER TO ingy;

--
-- Name: in_stock(integer, integer); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION in_stock(integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
  DECLARE
    b_id ALIAS FOR $1;
    b_edition ALIAS FOR $2;
    b_isbn TEXT;
    stock_amount INTEGER;
  BEGIN
     -- This SELECT INTO statement retrieves the ISBN
     -- number of the row in the editions table that had
     -- both the book ID number and edition number that
     -- were provided as function arguments.
    SELECT INTO b_isbn isbn FROM editions WHERE
      book_id = b_id AND edition = b_edition;
 
     -- Check to see if the ISBN number retrieved
     -- is NULL.  This will happen if there is not an
     -- existing book with both the ID number and edition
     -- number specified in the function arguments.
     -- If the ISBN is null, the function returns a
     -- FALSE value and ends.
    IF b_isbn IS NULL THEN
      RETURN FALSE;
    END IF;
 
     -- Retrieve the amount of books available from the
     -- stock table and record the number in the
     -- stock_amount variable.
    SELECT INTO stock_amount stock FROM stock WHERE isbn = b_isbn;
 
     -- Use an IF/THEN/ELSE check to see if the amount
     -- of books available is less than, or equal to 0.
     -- If so, return FALSE.  If not, return TRUE.
    IF stock_amount <= 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END;
$_$;


ALTER FUNCTION public.in_stock(integer, integer) OWNER TO ingy;

--
-- Name: isbn_to_title(text); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION isbn_to_title(text) RETURNS text
    LANGUAGE sql
    AS $_$SELECT title FROM books
                                 JOIN editions AS e (isbn, id)
                                 USING (id)
                                 WHERE isbn = $1$_$;


ALTER FUNCTION public.isbn_to_title(text) OWNER TO ingy;

--
-- Name: mixed(); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION mixed() RETURNS integer
    LANGUAGE plpgsql
    AS $$
       DecLarE
          --assigns 1 to the oNe variable
          oNe IntEgER 
          := 1;

       bEGiN

          --displays the value of oNe
          ReTUrn oNe;       
       eNd;
       $$;


ALTER FUNCTION public.mixed() OWNER TO ingy;

--
-- Name: raise_test(); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION raise_test() RETURNS integer
    LANGUAGE plpgsql
    AS $$
  DECLARE
 
     -- Declare an integer variable for testing.
 
    an_integer INTEGER = 1;
 
  BEGIN
 
     -- Raise a debug level message.
 
    RAISE DEBUG 'The raise_test() function began.';
 
    an_integer = an_integer + 1;
 
     -- Raise a notice stating that the an_integer
     -- variable was changed, then raise another notice
     -- stating its new value.
 
    RAISE NOTICE 'Variable an_integer was changed.';
    RAISE NOTICE 'Variable an_integer value is now %.',an_integer;
 
     -- Raise an exception.
 
    RAISE EXCEPTION 'Variable % changed.  Aborting transaction.',an_integer;
 
  END;
$$;


ALTER FUNCTION public.raise_test() OWNER TO ingy;

--
-- Name: ship_item(text, text, text); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION ship_item(text, text, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
  DECLARE
    l_name ALIAS FOR $1;
    f_name ALIAS FOR $2;
    book_isbn ALIAS FOR $3;
    book_id INTEGER;
    customer_id INTEGER;
 
  BEGIN
 
    SELECT INTO customer_id get_customer_id(l_name,f_name);
 
    IF customer_id = -1 THEN
      RETURN -1;
    END IF;
 
    SELECT INTO book_id book_id FROM editions WHERE isbn = book_isbn;
 
    IF NOT FOUND THEN
      RETURN -1;
    END IF;
 
    PERFORM add_shipment(customer_id,book_isbn);
 
    RETURN 1;
  END;
$_$;


ALTER FUNCTION public.ship_item(text, text, text) OWNER TO ingy;

--
-- Name: stock_amount(integer, integer); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION stock_amount(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
  DECLARE
     -- Declare aliases for function arguments.
    b_id ALIAS FOR $1;
    b_edition ALIAS FOR $2;
     -- Declare variable to store the ISBN number.
    b_isbn TEXT;
     -- Declare variable to store the stock amount.
    stock_amount INTEGER;
  BEGIN
     -- This SELECT INTO statement retrieves the ISBN
     -- number of the row in the editions table that had
     -- both the book ID number and edition number that
     -- were provided as function arguments.
    SELECT INTO b_isbn isbn FROM editions WHERE
      book_id = b_id AND edition = b_edition;
 
     -- Check to see if the ISBN number retrieved
     -- is NULL.  This will happen if there is not an
     -- existing book with both the ID number and edition
     -- number specified in the function arguments.
     -- If the ISBN is null, the function returns a
     -- value of -1 and ends.
    IF b_isbn IS NULL THEN
      RETURN -1;
    END IF;
 
     -- Retrieve the amount of books available from the
     -- stock table and record the number in the
     -- stock_amount variable.
    SELECT INTO stock_amount stock FROM stock WHERE isbn = b_isbn;
 
     -- Return the amount of books available.
    RETURN stock_amount;
  END;
$_$;


ALTER FUNCTION public.stock_amount(integer, integer) OWNER TO ingy;

--
-- Name: sync_authors_and_books(); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION sync_authors_and_books() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF TG_OP = 'UPDATE' THEN
      UPDATE books SET author_id = new.id WHERE author_id = old.id; 
    END IF;
    RETURN new;
  END;
$$;


ALTER FUNCTION public.sync_authors_and_books() OWNER TO ingy;

--
-- Name: test(integer); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION test(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
  
 DECLARE 
   -- defines the variable as ALIAS
  variable ALIAS FOR $1;
 BEGIN
  -- displays the variable after multiplying it by two 
  return variable * 2.0;
 END; 
 $_$;


ALTER FUNCTION public.test(integer) OWNER TO ingy;

--
-- Name: test_check_a_id(); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION test_check_a_id() RETURNS opaque
    LANGUAGE plpgsql
    AS $$
    BEGIN
     -- checks to make sure the author id
     -- inserted is not left blank or less than 100

        IF NEW.a_id ISNULL THEN
           RAISE EXCEPTION
           'The author id cannot be left blank!';
        ELSE
           IF NEW.a_id < 100 THEN
              RAISE EXCEPTION
              'Please insert a valid author id.';
           ELSE
           RETURN NEW;
           END IF;
        END IF;
    END;
$$;


ALTER FUNCTION public.test_check_a_id() OWNER TO ingy;

--
-- Name: title(integer); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION title(integer) RETURNS text
    LANGUAGE sql
    AS $_$SELECT title from books where id = $1$_$;


ALTER FUNCTION public.title(integer) OWNER TO ingy;

--
-- Name: triple_price(double precision); Type: FUNCTION; Schema: public; Owner: ingy
--

CREATE FUNCTION triple_price(double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $_$
  DECLARE
     -- Declare input_price as an alias for the
     -- argument variable normally referenced with
     -- the $1 identifier.
    input_price ALIAS FOR $1;
 
  BEGIN
     -- Return the input price multiplied by three.
    RETURN input_price * 3;
  END;
 $_$;


ALTER FUNCTION public.triple_price(double precision) OWNER TO ingy;

--
-- Name: sum(text); Type: AGGREGATE; Schema: public; Owner: ingy
--

CREATE AGGREGATE sum(text) (
    SFUNC = textcat,
    STYPE = text,
    INITCOND = ''
);


ALTER AGGREGATE public.sum(text) OWNER TO ingy;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: alternate_stock; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE alternate_stock (
    isbn text,
    cost numeric(5,2),
    retail numeric(5,2),
    stock integer
);


ALTER TABLE public.alternate_stock OWNER TO ingy;

--
-- Name: author_ids; Type: SEQUENCE; Schema: public; Owner: ingy
--

CREATE SEQUENCE author_ids
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.author_ids OWNER TO ingy;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE authors (
    id integer NOT NULL,
    last_name text,
    first_name text
);


ALTER TABLE public.authors OWNER TO ingy;

--
-- Name: book_backup; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE book_backup (
    id integer,
    title text,
    author_id integer,
    subject_id integer
);


ALTER TABLE public.book_backup OWNER TO ingy;

--
-- Name: book_ids; Type: SEQUENCE; Schema: public; Owner: ingy
--

CREATE SEQUENCE book_ids
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.book_ids OWNER TO ingy;

--
-- Name: book_queue; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE book_queue (
    title text NOT NULL,
    author_id integer,
    subject_id integer,
    approved boolean
);


ALTER TABLE public.book_queue OWNER TO ingy;

--
-- Name: books; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE books (
    id integer NOT NULL,
    title text NOT NULL,
    author_id integer,
    subject_id integer
);


ALTER TABLE public.books OWNER TO ingy;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE customers (
    id integer NOT NULL,
    last_name text,
    first_name text
);


ALTER TABLE public.customers OWNER TO ingy;

--
-- Name: daily_inventory; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE daily_inventory (
    isbn text,
    is_stocked boolean
);


ALTER TABLE public.daily_inventory OWNER TO ingy;

--
-- Name: distinguished_authors; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE distinguished_authors (
    award text
)
INHERITS (authors);


ALTER TABLE public.distinguished_authors OWNER TO ingy;

--
-- Name: editions; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE editions (
    isbn text NOT NULL,
    book_id integer,
    edition integer,
    publisher_id integer,
    publication date,
    type character(1),
    CONSTRAINT integrity CHECK (((book_id IS NOT NULL) AND (edition IS NOT NULL)))
);


ALTER TABLE public.editions OWNER TO ingy;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE employees (
    id integer NOT NULL,
    last_name text NOT NULL,
    first_name text,
    CONSTRAINT employees_id CHECK ((id > 100))
);


ALTER TABLE public.employees OWNER TO ingy;

--
-- Name: favorite_authors; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE favorite_authors (
    employee_id integer,
    authors_and_titles text[]
);


ALTER TABLE public.favorite_authors OWNER TO ingy;

--
-- Name: favorite_books; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE favorite_books (
    employee_id integer,
    books text[]
);


ALTER TABLE public.favorite_books OWNER TO ingy;

--
-- Name: money_example; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE money_example (
    money_cash money,
    numeric_cash numeric(6,2)
);


ALTER TABLE public.money_example OWNER TO ingy;

--
-- Name: my_list; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE my_list (
    todos text
);


ALTER TABLE public.my_list OWNER TO ingy;

--
-- Name: numeric_values; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE numeric_values (
    num numeric(30,6)
);


ALTER TABLE public.numeric_values OWNER TO ingy;

--
-- Name: publishers; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE publishers (
    id integer NOT NULL,
    name text,
    address text
);


ALTER TABLE public.publishers OWNER TO ingy;

--
-- Name: shipments; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE shipments (
    id integer DEFAULT nextval(('"shipments_ship_id_seq"'::text)::regclass) NOT NULL,
    customer_id integer,
    isbn text,
    ship_date timestamp with time zone
);


ALTER TABLE public.shipments OWNER TO ingy;

--
-- Name: recent_shipments; Type: VIEW; Schema: public; Owner: ingy
--

CREATE VIEW recent_shipments AS
 SELECT count(*) AS num_shipped,
    max(shipments.ship_date) AS max,
    b.title
   FROM ((shipments
     JOIN editions USING (isbn))
     JOIN books b(book_id, title, author_id, subject_id) USING (book_id))
  GROUP BY b.title
  ORDER BY count(*) DESC;


ALTER TABLE public.recent_shipments OWNER TO ingy;

--
-- Name: schedules; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE schedules (
    employee_id integer NOT NULL,
    schedule text
);


ALTER TABLE public.schedules OWNER TO ingy;

--
-- Name: shipments_ship_id_seq; Type: SEQUENCE; Schema: public; Owner: ingy
--

CREATE SEQUENCE shipments_ship_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.shipments_ship_id_seq OWNER TO ingy;

--
-- Name: states; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE states (
    id integer NOT NULL,
    name text,
    abbreviation character(2)
);


ALTER TABLE public.states OWNER TO ingy;

--
-- Name: stock; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE stock (
    isbn text NOT NULL,
    cost numeric(5,2),
    retail numeric(5,2),
    stock integer
);


ALTER TABLE public.stock OWNER TO ingy;

--
-- Name: stock_backup; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE stock_backup (
    isbn text,
    cost numeric(5,2),
    retail numeric(5,2),
    stock integer
);


ALTER TABLE public.stock_backup OWNER TO ingy;

--
-- Name: stock_view; Type: VIEW; Schema: public; Owner: ingy
--

CREATE VIEW stock_view AS
 SELECT stock.isbn,
    stock.retail,
    stock.stock
   FROM stock;


ALTER TABLE public.stock_view OWNER TO ingy;

--
-- Name: subject_ids; Type: SEQUENCE; Schema: public; Owner: ingy
--

CREATE SEQUENCE subject_ids
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.subject_ids OWNER TO ingy;

--
-- Name: subjects; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE subjects (
    id integer NOT NULL,
    subject text,
    location text
);


ALTER TABLE public.subjects OWNER TO ingy;

--
-- Name: text_sorting; Type: TABLE; Schema: public; Owner: ingy; Tablespace: 
--

CREATE TABLE text_sorting (
    letter character(1)
);


ALTER TABLE public.text_sorting OWNER TO ingy;

--
-- Name: authors_pkey; Type: CONSTRAINT; Schema: public; Owner: ingy; Tablespace: 
--

ALTER TABLE ONLY authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: books_id_pkey; Type: CONSTRAINT; Schema: public; Owner: ingy; Tablespace: 
--

ALTER TABLE ONLY books
    ADD CONSTRAINT books_id_pkey PRIMARY KEY (id);


--
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: ingy; Tablespace: 
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: employees_pkey; Type: CONSTRAINT; Schema: public; Owner: ingy; Tablespace: 
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: pkey; Type: CONSTRAINT; Schema: public; Owner: ingy; Tablespace: 
--

ALTER TABLE ONLY editions
    ADD CONSTRAINT pkey PRIMARY KEY (isbn);


--
-- Name: publishers_pkey; Type: CONSTRAINT; Schema: public; Owner: ingy; Tablespace: 
--

ALTER TABLE ONLY publishers
    ADD CONSTRAINT publishers_pkey PRIMARY KEY (id);


--
-- Name: schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: ingy; Tablespace: 
--

ALTER TABLE ONLY schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (employee_id);


--
-- Name: state_pkey; Type: CONSTRAINT; Schema: public; Owner: ingy; Tablespace: 
--

ALTER TABLE ONLY states
    ADD CONSTRAINT state_pkey PRIMARY KEY (id);


--
-- Name: stock_pkey; Type: CONSTRAINT; Schema: public; Owner: ingy; Tablespace: 
--

ALTER TABLE ONLY stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (isbn);


--
-- Name: subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: ingy; Tablespace: 
--

ALTER TABLE ONLY subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: books_title_idx; Type: INDEX; Schema: public; Owner: ingy; Tablespace: 
--

CREATE INDEX books_title_idx ON books USING btree (title);


--
-- Name: shipments_ship_id_key; Type: INDEX; Schema: public; Owner: ingy; Tablespace: 
--

CREATE UNIQUE INDEX shipments_ship_id_key ON shipments USING btree (id);


--
-- Name: text_idx; Type: INDEX; Schema: public; Owner: ingy; Tablespace: 
--

CREATE INDEX text_idx ON text_sorting USING btree (letter);


--
-- Name: unique_publisher_idx; Type: INDEX; Schema: public; Owner: ingy; Tablespace: 
--

CREATE UNIQUE INDEX unique_publisher_idx ON publishers USING btree (name);


--
-- Name: sync_stock_with_editions; Type: RULE; Schema: public; Owner: ingy
--

CREATE RULE sync_stock_with_editions AS
    ON UPDATE TO editions DO  UPDATE stock SET isbn = new.isbn
  WHERE (stock.isbn = old.isbn);


--
-- Name: check_shipment; Type: TRIGGER; Schema: public; Owner: ingy
--

CREATE TRIGGER check_shipment BEFORE INSERT OR UPDATE ON shipments FOR EACH ROW EXECUTE PROCEDURE check_shipment_addition();


--
-- Name: sync_authors_books; Type: TRIGGER; Schema: public; Owner: ingy
--

CREATE TRIGGER sync_authors_books BEFORE UPDATE ON authors FOR EACH ROW EXECUTE PROCEDURE sync_authors_and_books();


--
-- Name: valid_employee; Type: FK CONSTRAINT; Schema: public; Owner: ingy
--

ALTER TABLE ONLY schedules
    ADD CONSTRAINT valid_employee FOREIGN KEY (employee_id) REFERENCES employees(id) MATCH FULL;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

