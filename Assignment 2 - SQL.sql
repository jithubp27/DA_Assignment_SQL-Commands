use mavenmovies;
-- Question 1: Retrieve the total number of rentals made in the Sakila database. 
select count(*) from rental;

-- Question 2: Find the average rental duration (in days) of movies rented from the Sakila database
select avg(datediff(return_date,rental_date)) as avg_rental_duration from rental;

-- Question 3: Display the first name and last name of customers in uppercase.
select upper(first_name) as 'First name', upper(last_name) 'Last name' from customer;

-- Question 4: Extract the month from the rental date and display it alongside the rental ID.
select rental_id as 'Rental id', month(rental_date) from rental;
select rental_id as 'Rental id', monthname(rental_date) from rental;

-- Question 5: Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
select customer_id as 'Customer ID', count(*) as 'Count of rentals' from rental group by customer_id order by customer_id;

-- Question 6: Find the total revenue generated by each store. 
select * from payment; -- staff_id , rental id, amount
select * from store; -- storeid,
select * from staff; -- staff id, store id
-- answer--
select store.store_id, sum(amount) from payment left join staff on payment.staff_id=staff.staff_id 
left join store on staff.store_id=store.store_id group by store.store_id;

-- Question 7:  Display the title of the movie, customer's first name, and last name who rented it.
 select * from film; -- title, film id
  select * from inventory; -- film id, store id, inventory id
   select * from rental; -- customer id, rental id, staff id, inventory id
 select * from customer; -- customer_id, first name, last name, store id 
 -- answer--
 select title, c.first_name, c.last_name from film inner join inventory on film.film_id=inventory.film_id left join rental r 
 on inventory.inventory_id=r.inventory_id left join customer c on c.customer_id=r.customer_id ;
 
-- Question 8: Retrieve the names of all actors who have appeared in the film "Gone with the Wind." 
select * from actor; -- actor id, name
select * from film; -- filmid, title, lang id
select * from film_actor; -- actor id, film id
-- answer --
select first_name, last_name from film left join film_actor fa on fa.film_id=film.film_id left join actor a on a.actor_id=fa.actor_id where title="Gone with the Wind";
-- no movie exist like "Gone with the Wind" let's try for movie "Gone Trouble"
select first_name, last_name from film left join film_actor fa on fa.film_id=film.film_id left join actor a on a.actor_id=fa.actor_id
where title='Gone Trouble';

-- Question 9: Determine the total number of rentals for each category of movies.
select * from film_category; -- film id, category id
select * from film; -- film id, title, lang id
select * from inventory; -- film id, inventory id
select * from rental; -- rental id, inventory id, customer id, staff id
-- answer --
select category_id, count(*) from film_category fc  join film f on f.film_id=fc.film_id  join inventory i on i.film_id=f.film_id 
 join rental r on r.inventory_id=i.inventory_id group by fc.category_id; 
 
-- Question 10: Find the average rental rate of movies in each language.
select * from film; -- film id, title, lang id, rental rate
select * from language; -- lang id, name
-- answer --
select name, avg(rental_rate) from language l inner join film f on f.language_id=l.language_id group by l.language_id;

-- Question 3: Retrieve the customer names along with the total amount they've spent on rentals.
select * from customer; -- customer_id, store_id, name, address id
select * from payment; -- payment id, customer id, staff id, rental id, amount
select * from rental; -- rental id, inventory id, customer id, staff id
-- answer -- 
select c.customer_id, concat(first_name,' ',last_name) as Name, sum(amount) from customer c 
join payment p on p.customer_id=c.customer_id group by p.customer_id;

-- Question 4: List the titles of movies rented by each customer in a particular city (e.g., 'London'). 
select * from customer; -- customer id, store id, name, address id 4
select * from rental; -- rental id, inventory id, customer id, staff id 3
select * from inventory; -- inventory id, film id, store id 2
select * from film; -- film id, title, lang id, rental rate 1
select * from address; -- address id, city id, 5
select * from city; -- city id, city, country id 6
-- answer --
select cu.customer_id,title,cu.first_name, cu.last_name, c.city from film join inventory i on i.film_id=film.film_id join rental r on r.inventory_id=i.inventory_id
join customer cu on cu.customer_id=r.customer_id join address a on a.address_id=cu.address_id join city c on c.city_id=a.city_id
where c.city like 'london' order by customer_id;

-- Question 5: Display the top 5 rented movies along with the number of times they've been rented. 
select * from film; -- film id, title, lang id
select * from inventory; -- film id, inventory id, store id
select * from rental; -- rental id, inventory id, customer id, staff id
-- answer --
select title, count(rental_id) as rental_count from film join inventory on inventory.film_id=film.film_id 
join rental on rental.inventory_id=inventory.inventory_id group by inventory.film_id order by rental_count desc limit 5;

-- Question 6: Determine the customers who have rented movies from both stores (store ID 1 and store ID 2). 
select * from customer; -- customer id, store id, name, address id
select * from rental; -- rental id, inventory id, customer id, staff id,
select * from inventory; -- inventory id, film id, store id,
select * from store; -- store id, manager staff id, address id
select * from staff; -- staff id, store id,  
-- answer --
select customer.customer_id, first_name, last_name from customer join rental on rental.customer_id=customer.customer_id
join inventory on inventory.inventory_id=rental.inventory_id join store on store.store_id=inventory.store_id 
where store.store_id in (1,2) group by customer.customer_id having count(distinct store.store_id);