-- Supply Chain Efficiency & Profitability Analysis with SQL
-- Create the Database
CREATE DATABASE supply_chain_db;

-- Create the Table
CREATE TABLE supply_chain
(
    product_type VARCHAR(100),
    sku VARCHAR(50) PRIMARY KEY,
    price NUMERIC(10,2),
    availability VARCHAR(50),
    number_of_products_sold INT,
    revenue_generated NUMERIC(15,2),
    customer_demographics VARCHAR(100),
    stock_levels INT,
    lead_times INT,
    order_quantities INT,
    shipping_times INT,
    shipping_carriers VARCHAR(100),
    shipping_costs NUMERIC(10,2),
    supplier_name VARCHAR(100),
    location VARCHAR(100),
    Lead_time INT,
    production_volumes INT,
    manufacturing_lead_time INT,
    manufacturing_costs NUMERIC(15,2),
    inspection_results VARCHAR(50),
    defect_rates NUMERIC(5,2),
    transportation_modes VARCHAR(50),
    routes VARCHAR(100),
    costs NUMERIC(15,2)
)

-- Data Validation 
-- Check total rows
SELECT COUNT(*) FROM supply_chain;

-- Check missing values
SELECT
COUNT (*) FILTER (WHERE product_type IS NULL) AS missing_product_type,
COUNT (*) FILTER (WHERE sku IS NULL) AS missing_sku,
COUNT (*) FILTER (WHERE price IS NULL) AS missing_price,
COUNT (*) FILTER (WHERE availability IS NULL) AS missing_availability,
COUNT (*) FILTER (WHERE number_of_products_sold IS NULL) AS missing_number_of_products_sold,
COUNT (*) FILTER (WHERE revenue_generated IS NULL) AS missing_revenue_generated,
COUNT (*) FILTER (WHERE customer_demographics IS NULL) AS missing_customer_demographics,
COUNT (*) FILTER (WHERE stock_levels IS NULL) AS missing_stock_levels,
COUNT (*) FILTER (WHERE lead_times IS NULL) AS missing_lead_times,
COUNT (*) FILTER (WHERE order_quantities IS NULL) AS missing_order_quantities,
COUNT (*) FILTER (WHERE shipping_times IS NULL) AS missing_shipping_times,
COUNT (*) FILTER (WHERE shipping_carriers IS NULL) AS missing_shipping_carriers,
COUNT (*) FILTER (WHERE shipping_costs IS NULL) AS missing_shipping_costs,
COUNT (*) FILTER (WHERE supplier_name IS NULL) AS missing_supplier_name,
COUNT (*) FILTER (WHERE location IS NULL) AS missing_location,
COUNT (*) FILTER (WHERE Lead_time IS NULL) AS missing_Lead_time,
COUNT (*) FILTER (WHERE production_volumes IS NULL) AS missing_production_volumes,
COUNT (*) FILTER (WHERE manufacturing_lead_time IS NULL) AS missing_manufacturing_lead_time,
COUNT (*) FILTER (WHERE manufacturing_costs IS NULL) AS missing_manufacturing_costs,
COUNT (*) FILTER (WHERE inspection_results IS NULL) AS missing_inspection_results,
COUNT (*) FILTER (WHERE defect_rates IS NULL) AS missing_defect_rates,
COUNT (*) FILTER (WHERE transportation_modes IS NULL) AS missing_transportation_modes,
COUNT (*) FILTER (WHERE routes IS NULL) AS missing_routes,
COUNT (*) FILTER (WHERE costs IS NULL) AS missing_costs
FROM supply_chain

-- Data Analysis and Findings

-- A. Inventory & Stock Control:
-- Q1: Which products are running low on stock?
SELECT sku, product_type, stock_levels, availability
FROM supply_chain
WHERE stock_levels < 50
ORDER BY stock_levels ASC;

-- Q2: What is the average stock level by product type?
SELECT product_type, ROUND(AVG(stock_levels),2) as avg_stock
FROM supply_chain
GROUP BY product_type
ORDER BY avg_stock;

-- Q3. Inventory turnover ratio per product type.
SELECT product_type,
       ROUND(SUM(number_of_products_sold)::numeric / NULLIF(AVG(stock_levels),0),2) AS inventory_turnover
FROM supply_chain
GROUP BY product_type
ORDER BY inventory_turnover DESC;

-- B. Supplier Performance:
-- Q1: What is the average lead time per supplier?
SELECT supplier_name, ROUND(AVG(lead_times),2) AS avg_lead_time
FROM supply_chain
GROUP BY supplier_name
ORDER BY avg_lead_time;

-- Q2: Top 5 suppliers by cost contribution
SELECT supplier_name, SUM(costs) as total_cost
FROM supply_chain
GROUP BY supplier_name
ORDER BY total_cost DESC
LIMIT 5;

--Q3. Supplier defect rate comparison
SELECT supplier_name, ROUND(AVG(defect_rates),2) AS avg_defect_rate
FROM supply_chain
GROUP BY supplier_name
ORDER BY avg_defect_rate ASC;

-- C. Sales & Profitability:
-- Q1: Profitability by category
SELECT product_type,
	SUM(revenue_generated) AS total_sale,
	SUM(costs) AS total_cost,
	SUM(revenue_generated-costs) AS total_profit
FROM supply_chain
GROUP BY product_type
ORDER BY total_profit DESC;

-- Q2: Top 10 best-selling product
SELECT SKU, product_type, SUM(number_of_products_sold) AS units_sold, SUM(revenue_generated) AS revenue
FROM supply_chain
GROUP BY SKU, product_type
ORDER BY revenue DESC
LIMIT 10;

-- Q3: Profit margin % by category
SELECT product_type,
       SUM(revenue_generated) AS total_revenue,
       SUM(costs) AS total_cost,
       ROUND(((SUM(revenue_generated)-SUM(costs))::numeric / NULLIF(SUM(revenue_generated),0))*100,2) AS profit_margin_percent
FROM supply_chain
GROUP BY product_type
ORDER BY profit_margin_percent DESC;


-- D. Warehouse & Logistics:
-- Q1: Orders fulfilled by warehouse
SELECT location, COUNT(sku) AS orders_fulfilled
FROM supply_chain
GROUP BY location
ORDER BY orders_fulfilled DESC;

-- Q2: Shipping mode preference
SELECT transportation_modes, COUNT(sku) AS orders
FROM supply_chain
GROUP BY transportation_modes
ORDER BY orders DESC;

-- Q3. Average shipping cost by carrier
SELECT shipping_carriers, ROUND(AVG(shipping_costs),2) AS avg_shipping_cost
FROM supply_chain
GROUP BY shipping_carriers
ORDER BY avg_shipping_cost DESC;

-- Q4. Which routes are the most expensive?
SELECT routes, ROUND(AVG(costs),2) AS avg_cost
FROM supply_chain
GROUP BY routes
ORDER BY avg_cost DESC;

-- E. Market Insights:
-- Q1: Revenue contribution by region/location
SELECT location, SUM(revenue_generated) AS total_revenue
FROM supply_chain
GROUP BY location
ORDER BY total_revenue DESC;

-- Q2. Which regions are most cost-efficient?
SELECT location,
       SUM(revenue_generated) AS total_revenue,
       SUM(costs) AS total_cost,
       ROUND((SUM(costs)::numeric / NULLIF(SUM(revenue_generated),0)) * 100, 2) AS cost_to_revenue_percent
FROM supply_chain
GROUP BY location
ORDER BY cost_to_revenue_percent ASC;
