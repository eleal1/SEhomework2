-- Create database
CREATE DATABASE IF NOT EXISTS recipe_site;
USE recipe_site;

-- Ingredients table
CREATE TABLE ingredients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    origin VARCHAR(100),
    safety_tip TEXT,
    interesting_fact TEXT
);

-- Recipes table
CREATE TABLE recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    instructions TEXT,
    protein_type ENUM('Chicken', 'Beef', 'Tofu', 'Grains', 'Fish') NOT NULL,
    image_url VARCHAR(255)
    UPDATE recipes SET image_url = '/images/chicken.jpg' WHERE name = 'Garlic Chicken';
    UPDATE recipes SET image_url = '/images/burger.jpg' WHERE name = 'Classic Burger';
    UPDATE recipes SET image_url = '/images/tofu.jpg' WHERE name = 'Tofu Stir Fry';
    UPDATE recipes SET image_url = '/images/quinoa.jpg' WHERE name = 'Quinoa Salad';
);

-- Recipe-Ingredients junction table
CREATE TABLE recipe_ingredients (
    recipe_id INT,
    ingredient_id INT,
    PRIMARY KEY (recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id) ON DELETE CASCADE
);

-- Sample ingredients
INSERT INTO ingredients (name, description, origin, safety_tip, interesting_fact) VALUES
('Chicken Breast', 'Lean protein source', 'Domestic fowl', 'Cook to internal temperature of 165°F (74°C)', 'Chicken is the most common type of poultry in the world'),
('Olive Oil', 'Healthy fat from olives', 'Mediterranean region', 'Store in cool, dark place to prevent rancidity', 'Olive oil was used to anoint kings and athletes in ancient Greece'),
('Garlic', 'Pungent bulb used for flavor', 'Central Asia', 'Can cause bad breath and heartburn in excess', 'Garlic has been used for medicinal purposes for thousands of years'),
('Basil', 'Aromatic herb', 'Tropical regions from central Africa to Southeast Asia', 'Generally safe, but can cause low blood sugar in large amounts', 'Considered sacred in some cultures'),
('Tomato', 'Red fruit used as vegetable', 'Western South America', 'Store at room temperature until ripe', 'Botanically a fruit but legally a vegetable in the US'),
('Ground Beef', 'Minced beef', 'Cattle', 'Cook to internal temperature of 160°F (71°C)', 'Hamburgers became popular at the 1904 St. Louis World\'s Fair'),
('Tofu', 'Soybean curd', 'China', 'Store in water and change daily', 'Tofu has been made for over 2,000 years'),
('Quinoa', 'Ancient grain', 'Andes region of South America', 'Rinse before cooking to remove saponins', 'NASA considers it for long-duration space missions');

-- Sample recipes
INSERT INTO recipes (name, description, instructions, protein_type, image_url) VALUES
('Garlic Chicken', 'Simple and flavorful chicken dish', '1. Season chicken with salt and pepper\n2. Heat oil in pan\n3. Cook chicken until golden\n4. Add garlic and cook until fragrant\n5. Serve hot', 'Chicken', '/images/chicken.jpg'),
('Classic Burger', 'Juicy beef burger', '1. Mix beef with seasonings\n2. Form patties\n3. Grill to desired doneness\n4. Serve on buns with toppings', 'Beef', '/images/burger.jpg'),
('Tofu Stir Fry', 'Healthy vegetarian option', '1. Press tofu to remove water\n2. Cut into cubes\n3. Stir fry with vegetables\n4. Add sauce and serve', 'Tofu', '/images/tofu.jpg'),
('Quinoa Salad', 'Nutritious grain salad', '1. Cook quinoa according to package\n2. Let cool\n3. Mix with vegetables and dressing\n4. Chill before serving', 'Grains', '/images/quinoa.jpg');

-- Recipe-Ingredient relationships
INSERT INTO recipe_ingredients VALUES
(1, 1), (1, 2), (1, 3),
(2, 2), (2, 6),
(3, 2), (3, 7), (3, 5),
(4, 2), (4, 8), (4, 5);