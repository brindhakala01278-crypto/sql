-- Create Database
CREATE DATABASE library_project_db;
USE library_project_db;

-- =============================
-- Category Table
-- =============================
CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

-- =============================
-- Book Table
-- =============================
CREATE TABLE Book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100),
    category_id INT,
    available_copies INT DEFAULT 1,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- =============================
-- Member Table
-- =============================
CREATE TABLE Member (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

-- =============================
-- Librarian Table
-- =============================
CREATE TABLE Librarian (
    librarian_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

-- =============================
-- Issue Record Table
-- =============================
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
    FOREIGN KEY (librarian_id) REFERENCES Librarian(librarian_id)
);

-- =============================
-- Activity Log Table
-- =============================
CREATE TABLE Activity_Log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    action VARCHAR(50),
    action_date DATE,
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

-- =============================
-- Sample Data (10 entries)
-- =============================

-- Categories
INSERT INTO Category (category_name) VALUES
('Fiction'), ('Science'), ('History'), ('Technology'), ('Education');

-- Books
INSERT INTO Book (title, author, category_id, available_copies) VALUES
('Book A','Author 1',1,5),
('Book B','Author 2',2,3),
('Book C','Author 3',3,4),
('Book D','Author 4',4,2),
('Book E','Author 5',5,6),
('Book F','Author 6',1,2),
('Book G','Author 7',2,3),
('Book H','Author 8',3,1),
('Book I','Author 9',4,5),
('Book J','Author 10',5,4);

-- Members
INSERT INTO Member (name, email, phone) VALUES
('Anu','anu@mail.com','1111111111'),
('Raj','raj@mail.com','2222222222'),
('Priya','priya@mail.com','3333333333'),
('Kumar','kumar@mail.com','4444444444'),
('Meena','meena@mail.com','5555555555'),
('Arun','arun@mail.com','6666666666'),
('Divya','divya@mail.com','7777777777'),
('Vijay','vijay@mail.com','8888888888'),
('Sneha','sneha@mail.com','9999999999'),
('Ravi','ravi@mail.com','1010101010');

-- Librarians
INSERT INTO Librarian (name, email) VALUES
('Lib1','lib1@mail.com'),
('Lib2','lib2@mail.com'),
('Lib3','lib3@mail.com');

-- Issue Records
INSERT INTO Issue_Record (book_id, member_id, librarian_id, issue_date, return_date, status) VALUES
(1,1,1,'2026-01-01','2026-01-10','Returned'),
(2,2,2,'2026-01-02',NULL,'Issued'),
(3,3,1,'2026-01-03','2026-01-12','Returned'),
(4,4,3,'2026-01-04',NULL,'Issued'),
(5,5,2,'2026-01-05','2026-01-15','Returned'),
(6,6,1,'2026-01-06',NULL,'Issued'),
(7,7,3,'2026-01-07','2026-01-17','Returned'),
(8,8,2,'2026-01-08',NULL,'Issued'),
(9,9,1,'2026-01-09','2026-01-18','Returned'),
(10,10,3,'2026-01-10',NULL,'Issued');

-- Activity Logs
INSERT INTO Activity_Log (member_id, book_id, action, action_date) VALUES
(1,1,'Borrowed','2026-01-01'),
(1,1,'Returned','2026-01-10'),
(2,2,'Borrowed','2026-01-02'),
(3,3,'Borrowed','2026-01-03'),
(3,3,'Returned','2026-01-12'),
(4,4,'Borrowed','2026-01-04'),
(5,5,'Borrowed','2026-01-05'),
(5,5,'Returned','2026-01-15'),
(6,6,'Borrowed','2026-01-06'),
(7,7,'Borrowed','2026-01-07');






create role admin_librarian;
GRANT  select,insert,update,delete on member to  admin_librarian;

SELECT * FROM librarian;
GRANT 'admin_librarian' TO 'lib1mail.com';

revoke admin_librarian from'lib1mail.com'