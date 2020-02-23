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

USE country_club;

Select name
from Facilities
Where membercost >0.0


/* Q2: How many facilities do not charge a fee to members? */


USE country_club;

Select count(name)
from Facilities
Where membercost = 0.0


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */


USE country_club;

Select facid,name,membercost,monthlymaintenance

from Facilities

Where membercost >0.0 and membercost < (0.2 *monthlymaintenance)

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

USE country_club;

Select *

from Facilities

Where facid IN ('1','5')
 


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

USE country_club;

Select name,monthlymaintenance,CASE WHEN monthlymaintenance > 100 Then 'Expensive'
		Else 'Cheap' end as Category


from Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */



Use country_club;
 
SELECT *
FROM Members
where joindate =(select( max(joindate)) from Members)



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */



USE country_club;
select F.name ,CONCAT(M.firstname," ",M.surname) as Name
From Members M
Left Join Bookings B
on M.memid = B.memid
Left Join Facilities F
on B.facid = F.facid
where F.name  IN ('Tennis court 1','Tennis court 2')
order by Name



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

USE country_club;


select   F.name as facility, CONCAT(M.firstname," ",M.surname)as Name,
	case 
		WHEN M.memid = 0 THEN B.slots*F.guestcost
		ELSE  B.slots*F.membercost END as Cost
			
FROM
                Members M                
                inner join Bookings B
                        on M.memid = B.memid
                inner join Facilities F
                        on B.facid = F.facid
        where
		(B.starttime >= '2012-09-14' and B.starttime < '2012-09-15') and
			((M.memid =0 and B.slots*F.guestcost > 30) or
			(M.memid != 0 and B.slots*F.membercost > 30))
order by Cost DESC
		

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

USE country_table; 

select  sub.facility,sub.member, sub.Cost
From
(
Select
F.name as facility, CONCAT(M.firstname," ",M.surname) as Name,
	case 
		WHEN M.memid = 0 THEN B.slots*F.guestcost
		ELSE  B.slots*F.membercost END as Cost
			
FROM
                Members M                
                inner join Bookings B
                        on M.memid = B.memid
                inner join Facilities F
                        on B.facid = F.facid
        where
		(B.starttime >= '2012-09-14' and B.starttime < '2012-09-15') 
    
    ) sub

where sub.cost >30
order by sub.Cost DESC


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */


Select sub.name,sub.Cost
From(
select F.name,
SUm(
CASE When B.memid = 0 Then B.slots * F.guestcost
else B.slots * F.membercost end )as Cost


From Facilities F
inner join Bookings B
on F.facid = B.facid
    
 Group BY F.name
) sub

where sub.Cost < 1000
group By sub.name
order by sub.cost






