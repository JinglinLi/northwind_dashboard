-- These queries were used to generate the dashboard on metabase

-- Northwind 1997 Annual Report 

-- Products Count Groupby Category 
CREATE VIEW product_category AS 
SELECT ps.product_name, cs.category_name 
FROM products ps LEFT JOIN categories cs ON cs.category_id = ps.category_id;

SELECT COUNT(product_name) AS product_count 
FROM product_category 
GROUP BY category_name;

-- Procuts Ordered by Annual Sale Amount
CREATE VIEW product_sale_1997 AS
SELECT ps.product_name, SUM(ods.unit_price * ods.quantity) as amount
FROM order_details ods
INNER JOIN orders os ON os.order_id = ods.order_id
INNER JOIN products ps ON ps.product_id = ods.product_id
WHERE os.order_date >= '1997-01-01' and os.order_date <= '1997-12-31'
GROUP BY ps.product_name
ORDER BY amount DESC;

-- Product : Annual Sale, Name, UnitPrice, Quantity 
CREATE VIEW product_sale_detail_1997 AS
SELECT ps.product_name, SUM(ods.quantity) as total_quantity, SUM(ods.unit_price * ods.quantity) as amount
FROM order_details ods
INNER JOIN orders os ON os.order_id = ods.order_id
INNER JOIN products ps ON ps.product_id = ods.product_id
WHERE os.order_date >= '1997-01-01' and os.order_date <= '1997-12-31'
GROUP BY ps.product_name
ORDER BY amount DESC;


-- Suppliers Count Groupedby Country 
select country, COUNT(*) as count from suppliers
GROUP BY country;

-- Customers Count Groupedby Country 
select country, COUNT(*) as count  from customers
GROUP BY country;

-- Suppliers Orderedby Annual Supply Amount 
CREATE VIEW supplier_product AS
SELECT ss.company_name, SUM(ps.unit_price * (ps.units_in_stock + ps.units_on_order)) as amount
FROM products ps
INNER JOIN suppliers ss ON ps.supplier_id = ss.supplier_id
GROUP BY ss.company_name
ORDER BY amount DESC;

-- Customers Orderedby Annual Order Amount 
CREATE VIEW customer_order_product_1997 AS 
SELECT cs.company_name, ps.product_name, ods.unit_price, ods.quantity
FROM order_details ods
INNER JOIN orders os ON os.order_id = ods.order_id
INNER JOIN customers cs ON os.customer_id = cs.customer_id
INNER JOIN products ps ON ods.product_id = ps.product_id
WHERE order_date >= '1997-01-01' and order_date <= '1997-12-31';

SELECT company_name, SUM (unit_price * quantity) AS amount 
FROM customer_order_product_1997
GROUP BY company_name
ORDER BY amount DESC; 

-- Monthly Sale 1997 
CREATE VIEW monthly_sale AS
SELECT EXTRACT(MONTH FROM order_date) as month, SUM(ods.unit_price * ods.quantity) as amount
FROM order_details ods
INNER JOIN orders os ON ods.order_id = os.order_id
GROUP BY month
ORDER BY month;

-- Montly Sale 1997 of top three customers
SELECT company_name, SUM (unit_price * quantity) AS amount 
FROM customer_order_product_1997
GROUP BY company_name
ORDER BY amount DESC
LIMIT 3; 

--top1 customer
CREATE VIEW monthly_sale_QUICKStop AS
SELECT EXTRACT(MONTH FROM order_date) as month, SUM(ods.unit_price * ods.quantity) as quick_stop
FROM order_details ods
INNER JOIN orders os ON ods.order_id = os.order_id
JOIN customers cs ON cs.customer_id = os.customer_id
WHERE cs.company_name = 'QUICK-Stop'
GROUP BY month
ORDER BY month;
--top2 customer
CREATE VIEW monthly_sale_SavealotMarkets AS
SELECT EXTRACT(MONTH FROM order_date) as month, SUM(ods.unit_price * ods.quantity) as save_a_lot_markets
FROM order_details ods
INNER JOIN orders os ON ods.order_id = os.order_id
JOIN customers cs ON cs.customer_id = os.customer_id
WHERE cs.company_name = 'Save-a-lot Markets'
GROUP BY month
ORDER BY month;
--top3 customer
CREATE VIEW monthly_sale_ErnstHandel AS
SELECT EXTRACT(MONTH FROM order_date) as month, SUM(ods.unit_price * ods.quantity) as ernst_handel
FROM order_details ods
INNER JOIN orders os ON ods.order_id = os.order_id
JOIN customers cs ON cs.customer_id = os.customer_id
WHERE cs.company_name = 'Ernst Handel'
GROUP BY month
ORDER BY month;

CREATE VIEW monthly_sale_customer AS
SELECT ms.month, ms.amount, msq.quick_stop, mss.save_a_lot_markets, mse.ernst_handel FROM monthly_sale ms
JOIN monthly_sale_QUICKStop msq ON ms.month = msq.month
JOIN monthly_sale_SavealotMarkets mss ON ms.month = mss.month
JOIN monthly_sale_ErnstHandel mse ON ms.month = mse.month;


-- OTHER e.g
-- Which customers by what product 
-- What could be a nice way to visualize?
CREATE VIEW customer_product AS
SELECT ps.product_name, cs.company_name, ods.unit_price * ods.quantity as amount
FROM order_details ods
INNER JOIN products ps ON ps.product_id = ods.product_id
INNER JOIN orders os ON os.order_id = ods.order_id
INNER JOIN customers cs ON cs.customer_id = os.customer_id
ORDER BY amount DESC;






