-- Simple SQL practice: online course platform example

-- Drop tables if they already exist
DROP TABLE IF EXISTS enrolments;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;

-- Create tables
CREATE TABLE students (
    student_id   SERIAL PRIMARY KEY,
    first_name   VARCHAR(50) NOT NULL,
    last_name    VARCHAR(50) NOT NULL,
    email        VARCHAR(100) UNIQUE NOT NULL,
    join_date    DATE NOT NULL
);

CREATE TABLE courses (
    course_id    SERIAL PRIMARY KEY,
    course_name  VARCHAR(100) NOT NULL,
    difficulty   VARCHAR(20) CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
    active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE enrolments (
    enrolment_id SERIAL PRIMARY KEY,
    student_id   INTEGER NOT NULL REFERENCES students(student_id),
    course_id    INTEGER NOT NULL REFERENCES courses(course_id),
    enrol_date   DATE NOT NULL,
    completion_percentage NUMERIC(5,2) DEFAULT 0.0
);

-- Insert sample data
INSERT INTO students (first_name, last_name, email, join_date) VALUES
('Alice', 'Smith', 'alice@example.com', '2025-01-01'),
('Bob', 'Jones', 'bob@example.com', '2025-01-05'),
('Charlie', 'Nguyen', 'charlie@example.com', '2025-01-10');

INSERT INTO courses (course_name, difficulty, active) VALUES
('Intro to Python', 'beginner', TRUE),
('Data Analysis with SQL', 'intermediate', TRUE),
('Advanced Machine Learning', 'advanced', FALSE);

INSERT INTO enrolments (student_id, course_id, enrol_date, completion_percentage) VALUES
(1, 1, '2025-01-02', 100.0),
(1, 2, '2025-01-07', 60.0),
(2, 1, '2025-01-06', 80.0),
(3, 2, '2025-01-15', 40.0);

-- 1. List all active courses
SELECT course_id, course_name, difficulty
FROM courses
WHERE active = TRUE;

-- 2. Find all students who joined after 3rd January 2025
SELECT first_name, last_name, email
FROM students
WHERE join_date > '2025-01-03';

-- 3. Show enrolments with student and course names
SELECT
    e.enrolment_id,
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_name,
    e.enrol_date,
    e.completion_percentage
FROM enrolments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY e.enrol_date;

-- 4. Average completion percentage per course
SELECT
    c.course_name,
    AVG(e.completion_percentage) AS avg_completion
FROM courses c
JOIN enrolments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY avg_completion DESC;

-- 5. Count how many students are enrolled on each difficulty level
SELECT
    c.difficulty,
    COUNT(DISTINCT e.student_id) AS students_enrolled
FROM courses c
JOIN enrolments e ON c.course_id = e.course_id
GROUP BY c.difficulty;
