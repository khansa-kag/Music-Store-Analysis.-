
CREATE TABLE Albums (
    album_id INT PRIMARY KEY,
    title VARCHAR(300) NUll,
    artist_id INT NULL 
);
CREATE TABLE Artists (
    artist_id INT PRIMARY KEY,
    name VARCHAR(255) NULL
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    company VARCHAR(255) NULL,  -- Allows NULL values
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NULL,  -- Allows NULL values
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    fax VARCHAR(20) NULL,  -- Allows NULL values
    email VARCHAR(255) NOT NULL,
    support_rep_id INT NOT NULL
);
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    title VARCHAR(100) NOT NULL,
    reports_to INT,  -- No NULL indication in the data type but assuming it's nullable based on prior discussions
    levels VARCHAR(10) NOT NULL,
    birthdate DATE NOT NULL,  -- Assuming DATE type but your CSV still has string format for dates
    hire_date DATE NOT NULL,  -- Assuming DATE type
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    fax VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE Genres (
    genre_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Invoices (
    invoice_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    invoice_date DATE NOT NULL,
    billing_address VARCHAR(255) NOT NULL,
    billing_city VARCHAR(100) NOT NULL,
    billing_state VARCHAR(100) NULL,  -- Allows NULL values
    billing_country VARCHAR(100) NOT NULL,
    billing_postal_code VARCHAR(20) NOT NULL,
    total DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Invoice_Lines (
    invoice_line_id INT PRIMARY KEY,
    invoice_id INT NOT NULL,
    track_id INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL
);

CREATE TABLE Media_Types (
    media_type_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Playlists (
    playlist_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Playlist_Tracks (
    playlist_id INT NOT NULL,
    track_id INT NOT NULL,
    PRIMARY KEY (playlist_id, track_id)
);

CREATE TABLE Tracks (
    track_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique identifier for each track
    name VARCHAR(255) NOT NULL,  -- Name of the track
    album_id INT NOT NULL,  -- Foreign key to Albums table
    media_type_id INT NOT NULL,  -- Foreign key to Media_Types table
    genre_id INT NOT NULL,  -- Foreign key to Genres table
    composer VARCHAR(255),  -- Composer of the track, can be NULL
    milliseconds INT NOT NULL,  -- Duration of the track in milliseconds
    bytes INT NOT NULL,  -- Size of the track file in bytes
    unit_price DECIMAL(10, 2) NOT NULL  -- Price of the track
);

Truncate table employees;

-- Digital Music Store Analysis

Select * from albums;
select * from artists;
select * from customers;
select * from employees;
select * from genres;
select * from invoice_lines;
select * from invoices;
select * from media_types;
select * from playlist_tracks;
select * from playlists;
select * from tracks;

Truncate table tracks;

-- Music Store Analysis: 
-- Who is the senior most employee based on title job? 
Select * from employees;
Select * 
From employees 
order by levels desc
limit 1;

-- which countries have the most invoices? 
select * from invoices;
Select  billing_country, count(billing_country) as most_invoices
from invoices
group by  billing_country;

-- 3- What are the top 3 values of total invoice? 
select * from invoices;
Select customer_id, total
from invoices
order by total desc
Limit 3;

-- Which city has the best customers. 
select * from invoices;
Select  sum(total) as highest_sum_of_invoice_totals, billing_city
from  invoices
group by  billing_city
order by sum(total) desc;

select * from invoice_lines;
select * from customers;
 
 
 -- 5 Who is the best customer? The customer who spent the most money will be declared the best customer. 
 -- Write a query that returns the person who spent the most money. 
 
 Select * from customers; 
Select * from invoices;

Select c.customer_id, c.first_Name, c.last_name, sum(i.total) as total_spending
From customers c
Left join invoices i
on c.customer_id = i.customer_id
group by c.customer_id
order by sum(i.total) desc;


-- Moderate Level Questions: 
Select * from genres; # gener_id and name 1 rock 
select * from tracks;
Select * from invoice_lines;
Select * from invoices;
select * from customers;

Select c.customer_id, c.first_name, c.last_name, c.address, c.email, g.genre_id, g.name
from customers c
Inner join invoices i on c.customer_id= i.customer_id
Inner Join  invoice_lines L on L.invoice_id= i.customer_id
Inner join tracks t on t.track_id= L.invoice_id
Inner Join genres g on g.genre_id= t.genre_id
where g.name = 'Rock'
group by c.customer_id, c.first_name, c.last_name, c.address, g.genre_id, g.name
order by email Asc;

-- 2  Invite the artist who have written the most rock music in our data set. Retrun Artist Name, 
-- Total track count of the top 10 rock bands.
Select a.name as Artist_Name, Count(t.track_id) as Total_Track_Count, g.name as Genre_Name
from artists a 
Inner Join albums b on a.artist_id=b.artist_id
Inner Join tracks t on b.album_id= t.album_id
Inner Join genres g on g.genre_id= t.genre_id 
WHERE g.name LIKE 'Rock'
group by a.name, g.name 
order by Total_Track_Count desc
limit 10;
 
 
SELECT artists.artist_id, artists.name,COUNT(artists.artist_id) AS number_of_songs
FROM tracks
JOIN albums ON albums.album_id = tracks.album_id
JOIN artists ON artists.artist_id = albums.artist_id
JOIN genres ON genres.genre_id = tracks.genre_id
WHERE genres.name LIKE 'Rock'
GROUP BY artists.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;


Select * from artists;
select * from genres;
select * from tracks;
select * from albums;

Select Avg(milliseconds) from tracks;

Select track_id, name as track_name, milliseconds
from tracks
where milliseconds > (Select Avg(milliseconds) from tracks)
order by milliseconds desc;


-- Advance
-- Question 1 
Select * from customers;
select * from invoices;
select * from invoice_lines;
select * from artists;
select * from tracks;
select * from albums;

Select sum(L.unit_price*L.quantity) as Total_Money_Spent, c.customer_id, c.first_name as customer_name, a.name as Artist 
from customers c
Inner join invoices i on c.customer_id= i.customer_id 
Inner join invoice_lines L on L.invoice_id= i.invoice_id
Inner join tracks t on t.track_id = L.track_id
Inner join albums b on b.album_id = t.album_id
Inner join artists a on a.artist_id= b.artist_id
group by c.customer_id, c.first_name, a.name
order by Total_Money_Spent desc;
