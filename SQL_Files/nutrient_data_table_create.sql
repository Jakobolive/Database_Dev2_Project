CREATE TABLE nutrient_data_table (
    nutrient_id SERIAL PRIMARY KEY, 
    nutritional_info_id SERIAL, 
    nutrient_name VARCHAR(60), 
    amount DECIMAL(4,2), 
    unit VARCHAR(60),
    FOREIGN KEY (nutritional_info_id) REFERENCES nutritional_value_table(nutritional_info_id) ON DELETE CASCADE
);

-- Test Insert Statements with fraction-like values
INSERT INTO nutrient_data_table (nutrient_id, nutritional_info_id, nutrient_name, amount, unit) 
VALUES 
(1, 1, 'Vitamin C', 0.75, 'mg'), 
(2, 1, 'Calcium', 1.50, 'mg'), 
(3, 2, 'Iron', 2.25, 'mg'), 
(4, 2, 'Potassium', 1.75, 'mg');

ALTER TABLE nutrient_data_table ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read.
CREATE POLICY "Public Read Nutrient Data"
ON nutrient_data_table
FOR SELECT
USING (true);