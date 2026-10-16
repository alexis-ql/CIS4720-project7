/* ==========================================================================
   students_db_backup.sql
   CIS 4720 Database Management and SQL

   WHAT THIS FILE IS
   A starter database for in_class_lab7b. It builds a schema called
   students_db holding one table of students, plus a view. The lab PCs are
   wiped every night, so a script like this one is how you get a working
   database back in a few seconds instead of typing it all again. The file
   is the database. The server is disposable.

   WHAT IT BUILDS
     1. A schema called students_db
     2. One table, STUDENT, with six columns and a primary key
     3. Five rows of data
     4. One view, STUDENT_GPA, showing just the names and the grade averages

   BEFORE YOU RUN IT
   The schema has to exist before VS Code can connect to it, and VS Code
   will not create one for you. Step 4 of the lab has you create it at the
   command prompt first. Do that step before you open VS Code.

   HOW TO RUN IT
   Open it in VS Code with SQLTools connected to students_db, then run the
   whole file. Lab7b walks you through it.

   READ THIS BEFORE YOU RUN IT A SECOND TIME
   Run it once and everything works. Run it twice and you get errors,
   because the table already exists and the rows are already there. Step 10
   of the lab explains which parts to comment out and why.
   ========================================================================== */


-- ======================================================================
-- SECTION 1. The schema
-- A schema is the container that holds your tables. CREATE DATABASE makes
-- one, and USE tells the server which one the statements below apply to.
-- ======================================================================

-- Create the schema. IF NOT EXISTS means this line is safe to run twice,
-- and safe to run even though you already made it at the command prompt.
CREATE DATABASE IF NOT EXISTS students_db;

-- Switch into it. Everything below lands inside this schema.
USE students_db;


-- ======================================================================
-- SECTION 2. The table
-- Each column gets a data type that fits what it holds:
--   INT           whole numbers, used here for the id
--   VARCHAR(30)   text up to 30 characters
--   DECIMAL(3,2)  a number with 1 digit before the point and 2 after,
--                 which is exactly the shape of a grade average
--   DATE          a real date, stored as YYYY-MM-DD
-- NOT NULL means the column may never be left empty.
-- PRIMARY KEY means student_id must be unique and may never be empty.
-- ======================================================================

-- CREATE TABLE STUDENT (
--     student_id  INT          NOT NULL,
--     first_name  VARCHAR(30)  NOT NULL,
--     last_name   VARCHAR(30)  NOT NULL,
--     major       VARCHAR(40),
--     gpa         DECIMAL(3,2),
--     enrolled_on DATE,
--     PRIMARY KEY (student_id)
-- );


-- ======================================================================
-- SECTION 3. The data
-- Five students. Two enrolled in the same term, which is useful later when
-- you start filtering on a date.
-- ======================================================================

-- INSERT INTO STUDENT VALUES (1,'Ana',   'Reyes', 'CIS',              3.75,'2025-08-25');
-- INSERT INTO STUDENT VALUES (2,'Marcus','Bell',  'Computer Science', 3.20,'2025-08-25');
-- INSERT INTO STUDENT VALUES (3,'Priya', 'Nair',  'Mathematics',      3.90,'2026-01-12');
-- INSERT INTO STUDENT VALUES (4,'Devon', 'Rao',   'CIS',              2.85,'2026-01-12');
-- INSERT INTO STUDENT VALUES (5,'Elena', 'Vargas','Business',         3.45,'2026-08-24');


-- ======================================================================
-- SECTION 4. The view
-- A view is a stored SELECT statement you can query as if it were a table.
-- This one shows only the names and the grade average, so anyone using it
-- cannot reach the id, the major or the enrollment date.
-- ======================================================================

-- CREATE VIEW STUDENT_GPA AS
-- SELECT first_name, last_name, gpa
-- FROM STUDENT;


-- ======================================================================
-- SECTION 5. Checks
-- These only read. They are safe to run as many times as you like, so
-- leave them switched on even after the first run.
-- ======================================================================

-- All five rows, straight from the table.
SELECT * FROM STUDENT;

-- The view, highest grade average first. Three columns, not six.
SELECT * FROM STUDENT_GPA ORDER BY gpa DESC;

-- Should come back as 5 students and an average of 3.43.
SELECT COUNT(*) AS students, ROUND(AVG(gpa), 2) AS average_gpa FROM STUDENT;

-- STUDENT is a BASE TABLE and STUDENT_GPA is a VIEW. SHOW TABLES on its
-- own does not tell them apart, which is why this one says FULL.
SHOW FULL TABLES;


-- ######################################################################
-- YOUR LAB7B WORK STARTS BELOW THIS LINE
--
-- Add your Chapter 5 statements under the headings below, in order. Put a
-- comment above every statement saying what it does, in your own words.
-- The comments are graded.
-- ######################################################################


-- STEP 11. Section 5.1, look at your schema

--shows which database I am using--
SELECT DATABASE() AS my_schema;

--shows the tables and views in the database--
SHOW FULL TABLES;


-- STEP 12. Section 5.2, look at the data types

--shows all the columns in the STUDENT table and their data types--
--also shows if a column can be null of if it is a primary key--
DESCRIBE STUDENT;


-- STEP 13. Section 5.3, create a table by copying with a subquery

--creates a table called STUDENT_COPY--
--and fills it in with the columns from STUDENT table--
CREATE TABLE STUDENT_COPY AS
SELECT student_id, first_name, last_name, gpa
FROM STUDENT;

--shows the structure of the created table--
--the sql command used to create it--
SHOW CREATE TABLE STUDENT_COPY;

-- STEP 14. Section 5.4, change the structure of the copy

--adds an "honors" column to the table--
ALTER TABLE STUDENT_COPY ADD COLUMN honors CHAR(1);

--changes the "last_name" column to allow up to 50 characters--
--and not accept nulls--
ALTER TABLE STUDENT_COPY MODIFY COLUMN last_name VARCHAR(50) NOT NULL;

--makes "student_id" the primary key--
ALTER TABLE STUDENT_COPY ADD PRIMARY KEY (student_id);

--shows all the columns in the STUDENT table and their data types--
--also shows if a column can be null or if it is a primary key--
--all changes from the previous steps are reflected--
DESCRIBE STUDENT_COPY;

--fails because it's adding an entry where the STUDENT_ID is 1,--
--yet there is already a row in the table with that ID number--
--because student_id is the primary key, it must be unique--
INSERT INTO STUDENT_COPY VALUES (1,'Duplicate','Row',0.00,NULL);

--removes the "honors" column from the table--
ALTER TABLE STUDENT_COPY DROP COLUMN honors;


-- STEP 15. Section 5.5, insert, update and delete a row

--adds a new entry--
--shows the new entry in the table--
INSERT INTO STUDENT_COPY VALUES (6,'Omar','Faruqi',3.10);
SELECT * FROM STUDENT_COPY WHERE student_id = 6;

--updates the gpa of the entry where student_id is 6 to 3.35--
UPDATE STUDENT_COPY SET gpa = 3.35 WHERE student_id = 6;
SELECT * FROM STUDENT_COPY WHERE student_id = 6;

--deletes the entry where student_id is 6--
--shows the number of rows left--
DELETE FROM STUDENT_COPY WHERE student_id = 6;
SELECT COUNT(*) AS rows_left FROM STUDENT_COPY;


-- STEP 16. Section 5.6, create a view and update through it

--creates a view with only students with a gpa that is at least 3.50--
CREATE VIEW HIGH_GPA AS
SELECT student_id, first_name, last_name, gpa
FROM STUDENT_COPY
WHERE gpa >= 3.50;

--shows the view that contains the students with a gpa greater than 3.50--
SELECT * FROM HIGH_GPA ORDER BY gpa DESC;

--shows the gpa of the student with student_id 1--
SELECT student_id, gpa FROM STUDENT_COPY WHERE student_id = 1;

--updates the gpa of the student to 3.95 in the view only--
UPDATE HIGH_GPA SET gpa = 3.95 WHERE student_id = 1;

--shows the updated gpa of the student with student_id 1--
SELECT student_id, gpa FROM STUDENT_COPY WHERE student_id = 1;

--creates a view that shows the number of students and their gpa--
CREATE VIEW GPA_SUMMARY AS
SELECT COUNT(*) AS n, ROUND(AVG(GPA), 2) AS avg_gpa
FROM STUDENT_COPY;

--fails because aggregated views can't be changed--
UPDATE GPA_SUMMARY SET avg_gpa = 4.00;



--PROJECT 7--

-- STEP 6 --

--creates the "course" table with 5 columns--
CREATE TABLE COURSE (
    course_id INT NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_title VARCHAR(50) NOT NULL,
    credits INT,
    dept VARCHAR(30),
    PRIMARY KEY (course_id)
);

--shows all the columns in the COURSE table and their data types--
--also shows if a column can be null or if it is a primary key--
DESCRIBE COURSE;


-- STEP 7 --

--adds 5 course records into the COURSE table--
INSERT INTO COURSE VALUES (101,'CIS4720','Database Management and SQL',3,'CIS');
INSERT INTO COURSE VALUES (102,'CIS2000','Intro to Programming',3,'CIS');
INSERT INTO COURSE VALUES (103,'MATH1600','Calculus I',4,'Mathematics');
INSERT INTO COURSE VALUES (104,'BUS2100','Principles of Management',3,'Business');
INSERT INTO COURSE VALUES (105,'CIS4850','Advanced Python',3,'CIS');

--displays all the rows in the COURSE table--
SELECT * FROM COURSE;


--STEP  8--

--creates the "enrollment" table with 4 columns--
CREATE TABLE ENROLLMENT (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    term VARCHAR(15),
    grade CHAR(1),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT (student_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);

--shows all the columns in the ENROLLMENT table and their data types--
--also shows if a column can be null or if it is a primary key--
DESCRIBE ENROLLMENT;


--STEP  9--

--adds 8 row entries into the ENROLLMENT table--
INSERT INTO ENROLLMENT VALUES (1,101,'Fall 2026','A');
INSERT INTO ENROLLMENT VALUES (1,102,'Fall 2026','B');
INSERT INTO ENROLLMENT VALUES (1,103,'Spring 2026','A');
INSERT INTO ENROLLMENT VALUES (2,101,'Fall 2026','B');
INSERT INTO ENROLLMENT VALUES (2,104,'Fall 2026','C');
INSERT INTO ENROLLMENT VALUES (3,101,'Fall 2026','A');
INSERT INTO ENROLLMENT VALUES (3,103,'Spring 2026','A');
INSERT INTO ENROLLMENT VALUES (4,102,'Fall 2026','C');


--displays the count of rows in the ENROLLMENT table--
SELECT COUNT(*) AS enrollment_rows FROM ENROLLMENT;

--the student_id 99 does not exist so it will fail--
--INSERT INTO ENROLLMENT VALUES (99,101,'Fall 2026','A');

--the course_id 999 does not exist so it will fail--
--INSERT INTO ENROLLMENT VALUES (1,999,'Fall 2026', 'A');

--fails because it violates the unique primary key rule--
--another entry with student_id as 1,--
--and course_id as 101 already exists--
--INSERT INTO ENROLLMENT VALUES (1,101,'Spring 2027','B');


--STEP 10--
--joins the tables STUDENT, ENROLLMENT, and COURSE with JOIN ON
SELECT s.first_name, s.last_name, c.course_code, c.course_title, e.term, e.grade
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id
ORDER BY s.last_name, c.course_code;


--STEP 11--
--combines the STUDENT and ENROLLMENT tables and displays--
--the number of courses taken per student--
SELECT s.first_name, s.last_name, COUNT(e.course_id) AS courses_taken
FROM STUDENT s
LEFT JOIN ENROLLMENT e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY courses_taken DESC, s.last_name;

--uses a LEFT JOIN to keep all the courses
--and IS NULL to find unmatched enrollments
SELECT c.course_code, c.course_title
FROM COURSE c
LEFT JOIN ENROLLMENT e ON c.course_id = e.course_id
WHERE e.student_id IS NULL;


--STEP 12--
--creates a view joining the tables STUDENT, ENROLLMENT, COURSE with JOIN ON
CREATE VIEW STUDENT_SCHEDULE AS
SELECT s.first_name, s.last_name, c.course_code, c.course_title, e.term, e.grade
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id;

--displays entire view--
SELECT * FROM STUDENT_SCHEDULE;

--displays from the view only the rows that have "Reyes" in the last_name column
SELECT * FROM STUDENT_SCHEDULE WHERE last_name = 'Reyes';

--displays from the view only the rows that have "CIS4720" in the course_code column
SELECT * FROM STUDENT_SCHEDULE WHERE course_code = 'CIS4720';


--STEP 13--
--creates a view showing how many students are enrolled in each course
CREATE VIEW COURSE_HEADCOUNT AS
SELECT c.course_code, c.course_title,
        COUNT(e.student_id) AS students_enrolled
FROM COURSE c
LEFT JOIN ENROLLMENT e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title;

--displays courses by amount of students enrolled
SELECT * FROM COURSE_HEADCOUNT ORDER BY students_enrolled DESC;

--displays all the tables and views in the database
SHOW FULL TABLES;

--fails becuase students_enrolled is a calculated value
UPDATE COURSE_HEADCOUNT SET students_enrolled = 99 WHERE course_code = 'CIS4720';

