CREATE TABLE recipes_table (
    recipe_id SERIAL PRIMARY KEY, 
    recipe_name VARCHAR(255), 
    recipe_desc VARCHAR(255)
);

-- Test Insert Statements related to baking & food preservation
INSERT INTO recipes_table (recipe_id, recipe_name, recipe_desc) 
VALUES 
(1, 'Sourdough Starter', 'A fermented mixture of flour and water used as a natural yeast for baking.'), 
(2, 'Classic Bread Loaf', 'A simple homemade bread recipe with a long fermentation process for better flavor.'), 
(3, 'Fruit Jam Preservation', 'A step-by-step guide to making and canning homemade fruit jam.'), 
(4, 'Pickled Vegetables', 'A traditional method for preserving vegetables using vinegar, salt, and spices.'), 
(5, 'Homemade Granola Bars', 'Nutritious baked bars made with oats, honey, and dried fruit for long-term storage.');

ALTER TABLE recipes_table ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read.
CREATE POLICY "Public Read Recipes"
ON recipes_table
FOR SELECT
USING (true);