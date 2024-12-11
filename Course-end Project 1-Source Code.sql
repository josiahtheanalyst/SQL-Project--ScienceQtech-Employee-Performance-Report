/*==============================================================================================
						COURSE NAME: SQL CERTIFICATION COURSE-END PROJECT 1
        
						PROJECT TITLE: ScienceQtech Employee Performance Mapping.
================================================================================================*/

/*==============================================================================================
									TASKS TO BE PERFORMED
================================================================================================*/

/*==============================================================================================
1.Create a database named employee, then import data_science_team.csv , proj_table.csv and 
emp_record_table.csv into the employee database from the given resources.
================================================================================================*/

create schema employees;
use employees;

/*1a. retrieving the list of tables in the employees schema*/

Select table_name
from information_schema.tables
where table_schema = 'employees';

/*1b. Describing each table in the employees schema*/

desc employees.data_science_team;
desc employees.emp_record_table;
desc employees.proj_table;

/*==============================================================================================
2.Create an ER diagram for the given employee database.
================================================================================================*/


/*==============================================================================================
3. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the 
employee record table, and make a list of employees and details of their department
================================================================================================*/
SELECT 	emp_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM emp_record_table;


/*==============================================================================================
4. 4.Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
		●less than two
		●greater than four 
		●between two and four
================================================================================================*/

SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT,
    EMP_RATING
FROM
    emp_record_table
WHERE
    EMP_RATING < 2;
    

SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT,
    EMP_RATING
FROM
    emp_record_table
WHERE
    EMP_RATING > 4;
    


SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT,
    EMP_RATING
FROM
    emp_record_table
WHERE
    EMP_RATING BETWEEN 2 AND 4;
    
    
    
    

/*==============================================================================================
5. Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance 
department from the employee table and then give the resultant column alias as NAME.									
================================================================================================*/

SELECT 
    CONCAT(FIRST_NAME, ', ', LAST_NAME) AS NAME
FROM
    emp_record_table
WHERE
    DEPT = 'FINANCE';
    


/*==============================================================================================
6. Write a query to list only those employees who have someone reporting to them. 
Also, show the number of reporters (including the President).
================================================================================================*/

SELECT 
    e.EMP_ID,
    CONCAT(e.FIRST_NAME, ', ', e.LAST_NAME) AS 'EMPLOYEE NAME', -- To combine first and last name as Employee Name
    COUNT(r.EMP_ID) AS 'NO OF REPORTERS'  -- Counts the no of employees reporting to each manager
FROM
    emp_record_table e
        JOIN
    emp_record_table r ON e.EMP_ID = r.MANAGER_ID  -- Left join emp_record_table to itself to match employees r to manager r
    GROUP BY e.EMP_ID, e.FIRST_NAME, e.LAST_NAME -- This groups the result by the manager's ID and name to aggregate the count
    HAVING count(r.EMP_ID >0); -- This filters those managers who have at least one employee reporting to them.
    

/*==============================================================================================
7.Write a query to list down all the employees from the healthcare and finance departments 
using union. Take data from the employee record table.
================================================================================================*/

SELECT 
    EMP_ID,
    CONCAT(FIRST_NAME, ', ', LAST_NAME) AS 'EMPLOYEE NAME',
    DEPT
FROM
    emp_record_table
WHERE
    DEPT = 'HEALTHCARE' 
UNION SELECT 
    EMP_ID,
    CONCAT(FIRST_NAME, ', ', LAST_NAME) AS 'EMPLOYEE NAME',
    DEPT
FROM
    emp_record_table
WHERE
    DEPT = 'FINANCE';



/*==============================================================================================
8.	Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, 
DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along 
with the max emp rating for the department.									
================================================================================================*/

SELECT 
    e.EMP_ID,
    e.FIRST_NAME,
    e.LAST_NAME,
    e.ROLE,
    e.DEPT,
    e.EMP_RATING,
    MAX(e.EMP_RATING) OVER (PARTITION BY e.DEPT) AS MAX_DEPTAL_RATING
FROM
    emp_record_table e
ORDER BY e.DEPT, e.EMP_RATING DESC;
            


/*==============================================================================================
9. Write a query to calculate the minimum and the maximum salary of the employees in each role.
Take data from the employee record table.
================================================================================================*/

SELECT 
    ROLE,
    MIN(SALARY) AS 'MINIMUM SALARY',
    MAX(SALARY) AS 'MAXIMUM SALARY'
FROM
    emp_record_table
GROUP BY ROLE;




/*==============================================================================================
10.	Write a query to assign ranks to each employee based on their experience. 
Take data from the employee record table.									
================================================================================================*/


SELECT 
	EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    ROLE, 
    DEPT, 
    EXP, 
    RANK() OVER( ORDER BY EXP DESC) AS 'RANK' 
FROM emp_record_table;



/*==============================================================================================
11.Write a query to create a view that displays employees in various countries whose salary is 
more than six thousand. Take data from the employee record table.
================================================================================================*/

CREATE VIEW HighSalaryEmployees AS
    SELECT 
        CONCAT(FIRST_NAME, ', ', LAST_NAME) AS 'EMPLOYEE NAME',
        COUNTRY,
        SALARY
    FROM
        emp_record_table
    HAVING SALARY > 6000
    ORDER BY SALARY DESC; -- This was not part of the tasks, I just added it.

SELECT * FROM employees.highsalaryemployees;






/*==============================================================================================
12. Write a nested query to find employees with experience of more than ten years. 
Take data from the employee record table.
================================================================================================*/

SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, EXP
FROM
    emp_record_table
WHERE
    EXP IN (SELECT 
            EXP
        FROM
            emp_record_table
        WHERE
            EXP > 10)
ORDER BY EXP DESC;



/*==============================================================================================
13.Write a query to create a stored procedure to retrieve the details of the employees 
whose experience is more than three years. Take data from the employee record table.									
================================================================================================*/
-- SET DELIMITER TO &&, //, \\, || TO MAKE DELIMITER WORK AND RESET IT BACK TO ; 

DELIMITER &&
CREATE PROCEDURE 
	EmployeesExpGreaterthan3()
BEGIN
SELECT 
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    ROLE,
    DEPT,
    EXP,
    COUNTRY,
    CONTINENT,
    SALARY
FROM
    emp_record_table
WHERE
    EXP > 3
ORDER BY EXP ASC, SALARY ASC;
END &&

-- RESET DELIMITER TO ;
DELIMITER ;
CALL EmployeesExpGreaterthan3;






/*==============================================================================================
14.Write a query using stored functions in the project table to check whether the job profile 
assigned to each employee in the data science team matches the organization’s set standard.
The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'.
================================================================================================*/

DELIMITER $$

CREATE FUNCTION EmployeeJobProfile(EXP INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE job_profile VARCHAR(50);

    IF EXP <= 2 THEN
        SET job_profile = 'JUNIOR DATA SCIENTIST';
    ELSEIF EXP > 2 AND EXP <= 5 THEN
        SET job_profile = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF EXP > 5 AND EXP <= 10 THEN
        SET job_profile = 'SENIOR DATA SCIENTIST';
    ELSEIF EXP > 10 AND EXP <= 12 THEN
        SET job_profile = 'LEAD DATA SCIENTIST';
    ELSEIF EXP > 12 AND EXP <= 16 THEN
        SET job_profile = 'MANAGER';
    ELSE
        SET job_profile = 'OTHER';
    END IF;

    RETURN job_profile;
END $$

DELIMITER ;


SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    ROLE,
    EXP,
    EmployeeJobProfile(EXP) AS 'EXPECTED_PROFILE',
    CASE
        WHEN ROLE = EmployeeJobProfile(EXP) THEN 'MATCHES STANDARD'
        ELSE 'DOES NOT MATCH STANDARD'
    END AS 'STATUS'
FROM
    emp_record_table
WHERE
    ROLE = 'DATA SCIENCE';


SELECT EmployeeJobProfile(1); -- Should return 'JUNIOR DATA SCIENTIST'
SELECT EmployeeJobProfile(6); -- Should return 'SENIOR DATA SCIENTIST'


SELECT EmployeeJobProfile(1) AS JobProfile
UNION ALL
SELECT EmployeeJobProfile(2)
UNION ALL
SELECT EmployeeJobProfile(8)
UNION ALL
SELECT EmployeeJobProfile(11)
UNION ALL
SELECT EmployeeJobProfile(14)
UNION ALL
SELECT EmployeeJobProfile(17);


/*==============================================================================================
15.Create an index to improve the cost and performance of the query to find the employee whose 
FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.									
================================================================================================*/

CREATE INDEX indx_first_name ON emp_record_table (FIRST_NAME);







/*==============================================================================================
16.Write a query to calculate the bonus for all the employees, based on their ratings and 
salaries (Use the formula: 5% of salary * employee rating).
================================================================================================*/

SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    SALARY,
    EMP_RATING,
    (0.05 * SALARY * EMP_RATING) AS BONUS
FROM
    emp_record_table
    ORDER BY EMP_RATING DESC, EMP_RATING DESC;




/*==============================================================================================
17.Write a query to calculate the average salary distribution based on the continent and 
country. Take data from the employee record table.

Two codes were used here: One with null outputs for some continents and countries. 									
================================================================================================*/
-- OPTION A
SELECT 
    CONTINENT, COUNTRY, ROUND(AVG(SALARY), 0) AS 'AVERAGE SALARY'
FROM
    emp_record_table
GROUP BY CONTINENT , COUNTRY WITH ROLLUP;


-- OPTION B

SELECT 
    CONTINENT,
    COUNTRY,
    ROUND(AVG(SALARY), 0) AS 'AVERAGE SALARY'
FROM
    emp_record_table
GROUP BY CONTINENT , COUNTRY WITH ROLLUP
HAVING CONTINENT IS NOT NULL
    AND COUNTRY IS NOT NULL;

