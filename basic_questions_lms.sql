use magist;
--QUESTION 1 HOW MANY ORDERS ARE THERE INT TOTAL ?;  ####-- 99.441; 
SELECT * FROM orders;


--QUESTION 2 ARE THEY ALL DELIVERED?;  ###-- 96.478;
SELECT * FROM orders WHERE order_status = 'delivered';

SELECT 
    order_status, 
    COUNT(*) AS orders
FROM
    orders
GROUP BY order_status;

--QUESTION 3 ARE THEY GROWING?; 
-->GROWTH FROM 2016 until end of 2018 - since SEPT 2018 ORDERS ARE REDUCING DRASTICALLY;
SELECT * FROM orders;

SELECT 
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    count(order_id) AS total_orders
FROM orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


--QUESTION 4 HOW MANY PRODUCTS ARE THERE?; 32.951;
SELECT DISTINCT * FROM products;

--QUESTION 5 WHICH CATEGORY HAS THE MOST PRODUCTS?;
-->BE AWARE THAT THE CATEGORIES DO NOT MAKE SENSE e,g BED, TABLE, BATHROOM IS THE SAME CATEGORY 
-->(HAS THE MOST PRODUCTS)
--> informatica acessorios: 1639
--> eletrodomesticos (_2): 370 + 90
--> consoles games: 317
--> eletroportateis: 231
--> eletronicos: 517
--> telefonia: 1134;
SELECT 
    p.product_category_name,
    pcat.product_category_name_english,
    COUNT(*) AS total_products
FROM products AS p
JOIN product_category_name_translation AS pcat ON p.product_category_name = pcat.product_category_name
GROUP BY p.product_category_name
ORDER BY total_products DESC;

SELECT 
    product_category_name, 
    COUNT(DISTINCT product_id) AS n_products
FROM
    products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC;

--QUESTION 6 HOW MANY OF THEM WERE ACTUALLY SOLD?; 32.951 --> ALL OF THEM;
SELECT DISTINCT
    (p.product_id)
FROM
    order_items AS o
        INNER JOIN
    products AS p ON o.product_id = p.product_id;
 

 
--QUESTION 7 PRICE OF MOST CHEAP AND MOST EXPENSIVE PRODUCT?; 
-->MAX 6.735€ CATEGROY: HOUSEHOLD ACESSOIRES; 
-->MIN 0.85 € CATEGORY: CONSTRUCTION TOOLS;
SELECT 
    o.product_id, MAX(o.price), p.product_category_name
FROM
    order_items AS o
        JOIN
    products AS p ON p.product_id = o.product_id
GROUP BY product_id
ORDER BY MAX(price) DESC
LIMIT 1;
-------------------
SELECT 
    o.product_id, MIN(o.price), p.product_category_name
FROM
    order_items AS o
        JOIN
    products AS p ON o.product_id = p.product_id
GROUP BY product_id
ORDER BY MAX(price) ASC
LIMIT 1;

--QUESTION 8 WHAT IS THE HIGHEST AND LOWEST ORDER PAYMENT VALUES?;
--> highest value 13.664,01 €
--> lowest value 0,01 €; (0 ?)

SELECT max(payment_value) FROM order_payments;
SELECT payment_value FROM order_payments;

-------------
SELECT * FROM products;
--compare electronic products group --> (how many are they selling, how much turn around do they make?);
--> most sold category: moveis_decoracao (decorative furniture), cama_mesa_banho (bed, table, bathroom), 
--> ferramentas_jardim (tools garden), informatica acessorios (IT accessoires)

SELECT 
    COUNT(oi.product_id) AS most_sold, oi.product_id, p.product_category_name
FROM
    order_items AS oi
        JOIN
    orders AS o ON o.order_id = oi.order_id
        JOIN
    products AS p ON p.product_id = oi.product_id
GROUP BY oiproduct_category_nameproduct_category_name_english.product_id
ORDER BY most_sold DESC;





--product availability in Brazil --> research
--Is the target group buying high-price products? (max/ min price per product/ order)
--compare electronic categories with other products

--What happened november 2018 in Brazil? --> research --> obsolete, its autumn 2018


--Which products can be the fastes to reach the brazilian market? 
--Why is the minimum order value 0 ? check order_status, payment_status
--How much % of all orders is paid in installments? --> advantages of offering installement payments for companies? Are sales increasing?

--Why were products returned? Why were customers unhappy?  ;
#-------------------------------------------------------------------------------------------#
#What categories of tech products does Magist have?;
'audio', 'eletrodomesticos', 'eletrodomesticos_2', 'eletronicos',
'eletroportateis', 'informatica_acessorios',
'pcs', 'livros_tecnicos', 'telefonia', 'telefonia_fixa';

#How many products of these tech categories have been sold (within the time window of the database snapshot)? 
# or distinct 4308

SELECT 
    COUNT(DISTINCT p.product_id)
FROM
    orders AS o
        JOIN
    order_items AS oi ON o.order_id = oi.order_id
        JOIN
    products AS p ON oi.product_id = p.product_id
WHERE
    p.product_category_name IN ('audio' , 'eletrodomesticos',
        'eletrodomesticos_2',
        'eletronicos',
        'eletroportateis',
        'informatica_acessorios',
        'pcs',
        'livros_tecnicos',
        'telefonia',
        'telefonia_fixa');

#What percentage does that represent from the overall number of products sold?
#delivered total:// 4308 from 96.478 --> 4.47% 

#What’s the average price of the products being sold?
#118.96

SELECT 
    ROUND(AVG(oi.price), 2)
FROM
    order_items AS oi
        JOIN
    products AS p ON oi.product_id = p.product_id
WHERE
    p.product_category_name IN ('audio' , 'eletrodomesticos',
        'eletrodomesticos_2',
        'eletronicos',
        'eletroportateis',
        'informatica_acessorios',
        'pcs',
        'livros_tecnicos',
        'telefonia',
        'telefonia_fixa');


#Are expensive tech products popular?

SELECT 
    
FROM
    order_items AS oi
        JOIN
    products AS p ON oi.product_id = p.product_id
WHERE
    p.product_category_name IN ('audio' , 'eletrodomesticos',
        'eletrodomesticos_2',
        'eletronicos',
        'eletroportateis',
        'informatica_acessorios',
        'pcs',
        'livros_tecnicos',
        'telefonia',
        'telefonia_fixa');
        
#-------------------------------------------------------------------------------------------#
#How many months of data are included in the magist database?
#25 months (2016-09 - 2018-10)
SELECT * FROM orders;


#How many sellers are there?  total sellers: 3095
#How many Tech sellers are there?: tech categories: 607
#What percentage of overall sellers are Tech sellers? : 19.62%

SELECT 
    COUNT(DISTINCT s.seller_id)
FROM
    sellers AS s
        JOIN
    order_items AS oi ON s.seller_id = oi.seller_id
        JOIN
    products AS p ON oi.product_id = p.product_id
WHERE
    p.product_category_name IN ('audio' , 'eletrodomesticos',
        'eletrodomesticos_2',
        'eletronicos',
        'eletroportateis',
        'informatica_acessorios',
        'pcs',
        'livros_tecnicos',
        'telefonia',
        'telefonia_fixa');

#What is the total amount earned by all sellers?
# 16.008.872,14 €
SELECT round(SUM(payment_value),2) FROM order_payments; 

#What is the total amount earned by all Tech sellers?
#3.349.121,73 €

SELECT 
    ROUND(SUM(op.payment_value), 2) AS total_revenue_tech_sellers
FROM
    order_payments AS op
        JOIN
    order_items AS oi ON op.order_id = oi.order_id
        JOIN
    products AS P ON oi.product_id = p.product_id
WHERE
    p.product_category_name IN ('audio' , 'eletrodomesticos',
        'eletrodomesticos_2',
        'eletronicos',
        'eletroportateis',
        'informatica_acessorios',
        'pcs',
        'livros_tecnicos',
        'telefonia',
        'telefonia_fixa'); 
 
#Can you work out the average monthly income of all sellers?
# 197,28 € /24; 7,56 €

SELECT 
    ROUND(AVG(op.payment_value), 2) AS avg_all_sellers
FROM
    order_payments AS op
        JOIN
    order_items AS oi ON op.order_id = oi.order_id
        JOIN
    products AS P ON oi.product_id = p.product_id;
 

# Can you work out the average monthly income of Tech sellers?



#-------------------------------------------------------------------------------------------#

--Compare market Brazil - Europe, in sense of cost-effective consumer --> research;

# Local Purchasing Power in Brazil is 57.4% lower than in Spain
# mobile phone monthly plan 27% % lower in Brazil than in Spain
# Average monthly salary 77% less in Brazil than Spain 

#-------------------------------------------------------------------------------------------#
##2.3. In relation to the delivery time:
#What’s the average time between the order being placed and the product being delivered?;
# --> 12,5;

SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                    order_purchase_timestamp)),
            1) AS average_delivery_time
FROM
    orders;

#Is there any pattern for delayed orders, e.g. big products being delayed more often?;
# category most delayed: cama_mesa_banho, beleza_saude, moveis_decoracao, esporte_lazer, informatica_accessorios
#--> but also the biggest categories
SELECT
    p.product_category_name,
    COUNT(*) AS category_count
FROM
orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
JOIN products AS p ON p.product_id = oi.product_id
WHERE DATE(order_delivered_customer_date) > DATE(order_estimated_delivery_date)
GROUP BY p.product_category_name
ORDER BY category_count DESC;

#most delayed product is from ferramentas_jardim, moveis_decoracao, beleza_saude;
# most heavy products are from moveis_sala, not more often delayed than others;
# eletronicos are not often delayed;

SELECT
    p.product_id,
    p.product_category_name,
    oi.freight_value,
    COUNT(*) AS most_delayed_product
FROM
orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
JOIN products AS p ON p.product_id = oi.product_id
WHERE DATE(order_delivered_customer_date) > DATE(order_estimated_delivery_date)
GROUP BY p.product_id, p.product_category_name, oi.freight_value
ORDER BY most_delayed_product DESC;

#How many orders are delivered on time vs orders delivered with a delay?
#DELIVERED as estimated: 1334
#1334 orders from 96.478 total delivered orders: 1.4% orders are delivered as estimated
    
    SELECT * FROM order_items;
    
    SELECT 
    COUNT(*) AS on_time_orders
FROM
    orders
WHERE
    DATE(order_delivered_customer_date) = DATE(order_estimated_delivery_date);


#delayed: 6665 -- from 96478 total delivered: 6.9% ;  

SELECT
 COUNT(*) AS delayed_orders
FROM
orders
WHERE order_status = "delivered" AND DATE(order_delivered_customer_date) > DATE(order_estimated_delivery_date);

# too early: 88471 from 96478: 91,83% 

SELECT
 COUNT(*) AS too_early_orders
FROM
orders
WHERE order_status = "delivered" AND DATE(order_delivered_customer_date) < DATE(order_estimated_delivery_date);

SELECT count(*) FROM orders WHERE order_status = "canceled"; #625
SELECT count(*) FROM orders WHERE order_status = "delivered";#96478
SELECT

#average estimated delivery time: 24,33 days;
SELECT 
round(AVG(datediff(order_purchase_timestamp,order_estimated_delivery_date)),2) AS estimated_deliver_time
 FROM ORDERS;

#average real delivery time: 12,5
SELECT 
round(AVG(datediff(order_purchase_timestamp,order_delivered_customer_date)),2) AS estimated_deliver_time
 FROM ORDERS;
 
 
 #-------------------------------------------------------------------------------------------#
 #Order-revciews
 
 #What is the average score in reviews? #4.08 (from 5)
 SELECT round(AVG(review_score),2) FROM order_reviews; #4.08
 
 SELECT; 

SELECT count(review_score), review_score FROM order_reviews GROUP BY review_score ORDER BY count(review_score) DESC;
#57.53 % -- 5 
#19.25% -- 4
# 8.26% -- 3
# 3.21% -- 2
#11.77 % -- 1

SELECT * FROM order_reviews; # total: 98.371

#How good is customer service? 
#how fast is beeing replied to reviews?;
# 2.69 days
SELECT round(avg(datediff(review_creation_date,review_answer_timestamp)) ,2) AS avg_reply_time FROM order_reviews;




