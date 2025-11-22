DROP DATABASE IF EXISTS internship_placement_tracker;
CREATE DATABASE internship_placement_tracker;
USE internship_placement_tracker;

CREATE TABLE Admin (
    Admin_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_name VARCHAR(20) NOT NULL,
    Middle_name VARCHAR(15),
    Last_name VARCHAR(20),
    Mail VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Admin_Phoneno (
    Admin_ID INT,
    Phone_no VARCHAR(15),
    PRIMARY KEY (Admin_ID, Phone_no),
    FOREIGN KEY (Admin_ID) REFERENCES Admin(Admin_ID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Company (
    Company_ID INT PRIMARY KEY AUTO_INCREMENT,
    Company_Name VARCHAR(80) UNIQUE NOT NULL,
    Industry VARCHAR(30),
    Admin_ID INT,
    FOREIGN KEY (Admin_ID) REFERENCES Admin(Admin_ID)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE CompanyLocation (
    Company_ID INT,
    Location VARCHAR(100),
    PRIMARY KEY (Company_ID, Location),
    FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE HR (
    HR_id VARCHAR(20) PRIMARY KEY,
    HR_email VARCHAR(100),
    HR_name VARCHAR(50),
    HR_phone VARCHAR(15),
    Company_ID INT,
    FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Job (
    Job_ID INT PRIMARY KEY AUTO_INCREMENT,
    Company_ID INT NOT NULL,
    Title VARCHAR(60) NOT NULL,
    Job_type VARCHAR(50),
    Duration VARCHAR(50),
    CTC DECIMAL(10,2),
    CGPA_cutoff DECIMAL(4,2),
    Eligibility_criteria TEXT,
    date_posted DATE,
    no_of_positions INT,
    FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Job_Location (
    Job_ID INT,
    Location VARCHAR(100),
    PRIMARY KEY (Job_ID, Location),
    FOREIGN KEY (Job_ID) REFERENCES Job(Job_ID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Student (
    SRN CHAR(13) PRIMARY KEY,
    First_name VARCHAR(50) NOT NULL,
    Middle_name VARCHAR(20),
    Last_name VARCHAR(50),
    DOB DATE,
    Batch_year INT,
    CGPA DECIMAL(4,2) CHECK (CGPA >= 0.00 AND CGPA <= 10.00),
    Email VARCHAR(50) UNIQUE NOT NULL,
    Phone_no VARCHAR(15),
    Branch ENUM('CSE', 'ECE', 'AIML') NOT NULL,
    Admin_ID INT,
	Resume_link VARCHAR(255),
    FOREIGN KEY (Admin_ID) REFERENCES Admin(Admin_ID)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Application (
    Appln_ID INT,
    Appln_date DATE NOT NULL,
    Appln_status ENUM('Accepted','Rejected','Pending') DEFAULT 'Pending',
    Resume_link VARCHAR(255),
    Student_SRN CHAR(13) NOT NULL,
    Job_ID INT NOT NULL,
    Company_ID INT,
    Admin_ID INT,
    PRIMARY KEY (Student_SRN,Job_ID,Appln_ID),
    FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (Admin_ID) REFERENCES Admin(Admin_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Interview_Round (
    Round_ID INT PRIMARY KEY AUTO_INCREMENT,
    Round_No INT,
    Round_type VARCHAR(50),
    Interview_Date DATE,
    Result ENUM('Selected','Rejected','On-Hold'),
    Feedback TEXT,
    Interview_mode ENUM('Virtual','Offline'),
    Job_ID INT NOT NULL,
    Company_ID INT,
    FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Job_ID) REFERENCES Job(Job_ID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE For1 (
    SRN CHAR(13),
    Round_ID INT,
    PRIMARY KEY (SRN, Round_ID),
    FOREIGN KEY (SRN) REFERENCES Student(SRN)
	ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Round_ID) REFERENCES Interview_Round(Round_ID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Placement_Offer (
    Offer_ID INT AUTO_INCREMENT,
    SRN CHAR(13),
    Offer_type ENUM('Internship', 'Full-time'),
    Offer_date DATE,
    Package DECIMAL(10,2),
    Placement_status ENUM('Accepted', 'Rejected', 'Pending') DEFAULT 'Pending',
    Joining_date DATE,
    Round_ID INT,
    PRIMARY KEY (Offer_ID, Round_ID),
    FOREIGN KEY (SRN) REFERENCES Student(SRN)
        ON DELETE CASCADE ON UPDATE CASCADE 
);

INSERT INTO Admin (First_name, Middle_name, Last_name, Mail) VALUES
('Ravi', 'Kumar', 'Sharma', 'ravi.sharma@admin.com'),
('Priya', NULL, 'Menon', 'priya.menon@admin.com'),
('Arjun', 'M', 'Patel', 'arjun.patel@admin.com'),
('Sneha', NULL, 'Nair', 'sneha.nair@admin.com'),
('Vikram', 'Raj', 'Singh', 'vikram.singh@admin.com');

INSERT INTO Admin_Phoneno (Admin_ID, Phone_no) VALUES
(1, '9876543210'),
(2, '8765432109'),
(3, '9988776655'),
(4, '9123456780'),
(5, '9090909090');

INSERT INTO Company (Company_Name, Industry, Admin_ID) VALUES
('TechNova Solutions', 'Software', 1),
('InnoBuild Systems', 'Construction', 2),
('Healthify Pvt Ltd', 'Healthcare', 3),
('GreenVolt Energy', 'Renewable Energy', 4),
('FinEdge Finance', 'FinTech', 5);

INSERT INTO CompanyLocation (Company_ID, Location) VALUES
(1, 'Bangalore'),
(1, 'Pune'),
(2, 'Hyderabad'),
(3, 'Mumbai'),
(4, 'Chennai');

INSERT INTO HR (HR_id, HR_email, HR_name, HR_phone, Company_ID) VALUES
('HR001', 'hr.tech@technova.com', 'Meena Rao', '9811111111', 1),
('HR002', 'hr@innobuild.com', 'Suresh Iyer', '9822222222', 2),
('HR003', 'hr@healthify.com', 'Aditi Sharma', '9833333333', 3),
('HR004', 'hr@greenvolt.com', 'Rohan Das', '9844444444', 4),
('HR005', 'hr@finedge.com', 'Kavya Nair', '9855555555', 5);

INSERT INTO Job (Company_ID, Title, Job_type, Duration, CTC, CGPA_cutoff, Eligibility_criteria, date_posted, no_of_positions)
VALUES
(1, 'Software Developer Intern', 'Internship', '6 months', 600000.00, 7.5, 'CSE, AIML students only', '2025-01-15', 3),
(2, 'Project Engineer', 'Full-time', 'Permanent', 800000.00, 7.0, 'All branches eligible', '2025-02-10', 4),
(3, 'Data Analyst Intern', 'Internship', '4 months', 500000.00, 8.0, 'CSE, AIML', '2025-03-05', 2),
(4, 'Electrical Engineer', 'Full-time', 'Permanent', 750000.00, 6.5, 'ECE students only', '2025-03-20', 2),
(5, 'Finance Associate', 'Full-time', 'Permanent', 900000.00, 8.2, 'CSE, AIML, ECE', '2025-04-01', 1);

INSERT INTO Job_Location (Job_ID, Location) VALUES
(1, 'Bangalore'),
(2, 'Hyderabad'),
(3, 'Mumbai'),
(4, 'Chennai'),
(5, 'Pune');

INSERT INTO Student (SRN, First_name, Middle_name, Last_name, DOB, Batch_year, CGPA, Email, Phone_no, Branch, Admin_ID, Resume_link)
VALUES
('PES2UG22CS001', 'Aarav', NULL, 'Verma', '2003-04-12', 2026, 8.6, 'aarav.verma@pes.edu', '9000011111', 'CSE', 1, 'resume_link_aarav.pdf'),
('PES2UG22CS002', 'Diya', NULL, 'Iyer', '2003-07-15', 2026, 9.1, 'diya.iyer@pes.edu', '9000022222', 'AIML', 2, 'resume_link_diya.pdf'),
('PES2UG22CS003', 'Karan', 'Raj', 'Shah', '2002-12-10', 2025, 7.8, 'karan.shah@pes.edu', '9000033333', 'ECE', 3, 'resume_link_karan.pdf'),
('PES2UG22CS004', 'Neha', NULL, 'Reddy', '2003-01-20', 2026, 8.2, 'neha.reddy@pes.edu', '9000044444', 'CSE', 4, 'resume_link_neha.pdf'),
('PES2UG22CS005', 'Rohit', NULL, 'Das', '2003-09-05', 2026, 8.9, 'rohit.das@pes.edu', '9000055555', 'AIML', 5, 'resume_link_rohit.pdf');

INSERT INTO Application (Appln_ID, Appln_date, Appln_status, Resume_link, Student_SRN, Job_ID, Company_ID, Admin_ID)
VALUES
(1, '2025-02-01', 'Pending', 'resume_link_aarav.pdf', 'PES2UG22CS001', 1, 1, 1),
(2, '2025-02-03', 'Accepted', 'resume_link_diya.pdf', 'PES2UG22CS002', 3, 3, 2),
(3, '2025-02-04', 'Rejected', 'resume_link_karan.pdf', 'PES2UG22CS003', 4, 4, 3),
(4, '2025-02-05', 'Pending', 'resume_link_neha.pdf', 'PES2UG22CS004', 2, 2, 4),
(5, '2025-02-07', 'Accepted', 'resume_link_rohit.pdf', 'PES2UG22CS005', 5, 5, 5);

INSERT INTO Interview_Round (Round_No, Round_type, Interview_Date, Result, Feedback, Interview_mode, Job_ID, Company_ID)
VALUES
(1, 'Aptitude Test', '2025-02-10', 'Selected', 'Good logical reasoning', 'Virtual', 1, 1),
(2, 'Technical Round', '2025-02-15', 'Selected', 'Strong coding skills', 'Virtual', 3, 3),
(3, 'HR Round', '2025-02-20', 'Rejected', 'Needs better communication', 'Offline', 4, 4),
(4, 'Group Discussion', '2025-02-22', 'On-Hold', 'Average performance', 'Offline', 2, 2),
(5, 'Final Interview', '2025-02-25', 'Selected', 'Excellent candidate', 'Virtual', 5, 5);

INSERT INTO For1 (SRN, Round_ID) VALUES
('PES2UG22CS001', 1),
('PES2UG22CS002', 2),
('PES2UG22CS003', 3),
('PES2UG22CS004', 4),
('PES2UG22CS005', 5);

INSERT INTO Placement_Offer (SRN, Offer_type, Offer_date, Package, Placement_status, Joining_date, Round_ID)
VALUES
('PES2UG22CS001', 'Internship', '2025-03-01', 600000.00, 'Accepted', '2025-06-01', 1),
('PES2UG22CS002', 'Internship', '2025-03-05', 500000.00, 'Accepted', '2025-06-15', 2),
('PES2UG22CS003', 'Full-time', '2025-03-10', 750000.00, 'Rejected', '2025-07-01', 3),
('PES2UG22CS004', 'Full-time', '2025-03-12', 800000.00, 'Pending', '2025-07-10', 4),
('PES2UG22CS005', 'Full-time', '2025-03-15', 900000.00, 'Accepted', '2025-08-01', 5);

-- Drop functions if they exist
DROP FUNCTION IF EXISTS get_avg_cgpa;
DROP FUNCTION IF EXISTS AvgPlacedPackage;

-- Drop procedures if they exist
DROP PROCEDURE IF EXISTS GetEligibleStudentsForJob;
DROP PROCEDURE IF EXISTS AddStudent;

-- Drop triggers if they exist
DROP TRIGGER IF EXISTS check_cgpa_before_insert;
DROP TRIGGER IF EXISTS trg_log_deleted_company;

-- Function 1
DELIMITER $$
CREATE FUNCTION get_avg_cgpa()
RETURNS DECIMAL(4,2)
DETERMINISTIC
BEGIN
    DECLARE avg_c DECIMAL(4,2);
    SELECT ROUND(AVG(CGPA), 2) INTO avg_c FROM Student;
    RETURN IFNULL(avg_c, 0.00);
END$$

SELECT get_avg_cgpa();

-- Function 2
DELIMITER //
CREATE FUNCTION AvgPlacedPackage()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_pkg DECIMAL(10,2);
    SELECT AVG(Package) INTO avg_pkg
    FROM Placement_Offer
    WHERE Placement_status = 'Accepted';
    RETURN avg_pkg;
END //
DELIMITER ;

SELECT AvgPlacedPackage();

-- Procedure 1
DELIMITER //
CREATE PROCEDURE AddStudent(
    IN p_SRN CHAR(13),
    IN p_First_name VARCHAR(50),
    IN p_Middle_name VARCHAR(20),
    IN p_Last_name VARCHAR(50),
    IN p_DOB DATE,
    IN p_Batch_year INT,
    IN p_CGPA DECIMAL(4,2),
    IN p_Email VARCHAR(50),
    IN p_Phone_no VARCHAR(15),
    IN p_Branch VARCHAR(10),
    IN p_Admin_ID INT,
    IN p_Resume_link VARCHAR(255)
)
BEGIN
    INSERT INTO Student (
        SRN, First_name, Middle_name, Last_name, DOB,
        Batch_year, CGPA, Email, Phone_no, Branch, Admin_ID, Resume_link
    )
    VALUES (
        p_SRN, p_First_name, p_Middle_name, p_Last_name, p_DOB,
        p_Batch_year, p_CGPA, p_Email, p_Phone_no, p_Branch, p_Admin_ID, p_Resume_link
    );
END //

DELIMITER ;

CALL AddStudent(
    'PES2UG22CS015', 'Riya', NULL, 'Singh', '2003-06-18',
    2026, 8.5, 'riya.singh@pes.edu', '9004686446', 'CSE',2, 'resume_link_riya.pdf'
);

SELECT * FROM student;

-- Procedure 2
DELIMITER //
CREATE PROCEDURE GetEligibleStudentsForJob(IN p_JobID INT)
BEGIN
    SELECT s.SRN, s.First_name, s.CGPA, j.Title, j.CGPA_cutoff
    FROM Student s
    JOIN Job j ON j.Job_ID = p_JobID
    WHERE s.CGPA >= j.CGPA_cutoff;
END //
DELIMITER ;

CALL GetEligibleStudentsForJob(1);

CREATE TABLE Deleted_Companies_Log (
    Company_ID INT,
    Company_Name VARCHAR(100),
    Deleted_At DATETIME
);

-- Trigger 1
DELIMITER //
CREATE TRIGGER trg_log_deleted_company
AFTER DELETE ON Company
FOR EACH ROW
BEGIN
    INSERT INTO Deleted_Companies_Log (Company_ID, Company_Name, Deleted_At)
    VALUES (OLD.Company_ID, OLD.Company_Name, NOW());
END //
DELIMITER ;
-- INSERT INTO Company (Company_Name, Industry, Admin_ID) VALUES ('Healthify Pvt Ltd', 'Healthcare', 3);
DELETE FROM Company
WHERE Admin_ID = 3;
Select * from Deleted_Companies_Log;

-- Trigger 2
DELIMITER //
CREATE TRIGGER check_cgpa_before_insert
BEFORE INSERT ON Student
FOR EACH ROW
BEGIN
    IF NEW.CGPA < 6.5 OR NEW.CGPA > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid CGPA. Must be between 6.5 and 10.';
    END IF;
END//
DELIMITER ;
INSERT INTO Student Values('PES2UG22CS008', 'Nons', NULL, 'sharma', '2003-04-12', 2026, 6.4, 'arushi.sharma@pes.edu', '9000011211', 'CSE', 1, 'resume_link_nons.pdf');