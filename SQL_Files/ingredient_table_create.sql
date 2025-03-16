CREATE TABLE ingredient_table (
    ingredient_id SERIAL PRIMARY KEY, 
    ingredient_name VARCHAR(60), 
    measurement DECIMAL(4,2), 
    nutrient_id SERIAL,
    FOREIGN KEY (nutrient_id) REFERENCES nutrient_data_table(nutrient_id) ON DELETE CASCADE
);

-- Test Insert Statements with fraction-like values
INSERT INTO ingredient_table (ingredient_id, ingredient_name, measurement, nutrient_id) 
VALUES 
(1, 'Flour', 1.50, 1), 
(2, 'Sugar', 0.75, 2), 
(3, 'Milk', 2.25, 3), 
(4, 'Butter', 1.25, 4);

ALTER TABLE ingredient_table ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read.
CREATE POLICY "Public Read Ingredients"
ON ingredient_table
FOR SELECT
USING (true);