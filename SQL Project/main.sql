CREATE TABLE payment_type (
  payment_type_id INTEGER,
  payment_type_name TEXT,
  primary key(payment_type_id)
);

CREATE TABLE staffs (
  staff_id TEXT,
  staff_name TEXT,
  gender TEXT,
  primary key(staff_id)
);

CREATE TABLE store_location (
  location_id TEXT,
  location_name TEXT,
  location_address TEXT,
  primary key(location_id)
);

CREATE TABLE order_type(
  ordertype_id INTEGER,
  ordertype_name TEXT,
  primary key(ordertype_id)
);

CREATE TABLE items_type (
  items_type_id INTEGER,
  items_type_name TEXT,
  primary key(items_type_id)
);

CREATE TABLE items (
  items_id TEXT,
  items_name TEXT,
  items_type_id INTEGER,
  items_price REAL,
  primary key(items_id),
  foreign key(items_type_id) references items_type(items_type_id)
);

CREATE TABLE order_detail (
  order_id INTEGER,
  items_id TEXT,
  primary key(order_id,items_id),
  foreign key(order_id) references orders(order_id),
  foreign key(items_id) references items(items_id)
);

CREATE TABLE orders (
  order_id INTEGER,
  ordertype_id INTEGER,
  date DATE,
  location_id TEXT,
  staff_id TEXT,
  time_of_day TEXT,
  total_amount REAL,
  payment_type_id INTEGER,
  primary key (order_id),
  foreign key (order_id) references order_detail(order_id),
  foreign key (ordertype_id) references order_type(ordertype_id),
  foreign key (location_id) references store_location(location_id),
  foreign key (staff_id) references staffs(staff_id),
  foreign key (payment_type_id) references payment_type(payment_type_id)
);

INSERT INTO payment_type (payment_type_id, payment_type_name) VALUES
(1, 'Cash'),
(2, 'Credit card'),
(3, 'Promptpay');

INSERT INTO staffs (staff_id, staff_name, gender) VALUES
('S001', 'Lisa', 'F'),
('S002', 'Jisoo', 'F'),
('S003', 'Bambam', 'M');

INSERT INTO store_location (location_id, location_name, location_address) VALUES
('L001', 'Central World', '123 Bangkok'),
('L002', 'Central Bangna', '456 Bangkok'),
('L003', 'Mega Bangna', '789 Bangkok');

INSERT INTO order_type (ordertype_id, ordertype_name) VALUES
(1, 'Dine-in'),
(2, 'Takeaway'),
(3, 'Delivery');

INSERT INTO items_type (items_type_id, items_type_name) VALUES
(1, 'Entree'),
(2, 'Main'),
(3, 'Dessert');

INSERT INTO items (items_id, items_name, items_type_id, items_price) VALUES
('I001', 'Spaghetti Bolognese', 1, 10.99),
('I002', 'Lasagna', 1, 12.99),
('I003', 'Parmigiana', 2, 14.99),
('I004', 'Saltimbocca', 2, 16.99),
('I005', 'Tiramisu', 3, 8.99),
('I006', 'Cheesecake', 3, 9.99);


INSERT INTO orders (order_id, ordertype_id, date, location_id, staff_id, time_of_day, total_amount, payment_type_id) VALUES
(1, 1, '2022-01-01', 'L001', 'S001', 'Dinner', 38.97, 1),
(2, 2, '2022-01-01', 'L002', 'S002', 'Lunch', 25.98, 2),
(3, 3, '2022-01-01', 'L003', 'S003', 'Breakfast', 9.99, 1),
(4, 1, '2022-01-02', 'L001', 'S001', 'Dinner', 23.98, 1),
(5, 2, '2022-01-02', 'L002', 'S002', 'Lunch', 14.99, 3),
(6, 3, '2022-01-03', 'L003', 'S003', 'Breakfast', 25.98, 3),
(7, 1, '2022-01-04', 'L001', 'S001', 'Dinner', 20.98, 1),
(8, 2, '2022-01-04', 'L002', 'S002', 'Lunch', 12.99, 2),
(9, 3, '2022-01-04', 'L003', 'S003', 'Breakfast', 31.98, 2),
(10, 1, '2022-01-5', 'L001', 'S001', 'Dinner', 18.98, 1),
(11, 2, '2022-01-5', 'L002', 'S002', 'Lunch', 23.98, 2),
(12, 3, '2022-01-6', 'L003', 'S003', 'Breakfast', 14.99, 3);

INSERT INTO order_detail (order_id, items_id) VALUES
(1, 'I001'),
(1, 'I002'),
(1, 'I003'),
(2, 'I004'),
(2, 'I005'),
(3, 'I006'),
(4, 'I001'),
  (4, 'I002'),
  (5, 'I003'),
  (6, 'I004'),
  (6, 'I005'),
  (7, 'I006'),
  (7, 'I001'),
  (8, 'I002'),
  (9, 'I003'),
  (9, 'I004'),
  (10, 'I005'),
  (10, 'I006'),
  (11, 'I001'),
  (11, 'I002'),
  (12, 'I003');

.mode markdown
.header on


.print 1. "Most sale order amount order by store location"
.print 
  
WITH  saleAmount as (SELECT loc.location_id,sum(ord.total_amount) as total_amount FROM orders ord 
left join store_location loc on ord.location_id = loc.location_id
group by ord.location_id)
  
SELECT saleAmount.location_id,lo.location_name,saleAmount.total_amount  FROM saleAmount
  LEFT JOIN store_location lo on saleAmount.location_id = lo.location_id
  order by total_amount desc;

.print 
.print  "2.Most use payment type during lunch time"
.print 

WITH payment as (SELECT ord.payment_type_id,count(*) as use_count FROM orders ord
  left join payment_type pt on ord.payment_type_id = pt.payment_type_id 
where time_of_day = 'Lunch'
group by ord.payment_type_id)
SELECT pmt.payment_type_name,pm.use_count from payment pm
left join payment_type pmt on pm.payment_type_id = pmt.payment_type_id
order by pm.use_count desc
limit 1;

.print 
.print  "3. Total dessert sale amount between 1-Jan-2022 to 3-Jan-2022"
.print 

SELECT itt.items_type_name, sum(ord.total_amount) FROM orders ord 
left join order_detail od on ord.order_id = od.order_id
left join items it on od.items_id = it.items_id
left join items_type itt on it.items_type_id = itt.items_type_id
where itt.items_type_name = 'Dessert' and ord.date between '2022-01-01' and '2022-01-03'
