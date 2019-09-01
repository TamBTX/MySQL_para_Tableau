#Tableautasks con employees_mod

#Empleados según género
USE employees_mod;
SELECT
	YEAR(de.from_date) AS calendar_year,
    e.gender,
    COUNT(e.emp_no) AS num_of_employees
FROM
	t_dept_emp de
		JOIN
	t_employees e ON de.emp_no=e.emp_no
GROUP BY calendar_year, e.gender
HAVING calendar_year >= '1990'
ORDER BY calendar_year;

#Número de managers por departamento
 SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN YEAR(dm.to_date) >= e.calendar_year AND YEAR(dm.from_date) <= e.calendar_year THEN 1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN 
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, calendar_year;

#Salario promedio anual de los empleados
SELECT
	e.gender,
	d.dept_name,
    ROUND(AVG(s.salary),2) AS avg_salary,
    YEAR(s.from_date) AS calendar_year
FROM
	t_salaries s
		JOIN
	t_employees e ON e.emp_no=s.emp_no
		JOIN
	t_dept_emp de ON e.emp_no=de.emp_no
		JOIN
	t_departments d ON de.dept_no=d.dept_no
GROUP BY calendar_year, e.gender, d.dept_no
HAVING calendar_year <= '2002'
ORDER BY d.dept_no, calendar_year;
		
#Salario promedio de los empleados (desde 1990)
DELIMITER $$
USE employees_mod$$
CREATE PROCEDURE avg_salary_dept(IN p_salary_1 FLOAT, IN p_salary_2 FLOAT)
BEGIN
	SELECT
		e.gender,
		d.dept_name,
		ROUND(AVG(s.salary),2) as avg_salary
	FROM
		t_employees e
			JOIN
		t_salaries s ON e.emp_no=s.emp_no
			JOIN
		t_dept_emp de ON s.emp_no=de.emp_no
			JOIN
		t_departments d ON de.dept_no=d.dept_no
	WHERE 
		s.salary BETWEEN p_salary_1 AND p_salary_2
GROUP BY d.dept_no, e.gender;
END$$
    
DELIMITER ;
CALL employees_mod.avg_salary_dept('50000','90000');

	