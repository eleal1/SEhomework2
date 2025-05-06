// Ingredient hover tooltips
document.addEventListener('DOMContentLoaded', function() {
    const ingredientItems = document.querySelectorAll('.ingredient-item');
    
    ingredientItems.forEach(item => {
        item.addEventListener('mouseenter', function() {
            const tooltip = this.querySelector('.ingredient-tooltip');
            tooltip.style.display = 'block';
            
            // Position tooltip
            const rect = this.getBoundingClientRect();
            tooltip.style.left = `${rect.left}px`;
            tooltip.style.top = `${rect.bottom}px`;
        });
        
        item.addEventListener('mouseleave', function() {
            const tooltip = this.querySelector('.ingredient-tooltip');
            tooltip.style.display = 'none';
        });
    });
});