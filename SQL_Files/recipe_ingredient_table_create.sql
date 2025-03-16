CREATE TABLE recipe_ingredients_table (
    recipe_id SERIAL, 
    ingredient_id SERIAL, 
    portion DECIMAL(4,2), 
    PRIMARY KEY (recipe_id, ingredient_id), 
    FOREIGN KEY (recipe_id) REFERENCES recipes_table(recipe_id) ON DELETE CASCADE, 
    FOREIGN KEY (ingredient_id) REFERENCES ingredient_table(ingredient_id) ON DELETE CASCADE
);

-- Test Insert Statements with fraction-like portions
INSERT INTO recipe_ingredients_table (recipe_id, ingredient_id, portion) 
VALUES 
(1, 1, 2.00),  -- Sourdough Starter → 2 cups Flour
(1, 3, 0.75),  -- Sourdough Starter → 3/4 cup Milk
(2, 1, 3.50),  -- Classic Bread Loaf → 3 1/2 cups Flour
(2, 4, 0.50),  -- Classic Bread Loaf → 1/2 cup Butter
(3, 2, 1.25),  -- Fruit Jam Preservation → 1 1/4 cups Sugar
(3, 3, 0.50),  -- Fruit Jam Preservation → 1/2 cup Milk
(4, 2, 0.75),  -- Pickled Vegetables → 3/4 cup Sugar
(4, 3, 1.50);  -- Pickled Vegetables → 1 1/2 cups Milk

ALTER TABLE recipe_ingredients_table ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read.
CREATE POLICY "Public Read Recipe Ingredients"
ON recipe_ingredients_table
FOR SELECT
USING (true);