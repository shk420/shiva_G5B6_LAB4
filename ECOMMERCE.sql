create database ECOMMERCE;
USE ECOMMERCE;
CREATE TABLE SUPPLIER(
SUPP_ID INT unsigned primary KEY auto_increment NOT NULL,
SUPP_NAME VARCHAR(50) NOT NULL,
SUPP_CITY VARCHAR(50) NOT NULL,
SUPP_PHONE VARCHAR(50) NOT NULL
);
CREATE TABLE CUSTOMER(
CUS_ID INT unsigned PRIMARY KEY auto_increment NOT NULL,
CUS_NAME VARCHAR(20) NOT NULL,
CUS_PHONE VARCHAR(10) NOT NULL,
CUS_CITY VARCHAR(30) NOT NULL,
CUS_GENDER ENUM('M', 'F') NOT NULL
);
CREATE TABLE category(
CAT_ID INT unsigned PRIMARY KEY auto_increment NOT NULL,
CAT_NAME  VARCHAR(20) NOT NULL
);

CREATE TABLE product(
PRO_ID INT unsigned PRIMARY KEY auto_increment NOT NULL,
PRO_NAME VARCHAR(20) NOT NULL default "Dummy",
PRO_DESEC VARCHAR(60) NOT NULL,
CAT_ID INT unsigned, FOREIGN KEY (CAT_ID) REFERENCES category(CAT_ID)
);

CREATE TABLE SUPPLIER_PRICING(
PRICING_ID INT unsigned PRIMARY KEY auto_increment NOT NULL,
PRO_ID INT UNSIGNED, foreign key (PRO_ID) REFERENCES product(PRO_ID),
SUPP_ID INT UNSIGNED, foreign key(SUPP_ID) REFERENCES SUPPLIER(SUPP_ID),
SUPP_PRICE INT DEFAULT 0
);
CREATE TABLE orders(
ORD_ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
ORD_AMOUNT INT NOT NULL,
ORD_DATE DATE NOT NULL,
CUS_ID INT UNSIGNED, FOREIGN KEY(CUS_ID) REFERENCES CUSTOMER(CUS_ID),
PRICING_ID INT UNSIGNED, FOREIGN KEY(PRICING_ID) REFERENCES SUPPLIER_PRICING(PRICING_ID)
);
CREATE TABLE RATING(
RAT_ID INT unsigned primary KEY auto_increment NOT NULL,
ORD_ID INT UNSIGNED, FOREIGN KEY (ORD_ID) REFERENCES orders(ORD_ID),
RAT_RATSTARS INT NOT NULL 
);

INSERT INTO 
SUPPLIER(SUPP_NAME,SUPP_CITY,SUPP_PHONE) 
VALUES
('Rajesh Retails','Delhi','1234567890'),
('Appario Ltd.','Mumbai','2589631470'),
('Knome products','Banglore','9785462315'),
('Bansal Retails','Kochi','8975463285'),
('Mittal Ltd.','Lucknow','7898456532');
INSERT INTO 
CUSTOMER(CUS_NAME,CUS_PHONE,CUS_CITY,CUS_GENDER)
VALUES 
('AAKASH','9999999999','DELHI','M'),
('AMAN','9785463215','NOIDA','M'),
('NEHA','9999999999','MUMBAI','F'),
('MEGHA','9994562399','KOLKATA','F'),
('PULKIT','7895999999','LUCKNOW','M');

INSERT INTO category(CAT_NAME) VALUES 
('BOOKS'),
('GAMES'),
('GROCERIES'),
('ELECTRONICS'),
('Clothes');

INSERT INTO product (PRO_ID,PRO_NAME,PRO_DESEC,CAT_ID) VALUES 
(14,'GTA V','Windows 7 and above with i5 processor and 8GB RAM',2),
(15,'TSHIRT','SIZE-L with Black, Blue and White variations',5),
(16,'ROG LAPTOP	','Windows 10 with 15inch screen, i7 processor, 1TB SSD',4),
(17,'OATS','Highly Nutritious from Nestle',3),
(18,'HARRY POTTER','Best Collection of all time by J.K Rowling',1),
(19,'MILK','1L Toned Milk',3),
(20,'Boat Earphones','1.5Meter long Dolby Atmos',4),
(21,'Jeans','Stretchable Denim Jeans with various sizes and color',5),
(22,'Project IGI','compatible with windows 7 and above',2),
(23,'Hoodie','Black GUCCI for 13 yrs and above',5),
(24,'Rich Dad Poor Dad','Written by RObert Kiyosaki',1),
(25,'Train Your Brain','By Shireen Stephen',1);


INSERT INTO SUPPLIER_PRICING (PRICING_ID, PRO_ID, SUPP_ID, SUPP_PRICE) VALUES
(11, 14, 2, 1500),
(12, 16, 5, 30000),
(13, 18, 1, 3000),
(14, 15, 3, 2500),
(15, 17, 1, 1000);

INSERT INTO orders(ORD_ID,ORD_AMOUNT,ORD_DATE,CUS_ID,PRICING_ID) VALUES 
(101,1500,'2021-10-06',2,11),
(102,1000,'2021-10-12',3,15),
(103,30000,'2021-09-16',5,12),
(104,1500,'2021-10-05',1,11),
(105,3000,'2021-08-16',4,13),
(106,1450,'2021-08-18',1,14),
(107,789,'2021-09-01',3,12),
(108,780,'2021-09-07',5,11),
(109,3000,'2021-01-10',5,13),
(110,2500,'2021-09-10',2,14),
(111,1000,'2021-09-15',4,15),
(112,789,'2021-09-16',4,12),
(113,31000,'2021-09-16',1,13),
(114,1000,'2021-09-16',3,15),
(115,3000,'2021-09-16',5,13),
(116,99,'2021-09-17',2,14);


INSERT INTO rating(ORD_ID,RAT_RATSTARS) VALUES 
(101,4),
(102,3),
(103,1),
(104,2),
(105,4),
(106,3),
(107,4),
(108,4),
(109,3),
(110,5),
(111,3),
(112,4),
(113,2),
(114,1),
(115,1),
(116,0);


SELECT CUS_GENDER, COUNT(DISTINCT CUSTOMER.CUS_ID) as TotalCustomers
FROM CUSTOMER
JOIN orders ON CUSTOMER.CUS_ID = orders.CUS_ID
WHERE orders.ORD_AMOUNT >= 3000
GROUP BY CUS_GENDER;

select cus_name, cus_city, o.ORD_AMOUNT, o.pricing_id, s.PRO_ID, p.PRO_NAME, p.PRO_DESEC
   from customer inner join orders as o 
     on customer.cus_id=o.CUS_ID 
     inner join supplier_pricing as s
       on o.PRICING_ID = s.PRICING_ID
     inner join product as p
       on s.PRO_ID=p.PRO_ID
     and customer.cus_id=2;
select s.supp_name, count(p.PRO_NAME) as num_of_products from supplier as s inner join supplier_pricing as sp on s.SUPP_ID=sp.SUPP_ID
        inner join product as p on sp.PRO_ID=p.PRO_ID
        group by s.SUPP_NAME
        having num_of_products > 1;
select c.cus_name, o.ord_amount, o.ord_date, p.pro_name, p.PRO_DESEC  from orders as o inner join supplier_pricing as sp 
         on o.PRICING_ID=sp.PRICING_ID
     inner join product as p on sp.pro_id=p.PRO_ID   
     inner join customer as c
       on o.CUS_ID=c.cus_id
    where o.ORD_DATE > "2021-09-01";

select customer.cus_name,customer.cus_gender from customer where customer.cus_name like 'A%' or customer.cus_name like '%A';














