CREATE DATABASE Supplier183;
USE Supplier183;
CREATE TABLE Supplier (
    SID INT PRIMARY KEY,
    Sname VARCHAR(30),
    City VARCHAR(30)
);
CREATE TABLE Partss (
    PID INT PRIMARY KEY,
    Pname VARCHAR(30),
    Color VARCHAR(20)
);
CREATE TABLE Catalog (
    SID INT,
    PID INT,
    Cost DECIMAL(10,2) CHECK(Cost >= 0),
    PRIMARY KEY(SID, PID),
    FOREIGN KEY(SID) REFERENCES Supplier(SID),
    FOREIGN KEY(PID) REFERENCES Parts(PID)
);
INSERT INTO Supplier VALUES
(1, 'Acme Widget Suppliers', 'Bangalore'),
(2, 'ABC Suppliers', 'Mumbai'),
(3, 'XYZ Suppliers', 'Delhi'),
(4, 'Global Suppliers', 'Chennai'),
(5, 'Best Parts', 'Bangalore');

INSERT INTO Partss VALUES
(01, 'Book', 'Red'),
(02, 'Pen', 'Blue'),
(03, 'Pencil', 'Red'),
(04, 'Scale', 'Green'),
(05, 'Mobile', 'Black');

INSERT INTO Catalog VALUES
(1, 01, 50),
(1, 02, 40),
(2, 03, 55),
(2, 05, 70),
(3, 04, 25),
(4, 04, 35),
(4, 05, 80);

select Pname
from Partss
where PID in (
select PID
from Catalog
);

SELECT Sname
FROM Supplier S
WHERE NOT EXISTS (
    SELECT *
    FROM Parts P
    WHERE P.Color = 'Red'
    AND NOT EXISTS (
        SELECT *
        FROM Catalog C
        WHERE C.SID = S.SID
        AND C.PID = P.PID
    )
);

SELECT Sname
FROM Supplier S
WHERE NOT EXISTS (
    SELECT *
    FROM Parts P
    WHERE NOT EXISTS (
        SELECT *
        FROM Catalog C
        WHERE C.SID = S.SID
        AND C.PID = P.PID
    )
);
SELECT DISTINCT SID
FROM Catalog C
WHERE Cost > (
    SELECT AVG(Cost)
    FROM Catalog
    WHERE PID = C.PID
);

SELECT Pname, Sname
FROM Partss P, Supplier S, Catalog C
WHERE P.PID = C.PID
AND S.SID = C.SID
AND C.Cost = (
    SELECT MAX(Cost)
    FROM Catalog
    WHERE PID = P.PID
);

SELECT Pname
FROM Partss
WHERE PID IN (
    SELECT PID
    FROM Catalog
    WHERE SID = (
        SELECT SID
        FROM Supplier
        WHERE Sname = 'Acme Widget Suppliers'
    )
);


SELECT Pname, Sname, Cost
FROM Partss P, Supplier S, Catalog C
WHERE P.PID = C.PID
AND S.SID = C.SID
AND Cost = (
    SELECT MAX(Cost)
    FROM Catalog
);

SELECT Sname
FROM Supplier S
WHERE NOT EXISTS (
    SELECT *
    FROM Catalog C
    WHERE C.SID = S.SID
    AND C.PID IN (
        SELECT PID
        FROM Partss
        WHERE Color = 'Red'
    )
);

SELECT Sname, SUM(Cost) 
FROM Supplier S, Catalog C
WHERE S.SID = C.SID
GROUP BY S.SID, Sname;

SELECT Sname
FROM Supplier
WHERE SID IN (
    SELECT SID
    FROM Catalog
    WHERE Cost < 20
    GROUP BY SID
    HAVING COUNT(PID) >= 2
);

SELECT Pname, Sname, Cost
FROM Partss P, Supplier S, Catalog C
WHERE P.PID = C.PID
AND S.SID = C.SID
AND Cost = (
    SELECT MIN(Cost)
    FROM Catalog
    WHERE PID = P.PID
);