CREATE TABLE sales_table (
    sale_id SERIAL PRIMARY KEY,
    total_price DECIMAL(6,2),
    sale_date DATE DEFAULT CURRENT_DATE
);

-- Insert the sales data into sales_table
INSERT INTO sales_table (total_price, sale_date) 
VALUES 
(17.97, '2025/03/16'),  -- Total price for 3 Small Sourdough Bread Kits
(19.98, '2025/03/15'),  -- Total price for 2 Large Sourdough Bread Kits
(17.45, '2025/03/14'),  -- Total price for 5 Regular Classic Bread Loafs
(49.90, '2025/03/13'),  -- Total price for 10 500g Strawberry Jam
(45.43, '2025/03/12')   -- Total price for 7 Jars of Pickled Cucumbers
RETURNING sale_id;

-- Junction Table to Store Multiple Variations per Sale
CREATE TABLE sales_variations_table (
    sale_variation_id SERIAL PRIMARY KEY,
    sale_id INT,
    variation_id INT,
    quantity INT,
    FOREIGN KEY (sale_id) REFERENCES sales_table(sale_id) ON DELETE CASCADE,
    FOREIGN KEY (variation_id) REFERENCES product_variation_table(variation_id) ON DELETE CASCADE
);

-- Insert sales variations for each sale
INSERT INTO sales_variations_table (sale_id, variation_id, quantity) 
VALUES
(1, 1, 3),  -- 3 Small Sourdough Bread Kits for sale 1
(2, 2, 2),  -- 2 Large Sourdough Bread Kits for sale 2
(3, 3, 5),  -- 5 Regular Classic Bread Loafs for sale 3
(4, 4, 10), -- 10 500g Strawberry Jam for sale 4
(5, 5, 7);  -- 7 Jars of Pickled Cucumbers for sale 5

-- Enable Row Level Security
ALTER TABLE sales_table ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales_variations_table ENABLE ROW LEVEL SECURITY;

-- Allow Public Read Access
CREATE POLICY "Public Read Sales"
ON sales_table
FOR SELECT
USING (true);

-- Allow Public Insert Access
CREATE POLICY "Public Insert Sales"
ON sales_table
FOR INSERT
WITH CHECK (true);

-- Allow Public Read Access
CREATE POLICY "Public Read Sales Variations"
ON sales_variations_table
FOR SELECT
USING (true);

-- Allow Public Insert Access
CREATE POLICY "Public Insert Sales Variations"
ON sales_variations_table
FOR INSERT
WITH CHECK (true);
