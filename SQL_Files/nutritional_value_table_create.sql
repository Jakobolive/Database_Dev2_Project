CREATE TABLE nutritional_value_table (
    nutritional_info_id SERIAL PRIMARY KEY, 
    serving_size DECIMAL(4,2), 
    calories DECIMAL(4,2), 
    total_fat DECIMAL(4,2), 
    saturated_fat DECIMAL(4,2), 
    trans_fat DECIMAL(4,2), 
    total_carbs DECIMAL(4,2), 
    fiber DECIMAL(4,2), 
    sugar DECIMAL(4,2), 
    added_sugars DECIMAL(4,2), 
    protein DECIMAL(4,2), 
    cholesterol DECIMAL(4,2), 
    sodium DECIMAL(4,2)
);

-- Test Insert Statements
INSERT INTO nutritional_value_table (nutritional_info_id, serving_size, calories, total_fat, saturated_fat, trans_fat, total_carbs, fiber, sugar, added_sugars, protein, cholesterol, sodium) 
VALUES 
(1, 5.00, 0.75, 0.50, 0.25, 0.00, 0.50, 0.75, 0.25, 0.50, 0.75, 0.25, 0.50), 
(2, 5.00, 0.50, 0.25, 0.00, 0.00, 0.75, 0.50, 0.00, 0.25, 0.50, 0.75, 0.25);

ALTER TABLE nutritional_value_table ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read.
CREATE POLICY "Public Read Nutritional Values"
ON nutritional_value_table
FOR SELECT
USING (true);
