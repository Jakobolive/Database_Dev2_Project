CREATE TABLE product_variation_table (
    variation_id SERIAL PRIMARY KEY, 
    product_id SERIAL, 
    size VARCHAR(20), 
    cost DECIMAL(5,2), 
    stock INT,
    FOREIGN KEY (product_id) REFERENCES product_table(product_id) ON DELETE CASCADE
);

-- Test Insert Statements with product variations
INSERT INTO product_variation_table (variation_id, product_id, size, cost, stock) 
VALUES 
(1, 1, 'Small', 5.99, 50),  -- Sourdough Bread Kit → Small size, $5.99, 50 in stock
(2, 1, 'Large', 9.99, 30),  -- Sourdough Bread Kit → Large size, $9.99, 30 in stock
(3, 2, 'Regular', 3.49, 100),  -- Classic Bread Loaf → Regular size, $3.49, 100 in stock
(4, 3, '500g', 4.99, 75),  -- Strawberry Jam → 500g size, $4.99, 75 in stock
(5, 4, 'Jar', 6.49, 40);  -- Pickled Cucumbers → Jar size, $6.49, 40 in stock

ALTER TABLE product_variation_table ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read.
CREATE POLICY "Public Read Product Variations"
ON product_variation_table
FOR SELECT
USING (true);