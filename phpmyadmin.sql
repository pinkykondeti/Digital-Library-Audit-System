

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
    ReturnDate DATE NULL,
    FOREIGN KEY (StudentID) REFERENCES Students1(StudentID),
    FOREIGN KEY (BookID) REFERENCES Books1(BookID)
);

INSERT INTO Books1 VALUES
(1, 'The Alchemist', 'Paulo Coelho', 'Fiction', 1988, 5),
(2, 'Physics Fundamentals', 'Halliday', 'Science', 2010, 3),
(3, 'World History', 'John Keegan', 'History', 2005, 4),
(4, 'Data Structures', 'Mark Allen', 'Technology', 2018, 6);

INSERT INTO Students1 VALUES
(101, 'Rahul Sharma', 'rahul@email.com', 'CSE', '2022-06-01', 'Active'),
(102, 'Priya Reddy', 'priya@email.com', 'ECE', '2021-08-15', 'Active'),
(103, 'Arjun Kumar', 'arjun@email.com', 'MBA', '2019-01-10', 'Active');

INSERT INTO IssuedBooks1 VALUES
(1, 101, 1, DATE_SUB(CURDATE(), INTERVAL 20 DAY), NULL),
(2, 102, 2, DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(3, 103, 3, DATE_SUB(CURDATE(), INTERVAL 30 DAY), NULL);

SELECT 
    s.StudentID,
    s.StudentName,
    b.Title,
    ib.IssueDate,
    DATEDIFF(CURDATE(), ib.IssueDate) AS DaysOverdue
FROM IssuedBooks1 ib
JOIN Students1 s ON ib.StudentID = s.StudentID
JOIN Books1 b ON ib.BookID = b.BookID
WHERE ib.ReturnDate IS NULL
AND DATEDIFF(CURDATE(), ib.IssueDate) > 14;

SELECT 
    b.Category,
    COUNT(*) AS TotalBorrows
FROM IssuedBooks1 ib
JOIN Books1 b ON ib.BookID = b.BookID
GROUP BY b.Category
ORDER BY TotalBorrows DESC;

ALTER TABLE Students1
ADD Status VARCHAR(20) DEFAULT 'Active';
UPDATE Students1 s
SET Status = 'Inactive'
WHERE NOT EXISTS (
    SELECT 1
    FROM IssuedBooks1 ib
    WHERE ib.StudentID = s.StudentID
    AND ib.IssueDate >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
);

SELECT 
    s.StudentName,
    b.Title,
    ib.IssueDate,
    DATEDIFF(CURDATE(), ib.IssueDate) AS TotalDays,
    CASE
        WHEN DATEDIFF(CURDATE(), ib.IssueDate) > 14
        THEN (DATEDIFF(CURDATE(), ib.IssueDate) - 14) * 5
        ELSE 0
    END AS PenaltyAmount
FROM IssuedBooks1 ib
JOIN Students1 s ON ib.StudentID = s.StudentID
JOIN Books1 b ON ib.BookID = b.BookID
WHERE ib.ReturnDate IS NULL;

