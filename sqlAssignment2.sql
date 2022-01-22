/* TASK_1: DETAILS OF DATA 

superstores datebase contain 5 tables:
1.cust_dimen 
2.market_fact 
3.orders_dimen 
4.prod_dimen 
5.shipping_dimen
 
1.cust_dimen: this table contains all information about the customers.
it has 5 columns,
customer_name i.e. name of the customers
province i.e.location of the customers
region i.e. region of the customers
customer_segment i.e. segment of the customers
cust_id i.e. provide unique customers id

In cust_dimen table, primary key is cust_id and foreign key is NA.

2.market_fact: this table provides the details of each and every order_item sold
it has 10 columns,  
ord_id: contain order id 
prod_id:contain product id
ship_id:contain shipment id
cust_id: contain customers id
sales: sales from the Item sold 
discount: discount on the item sold
order_quantity: order quantity of the item sold
profit: profit from the item sold
shipping_cost: shipping cost of the item sold
product_base_margin: product base margin on the item sold

In market_fact table,primary key is NA and foreign key is ord_id,prod_id,ship_id & cust_id.

3.orders_dimen: this table provides the details of every order placed
it has 4 columns, 
order_id: contain order id
order_date: contain order date
order_priority: provides priority of the order
ord_id: contain unique order id

In orders_dimen table,primary key is ord_id and foreign key is NA. 

4.prod_id: this table contains the details of product categories & their sub-categories
it has 3 columns,
product_category:shows category of the product
product_sub_category:shows sub category of the product 
prod_id: provides unique product id

In prod_dimen table,primary key is prod_id and foreign key is NA.

5.shipping_dimen:this table contains the shipping information of orders 
it has 4 columns,
order_id:shows order id
ship_mode:provide mode of shipment
ship_date:provide date of shipment
ship_id:shows unique ship id 

In shipping_dimen table,primary key is ship_id and foreign key is order_id.
 

 TASK_2: BASIC & ADVANCED ANALYSIS */

create schema superstores;
use superstores;
show tables;
select *from cust_dimen;
select *from market_fact;
select *from orders_dimen;
select *from prod_dimen;
select *from shipping_dimen;

/*1.Write a query to display the Customer_Name and Customer Segment using alias name “Customer Name", "Customer Segment" from table Cust_dimen.*/ 

SELECT 
    customer_name AS 'customer name',
    customer_segment AS 'customer segment'
FROM
    cust_dimen;  
    
/*2.Write a query to find all the details of the customer from the table cust_dimen order by desc. */    

SELECT 
    *
FROM
    cust_dimen
ORDER BY cust_id DESC;

/*3.Write a query to get the Order ID, Order date from table orders_dimen where ‘Order Priority’ is high. */

SELECT 
    order_id, order_date
FROM
    orders_dimen
WHERE
    order_priority = 'high';
    
  /*4.Find the total and the average sales (display total_sales and avg_sales)   */  
  
  SELECT 
   round(SUM(sales),2) 'total sales', round(AVG(sales),2) 'avg sales'
FROM
    market_fact;
    
 /*5.Write a query to get the maximum and minimum sales from maket_fact table. */
 
 SELECT 
    MAX(sales) 'max sales', MIN(sales) 'min sales'
FROM
    market_fact;
    
/*6.Display the number of customers in each region in decreasing order of no_of_customers.
    The result should contain columns Region, no_of_customers.*/  

SELECT 
    region, COUNT(cust_id) 'no of customers'
FROM
    cust_dimen
GROUP BY region
ORDER BY COUNT(cust_id) DESC;

/*7.Find the region having maximum customers (display the region name and max(no_of_customers) */

SELECT 
    region, COUNT(cust_id) 'max(no_of_customers)'
FROM
    cust_dimen
GROUP BY region
ORDER BY COUNT(cust_id) DESC LIMIT 1;

/*8.Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased 
(display the customer name, no_of_tables purchased)*/

SELECT 
    c.region 'region',
    c.customer_name 'customer name',
    p.product_sub_category 'product sub category',
    SUM(m.order_quantity) 'no of tables'
FROM
    market_fact m
        JOIN
    cust_dimen c ON m.cust_id = c.cust_id
        JOIN
    prod_dimen p ON m.prod_id = p.prod_id
WHERE
    c.region = 'atlantic'
        AND p.product_sub_category = 'tables'
GROUP BY c.customer_name
ORDER BY SUM(m.order_quantity);


/*9.Find all the customers from Ontario province who own Small Business. (display the customer name, no of small business owners) */

SELECT 
    customer_name, COUNT(*) 'no of small business owner'
FROM
    cust_dimen
WHERE
    province = 'ontario'
        AND customer_segment = 'small business'
GROUP BY customer_name;	

/*10.Find the number and id of products sold in decreasing order of products sold 
(display product id, no_of_products sold)    
*/

SELECT 
    prod_id 'product id', COUNT(*) 'no of products sold'
FROM
    market_fact
GROUP BY prod_id
ORDER BY count(*) desc;

/*11.Display product Id and product sub category whose produt category belongs to Furniture and Technlogy.
	 The result should contain columns product id, product sub category. */
 
SELECT 
    prod_id 'product id', product_sub_category
FROM
    prod_dimen
WHERE
    product_category = 'furniture'
        OR product_category = 'technology';    
        
/*12.Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)? */
        
SELECT 
    p.product_category,round(SUM(m.profit),2) 'profits'
FROM
    market_fact m
	JOIN
    prod_dimen p ON m.prod_id = p.prod_id
GROUP BY product_category
ORDER BY profits DESC;     

/*13.Display the product category, product sub-category and the profit within each subcategory in three columns.*/

SELECT 
    p.product_category,
    p.product_sub_category,
    round(SUM(m.profit),2) 'profit'
FROM
    market_fact m
        JOIN
    prod_dimen p ON m.prod_id = p.prod_id
GROUP BY p.product_sub_category
order by profit desc;

/*14.Display the order date, order quantity and the sales for the order.*/

SELECT 
    o.order_date, m.order_quantity, m.sales
FROM
    orders_dimen o
        JOIN
     market_fact m ON o.ord_id = m.ord_id;
     
/*15.Display the names of the customers whose name contains the  
       i) Second letter as ‘R’        ii) Fourth letter as ‘D’ 
*/

SELECT 
	distinct customer_name
FROM
    cust_dimen
WHERE
    customer_name LIKE '_r_d%';

/*16.Write a SQL query to make a list with Cust_Id, Sales, Customer Name and their region where sales are between 1000 and 5000. */

SELECT 
    c.cust_id, m.sales, c.customer_name, c.region
FROM
    cust_dimen c
        JOIN
    market_fact m ON c.cust_id = m.cust_id
WHERE
    m.sales BETWEEN 1000 AND 5000;
    
/*17.Write a SQL query to find the 3rd highest sales. */
    
   SELECT 
    sales
FROM
    market_fact
ORDER BY sales DESC
LIMIT 2,1;

/*18.Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, 
    display the  region-wise no_of_shipments and the  profit made in each region in decreasing order of profits
    (i.e. region, no_of_shipments, profit_in_each_region) */
    
SELECT 
    c.region,
    COUNT(DISTINCT m.ship_id) 'no of shipments',
    round(sum(m.profit),2) 'profit in each region'
FROM
    market_fact m
        JOIN
    cust_dimen c ON m.cust_id = c.cust_id
        JOIN
    prod_dimen p ON m.prod_id = p.prod_id
WHERE
    product_sub_category = (SELECT 
            p.product_sub_category
        FROM
            market_fact m
                JOIN
            prod_dimen p ON m.prod_id = p.prod_id
        GROUP BY product_sub_category
        ORDER BY SUM(m.profit)
        LIMIT 1)
GROUP BY c.region
ORDER BY SUM(m.profit);