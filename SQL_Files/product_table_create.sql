CREATE TABLE product_table (
    product_id SERIAL PRIMARY KEY, 
    recipe_id SERIAL, 
    product_name VARCHAR(255), 
    description VARCHAR(255),
    FOREIGN KEY (recipe_id) REFERENCES recipes_table(recipe_id) ON DELETE CASCADE
);

-- Test Insert Statements related to baking & preservation
INSERT INTO product_table (product_id, recipe_id, product_name, description) 
VALUES 
(1, 1, 'Sourdough Bread Kit', 'A ready-to-use sourdough starter with flour for homemade baking.'), 
(2, 2, 'Classic Bread Loaf', 'Freshly baked bread using traditional fermentation techniques.'), 
(3, 3, 'Strawberry Jam', 'Homemade fruit jam with no artificial preservatives.'), 
(4, 4, 'Pickled Cucumbers', 'Crisp cucumbers preserved in vinegar and spices.');

ALTER TABLE product_table ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read.
CREATE POLICY "Public Read Products"
ON product_table
FOR SELECT
USING (true);