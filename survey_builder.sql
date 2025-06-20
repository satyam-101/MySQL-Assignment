-- ======================================
-- 0. DATABASE CREATION
-- ======================================

CREATE DATABASE online_survey;
USE online_survey;

-- ======================================
-- 1. SCHEMA DESIGN & TABLE RELATIONSHIPS
-- ======================================

-- 1.1 Question types for different kinds of survey questions
CREATE TABLE question_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT 'E.g., Single Choice, Multiple Choice, Text Input, Rating Scale'
);

-- 1.2 User accounts (with anonymous support)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    is_anonymous BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1.3 Survey metadata (title, validity period, template status)
CREATE TABLE surveys (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    is_template BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1.4 Questions belonging to a survey
CREATE TABLE questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    survey_id INT,
    text TEXT NOT NULL,
    question_type_id INT,
    page_number INT DEFAULT 1,
    FOREIGN KEY (survey_id) REFERENCES surveys(id) ON DELETE CASCADE,
    FOREIGN KEY (question_type_id) REFERENCES question_types(id)
);

-- 1.5 Options for single/multiple choice questions
CREATE TABLE options (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT,
    option_text VARCHAR(255) NOT NULL,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

-- 1.6 Survey submission metadata
CREATE TABLE responses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    survey_id INT,
    response_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (survey_id) REFERENCES surveys(id) ON DELETE CASCADE
);

-- 1.7 Answers given by the user (text or rating)
CREATE TABLE response_answers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    response_id INT,
    question_id INT,
    text_answer TEXT,
    rating_value INT,
    FOREIGN KEY (response_id) REFERENCES responses(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

-- 1.8 Chosen options (for choice questions)
CREATE TABLE response_options (
    id INT AUTO_INCREMENT PRIMARY KEY,
    response_answer_id INT,
    option_id INT,
    FOREIGN KEY (response_answer_id) REFERENCES response_answers(id) ON DELETE CASCADE,
    FOREIGN KEY (option_id) REFERENCES options(id) ON DELETE CASCADE
);

-- ======================================
-- 2. SAMPLE DATA (Minimum 5 per table)
-- ======================================

INSERT INTO question_types (name) VALUES 
('Single Choice'), ('Multiple Choice'), ('Text Input'), ('Rating Scale');

INSERT INTO users (name, email, is_anonymous) VALUES 
('Raju', 'raju@example.com', FALSE),
('Sahil', 'sahil@example.com', FALSE),
('Balaji', 'balaji@example.com', FALSE),
(NULL, NULL, TRUE),
(NULL, NULL, TRUE);

INSERT INTO surveys (title, description, start_date, end_date) VALUES 
('Customer Satisfaction Survey', 'Monthly feedback survey', '2025-06-01', '2025-06-30'),
('Product Feature Feedback', 'New feature evaluation', '2025-06-01', '2025-07-01');

INSERT INTO questions (survey_id, text, question_type_id, page_number) VALUES 
(1, 'How satisfied are you with our service?', 4, 1),
(1, 'Which features do you use?', 2, 1),
(1, 'Any suggestions?', 3, 2),
(2, 'Would you recommend our app?', 1, 1),
(2, 'Rate the new dashboard.', 4, 1);

INSERT INTO options (question_id, option_text) VALUES 
(2, 'Search'), (2, 'Dashboard'), (2, 'Reports'), (2, 'Analytics'),
(4, 'Yes'), (4, 'No');

INSERT INTO responses (user_id, survey_id) VALUES 
(1, 1), (2, 1), (3, 1), (4, 1), (5, 2);

INSERT INTO response_answers (response_id, question_id, rating_value) VALUES 
(1, 1, 5), (2, 1, 4), (3, 1, 3), (4, 1, 4), (5, 5, 5);

INSERT INTO response_answers (response_id, question_id, text_answer) VALUES 
(1, 3, 'Improve UI'), (2, 3, 'Add dark mode'), (3, 3, 'More integrations'), (4, 3, 'Better support');

INSERT INTO response_answers (response_id, question_id) VALUES 
(1, 2), (2, 2), (3, 2), (4, 2), (5, 4);

INSERT INTO response_options (response_answer_id, option_id) VALUES 
(9, 1), (9, 2),
(10, 2), (10, 3),
(11, 1), (11, 3),
(12, 2), (12, 4),
(13, 6);

-- ======================================
-- 3. QUERIES SHOWING THE IMPLEMENTATION OF THE FEATURES
-- ======================================

-- 3.1 List all surveys and their active periods
SELECT id, title, description, start_date, end_date, is_template
FROM surveys;

-- 3.2 List all questions in a specific survey with their types
SELECT q.id, q.text, qt.name AS question_type
FROM questions q
JOIN question_types qt ON q.question_type_id = qt.id
WHERE q.survey_id = 1;

-- 3.3 List all supported question types
SELECT * FROM question_types;

-- 3.4 List all options for a given multiple choice question
SELECT option_text FROM options WHERE question_id = 2;

-- 3.5 Show all user responses
SELECT r.id, u.name, s.title AS survey, r.response_date
FROM responses r
JOIN users u ON r.user_id = u.id
JOIN surveys s ON r.survey_id = s.id;

-- 3.6 Show text and rating answers for survey 1
SELECT q.text AS question, ra.text_answer, ra.rating_value
FROM response_answers ra
JOIN questions q ON ra.question_id = q.id
JOIN responses r ON ra.response_id = r.id
WHERE r.survey_id = 1;

-- 3.7 Count responses per question
SELECT q.text AS question, COUNT(ra.id) AS total_responses
FROM response_answers ra
JOIN questions q ON ra.question_id = q.id
GROUP BY q.id;

-- 3.8 Average rating per question
SELECT q.text AS question, AVG(ra.rating_value) AS avg_rating
FROM response_answers ra
JOIN questions q ON ra.question_id = q.id
WHERE q.question_type_id = 4
GROUP BY q.id;

-- 3.9 Count how many times each option was selected
SELECT q.text AS question, o.option_text, COUNT(ro.id) AS times_selected
FROM response_options ro
JOIN response_answers ra ON ro.response_answer_id = ra.id
JOIN options o ON ro.option_id = o.id
JOIN questions q ON ra.question_id = q.id
GROUP BY q.text, o.option_text;

-- 3.10 Show which users responded anonymously
SELECT u.id AS user_id, u.name, u.is_anonymous
FROM users u
JOIN responses r ON u.id = r.user_id
WHERE u.is_anonymous = TRUE;

-- 3.11 Show paginated questions (by page number)
SELECT text, page_number
FROM questions
WHERE survey_id = 1
ORDER BY page_number;

-- 3.12 Show currently active surveys (based on date)
SELECT id, title, start_date, end_date
FROM surveys
WHERE CURDATE() BETWEEN start_date AND end_date;

-- 3.13 Export response answers to CSV (with headers) [Windows path]
(
  SELECT 'id', 'response_id', 'question_id', 'text_answer', 'rating_value'
  UNION ALL
  SELECT id, response_id, question_id, text_answer, rating_value FROM response_answers
)
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/survey_results.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\\r\\n';