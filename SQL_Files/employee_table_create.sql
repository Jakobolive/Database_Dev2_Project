-- Create employee table to contain employee/user information.
CREATE TABLE employees_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Enable pgcrypto extension possibly needed if ran out of Supabase. (run once)
--CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Insert a new employee (Aunt Rosie) into the employees table.
INSERT INTO employees_table (name, username, email, password, phone_number)
VALUES (
    'Aunt Rosie',
    'Rosie123',
    'auntrosie@gmail.com',
    crypt('password123', gen_salt('bf')),
    '123-456-7890'
);

-- Delete test values from the employees table.
Delete from employees_table where name = 'Aunt Rosie';

ALTER TABLE employees_table ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read employees. (excluding sensitive fields)
CREATE POLICY "Public Read Employees"
ON employees_table
FOR SELECT
USING (true);
