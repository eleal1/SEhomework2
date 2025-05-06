const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// Database connection
const db = require('./database/connection');

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// Set EJS as view engine
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// Routes
app.get('/', (req, res) => {
    res.render('home', { title: 'Home | My Recipe Site' });
});

app.get('/recipes', (req, res) => {
    const query = `
        SELECT r.id, r.name, r.protein_type, r.description, r.image_url, 
               GROUP_CONCAT(i.name SEPARATOR ', ') as ingredients
        FROM recipes r
        JOIN recipe_ingredients ri ON r.id = ri.recipe_id
        JOIN ingredients i ON ri.ingredient_id = i.id
        GROUP BY r.id
    `;
    
    db.query(query, (err, results) => {
        if (err) throw err;
        
        // Organize by protein type
        const recipesByProtein = {};
        results.forEach(recipe => {
            if (!recipesByProtein[recipe.protein_type]) {
                recipesByProtein[recipe.protein_type] = [];
            }
            recipesByProtein[recipe.protein_type].push(recipe);
        });
        
        res.render('recipes', { 
            title: 'Recipes | My Recipe Site',
            recipesByProtein 
        });
    });
});

app.get('/recipe/:id', (req, res) => {
    const recipeId = req.params.id;
    
    const recipeQuery = 'SELECT * FROM recipes WHERE id = ?';
    const ingredientsQuery = `
        SELECT i.* FROM ingredients i
        JOIN recipe_ingredients ri ON i.id = ri.ingredient_id
        WHERE ri.recipe_id = ?
    `;
    
    db.query(recipeQuery, [recipeId], (err, recipeResults) => {
        if (err) throw err;
        
        if (recipeResults.length === 0) {
            return res.status(404).send('Recipe not found');
        }
        
        const recipe = recipeResults[0];
        
        db.query(ingredientsQuery, [recipeId], (err, ingredientResults) => {
            if (err) throw err;
            
            res.render('recipe', {
                title: `${recipe.name} | My Recipe Site`,
                recipe,
                ingredients: ingredientResults
            });
        });
    });
});

app.get('/add-recipe', (req, res) => {
    db.query('SELECT * FROM ingredients', (err, ingredients) => {
        if (err) throw err;
        res.render('add-recipe', {
            title: 'Add Recipe | My Recipe Site',
            ingredients
        });
    });
});

app.post('/add-recipe', (req, res) => {
    const { name, description, instructions, protein_type, image_url, ingredients } = req.body;
    
    // First insert the recipe
    const insertRecipe = 'INSERT INTO recipes (name, description, instructions, protein_type, image_url) VALUES (?, ?, ?, ?, ?)';
    
    db.query(insertRecipe, [name, description, instructions, protein_type, image_url], (err, result) => {
        if (err) throw err;
        
        const recipeId = result.insertId;
        const ingredientIds = Array.isArray(ingredients) ? ingredients : [ingredients];
        
        // Insert recipe-ingredient relationships
        const insertRelations = 'INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES ?';
        const relations = ingredientIds.map(id => [recipeId, id]);
        
        db.query(insertRelations, [relations], (err) => {
            if (err) throw err;
            res.redirect(`/recipe/${recipeId}`);
        });
    });
});

// Start server
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});