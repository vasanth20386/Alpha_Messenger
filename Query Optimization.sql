-- Query Optimization

-- 1. In many cases, an EXISTS subquery with a correlated condition will perform better than a non correlated IN subquery

SELECT
        USER.first_name,
        USER.last_name 
    FROM
        USER 
    WHERE
        EXISTS (
            SELECT
                1 
            FROM
                contacts 
            WHERE
                (
                    USER.user_id = contacts.user_id
                ) 
            GROUP BY
                contacts.user_id 
            HAVING
                Count(contacts.contact_id) = (
                    SELECT
                        Max(noofcontacts) AS highestNoOfContacts 
                    FROM
                        (SELECT
                            contacts.user_id,
                            Count(contacts.contact_id) AS NoOfContacts 
                        FROM
                            contacts 
                        GROUP BY
                            contacts.user_id) AS T) 
                    ORDER BY
                        NULL
                );    
                
-- 2. By default, the database sorts all 'GROUP BY col1, col2,... queries as if you specified 'ORDER BY col1, col2,... in the query as well.
-- If a query includes a GROUP BY clause but you want to avoid the overhead of sorting the result, you can suppress sorting by specifying 'ORDER BY NULL'.

SELECT USER.user_id,
       USER.first_name,
       USER.last_name
FROM   USER
WHERE  EXISTS (SELECT 1
               FROM   status_views
               WHERE  ( EXISTS (SELECT 1
                                FROM   status
                                WHERE  ( status.posted_by = 77 )
                                       AND ( status_views.status_id =
                                             status.status_id
                                           )) )
                      AND ( USER.user_id = status_views.user_id ));