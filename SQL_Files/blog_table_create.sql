-- Create blog_table with employee_id as a foreign key.
CREATE TABLE blog_table (
    blog_id SERIAL PRIMARY KEY,
    blog_title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    published_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees_table(id) ON DELETE CASCADE
);

-- Insert a test entry into the blog_table, linking to Aunt Rosie's employee ID.
INSERT INTO blog_table (blog_title, author, message, published_date, employee_id)
VALUES (
    'Aunt Rosie''s First Post',  
    'Aunt Rosie',
    'Welcome to Aunt Rosie''s blog where I share my delicious pie recipes and stories.',  
    CURRENT_TIMESTAMP,
    (SELECT id FROM employees_table WHERE username = 'Rosie123')
);

ALTER TABLE blog_table ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read blogs.
CREATE POLICY "Public Read Blogs"
ON blog_table
FOR SELECT
USING (true);

-- Allow anyone to insert into blog_table
CREATE POLICY "Public Insert Blogs"
ON blog_table
FOR INSERT
WITH CHECK (true);