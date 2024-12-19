create database EmployeePerformance;
use EmployeePerformance;

CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Join_Date DATE NOT NULL,
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Project (
    Project_ID INT PRIMARY KEY,
    Project_Name VARCHAR(100) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE,
    Department VARCHAR(50)
);

CREATE TABLE Tasks (
    Task_ID INT PRIMARY KEY,
    Task_Name VARCHAR(100) NOT NULL,
    Employee_ID INT,
    Project_ID INT,
    Assigned_Date DATE NOT NULL,
    Deadline DATE,
    Completion_Date DATE,
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Completed', 'Overdue')) NOT NULL,
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID),
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
);

CREATE TABLE Feedback (
    Feedback_ID INT PRIMARY KEY,
    Employee_ID INT,
    Feedback_Date DATE NOT NULL,
    Feedback_Score INT CHECK (Feedback_Score BETWEEN 1 AND 5),
    Comments TEXT,
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
);

CREATE TABLE Training (
    Training_ID INT PRIMARY KEY,
    Employee_ID INT,
    Training_Date DATE NOT NULL,
    Skill_Improved VARCHAR(100) NOT NULL,
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
);

INSERT INTO Employees (Employee_ID, Name, Department, Role, Join_Date, Email) VALUES
(1, 'Alice Johnson', 'IT', 'Software Engineer', '2022-03-01', 'alice.johnson@gmail.com'),
(2, 'Bob Smith', 'HR', 'HR Manager', '2021-07-15', 'bob.smith@gmail.com'),
(3, 'Charlie Brown', 'Finance', 'Accountant', '2020-11-20', 'charlie.brown@gmail.com'),
(4, 'Diana Prince', 'Marketing', 'Marketing Specialist', '2023-01-10', 'diana.prince@gmail.com'),
(5, 'Eve Adams', 'IT', 'Data Analyst', '2022-06-05', 'eve.adams@gmail.com');

INSERT INTO Project (Project_ID,Project_Name, Start_Date, End_Date, Department) VALUES
(1,'Website Redesign', '2023-02-01', '2023-05-30', 'IT'),
(2,'Employee Engagement Survey', '2023-03-15', NULL, 'HR'),
(3,'Year-End Financial Audit', '2023-01-01', '2023-03-31', 'Finance'),
(4,'New Product Launch', '2023-04-01', '2023-06-30', 'Marketing');

INSERT INTO Tasks (Task_ID, Task_Name, Employee_ID, Project_ID, Assigned_Date, Deadline, Completion_Date, Status) VALUES
(1, 'Develop Login Feature', 1, 1, '2023-02-05', '2023-02-28', '2023-02-27', 'Completed'),
(2, 'Conduct HR Survey', 2, 2, '2023-03-20', '2023-04-10', NULL, 'Pending'),
(3, 'Prepare Audit Report', 3, 3, '2023-01-10', '2023-02-28', '2023-02-25', 'Completed'),
(4, 'Design Marketing Brochure', 4, 4, '2023-04-05', '2023-04-20', '2023-04-18', 'Completed'),
(5, 'Analyze User Data', 5, 1, '2023-02-15', '2023-03-01', NULL, 'Overdue');


INSERT INTO Feedback (Feedback_ID,Employee_ID, Feedback_Date, Feedback_Score, Comments) VALUES
(01,1, '2023-03-01', 4, 'Great work on the login feature!'),
(02,2, '2023-04-12', 3, 'HR survey is pending; needs improvement in time management.'),
(03,3, '2023-03-01', 5, 'Exceptional audit report!'),
(04,4, '2023-04-20', 4, 'Marketing brochure was well-received.'),
(05,5, '2023-03-05', 2, 'Missed deadline for data analysis.');

INSERT INTO Training (Training_ID,Employee_ID, Training_Date, Skill_Improved) VALUES
(11,1, '2023-01-15', 'React.js Development'),
(12,2, '2023-02-10', 'Employee Engagement Strategies'),
(13,3, '2023-01-20', 'Advanced Excel'),
(14,4, '2023-03-05', 'Graphic Design Basics'),
(15,5, '2023-02-25', 'SQL Optimization Techniques');

SELECT * FROM Employees;
SELECT * FROM Project;
SELECT * FROM Tasks;
SELECT * FROM Feedback;
SELECT * FROM Training;

-- Query 1: Find Employees with overdue task
select e.Name,t.Task_Name,t.Deadline
from Employees e
join Tasks t
on e.Employee_ID = t.Employee_ID
where t.Status = 'Overdue';

-- Query 2:Total projects handled by each department
select Department , count(*) as Total_projects
from Project
group by Department;

-- Query 3: Top-performing employees based on feedback
select e.Name , avg(f.Feedback_Score) as avg_score
from Employees e
join Feedback f
on e.Employee_ID = f.Employee_ID
group by e.Name
order by avg_score desc;

-- Query 4: Find Employees Who Have Not Completed Any Tasks
select e.Name, e.Department
from Employees e
left join Tasks t
on e.Employee_ID = t.Employee_ID
where t.Status != 'Completed' or t.Status is null;

-- Query 5: Get the Average Task Completion Time for Each Employee
SELECT 
    e.Name,
    AVG(DATEDIFF(DAY, t.Assigned_Date, t.Completion_Date)) AS AvgCompletionTime
FROM Employees e
JOIN Tasks t ON e.Employee_ID = t.Employee_ID
WHERE t.Status = 'Completed'
GROUP BY e.Name;

-- Query 6:List Employees with Feedback Scores Below 3
select e.Name , e.Department
from Employees e
join Feedback f
on e.Employee_ID = f.Employee_ID
where f.Feedback_Score < 3;

-- Query 7:Find Projects That Are Still Ongoing


SELECT Project_Name, Start_Date, End_Date
FROM Project
WHERE End_Date IS NULL OR End_Date > GETDATE();

-- Query 8:Count Tasks Assigned to Each Employee by Status
SELECT e.Name,t.Status,COUNT(t.Task_ID) AS TaskCount
FROM Employees e
LEFT JOIN Tasks t ON e.Employee_ID = t.Employee_ID
GROUP BY e.Name, t.Status;

-- Query 9: Get the Total Feedback Score and Average Score by Department
select e.Department,
       sum(f.Feedback_Score) as Total_Feedback_score,
	   avg(f.Feedback_Score) as avg_score
from Employees e
join Feedback f
on e.Employee_ID = f.Employee_ID
group by e.Department;

-- Query 10:List Employees Who Have Attended More Than One Training
select e.Name , count(t.Training_ID) as total_training
from Employees e
join Training t
on e.Employee_ID = t.Employee_ID
group by e.Name
having count(t.Training_ID) > 1;

-- Query 11: Find Tasks Overdue by More Than 30 Days
SELECT 
    t.Task_Name,
    e.Name AS AssignedTo,
    DATEDIFF(DAY, t.Deadline, GETDATE()) AS DaysOverdue
FROM Tasks t
JOIN Employees e ON t.Employee_ID = e.Employee_ID
WHERE t.Status = 'Overdue' AND DATEDIFF(DAY, t.Deadline, GETDATE()) > 30;

-- Query 12: Find Employees with No Feedback Records
SELECT e.Name
FROM Employees e
LEFT JOIN Feedback f ON e.Employee_ID = f.Employee_ID
WHERE f.Feedback_ID IS NULL;






