DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin','student') NOT NULL,
    ref_id VARCHAR(50)
);

INSERT INTO Users (username, password, role, ref_id) VALUES
('admin1', 'adminpass', 'admin', '1'),
('PES2UG22CS001', 'studentpass', 'student', 'PES2UG22CS001');
