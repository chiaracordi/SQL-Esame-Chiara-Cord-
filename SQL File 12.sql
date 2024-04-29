CREATE DATABASE toysgroup;
USE toysgroup;
-- creiamo la tabella PRODUCT
CREATE TABLE PRODUCT (
product_id INT PRIMARY KEY,
name_product VARCHAR(100) NOT NULL,
listprice DECIMAL(8,2) NOT NULL,
category VARCHAR(50) NOT NULL
);
-- creiamo la tabella REGION
CREATE TABLE REGION (
region_id INT PRIMARY KEY AUTO_INCREMENT,
region_name VARCHAR(100) NOT NULL,
country VARCHAR(100) NOT NULL
);
-- creiamo la tabella SALES
CREATE TABLE SALES (
sales_id INT PRIMARY KEY,
product_id INT NOT NULL,
quantity INT NOT NULL,
listprice DECIMAL(8,2) NOT NULL,
date_sales date NOT NULL,
region_id int  NOT NULL,
FOREIGN KEY (product_id) REFERENCES PRODUCT (product_id),
FOREIGN KEY (region_id) REFERENCES REGION (region_id)
);
-- popoliamo la tabella PRODUCT
INSERT INTO PRODUCT( product_id, name_product, listprice, category) VALUES
( 1, 'Candy Candy', 29.95, 'dolly'),
( 2, 'Superman', 19.95, 'super hero'),
( 3,'Lego city', 21.90, 'lego'),
( 4, 'Optimus Prime', 39.90, ' Transformers'),
( 5,'Saetta MC Queen', 24.90, 'Cars line'),
( 6,'Barbie Mobile', 49.90, 'dolly'),
( 7,'Barbie', 29.95, 'dolly'),
( 8, 'Cricchetto', 17.90, 'Cars Line'),
( 9,'Lego Track', 24.90,'Lego'),
( 10, 'Bratz', 12.90,'dolly')
;
-- popoliamo la tabella REGION
INSERT INTO REGION (region_name, country) VALUES
('North America', 'United States'),
('Europe A', 'Italia'),
('Europe B', 'Germania'),
('Europe C', 'Francia'),
('Europe D', 'Spagna'),
('Asia', 'Japan')
;
-- popoliamo la tabella SALES
INSERT INTO SALES (sales_id, product_id, quantity,listprice, date_sales, region_id) VALUES
(1, 2, 200, 19.95,'2023-09-05', 3),
(2, 4, 380, 39.90, '2023-10-06', 2),
(3, 5, 100, 24.90, '2024-03-10', 6),
(4, 9, 300, 24.90, '2024-03-11', 1),
(5, 7, 420, 29.90, '2024-03-12', 4),
(6, 3, 500, 21.90, '2024-03-14', 2),
(7, 6, 310, 49.90, '2024-03-15', 5),
(8, 8, 190, 17.90, '2024-03-16', 5),
(9,5 , 500, 24.90, '2024-03-19', 6),
(10, 2, 320, 19.95, '2024-03-24', 2)
;

-- 1. Verificare che i campi definiti come PK siano univoci. 
SELECT COUNT(*) AS duplicati_P, product_id
FROM PRODUCT
GROUP BY product_id
HAVING COUNT(*) > 1
;
SELECT COUNT(*) AS duplicati_R, region_id
FROM REGION
GROUP BY region_id
HAVING COUNT(*) >1
;
SELECT COUNT(*) AS duplicati_S, sales_id
FROM SALES
GROUP BY sales_id
HAVING COUNT(*) >1
;

-- 2. Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno. 
SELECT p.name_product,
       YEAR(s.date_sales) AS anno,
       SUM(s.quantity * p.listprice) AS total
FROM product p
INNER JOIN sales s 
ON p.product_id = s.product_id
GROUP BY p.name_product, YEAR(s.date_sales) 
;

-- 3. Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente. 
SELECT  r.region_name,
        r.country,
        YEAR(s.date_sales) AS anno,
        SUM(s.quantity * p.listprice) AS total
FROM product p
INNER JOIN sales s 
ON p.product_id = s.product_id
INNER JOIN region r 
ON s.region_id = r.region_id
GROUP BY r.region_name, r.country, YEAR(s.date_sales)
ORDER BY anno, total DESC
;

-- 4. Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato? 
SELECT  p.category,
        SUM(s.quantity) AS total_sales
FROM product p
INNER JOIN sales s 
ON p.product_id = s.product_id
GROUP BY p.category
ORDER BY total_sales DESC
LIMIT 1
;
-- 5. Rispondere alla seguente domanda: quali sono, se ci sono, i prodotti invenduti? Proponi due approcci risolutivi differenti. 
--    1° approccio : utilizzo di una subquery
SELECT p.name_product,
       p.category
FROM product p
WHERE (
    SELECT COUNT(*)
    FROM sales s
    WHERE s.product_id = p.product_id
) = 0
;
--    2° approccio : utilizzo left join
SELECT p.name_product
FROM product p
LEFT JOIN sales s
ON p.product_id = s.product_id
WHERE s.sales_id IS NULL
;

-- 6. Esporre l’elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendita più recente).
SELECT p.name_product,
       MAX(s.date_sales) AS ultima_data_vendita
FROM product p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.name_product
;