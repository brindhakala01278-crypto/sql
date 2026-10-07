-- when using the database
use library_project_db;

-- show tha alldatabse in in schemas u created
 show databases;
 
 -- to view the all the tables in database
 show tables;
 
 -- manager want to all records of activity_log
 select * from activity_log ;
 
-- librarian need only issued_id ,membber_id,status.
select issue_id,member_id,status from issue_record;


-- libraian want to see the  issue_records libarian_id was 2
select * from issue_record;
select * from issue_record where librarian_id = 2;

-- libraian want to see  date isse the book '2026-01-01' AND '2026-01-10';
SELECT *FROM Activity_Log
WHERE action_date BETWEEN '2026-01-01' AND '2026-01-10';

-- the librarian want to see  category_id= 3. copies>2
select * from  book;

select * from book where   category_id = 3 and available_copies >2;

-- labrarian  how the name  _ee other  don't know
select * from member where name like '_ee%';

-- maniteness Author 1, Author 2, Author 7 ,Author 10
select * from book;
select * from book where author in('Author 7','Author 2','Author 10','Author 1');

-- labrarian  want now to return_date was null
select * from issue_record where return_date is null;

select * from  member where upper(name)= 'kUMar';
-- librarian  email  left 9 
select name, left(email,9) from member ;

-- data formating
select book_id,librarian_id,member_id, date_format(issue_date,'%M,%d,%y') 
as issue_date from issue_record;

-- select ,from,where,group by,having,ordey by ,limit  
SELECT 
    m.name,
    COUNT(i.issue_id) AS total_books
FROM Member m
JOIN Issue_Record i 
    ON m.member_id = i.member_id
WHERE i.issue_date BETWEEN '2026-01-01' AND '2026-01-10'
GROUP BY m.member_id, m.name
HAVING COUNT(i.issue_id) > 1
ORDER BY total_books DESC
LIMIT 5;

-- inner join
SELECT m.name, b.title, a.action, a.action_date
FROM Activity_Log a
INNER JOIN Member m ON a.member_id = m.member_id
INNER JOIN Book b ON a.book_id = b.book_id;

-- left join
SELECT b.title, i.issue_id
FROM Book b
LEFT JOIN Issue_Record i ON b.book_id = i.book_id;

-- right join
SELECT m.name, i.issue_id, i.issue_date
FROM Member m
RIGHT JOIN Issue_Record i
    ON m.member_id = i.member_id;
    
-- full join
SELECT m.name, i.issue_id
FROM Member m
LEFT JOIN Issue_Record i 
    ON m.member_id = i.member_id
UNION
SELECT m.name, i.issue_id
FROM Member m
RIGHT JOIN Issue_Record i 
    ON m.member_id = i.member_id limit 2;

-- count function
select librarian_id,count(return_date) ,count(*)from  issue_record 
group by librarian_id;


-- join group by having
SELECT m.name, COUNT(i.issue_id) AS total_books
FROM Member m
JOIN Issue_Record i 
    ON m.member_id = i.member_id
WHERE i.issue_date BETWEEN '2026-01-01' AND '2026-01-10'
GROUP BY m.member_id, m.name
HAVING COUNT(i.issue_id) >= 1;


-- scalar subqueries
SELECT title, available_copies
FROM Book
WHERE available_copies > (
    SELECT AVG(available_copies)
    FROM Book
);



--- join of scalar subqueries
SELECT m.name, b.title, i.issue_date
FROM Issue_Record i
JOIN Member m ON i.member_id = m.member_id
JOIN Book b ON i.book_id = b.book_id
WHERE i.issue_date = (
    SELECT MAX(issue_date)
    FROM Issue_Record);


-- Correlated Subquery 

SELECT name
FROM Member m
WHERE (
    SELECT COUNT(*)
    FROM Issue_Record i
    WHERE i.member_id = m.member_id
) > 1;


-- tabular subqueries 
SELECT *
FROM Issue_Record
WHERE (book_id, member_id) IN (
    SELECT book_id, member_id
    FROM Issue_Record
    WHERE status = 'Issued');
    
    
    -- insert
INSERT INTO Book (title, author, category_id, available_copies)
VALUES 
('SQL Basics', 'John Doe', 1, 5),
('Advanced MySQL', 'Jane Smith', 2, 3),
('Data Science Intro', 'David Lee', 3, 4);

-- update
UPDATE Book
SET available_copies = available_copies + 2
WHERE available_copies < 3;


-- delete
/* DELETE FROM Issue_Record
WHERE status = 'Returned';*/


-- indexing
CREATE INDEX idx_book_title
ON Book(title);
