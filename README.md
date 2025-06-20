# 📊 Online Survey Builder - MySQL Project
**Author:** Satyam Singh

## 🧩 Project Overview
This project implements a full-featured **Online Survey Builder** using **MySQL** only. It supports dynamic surveys, question types, user submissions (including anonymous responses), and analytic reporting using SQL queries.

## ✅ Objectives Covered

### 1. Database Schema & Relationships
- **Users**: Tracks user info including anonymous support.
- **Surveys**: Stores survey metadata (title, description, validity).
- **Questions**: Dynamically linked to surveys and categorized by type.
- **Question Types**: Four types — Single Choice, Multiple Choice, Text Input, Rating Scale.
- **Options**: Stores answer choices for choice-based questions.
- **Responses**: Main record of a user's survey submission.
- **Response Answers**: Stores user answers (text or rating).
- **Response Options**: Records selected options for choice-based questions.

All tables use **foreign keys** for integrity and follow **3NF** design principles.

### 2. Sample Data
Each table includes **at least 5 tuples** with related records to demonstrate full functionality and allow all validation queries to run correctly.

### 3. Features Implemented (with Corresponding Queries)

| Feature No. | Feature Description                                      | Query No. | Query Summary                                     |
|-------------|-----------------------------------------------------------|-----------|--------------------------------------------------|
| 1           | List all created surveys                                 | 3.1       | SELECT all from `surveys`                        |
| 2           | Dynamic questions per survey                             | 3.2       | JOIN `questions` and `question_types`            |
| 3           | Show all question types                                  | 3.3       | SELECT * from `question_types`                   |
| 4           | Show options for a question                              | 3.4       | SELECT from `options` WHERE question_id = ?      |
| 5           | Show all user responses                                  | 3.5       | JOIN `responses`, `users`, and `surveys`         |
| 6           | Display text and rating answers                          | 3.6       | JOIN `response_answers`, `questions`, and `responses` |
| 7           | Count responses per question                             | 3.7       | GROUP BY question_id                             |
| 8           | Average rating per question                              | 3.8       | AVG on `rating_value` for rating-type questions  |
| 9           | Count each option selected                               | 3.9       | JOIN `response_options`, `options`, `questions`  |
| 10          | List anonymous respondents                               | 3.10      | WHERE `is_anonymous = TRUE`                      |
| 11          | Show paginated questions                                 | 3.11      | ORDER BY `page_number`                           |
| 12          | Show active surveys only                                 | 3.12      | WHERE CURDATE() BETWEEN start_date AND end_date  |
| 13          | Export all response answers with headers (CSV)           | 3.13      | `SELECT INTO OUTFILE` with headers using UNION   |

### 4. Export Functionality
- Response data is exportable using MySQL’s `SELECT ... INTO OUTFILE` syntax.
- The `UNION` trick is used to add column headers in the output.
- File export is compliant with MySQL’s `secure_file_priv` restriction.

Example (Windows):
```sql
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/survey_results.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n';
```

### 5. Assumptions
- Anonymous users are represented with `NULL` name/email but have valid `user_id` entries.
- The schema supports pagination via `page_number` and flexible data types for answers.

## 🔍 How to Use
1. Run the `.sql` file in MySQL Workbench or CLI.
2. Ensure your `secure_file_priv` is set correctly for CSV export.
3. Use the queries provided to test features and generate insights.

## 📦 File Contents
- `Online_Survey_Builder_Assignment.sql` – Full schema + sample data + validation queries.
- `README_Online_Survey_Project.txt` – This file explaining features and how to use them.

## 🏁 Final Notes
- Designed for clarity, normalization, and completeness.
- All 13 assignment features implemented successfully.

Feel free to customize the data or queries to suit your UI/frontend needs!
