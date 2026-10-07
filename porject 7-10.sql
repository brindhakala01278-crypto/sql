use library_project_db;

select * from activity_log;
select * from book;
select * from category;
select * from issue_record;
select * from librarian;
select * from member;


-- create the table
CREATE TABLE Issue_Record (
    issue_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    member_id INT,
    librarian_id INT,
    issue_date DATE,
    return_date DATE,
    status VARCHAR(50) DEFAULT 'Issued',
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (librarian_id) REFERENCES Librarian(librarian_id));
    
    -- add column
    alter table member add column aadhar_card int unique;
    
    desc member;
-- modify
alter table member modify phone varchar(10);

-- add constraint  (unique)
ALTER TABLE Member
ADD CONSTRAINT unique_email UNIQUE (email);

-- check constraint
ALTER TABLE Book
ADD CONSTRAINT chk_copies
CHECK (available_copies >= 0);



-- role grank  and revoke
create role admin_librarian;
GRANT  select,insert,update,delete on member to  admin_librarian;

SELECT * FROM librarian;
GRANT 'admin_librarian' TO 'lib1mail.com';

revoke admin_librarian from'lib1mail.com';

-- drop
alter table member drop  aadhar_card;


-- commit,rollback,save point
START TRANSACTION;
INSERT INTO Issue_Record (book_id, member_id, librarian_id, issue_date, status)
VALUES (1, 2, 1, CURDATE(), 'Issued');
SAVEPOINT after_issue;
UPDATE Book
SET available_copies = available_copies - 1
WHERE book_id = 1;
ROLLBACK TO after_issue;
COMMIT;

-- Temporary Table

CREATE TEMPORARY TABLE temp_member_activity AS
SELECT member_id, COUNT(*) AS total_issues
FROM Issue_Record
GROUP BY member_id;
SELECT *
FROM temp_member_activity
WHERE total_issues > 2;

-- share lock 
START TRANSACTION;

SELECT available_copies
FROM Book
WHERE book_id = 1
LOCK IN SHARE MODE;


-- EXCLUSE LOCK
START TRANSACTION;

SELECT *
FROM Book
WHERE book_id = 1
FOR UPDATE;

-- Decide whether to issue book

COMMIT;

-- view
CREATE VIEW view_issued_books AS
SELECT 
    m.name AS member_name,
    b.title AS book_title,
    i.issue_date,
    i.status
FROM Issue_Record i
JOIN Member m ON i.member_id = m.member_id
JOIN Book b ON i.book_id = b.book_id;

-- Issue Book (IN + OUT + Logic )

DELIMITER //
CREATE PROCEDURE issue_book (
    IN p_book_id INT,
    IN p_member_id INT,
    OUT p_message VARCHAR(100)
)
BEGIN
    DECLARE copies INT;

    SELECT available_copies INTO copies
    FROM Book
    WHERE book_id = p_book_id;

    IF copies > 0 THEN
        INSERT INTO Issue_Record (book_id, member_id, issue_date, status)
        VALUES (p_book_id, p_member_id, CURDATE(), 'Issued');

        UPDATE Book
        SET available_copies = available_copies - 1
        WHERE book_id = p_book_id;

        SET p_message = 'Book Issued Successfully';
    ELSE
        SET p_message = 'Book Not Available';
    END IF;
END //

DELIMITER ;

-- Example 2: Increase Copies After Return 

DELIMITER //

CREATE TRIGGER trg_after_return
AFTER UPDATE ON Issue_Record
FOR EACH ROW
BEGIN
    IF NEW.status = 'Returned' THEN
        UPDATE Book
        SET available_copies = available_copies + 1
        WHERE book_id = NEW.book_id;
    END IF;
END //

DELIMITER ;