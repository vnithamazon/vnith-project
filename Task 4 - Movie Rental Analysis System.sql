CREATE TABLE rental_data (
    MOVIE_ID INTEGER,
    CUSTOMER_ID INTEGER,
    GENRE VARCHAR(50),
    RENTAL_DATE DATE,
    RETURN_DATE DATE,
    RENTAL_FEE NUMERIC(10,2)
);

INSERT INTO rental_data VALUES
(1, 101, 'Action', '2024-01-15', '2024-01-18', 5.99),
(2, 102, 'Comedy', '2024-01-16', '2024-01-19', 4.99),
(3, 103, 'Drama', '2024-01-17', '2024-01-20', 4.99),
(4, 104, 'Action', '2024-02-01', '2024-02-04', 5.99),
(5, 105, 'Horror', '2024-02-02', '2024-02-05', 4.99),
(6, 101, 'Drama', '2024-02-10', '2024-02-13', 4.99),
(7, 102, 'Action', '2024-02-15', '2024-02-18', 5.99),
(8, 103, 'Comedy', '2024-03-01', '2024-03-04', 4.99),
(9, 104, 'Drama', '2024-03-05', '2024-03-08', 4.99),
(10, 105, 'Action', '2024-03-10', '2024-03-13', 5.99),
(11, 101, 'Horror', '2024-03-15', '2024-03-18', 4.99),
(12, 102, 'Drama', '2024-03-20', '2024-03-23', 4.99),
(13, 103, 'Action', '2024-03-25', '2024-03-28', 5.99),
(14, 104, 'Comedy', '2024-03-28', '2024-03-31', 4.99),
(15, 105, 'Drama', '2024-03-30', '2024-04-02', 4.99);

SELECT 
    GENRE,
    MOVIE_ID,
    COUNT(*) as rental_count,
    SUM(RENTAL_FEE) as total_fees
FROM rental_data
GROUP BY ROLLUP(GENRE, MOVIE_ID)
ORDER BY GENRE, MOVIE_ID;

SELECT 
    GENRE,
    COUNT(*) as rental_count,
    SUM(RENTAL_FEE) as total_fees
FROM rental_data
GROUP BY ROLLUP(GENRE)
ORDER BY GENRE;

SELECT 
    GENRE,
    DATE_TRUNC('month', RENTAL_DATE) as rental_month,
    CUSTOMER_ID,
    COUNT(*) as rental_count,
    SUM(RENTAL_FEE) as total_fees
FROM rental_data
GROUP BY CUBE(GENRE, DATE_TRUNC('month', RENTAL_DATE), CUSTOMER_ID)
ORDER BY GENRE, rental_month, CUSTOMER_ID;

SELECT 
    MOVIE_ID,
    CUSTOMER_ID,
    RENTAL_DATE,
    RENTAL_FEE
FROM rental_data
WHERE GENRE = 'Action'
ORDER BY RENTAL_DATE;

SELECT 
    MOVIE_ID,
    CUSTOMER_ID,
    GENRE,
    RENTAL_DATE,
    RENTAL_FEE
FROM rental_data
WHERE GENRE IN ('Action', 'Drama')
AND RENTAL_DATE >= CURRENT_DATE - INTERVAL '3 months'
ORDER BY RENTAL_DATE;


SELECT 
    GENRE,
    DATE_TRUNC('month', RENTAL_DATE) as rental_month,
    COUNT(*) as rental_count,
    SUM(RENTAL_FEE) as total_fees,
    AVG(RENTAL_FEE) as avg_fee
FROM rental_data
GROUP BY GENRE, DATE_TRUNC('month', RENTAL_DATE)
ORDER BY GENRE, rental_month;

SELECT 
    CUSTOMER_ID,
    GENRE,
    COUNT(*) as rental_count,
    SUM(RENTAL_FEE) as total_spent
FROM rental_data
GROUP BY CUBE(CUSTOMER_ID, GENRE)
ORDER BY CUSTOMER_ID, GENRE;

SELECT 
    GENRE,
    AVG(RETURN_DATE - RENTAL_DATE) as avg_rental_duration,
    COUNT(*) as rental_count
FROM rental_data
GROUP BY GENRE
ORDER BY avg_rental_duration DESC;

SELECT 
    RENTAL_DATE,
    SUM(RENTAL_FEE) as daily_revenue,
    COUNT(*) as rental_count
FROM rental_data
GROUP BY RENTAL_DATE
ORDER BY RENTAL_DATE;

SELECT 
    DATE_TRUNC('month', RENTAL_DATE) as rental_month,
    GENRE,
    COUNT(*) as rental_count,
    RANK() OVER (PARTITION BY DATE_TRUNC('month', RENTAL_DATE) 
                 ORDER BY COUNT(*) DESC) as popularity_rank
FROM rental_data
GROUP BY DATE_TRUNC('month', RENTAL_DATE), GENRE
ORDER BY rental_month, rental_count DESC;
