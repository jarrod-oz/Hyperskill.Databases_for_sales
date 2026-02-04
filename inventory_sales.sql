SELECT
    products.model,
    products.price,
    SUM(sales.total_price) AS total_sale_per_model,
    inventory.quantity AS inventory_per_model,
    SUM(sales.total_price) / inventory.quantity AS sales_inventory_ratio
FROM products
JOIN sales ON sales.product_id = products.product_id
JOIN inventory ON products.product_id = inventory.product_id
GROUP BY products.model, products.price, inventory.quantity
ORDER BY sales_inventory_ratio DESC;
