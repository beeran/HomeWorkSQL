use sakila

# 1a
SELECT 
    first_name, last_name
FROM
    actor;

# 1b
select concat(first_name, " ", last_name) as 'Actor Name'
from actor;

#SELECT 
#    CONCAT(CONCAT(first_name, " "), last_name) AS 'Actor Name'
#FROM
#    actor;
    
# 2a
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'Joe';
    
# 2b
select *
from actor
where last_name like '%gen%'
order by last_name, first_name;

# 2c
select last_name, first_name
from actor
where last_name like '%LI%';
#or use order by last_name, first_name

# 2d
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');

# 3a
alter table actor
add column description BLOB;
SELECT 
    *
FROM
    actor;
#BLOB: binary large object, does not hold characters

# 3b
alter table actor
drop column description;
SELECT 
    *
FROM
    actor;
    
# 4a
SELECT 
    last_name, COUNT(last_name) AS count
FROM
    actor
GROUP BY (last_name);

# 4b
SELECT 
    last_name, COUNT(last_name) AS count
FROM
    actor
GROUP BY (last_name)
HAVING COUNT(last_name) > 1;

# 4c 
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';

# 4d
SELECT 
    *
FROM
    actor
WHERE
    first_name = 'HARPO';
    
UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO';

#To verify the result:
SELECT 
    *
FROM
    actor
WHERE
    first_name = 'GROUCHO';   
    
# 5a
show create table address;
#describe address;

# 6a
SELECT 
    s.first_name, s.last_name, a.address
FROM
    staff AS s
        INNER JOIN
    address AS a USING (address_id);
#or using below, on has to go with x=y
#inner join address as a on
#s.address_id = a.address_id;

# 6b
SELECT 
    s.first_name,
    s.last_name,
    SUM(p.amount) AS 'Amount Aug 2005'
FROM
    payment AS p
        INNER JOIN
    staff AS s USING (staff_id)
WHERE
    p.payment_date LIKE '%2005-08%'
GROUP BY p.staff_id;

# 6c
SELECT 
    f.film_id, f.title, COUNT(a.actor_id) AS 'Number of actors'
FROM
    film AS f
        INNER JOIN
    film_actor AS a USING (film_id)
GROUP BY a.actor_id

# 6d
SELECT 
    COUNT(film_id) AS 'Hunchback Impossible Inventory Count'
FROM
    inventory
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible')
            
# 6e
SELECT 
    c.first_name,
    c.last_name,
    sum(p.amount) AS 'Total Amount Paid'
FROM
    payment AS p
        INNER JOIN
    customer AS c USING (customer_id)
GROUP BY p.customer_id
order by c.last_name;

# 7a
SELECT 
    title
FROM
    film
WHERE
    language_id IN (SELECT 
            language_id
        FROM
            language
        WHERE
            name = 'English')
        AND title LIKE 'K%'
        OR title LIKE 'Q%';

# 7b
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'))
                    
# 7c
SELECT 
    c.first_name, c.last_name, c.email
FROM
    customer AS c
        INNER JOIN
    address USING (address_id)
        INNER JOIN
    city USING (city_id)
        INNER JOIN
    country USING (country_id)
WHERE
    country.country = 'Canada';
/*

SELECT 
    first_name, last_name, email
FROM
    customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    city
                WHERE
                    country_id IN (SELECT 
                            country_id
                        FROM
                            country
                        WHERE
                            country = 'Canada')));
*/

# 7d
SELECT 
    title AS 'Family Movies'
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'Family'));
                    
# 7e 
SELECT 
    f.title, COUNT(i.film_id) AS 'Rental Count'
FROM
    film AS f
        INNER JOIN
    inventory AS i USING (film_id)
        INNER JOIN
    rental USING (inventory_id)
GROUP BY f.title
ORDER BY COUNT(i.film_id) DESC;

# 7f
SELECT 
    s.store_id, SUM(p.amount) AS 'Total Amount'
FROM
    payment AS p
        INNER JOIN
    staff AS s USING (staff_id)
GROUP BY p.staff_id;                    

# 7g
SELECT 
    s.store_id, c.city, country.country
FROM
    store AS s
        INNER JOIN
    address AS a USING (address_id)
        INNER JOIN
    city AS c USING (city_id)
        INNER JOIN
    country USING (country_id);
    
# 7h
SELECT 
    c.name AS 'Top Five Genres',
    SUM(p.amount) AS 'Gross Revenue'
FROM
    category AS c
        CROSS JOIN
    film_category USING (category_id)
        INNER JOIN
    inventory USING (film_id)
        INNER JOIN
    rental USING (inventory_id)
        INNER JOIN
    payment AS p USING (rental_id)
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

#8a
CREATE VIEW Top_Five_Gernes AS
    SELECT 
        c.name AS 'Top Five Genres',
        SUM(p.amount) AS 'Gross Revenue'
    FROM
        category AS c
            CROSS JOIN
        film_category USING (category_id)
            INNER JOIN
        inventory USING (film_id)
            INNER JOIN
        rental USING (inventory_id)
            INNER JOIN
        payment AS p USING (rental_id)
    GROUP BY c.name
    ORDER BY SUM(p.amount) DESC
    LIMIT 5;
 
# 8b
select * from Top_Five_Gernes;

# 8c
drop view Top_Five_Gernes;



