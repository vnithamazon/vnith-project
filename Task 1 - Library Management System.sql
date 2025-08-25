CREATE TABLE Books (
    BOOK_ID INT PRIMARY KEY,
    TITLE VARCHAR(100) NOT NULL,
    AUTHOR VARCHAR(100) NOT NULL,
    GENRE VARCHAR(50),
    YEAR_PUBLISHED INT,
    AVAILABLE_COPIES INT DEFAULT 0
);

CREATE TABLE Members (
    MEMBER_ID INT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE,
    PHONE_NO VARCHAR(20),
    ADDRESS TEXT,
    MEMBERSHIP_DATE DATE
);

CREATE TABLE BorrowingRecords (
    BORROW_ID INT PRIMARY KEY,
    MEMBER_ID INT,
    BOOK_ID INT,
    BORROW_DATE DATE,
    RETURN_DATE DATE,
    FOREIGN KEY (MEMBER_ID) REFERENCES Members(MEMBER_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES Books(BOOK_ID)
);

INSERT INTO Books VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925, 3),
(2, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 2),
(3, 'A Brief History of Time', 'Stephen Hawking', 'Science', 1988, 1),
(4, 'Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 4),
(5, 'The Art of War', 'Sun Tzu', 'Philosophy', 1910, 2);

INSERT INTO Members VALUES
(1, 'John Doe', 'john@email.com', '1234567890', '123 Main St', '2023-01-01'),
(2, 'Jane Smith', 'jane@email.com', '2345678901', '456 Oak Ave', '2023-02-15'),
(3, 'Bob Wilson', 'bob@email.com', '3456789012', '789 Pine Rd', '2023-03-20'),
(4, 'Alice Brown', 'alice@email.com', '4567890123', '321 Elm St', '2023-04-05'),
(5, 'Charlie Davis', 'charlie@email.com', '5678901234', '654 Maple Dr', '2023-05-10');

INSERT INTO BorrowingRecords VALUES
(1, 1, 1, '2023-06-01', '2023-06-15'),
(2, 2, 3, '2023-06-10', NULL),
(3, 3, 2, '2023-06-15', '2023-06-30'),
(4, 1, 4, '2023-07-01', NULL),
(5, 4, 5, '2023-07-05', '2023-07-20');

SELECT b.TITLE, br.BORROW_DATE FROM Books b JOIN BorrowingRecords br ON b.BOOK_ID = br.BOOK_ID WHERE br.MEMBER_ID = 1 AND br.RETURN_DATE IS NULL;

SELECT m.NAME, b.TITLE, br.BORROW_DATE FROM Members m JOIN BorrowingRecords br ON m.MEMBER_ID = br.MEMBER_ID JOIN Books b ON br.BOOK_ID = b.BOOK_ID WHERE br.RETURN_DATE IS NULL AND DATEDIFF(CURRENT_DATE, br.BORROW_DATE) > 30;

SELECT GENRE, SUM(AVAILABLE_COPIES) as TOTAL_AVAILABLE FROM Books GROUP BY GENRE;

SELECT b.TITLE, COUNT(*) as BORROW_COUNT FROM Books b JOIN BorrowingRecords br ON b.BOOK_ID = br.BOOK_ID GROUP BY b.BOOK_ID, b.TITLE ORDER BY BORROW_COUNT DESC LIMIT 1;

SELECT m.NAME, COUNT(DISTINCT b.GENRE) as GENRE_COUNT FROM Members m JOIN BorrowingRecords br ON m.MEMBER_ID = br.MEMBER_ID JOIN Books b ON br.BOOK_ID = b.BOOK_ID GROUP BY m.MEMBER_ID, m.NAME HAVING GENRE_COUNT >= 3;

SELECT DATE_FORMAT(BORROW_DATE, '%Y-%m') as MONTH, COUNT(*) as TOTAL_BORROWED FROM BorrowingRecords GROUP BY MONTH ORDER BY MONTH;

SELECT m.NAME, COUNT(*) as BORROW_COUNT FROM Members m JOIN BorrowingRecords br ON m.MEMBER_ID = br.MEMBER_ID GROUP BY m.MEMBER_ID, m.NAME ORDER BY BORROW_COUNT DESC LIMIT 3;

SELECT b.AUTHOR, COUNT(*) as BORROW_COUNT FROM Books b JOIN BorrowingRecords br ON b.BOOK_ID = br.BOOK_ID GROUP BY b.AUTHOR HAVING BORROW_COUNT >= 10;

SELECT m.NAME FROM Members m LEFT JOIN BorrowingRecords br ON m.MEMBER_ID = br.MEMBER_ID WHERE br.BORROW_ID IS NULL;
