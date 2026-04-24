📚 Digital Library Audit System

--Overview

The Digital Library Audit System is a SQL-based project designed to manage and analyze book borrowing activities in a college library. It helps track issued books, identify overdue returns, calculate penalties, and detect inactive students.

-- Features

1.Book and student management
2.Track issued and returned books
3.Identify overdue books (beyond 14 days)
4.Calculate penalty for late returns
5.Analyze most popular book categories
6.Detect inactive students (no activity in last 3 years)

-- Database Schema

-Books1

| Column          | Type     |
| --------------- | -------- |
| BookID          | INT (PK) |
| Title           | VARCHAR  |
| Author          | VARCHAR  |
| Category        | VARCHAR  |
| PublishedYear   | INT      |
| AvailableCopies | INT      |

-Students1

| Column      | Type     |
| ----------- | -------- |
| StudentID   | INT (PK) |
| StudentName | VARCHAR  |
| Email       | VARCHAR  |
| Department  | VARCHAR  |
| JoinDate    | DATE     |
| Status      | VARCHAR  |

-IssuedBooks1

| Column     | Type     |
| ---------- | -------- |
| IssueID    | INT (PK) |
| StudentID  | INT (FK) |
| BookID     | INT (FK) |
| IssueDate  | DATE     |
| ReturnDate | DATE     |

Setup Instructions

 1. Install MySQL

Download and install MySQL from:
https://dev.mysql.com/downloads/

 2. Create Database

CREATE DATABASE digitallibrary;
USE digitallibrary;

 3. Run SQL File

Execute the provided '.sql' file:

SOURCE digital_library_audit_final.sql;

--Key Queries

-Overdue Books

SELECT s.StudentName, b.Title, DATEDIFF(CURDATE(), ib.IssueDate) AS DaysOverdue

FROM IssuedBooks1 ib

JOIN Students1 s ON ib.StudentID = s.StudentID

JOIN Books1 b ON ib.BookID = b.BookID

WHERE ib.ReturnDate IS NULL

AND DATEDIFF(CURDATE(), ib.IssueDate) > 14;

-Popular Categories

SELECT b.Category, COUNT(*) AS TotalBorrows

FROM IssuedBooks1 ib

JOIN Books1 b ON ib.BookID = b.BookID

GROUP BY b.Category

ORDER BY TotalBorrows DESC;

-Inactive Students


UPDATE Students1 s

SET Status = 'Inactive'

WHERE NOT EXISTS (
    SELECT 1
    FROM IssuedBooks1 ib
    WHERE ib.StudentID = s.StudentID
    AND ib.IssueDate >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
);

-Penalty Calculation

SELECT 
    s.StudentName,
    b.Title,
    CASE
        WHEN DATEDIFF(CURDATE(), ib.IssueDate) > 14
        THEN (DATEDIFF(CURDATE(), ib.IssueDate) - 14) * 5
        ELSE 0
    END AS PenaltyAmount
    
FROM IssuedBooks1 ib

JOIN Students1 s ON ib.StudentID = s.StudentID

JOIN Books1 b ON ib.BookID = b.BookID

WHERE ib.ReturnDate IS NULL;

--Concepts Used

1. SQL DDL (CREATE, ALTER)
2. SQL DML (INSERT, UPDATE)
3. JOINS (INNER JOIN)
4. Aggregate Functions (COUNT)
5. GROUP BY & ORDER BY
6. Subqueries (NOT EXISTS)
7. Date Functions (DATEDIFF, CURDATE)

--Learning Outcome

This project demonstrates:

1. Real-world database design
2. Business logic implementation using SQL
3. Data analysis using queries
4. Safe data handling practices

Future Enhancements

1. Add fine payment tracking
2. Build frontend (React / HTML/CSS)
3. Create backend (Node.js / Flask)
3. Add authentication system

👨‍💻 Author

Developed this project as part of my learning
