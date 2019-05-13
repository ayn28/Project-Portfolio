/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
CODE:
SELECT name
FROM 'Facilities'
WHERE membercost != 0

OUTPUT:
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court

/* Q2: How many facilities do not charge a fee to members? */
CODE:
SELECT COUNT(name) as Count
FROM 'Facilities'
WHERE membercost = 0

OUTPUT:
4

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
CODE:
SELECT facid,
       name,
       membercost,
       monthlymaintenance
FROM 'Facilities'
WHERE membercost != 0
AND membercost < (monthlymaintenance * 0.2)

OUTPUT:
facid	name	           membercost	  monthlymaintenance
0	    Tennis Court 1	 5.0	        200
1	    Tennis Court 2	 5.0	        200
4	    Massage Room 1	 9.9	        3000
5	    Massage Room 2	 9.9	        3000
6	    Squash Court	   3.5	        80

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
CODE:
SELECT *
FROM 'Facilities'
WHERE facid IN (1, 5)

OUTPUT:
facid	  name	           membercost	guestcost	 initialoutlay	monthlymaintenance
1	      Tennis Court 2	 5.0	      25.0	     8000	          200
5	      Massage Room 2	 9.9	      80.0	     4000	          3000

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
CODE:
SELECT name,
       monthlymaintenance
       CASE WHEN monthlymaintenance > 100
         THEN 'Expensive'
         ELSE 'Cheap'
       END AS label
FROM 'Facilities'

OUTPUT:
name	           monthlymaintenance	     label
Tennis Court 1	                200	     Expensive
Tennis Court 2	                200	     Expensive
Badminton Court	                 50	     Cheap
Table Tennis	                   10	     Cheap
Massage Room 1	               3000	     Expensive
Massage Room 2	               3000	     Expensive
Squash Court	                   80	     Cheap
Snooker Table	                   15	     Cheap
Pool Table	                     15	     Cheap

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
CODE:
SELECT firstname, surname
FROM 'Members'
WHERE joindate
IN (SELECT MAX(joindate)
    FROM 'Members')

OUTPUT:
firstname	  surname
Darren	    Smith

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
CODE:
SELECT f.name as facility_name,
       CONCAT(m.firstname, ' ', m.surname) AS member_name
FROM 'Bookings' b
INNER JOIN 'Facilities' f
ON f.facid = b.facid
JOIN `Members` m
ON m.memid = b.memid
WHERE f.name IN ('Tennis Court 1', 'Tennis Court 2')
GROUP BY facility_name, member_name
ORDER BY member_name

OUTPUT:
facility_name	  member_name
Tennis Court 1	Anne Baker
Tennis Court 2	Anne Baker
Tennis Court 2	Burton Tracy
Tennis Court 1	Burton Tracy
Tennis Court 1	Charles Owen
Tennis Court 2	Charles Owen
Tennis Court 2	Darren Smith
Tennis Court 1	David Farrell
Tennis Court 2	David Farrell
Tennis Court 1	David Jones
Tennis Court 2	David Jones
Tennis Court 1	David Pinker
Tennis Court 1	Douglas Jones
Tennis Court 1	Erica Crumpet
Tennis Court 2	Florence Bader
Tennis Court 1	Florence Bader
Tennis Court 1	Gerald Butters
Tennis Court 2	Gerald Butters
Tennis Court 2	GUEST GUEST
Tennis Court 1	GUEST GUEST
Tennis Court 2	Henrietta Rumney
Tennis Court 2	Jack Smith
Tennis Court 1	Jack Smith
Tennis Court 1	Janice Joplette
Tennis Court 2	Janice Joplette
Tennis Court 2	Jemima Farrell
Tennis Court 1	Jemima Farrell
Tennis Court 1	Joan Coplin
Tennis Court 1	John Hunt
Tennis Court 2	John Hunt
Tennis Court 1	Matthew Genting
Tennis Court 2	Millicent Purview
Tennis Court 2	Nancy Dare
Tennis Court 1	Nancy Dare
Tennis Court 1	Ponder Stibbons
Tennis Court 2	Ponder Stibbons
Tennis Court 2	Ramnaresh Sarwin
Tennis Court 1	Ramnaresh Sarwin
Tennis Court 1	Tim Boothe
Tennis Court 2	Tim Boothe
Tennis Court 2	Tim Rownam
Tennis Court 1	Tim Rownam
Tennis Court 2	Timothy Baker
Tennis Court 1	Timothy Baker
Tennis Court 2	Tracy Smith
Tennis Court 1	Tracy Smith

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
CODE:
SELECT f.name AS facility_name,
       CONCAT(m.firstname, ' ', m.surname) AS member_name,
       CASE WHEN m.memid = 0
            THEN f.guestcost
            ELSE f.membercost
       END AS booking_cost
FROM `Bookings` b
JOIN `Facilities` f
ON f.facid = b.facid
JOIN `Members` m
ON m.memid = b.memid
WHERE (b.starttime LIKE '2012-09-14%' AND m.memid = 0 AND f.guestcost > 30)
  OR (b.starttime LIKE '2012-09-14%' AND m.memid <> 0 AND f.membercost > 30)
ORDER BY booking_cost DESC

OUTPUT:
facility_name	  member_name	 booking_cost
Massage Room 1	GUEST GUEST	 80.0
Massage Room 1	GUEST GUEST	 80.0
Massage Room 1	GUEST GUEST	 80.0
Massage Room 2	GUEST GUEST	 80.0

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
CODE:
SELECT facility_name,
       member_name,
       booking_cost
FROM (SELECT b.starttime,
             CONCAT(m.firstname, ' ', m.surname) AS member_name,
             f.name AS facility_name,
             CASE WHEN m.memid = 0
                  THEN f.guestcost
                  ELSE f.membercost
             END AS booking_cost
          FROM `Bookings` b
          JOIN `Facilities` f
          ON f.facid = b.facid
          JOIN `Members` m
          ON m.memid = b.memid)
WHERE starttime LIKE '2012-09-14%'
AND booking_cost > 30
ORDER BY booking_cost DESC

OUTPUT:
facility_name	  member_name	 booking_cost
Massage Room 1	GUEST GUEST	 80.0
Massage Room 1	GUEST GUEST	 80.0
Massage Room 1	GUEST GUEST	 80.0
Massage Room 2	GUEST GUEST	 80.0

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
CODE:
SELECT facility_name,
       total_revenue
FROM (SELECT f.name AS facility_name,
                    SUM(CASE WHEN m.memid = 0
                    THEN f.guestcost
                    ELSE f.membercost
                    END) AS total_revenue
     FROM Bookings b
     INNER JOIN Facilities f
     ON f.facid = b.facid
     INNER JOIN Members m
     ON m.memid = b.memid
     GROUP BY facility_name)
WHERE total_revenue < 1000
ORDER BY total_revenue DESC

OUTPUT:
facility_name	    total_revenue
Badminton Court	  604.5
Pool Table	      265.0
Snooker Table	    115.0
Table Tennis	    90.0
