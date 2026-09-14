-- DAY 09: SQL PROBLEM-SOLVING PRACTICE --

create database challenge;
-- Imported the dataset into the challenge database --
use challenge;
show tables;


-- Q1.Identify the top 5 most active users who have spent more than 10,000 seconds
--    on at least one session. 'Most active' is defined as having the highest number of
--    sessions. This will help you analyze user session data to find a potential
--    correlation between session duration and user activity.

select user_id from sessions_data
group by user_id
having max(secs_elapsed) > 10000
order by count(*) desc
limit 5
;

-- Q2.Using the Users data table, determine the most frequently used signup method
-- 	  for each Gender category, considering only users who have made a booking (as
--    indicated by a non-null value in the Date_first_booking column).
-- 	  Include all gender values (including null and other). Count bookings only
--    where the country is defined and Date_first_booking is not null.

select gender, signup_method, count(*)
from users
where country_destination <> 'NDF'
and date_first_booking is not null
group by gender, signup_method
;

-- Q3.Determine the average age of users by destination country, considering only
--    those with a booking and available age data. Sort the results from the youngest
--    to the oldest users.
--    	The country_destination column has ‘NDF’ entries which implies Not Defined.
--    	The output should not contain the countries as Not Defined.

select country_destination, avg(age) as average_age
from users
where date_first_booking is not null
and age is not null
and country_destination != 'NDF'
group by country_destination
order by average_age asc
;

-- Q4.We want to analyze how user sessions impact bookings. Write a query to find
--    users with fewer than 5 sessions who made a booking to the destination "US"
--    Sort the results by the number of sessions in descending order.

select u.id, count(s.user_id) as session_count
from users u
inner join sessions_data s
on u.id = s.user_id
where u.country_destination like 'US'
group by u.id
having session_count < 5
order by session_count desc
;

-- Q5.We want to analyze the activity of organic users, defined as those with "direct"
-- listed as their affiliate provider. Specifically, we are interested in the total number
-- of clicks made by these users. Please write a query to calculate the total clicks
-- made by organic users.

select count(s.action) as Total_clicks
from users u
inner join sessions_data s
on u.id = s.user_id
where u.affiliate_provider like 'direct'
and s.action_type like 'click'
;

-- Q6.Write a SQL query to identify the top 5 most common actions performed by
--    users who made a booking (i.e., country_destination is not 'NDF') and the devices
--    they use for these actions.

select s.action, s.device_type, count(*) as action_count
from users u
inner join sessions_data s
on u.id = s.user_id
where u.country_destination not like 'NDF'
group by s.action, s.device_type
order by count(*) desc
limit 5
;

-- Q7.Write a SQL query to determine the average time spent on actions by users who
--    have made a booking (i.e., country_destination is not 'NDF'), cross action type
--    and device type. Sort the results by average time spent in descending order.

 select s.action_type, s.device_type,
 avg(s.secs_elapsed) as average_time_spent
 from sessions_data s
 inner join users u
 on s.user_id = u.id
 where country_destination not like 'NDF'
 group by s.action_type, s.device_type
 order by average_time_spent desc
 ;

-- Q8.Write a SQL query to find the most frequent combinations of two actions
--    (performed by the same user on Windows Desktop devices) where the most
--    time is spent, for users who have made a booking (i.e., countrydestination is not
--    'NDF'). Consider the top 10 combinations from the resulting table ordered by
--    totaltime_spent in descending order which will be considered as most frequent. 

select s1.action as first_action,
s2.action as second_action,
count(*) as action_pair_count,
sum(s1.secs_elapsed + s2.secs_elapsed) as total_time_spent
from sessions_data s1
inner join sessions_data s2
on s1.user_id = s2.user_id
and s1.action <> s2.action
inner join users u
on u.id = s1.user_id
where country_destination not like 'NDF'
and s1.device_type = 'Windows Desktop'
and s2.device_type = 'Windows Desktop'
group by first_action, second_action
order by total_time_spent desc
limit 10
;

-- Q9.Write an SQL query to find the number of bookings and the conversion rate for
--    each first affiliate channel. Consider a booking as made if country_destination is
--    not 'NDF'.

select first_affiliate_tracked as affiliate_channel,
count(*) as total_users,
sum(country_destination <> 'NDF') as bookings,
round(sum(country_destination <> 'NDF')  / count(*) * 100, 4) as conversion_rate
from users
group by first_affiliate_tracked
;

-- Q10.Write a SQL query to calculate the conversion rate for each combination of
--     affiliate provider and signup method. Consider a booking as made if
--     country_destination is not 'NDF'.

select affiliate_provider, signup_method,
count(*) as total_users,
sum(country_destination <> 'NDF') as bookings,
round(sum(country_destination <> 'NDF') / count(*) *100, 4) as conversion_rate
from users
group by affiliate_provider, signup_method
order by conversion_rate desc
;










