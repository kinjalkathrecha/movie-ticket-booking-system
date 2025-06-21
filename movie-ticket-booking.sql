-- Step 1: Create the Database
CREATE DATABASE pr_133;

-- Step 2: Create the Tables

CREATE TABLE Customer (
    CustomerID INT identity(1,1) PRIMARY KEY ,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL
);

CREATE TABLE Movie (
    MovieID INT  identity(1,1) PRIMARY KEY ,
    Title VARCHAR(100) NOT NULL,
    Genre VARCHAR(50),
    Duration INT NOT NULL, -- Duration in minutes
    ReleaseDate DATE NOT NULL
);

CREATE TABLE Theater (
    TheaterID INT identity(1,1) PRIMARY KEY ,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    TotalSeats INT NOT NULL CHECK (TotalSeats > 0)
);

CREATE TABLE Showtime (
    ShowtimeID INT  identity(1,1) PRIMARY KEY ,
    MovieID INT NOT NULL,
    TheaterID INT NOT NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    FOREIGN KEY (MovieID) REFERENCES Movie(MovieID),
    FOREIGN KEY (TheaterID) REFERENCES Theater(TheaterID)
);

CREATE TABLE Booking (
    BookingID INT identity(1,1) PRIMARY KEY ,
    CustomerID INT NOT NULL,
    ShowtimeID INT NOT NULL,
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ShowtimeID) REFERENCES Showtime(ShowtimeID)
);

CREATE TABLE Seat (
    SeatID INT identity(1,1) PRIMARY KEY ,
    TheaterID INT NOT NULL,
    SeatNumber VARCHAR(10) NOT NULL,
    
    FOREIGN KEY (TheaterID) REFERENCES Theater(TheaterID),
    UNIQUE (TheaterID, SeatNumber) -- Ensures seat numbers are unique per theater
);

CREATE TABLE Ticket (
    TicketID INT identity(1,1) PRIMARY KEY ,
    BookingID INT NOT NULL,
    SeatID INT NOT NULL,
    Price DECIMAL(8,2) NOT NULL,
    TicketStatus VARCHAR(20) NOT NULL CHECK (TicketStatus IN ('Confirmed', 'Canceled')),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID),
    FOREIGN KEY (SeatID) REFERENCES Seat(SeatID)
);
-- Insert Data into Customer Table
INSERT INTO Customer (FirstName, LastName, Email, PhoneNumber) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890'),
('Alice', 'Smith', 'alice.smith@example.com', '2345678901'),
('Bob', 'Johnson', 'bob.johnson@example.com', '3456789012'),
('Emma', 'Brown', 'emma.brown@example.com', '4567890123'),
('Michael', 'Davis', 'michael.davis@example.com', '5678901234'),
('Sophia', 'Wilson', 'sophia.wilson@example.com', '6789012345');

-- Insert Data into Movie Table
INSERT INTO Movie (Title, Genre, Duration, ReleaseDate) VALUES
('Inception', 'Sci-Fi', 148, '2010-07-16'),
('Titanic', 'Romance', 195, '1997-12-19'),
('The Dark Knight', 'Action', 152, '2008-07-18'),
('Avengers: Endgame', 'Action', 181, '2019-04-26'),
('Frozen', 'Animation', 102, '2013-11-27'),
('The Lion King', 'Drama', 118, '1994-06-24');

-- Insert Data into Theater Table
INSERT INTO Theater (Name, Location, TotalSeats) VALUES
('IMAX Cinema', 'New York', 200),
('Regal Theater', 'Los Angeles', 150),
('AMC Theaters', 'Chicago', 180),
('Cineplex', 'Houston', 120),
('PVR Cinemas', 'San Francisco', 220),
('Landmark Theaters', 'Miami', 140);

-- Insert Data into Showtime Table
INSERT INTO Showtime (MovieID, TheaterID, StartTime, EndTime) VALUES
(1, 1, '2025-02-21 14:00:00', '2025-02-21 16:30:00'),
(2, 2, '2025-02-21 18:00:00', '2025-02-21 21:15:00'),
(3, 3, '2025-02-22 12:00:00', '2025-02-22 14:30:00'),
(4, 4, '2025-02-22 15:00:00', '2025-02-22 18:00:00'),
(5, 5, '2025-02-23 11:00:00', '2025-02-23 12:45:00'),
(6, 6, '2025-02-23 17:00:00', '2025-02-23 19:00:00');

-- Insert Data into Booking Table
INSERT INTO Booking (CustomerID, ShowtimeID, BookingDate) VALUES
(1, 1, '2025-02-20 10:00:00'),
(2, 2, '2025-02-20 12:30:00'),
(3, 3, '2025-02-21 09:45:00'),
(4, 4, '2025-02-21 14:15:00'),
(5, 5, '2025-02-22 08:00:00'),
(6, 6, '2025-02-22 16:00:00');

-- Insert Data into Seat Table
INSERT INTO Seat (TheaterID, SeatNumber) VALUES
(1, 'A1'),
(1, 'A2'),
(2, 'B1'),
(3, 'C1'),
(4, 'D1'),
(5, 'E1');

-- Insert Data into Ticket Table
INSERT INTO Ticket (BookingID, SeatID, Price, TicketStatus) VALUES
(1, 1, 12.50, 'Confirmed'),
(2, 3, 15.00, 'Confirmed'),
(3, 4, 10.00, 'Confirmed'),
(4, 5, 8.50, 'Canceled'),
(5, 6, 9.99, 'Confirmed'),
(6, 2, 11.00, 'Confirmed');


--Query.
--1.display movie table
SELECT * FROM Ticket;

--2.display theater table
SELECT TheaterID, Name, Location, TotalSeats FROM Theater;

--3.
SELECT s.ShowtimeID, m.Title, t.Name AS Theater, s.StartTime, s.EndTime 
FROM Showtime s
JOIN Movie m ON s.MovieID = m.MovieID
JOIN Theater t ON s.TheaterID = t.TheaterID
WHERE m.Title = 'Inception';

--4.
SELECT c.CustomerID, c.FirstName, c.LastName, c.Email, b.BookingID, s.StartTime
FROM Booking b
JOIN Customer c ON b.CustomerID = c.CustomerID
JOIN Showtime s ON b.ShowtimeID = s.ShowtimeID;

--5.
SELECT b.BookingID, c.FirstName, c.LastName, m.Title, t.Name AS Theater, s.StartTime, b.BookingDate
FROM Booking b
JOIN Customer c ON b.CustomerID = c.CustomerID
JOIN Showtime s ON b.ShowtimeID = s.ShowtimeID
JOIN Movie m ON s.MovieID = m.MovieID
JOIN Theater t ON s.TheaterID = t.TheaterID;

--6.
SELECT SeatID, SeatNumber
FROM Seat
WHERE TheaterID = 1 ;

--7.
SELECT m.Title, SUM(t.Price) AS TotalRevenue
FROM Ticket t
JOIN Booking b ON t.BookingID = b.BookingID
JOIN Showtime s ON b.ShowtimeID = s.ShowtimeID
JOIN Movie m ON s.MovieID = m.MovieID
WHERE t.TicketStatus = 'Confirmed'
GROUP BY m.Title;

--8.
SELECT th.Name AS Theater, COUNT(t.TicketID) AS TotalTickets
FROM Ticket t
JOIN Booking b ON t.BookingID = b.BookingID
JOIN Showtime s ON b.ShowtimeID = s.ShowtimeID
JOIN Theater th ON s.TheaterID = th.TheaterID
WHERE t.TicketStatus = 'Confirmed'
GROUP BY th.Name
ORDER BY TotalTickets DESC;

--9.
UPDATE Ticket 
SET Price = 20.00 
WHERE BookingID = 1;

--10.
DELETE FROM Booking WHERE BookingID = 4;

--11.
DELETE FROM Movie WHERE MovieID = 3;

--12.
SELECT c.CustomerID, c.FirstName, c.LastName, COUNT(b.BookingID) AS TotalBookings
FROM Booking b
JOIN Customer c ON b.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(b.BookingID) > 1;

--13.
SELECT DISTINCT m.Title, t.Name AS Theater
FROM Showtime s
JOIN Movie m ON s.MovieID = m.MovieID
JOIN Theater t ON s.TheaterID = t.TheaterID
WHERE t.Name = 'IMAX Cinema';

--14.
SELECT c.CustomerID, c.FirstName, c.LastName
FROM Customer c
LEFT JOIN Booking b ON c.CustomerID = b.CustomerID
WHERE b.BookingID IS NULL;

--stored procedure.
--1.Add a New Customer.
CREATE PROCEDURE AddCustomer
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @PhoneNumber VARCHAR(15)
AS
BEGIN
    INSERT INTO Customer (FirstName, LastName, Email, PhoneNumber)
    VALUES (@FirstName, @LastName, @Email, @PhoneNumber);

    PRINT 'Customer added successfully';
END;
--execute.
EXEC AddCustomer 'Ethan', 'Hunt', 'ethan.hunt@example.com', '7890123456';

--2.Book a ticket.
CREATE PROCEDURE BookaTicket
    @CustomerID INT,
    @ShowtimeID INT,
    @SeatID INT,
    @Price DECIMAL(8,2)
AS
BEGIN
    -- Check if the seat is already booked
    IF EXISTS (
        SELECT 1 FROM Ticket t
        JOIN Booking b ON t.BookingID = b.BookingID
        WHERE t.SeatID = @SeatID AND b.ShowtimeID = @ShowtimeID AND t.TicketStatus = 'Confirmed'
    )
    BEGIN
        PRINT 'Seat is already booked!';
        RETURN;
    END

    -- Insert booking
    INSERT INTO Booking (CustomerID, ShowtimeID)
    VALUES (@CustomerID, @ShowtimeID);

    -- Get the last inserted BookingID
    DECLARE @BookingID INT;
    SET @BookingID = (SELECT MAX(BookingID) FROM Booking);

    -- Insert ticket
    INSERT INTO Ticket (BookingID, SeatID, Price, TicketStatus)
    VALUES (@BookingID, @SeatID, @Price, 'Confirmed');

    PRINT 'Ticket booked!';
END;
EXEC BookaTicket 7, 7, 8, 200.00;
SELECT * FROM Booking;

--3.cancel booking
CREATE PROCEDURE CancelBooking
    @BookingID INT
AS
BEGIN
    BEGIN TRANSACTION;

    -- Check if the booking exists and is confirmed
    IF EXISTS (
        SELECT 1 
        FROM Ticket
        WHERE BookingID = @BookingID 
          AND TicketStatus = 'Confirmed'
    )
    BEGIN
        -- Update the ticket status to 'Canceled'
        UPDATE Ticket
        SET TicketStatus = 'Canceled'
        WHERE BookingID = @BookingID;

        -- Optional: Delete the ticket if you want to remove it completely
        DELETE FROM Ticket WHERE BookingID = @BookingID;

        -- Optional: Delete the booking if you want to remove it completely
        DELETE FROM Booking WHERE BookingID = @BookingID;

        COMMIT TRANSACTION;
        PRINT 'Booking canceled successfully';
    END
    ELSE
    BEGIN
        PRINT 'No confirmed booking found with the given BookingID';
        ROLLBACK TRANSACTION;
    END
END;
--execute.
EXEC CancelBooking 2;

--4. Update Ticket Price
CREATE PROCEDURE UpdateTicketPrice
    @TicketID INT,
    @NewPrice DECIMAL(8,2)
AS
BEGIN
    UPDATE Ticket
    SET Price = @NewPrice
    WHERE TicketID = @TicketID;

    PRINT 'Ticket price updated successfully';
END;
--execute.
EXEC UpdateTicketPrice 1, 25.00;

--5.Get Showtime Information for a Movie
CREATE PROCEDURE GetShowtimesForMovie
    @MovieTitle VARCHAR(100)
AS
BEGIN
    SELECT s.ShowtimeID, m.Title, t.Name AS Theater, s.StartTime, s.EndTime
    FROM Showtime s
    JOIN Movie m ON s.MovieID = m.MovieID
    JOIN Theater t ON s.TheaterID = t.TheaterID
    WHERE m.Title = @MovieTitle;
END;
--execute.
EXEC GetShowtimesForMovie 'Inception';

--functions.
--scalar
--1. Scalar-Valued Function: GetTotalRevenueForMovie
CREATE FUNCTION GetTotalRevenueForMovie (@MovieID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(10,2);
    
    SELECT @TotalRevenue = SUM(t.Price)
    FROM Ticket t
    JOIN Booking b ON t.BookingID = b.BookingID
    JOIN Showtime s ON b.ShowtimeID = s.ShowtimeID
    WHERE s.MovieID = @MovieID AND t.TicketStatus = 'Confirmed';
END;
SELECT MovieID, Title, dbo.GetTotalRevenueForMovie(MovieID) AS TotalRevenue
FROM Movie;
--2. Scalar-Valued Function: GetCustomerTotalBookings
CREATE FUNCTION GetCustomerTotalBookings (@CustomerID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalBookings INT;
    
    SELECT @TotalBookings = COUNT(*)
    FROM Booking
    WHERE CustomerID = @CustomerID;
END;
SELECT CustomerID, FirstName, LastName, dbo.GetCustomerTotalBookings(CustomerID) AS TotalBookings
FROM Customer;
--3. Table-Valued Function: GetShowtimesForMovie
CREATE FUNCTION GetShowtimesForMovie (@MovieTitle VARCHAR(100))
RETURNS TABLE
AS
RETURN
(
    SELECT s.ShowtimeID, m.Title, t.Name AS Theater, s.StartTime, s.EndTime
    FROM Showtime s
    JOIN Movie m ON s.MovieID = m.MovieID
    JOIN Theater t ON s.TheaterID = t.TheaterID
    WHERE m.Title = @MovieTitle
);
SELECT * FROM dbo.GetShowtimesForMovie('Inception');
--4. Table-Valued Function: GetConfirmedBookingsForCustomer
CREATE FUNCTION GetConfirmedBookingsForCustomer (@CustomerID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT b.BookingID, m.Title, t.Name AS Theater, s.StartTime, tk.TicketStatus, tk.Price
    FROM Booking b
    JOIN Showtime s ON b.ShowtimeID = s.ShowtimeID
    JOIN Movie m ON s.MovieID = m.MovieID
    JOIN Theater t ON s.TheaterID = t.TheaterID
    JOIN Ticket tk ON b.BookingID = tk.BookingID
    WHERE b.CustomerID = @CustomerID AND tk.TicketStatus = 'Confirmed'
);
SELECT * FROM dbo.GetConfirmedBookingsForCustomer(1);

--trigger
--1. Trigger to Automatically Set Account Creation Date
CREATE TRIGGER trg_SetCreationDate
ON Customer
AFTER INSERT
AS
BEGIN
    UPDATE Customer
    SET CreationDate = GETDATE()
    WHERE CustomerID IN (SELECT CustomerID FROM inserted);
END;
INSERT INTO Customer (FirstName, LastName) VALUES ('John', 'Doe');
SELECT * FROM Customer; 

--2. Trigger for Logging Deleted Customers
-- Create an Archive Table
CREATE TABLE Customer_Archive (
    CustomerID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DeletedDate DATETIME DEFAULT GETDATE()
);

-- Create the Trigger
CREATE TRIGGER trg_LogDeletedCustomers
ON Customer
AFTER DELETE
AS
BEGIN
    INSERT INTO Customer_Archive (CustomerID, FirstName, LastName)
    SELECT CustomerID, FirstName, LastName FROM deleted;
END;
DELETE FROM Customer WHERE CustomerID = 3;
SELECT * FROM Customer_Archive; -- Check the archive

--3.Trigger: Auto-Update Movie Genre if Null
CREATE TRIGGER trg_SetDefaultGenre
ON Movie
AFTER INSERT
AS
BEGIN
    UPDATE Movie
    SET Genre = 'Unknown'
    WHERE Genre IS NULL;
END;
INSERT INTO Movie (Title, Genre, Duration, ReleaseDate) 
VALUES ('Mystery Film', NULL, 120, '2025-06-15');

SELECT * FROM Movie WHERE Title = 'Mystery Film'; 

--cursor
--1.Cursor: Display All Customer Names One by One
DECLARE @FirstName VARCHAR(50), @LastName VARCHAR(50);

DECLARE CustomerNamesCursor CURSOR FOR
SELECT FirstName, LastName FROM Customer;

OPEN CustomerNamesCursor;
FETCH NEXT FROM CustomerNamesCursor INTO @FirstName, @LastName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Customer: ' + @FirstName + ' ' + @LastName;
    FETCH NEXT FROM CustomerNamesCursor INTO @FirstName, @LastName;
END;

CLOSE CustomerNamesCursor;
DEALLOCATE CustomerNamesCursor;

--2. Cursor: Print All Theater Names
DECLARE @TheaterName VARCHAR(100);

DECLARE TheaterCursor CURSOR FOR
SELECT Name FROM Theater;

OPEN TheaterCursor;
FETCH NEXT FROM TheaterCursor INTO @TheaterName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Theater: ' + @TheaterName;
    FETCH NEXT FROM TheaterCursor INTO @TheaterName;
END;

CLOSE TheaterCursor;
DEALLOCATE TheaterCursor;

--3.Cursor: Display All Customers with Their Phone Numbers
DECLARE @FirstName VARCHAR(50), @LastName VARCHAR(50), @PhoneNumber VARCHAR(15);

DECLARE CustomerCursor CURSOR FOR
SELECT FirstName, LastName, PhoneNumber FROM Customer;

OPEN CustomerCursor;
FETCH NEXT FROM CustomerCursor INTO @FirstName, @LastName, @PhoneNumber;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Customer: ' + @FirstName + ' ' + @LastName + ' - Phone: ' + @PhoneNumber;
    FETCH NEXT FROM CustomerCursor INTO @FirstName, @LastName, @PhoneNumber;
END;

CLOSE CustomerCursor;
DEALLOCATE CustomerCursor;

--exception handling
--1. Basic TRY...CATCH for Error Handling
BEGIN TRY
    INSERT INTO Customer (FirstName, LastName, Email, PhoneNumber)
    VALUES ('John', 'Doe', 'john.doe@example.com', '1234567890');
    
    PRINT 'Customer added successfully!';
END TRY
BEGIN CATCH
    PRINT 'Error: Unable to insert customer. Please check the details!';
END CATCH;

--2.Handling Division by Zero Exception
DECLARE @x INT = 10, @y INT = 0, @result INT;

BEGIN TRY
    SET @result = @x / @y;
    PRINT 'Result: ' + CAST(@result AS VARCHAR);
END TRY
BEGIN CATCH
    PRINT 'Error: Division by zero is not allowed!';
END CATCH;

--3.Using ERROR_NUMBER and ERROR_MESSAGE
BEGIN TRY
    -- Deleting a movie that does not exist
    DELETE FROM Movie WHERE MovieID = 999;
END TRY
BEGIN CATCH
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH;







