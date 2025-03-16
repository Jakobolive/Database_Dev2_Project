CREATE TABLE sales_table (
    sale_id SERIAL PRIMARY KEY, 
    variation_id SERIAL, 
    quantity INT, 
    total_price DECIMAL(6,2), 
    sale_date DATE,
    FOREIGN KEY (variation_id) REFERENCES product_variation_table(variation_id) ON DELETE CASCADE
);

-- Test Insert Statements with sale records
INSERT INTO sales_table (sale_id, variation_id, quantity, total_price, sale_date) 
VALUES 
(1, 1, 3, 17.97, '2025/03/16'),  -- 3 Small Sourdough Bread Kits, $17.97, sold on March 16, 2025
(2, 2, 2, 19.98, '2025/03/15'),  -- 2 Large Sourdough Bread Kits, $19.98, sold on March 15, 2025
(3, 3, 5, 17.45, '2025/03/14'),  -- 5 Regular Classic Bread Loafs, $17.45, sold on March 14, 2025
(4, 4, 10, 49.90, '2025/03/13'),  -- 10 500g Strawberry Jam, $49.90, sold on March 13, 2025
(5, 5, 7, 45.43, '2025/03/12');  -- 7 Jars of Pickled Cucumbers, $45.43, sold on March 12, 2025

ALTER TABLE sales_table ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read.
CREATE POLICY "Public Read Sales"
ON sales_table
FOR SELECT
USING (true);