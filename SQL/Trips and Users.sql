/*
262. Trips and Users
Table: Trips

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| id          | int      |
| client_id   | int      |
| driver_id   | int      |
| city_id     | int      |
| status      | enum     |
| request_at  | varchar  |     
+-------------+----------+
id is the primary key (column with unique values) for this table.
The table holds all taxi trips. Each trip has a unique id, while client_id and driver_id are foreign keys to the users_id at the Users table.
Status is an ENUM (category) type of ('completed', 'cancelled_by_driver', 'cancelled_by_client').
Table: Users

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| users_id    | int      |
| banned      | enum     |
| role        | enum     |
+-------------+----------+
users_id is the primary key (column with unique values) for this table.
The table holds all users. Each user has a unique users_id, and role is an ENUM type of ('client', 'driver', 'partner').
banned is an ENUM (category) type of ('Yes', 'No').
The cancellation rate is computed by dividing the number of canceled (by client or driver) requests with unbanned users by the total number of requests with unbanned users on that day.

Write a solution to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03" with at least one trip. Round Cancellation Rate to two decimal points.

Return the result table in any order.

*/

with req_d as (
	select 
		request_at,
		sum(case when u.banned = 'No' and u2.banned = 'No' then 1 end) trips_cnt,
		sum(case when status != 'completed'  and u.banned = 'No' and u2.banned = 'No' then 1 end) cancelled_cnt
	from trips t
	left join users u
		on u.users_id = t.client_id 
	left join users u2
		on u2.users_id = t.driver_id 
	group by 1
)
select 
	request_at as Day,
	round(coalesce(cancelled_cnt,0)/trips_cnt::numeric,2) as "Cancellation Rate"
from req_d
WHERE request_at BETWEEN '2013-10-01' AND '2013-10-03'
order by day;



