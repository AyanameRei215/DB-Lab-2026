-- 1. Таблиця "Категорія" (Category)
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Таблиця "Склад" (Warehouse)
CREATE TABLE warehouse (
    warehouse_id SERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    address      VARCHAR(200) NOT NULL
);

-- 3. Таблиця "Постачальник" (Supplier)
CREATE TABLE supplier (
    supplier_id    SERIAL PRIMARY KEY,
    company_name   VARCHAR(150) NOT NULL,
    contact_person VARCHAR(100),
    phone          VARCHAR(20)  NOT NULL
);

-- 4. Таблиця "Співробітник" (Employee)
CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    last_name   VARCHAR(50) NOT NULL,
    first_name  VARCHAR(50) NOT NULL,
    position    VARCHAR(100)
);

-- 5. Таблиця "Клієнт" (Customer)
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    phone       VARCHAR(20)
);

-- 6. Таблиця "Товар" (Product)
CREATE TABLE product (
    product_id      SERIAL PRIMARY KEY,
    name            VARCHAR(200) NOT NULL,
    category_id     INTEGER NOT NULL REFERENCES category(category_id),
    purchase_price  NUMERIC(10,2) NOT NULL CHECK (purchase_price > 0),
    sale_price      NUMERIC(10,2) NOT NULL CHECK (sale_price >= purchase_price),
    min_stock       INTEGER NOT NULL DEFAULT 0 CHECK (min_stock >= 0)
);

-- 7. Таблиця "Залишок" (Stock)
CREATE TABLE stock (
    stock_id     SERIAL PRIMARY KEY,
    product_id   INTEGER NOT NULL REFERENCES product(product_id),
    warehouse_id INTEGER NOT NULL REFERENCES warehouse(warehouse_id),
    quantity     INTEGER NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    UNIQUE (product_id, warehouse_id)
);

-- 8. Таблиця "Надходження" (Supply)
CREATE TABLE supply (
    supply_id     SERIAL PRIMARY KEY,
    product_id    INTEGER NOT NULL REFERENCES product(product_id),
    quantity      INTEGER NOT NULL CHECK (quantity > 0),
    supplier_id   INTEGER NOT NULL REFERENCES supplier(supplier_id),
    warehouse_id  INTEGER NOT NULL REFERENCES warehouse(warehouse_id),
    employee_id   INTEGER NOT NULL REFERENCES employee(employee_id),
    supply_date   DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 9. Таблиця "Продаж" (Sale)
CREATE TABLE sale (
    sale_id       SERIAL PRIMARY KEY,
    product_id    INTEGER NOT NULL REFERENCES product(product_id),
    quantity      INTEGER NOT NULL CHECK (quantity > 0),
    warehouse_id  INTEGER NOT NULL REFERENCES warehouse(warehouse_id),
    employee_id   INTEGER NOT NULL REFERENCES employee(employee_id),
    customer_id   INTEGER REFERENCES customer(customer_id),
    sale_date     DATE NOT NULL DEFAULT CURRENT_DATE
);

-- =====================
-- Вставка тестових даних
-- =====================

-- Категорії
INSERT INTO category (name) VALUES
    ('Процесори'),
    ('Материнські плати'),
    ('Блоки живлення'),
    ('Відеокарти');

-- Склади
INSERT INTO warehouse (name, address) VALUES
    ('Основний склад', 'вул. Київська, 15, Київ'),
    ('Резервний склад', 'вул. Львівська, 8, Львів');

-- Постачальники
INSERT INTO supplier (company_name, contact_person, phone) VALUES
    ('ТОВ ТехноПоставка', 'Петренко Іван', '+380521234567'),
    ('ФОП Громов', 'Громов Олексій', '+380671234567'),
    ('Комп''ютерний світ', 'Сидоренко Ольга', '+380931234567');

-- Співробітники
INSERT INTO employee (last_name, first_name, position) VALUES
    ('Коваленко', 'Анна', 'Комірник'),
    ('Мельник', 'Андрій', 'Менеджер з продажу'),
    ('Шевченко', 'Олена', 'Адміністратор складу');

-- Клієнти
INSERT INTO customer (name, phone) VALUES
    ('ФОП Шевченко', '+380991234567'),
    ('ТОВ Електронікс', '+380441234567'),
    ('Приватна особа Петров Іван', '+380631234567');

-- Товари 
INSERT INTO product (name, category_id, purchase_price, sale_price, min_stock) VALUES
    ('Процесор Intel Core i5-12400F', 1, 4500.00, 5700.00, 5),
    ('Процесор AMD Ryzen 5 5600X',   1, 5200.00, 6500.00, 3),
    ('Материнська плата ASUS PRIME B660M-A', 2, 3200.00, 3900.00, 2),
    ('Блок живлення Corsair RM650x', 3, 2800.00, 3500.00, 4),
    ('Відеокарта NVIDIA GeForce RTX 3060', 4, 12500.00, 14900.00, 2);

-- Залишки на складах
INSERT INTO stock (product_id, warehouse_id, quantity) VALUES
    (1, 1, 23),   
    (1, 2, 5),    
    (2, 1, 12),   
    (3, 1, 8),    
    (4, 1, 15),   
    (4, 2, 7),    
    (5, 1, 6);    

-- Надходження (поставки)
INSERT INTO supply (product_id, quantity, supplier_id, warehouse_id, employee_id, supply_date) VALUES
    (1, 50, 1, 1, 1, '2026-03-01'),
    (2, 30, 2, 1, 1, '2026-03-05'),
    (3, 20, 1, 1, 1, '2026-03-10'),
    (4, 25, 3, 2, 1, '2026-03-12'),
    (5, 10, 2, 1, 1, '2026-03-15');

-- Продажі
INSERT INTO sale (product_id, quantity, warehouse_id, employee_id, customer_id, sale_date) VALUES
    (1, 2, 1, 2, 1, '2026-03-20'),
    (1, 1, 2, 2, 2, '2026-03-21'),
    (2, 1, 1, 2, 3, '2026-03-22'),
    (4, 3, 1, 2, 1, '2026-03-23'),
    (5, 1, 1, 2, 2, '2026-03-24');

-- ===========================
-- Перевірка вставлених даних 
-- ===========================
SELECT * FROM category;
SELECT * FROM warehouse;
SELECT * FROM supplier;
SELECT * FROM employee;
SELECT * FROM customer;
SELECT * FROM product;
SELECT * FROM stock;
SELECT * FROM supply;
SELECT * FROM sale;
