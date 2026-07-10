
CREATE DATABASE digitallibrary;
USE digitallibrary;

CREATE TABLE Books1 (
    BookID INT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Author VARCHAR(150),
    Category VARCHAR(100),
    PublishedYear INT,
    AvailableCopies INT
);

CREATE TABLE Students1 (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(150) NOT NULL,
    Email VARCHAR(150),
    Department VARCHAR(100),
    JoinDate DATE,
    Status VARCHAR(20) DEFAULT 'Active'
);


CREATE TABLE IssuedBooks1 (
    IssueID INT PRIMARY KEY,
    StudentID INT,
    BookID INT,
    IssueDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students1(StudentID),
    FOREIGN KEY (BookID) REFERENCES Books1(BookID)
);



INSERT INTO Books1 VALUES
(1,'The Alchemist','Paulo Coelho','Fiction',1988,5),
(2,'Physics Fundamentals','Halliday','Science',2010,3),
(3,'World History','John Keegan','History',2005,4),
(4,'Data Structures','Mark Allen','Technology',2018,6),
(5,'Operating Systems','Galvin','Technology',2019,4),
(6,'Machine Learning','Tom Mitchell','Technology',2017,3),
(7,'Chemistry Basics','Brown','Science',2012,5);


INSERT INTO Students1 VALUES
(101,'Rahul Sharma','rahul@email.com','CSE','2022-06-01','Active'),
(102,'Priya Reddy','priya@email.com','ECE','2021-08-15','Active'),
(103,'Arjun Kumar','arjun@email.com','MBA','2019-01-10','Active'),
(104,'Sneha Rao','sneha@email.com','CSE','2020-02-20','Active'),
(105,'Rohit Verma','rohit@email.com','EEE','2018-07-15','Active');


INSERT INTO IssuedBooks1 VALUES
(1,101,1,DATE_SUB(CURDATE(),INTERVAL 20 DAY),NULL),
(2,102,2,DATE_SUB(CURDATE(),INTERVAL 10 DAY),DATE_SUB(CURDATE(),INTERVAL 2 DAY)),
(3,103,3,DATE_SUB(CURDATE(),INTERVAL 30 DAY),NULL),
(4,101,4,DATE_SUB(CURDATE(),INTERVAL 5 DAY),NULL),
(5,104,5,DATE_SUB(CURDATE(),INTERVAL 15 DAY),DATE_SUB(CURDATE(),INTERVAL 5 DAY)),
(6,101,6,DATE_SUB(CURDATE(),INTERVAL 3 DAY),NULL),
(7,102,7,DATE_SUB(CURDATE(),INTERVAL 7 DAY),NULL),
(8,103,4,DATE_SUB(CURDATE(),INTERVAL 4 YEAR),DATE_SUB(CURDATE(),INTERVAL 4 YEAR));



SELECT * FROM Books1;
SELECT * FROM Students1;
SELECT * FROM IssuedBooks1;

#overdue books report
SELECT
    s.StudentID,
    s.StudentName,
    b.Title,
    ib.IssueDate,
    DATEDIFF(CURDATE(), ib.IssueDate) AS DaysOverdue
FROM IssuedBooks1 ib
JOIN Students1 s
ON ib.StudentID = s.StudentID
JOIN Books1 b
ON ib.BookID = b.BookID
WHERE ib.ReturnDate IS NULL
AND DATEDIFF(CURDATE(), ib.IssueDate) > 14;

--most popular
SELECT
    b.Category,
    COUNT(*) AS TotalBorrows
FROM IssuedBooks1 ib
JOIN Books1 b
ON ib.BookID = b.BookID
GROUP BY b.Category
ORDER BY TotalBorrows DESC;

--inactive students
UPDATE Students1 s
SET Status='Inactive'
WHERE NOT EXISTS
(
    SELECT 1
    FROM IssuedBooks1 ib
    WHERE ib.StudentID=s.StudentID
    AND ib.IssueDate>=DATE_SUB(CURDATE(),INTERVAL 3 YEAR)
);

SELECT StudentID,StudentName,Status
FROM Students1;

--penality report
SELECT
    s.StudentName,
    b.Title,
    ib.IssueDate,
    DATEDIFF(CURDATE(), ib.IssueDate) AS TotalDays,
    CASE
        WHEN DATEDIFF(CURDATE(), ib.IssueDate) > 14
        THEN (DATEDIFF(CURDATE(), ib.IssueDate)-14)*5
        ELSE 0
    END AS PenaltyAmount
FROM IssuedBooks1 ib
JOIN Students1 s
ON ib.StudentID=s.StudentID
JOIN Books1 b
ON ib.BookID=b.BookID
WHERE ib.ReturnDate IS NULL;
