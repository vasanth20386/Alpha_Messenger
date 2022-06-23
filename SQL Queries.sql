-- 1. Find no.of messages sent in each group before “2022-01-01 00:00:00”

select g.group_name,count(gm.msg_id) as "No.of Messages"
from groups_ g
join group_message gm on gm.group_id = g.group_id
where timestamp < '2022-01-01 00:00:00'
group by g.group_id;

-- 2. Find user details who has viewed the status posted by a particular user

select user_id,first_name,last_name from user
where user_id in (
select user_id from status_views
where status_id in (
select status_id from status
where posted_by = 77
));


-- 3. Find the group name and maximum no.of participants

select group_id, Count(user_id) AS NoOfParticipants
from participants
group by group_id
having count(user_id) = (
SELECT Max(NoOfparticipants) AS highestNoOfParticipants
FROM  (SELECT group_id,
              Count(user_id) AS NoOfParticipants
       FROM   participants
       GROUP  BY group_id) as T
);

-- 4. Find the user name whose call duration is maximum

select first_name,last_name,phone_no
from user
where user_id= (SELECT caller_id FROM calls
where call_duration=(
select max(call_duration)
from calls)
);


-- 5. Find the user name who has maximum contacts

SELECT first_name,
       last_name
FROM   USER
WHERE  user_id IN (SELECT user_id
                   FROM   contacts
                   GROUP  BY user_id
                   HAVING Count(contact_id) = (SELECT
                          Max(noofcontacts) AS highestNoOfContacts
                                               FROM   (SELECT user_id,
                                                              Count(contact_id)
                                                              AS
                                                              NoOfContacts
                                                       FROM   contacts
                                                       GROUP  BY user_id) AS T));

-- 6. Number of direct messages sent by each user

SELECT
    user_id,
    first_name AS `Sender's first name`,
    last_name AS `Sender's last name`,
    COUNT(*) AS `No. of direct messages send`
FROM 
    user inner JOIN 
    direct_message ON user_id = sender_id
group by
    user_id,
    first_name,
    last_name;

-- 7. Find the callee’s phone numbers of which users called to with date?

SELECT u1.user_id as "user" , u2.phone_no as "called to", date(timestamp) as "date"
from calls
join user u1
on caller_id = u1.user_id
join user u2
on callee_id = u2.user_id
group by date(timestamp)
order by u1.user_id;

-- 8. Find the group details with participants

SELECT p1.group_id as "group id", group_concat(distinct p2.user_id) as "group participants"
FROM participants p1
JOIN participants p2
ON p1.group_id = p2.group_id
group by p1.group_id;

-- 9. Find the user ids who has seen the status posted by user 97
SELECT user_id, seen_time
                   FROM   status_views
                   WHERE  status_id IN (SELECT status_id
                                        FROM   status
                                        WHERE  posted_by = 97);
                                        
-- 10. Find the users who created their account in 2021
SELECT COUNT(user_id)
FROM  user
WHERE year(joined_at) = 2021;
