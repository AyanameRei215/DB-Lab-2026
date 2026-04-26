-- ==============================================================================
-- ЕТАП 1: Ненормалізована структура
-- ==============================================================================

-- Створення "плоскої" таблиці з дублюванням даних (як імітація імпорту з Excel)
CREATE TABLE unnormalized_supply (
    supply_id         SERIAL PRIMARY KEY,
    supply_date       DATE NOT NULL,
    supplier_name     VARCHAR(150),
    contact_person    VARCHAR(100),
    supplier_phone    VARCHAR(20),
    warehouse_name    VARCHAR(100),
    warehouse_address VARCHAR(200),
    product_name      VARCHAR(200),
    quantity          INTEGER
);

-- Вставка "брудних" даних для демонстрації аномалій оновлення та надмірності
INSERT INTO unnormalized_supply 
(supply_date, supplier_name, contact_person, supplier_phone, warehouse_name, warehouse_address, product_name, quantity) 
VALUES
('2026-03-01', 'ТОВ ТехноПоставка', 'Петренко Іван', '+380521234567', 'Основний склад', 'вул. Київська, 15', 'Процесор Intel Core i5-12400F', 50),
('2026-03-01', 'ТОВ ТехноПоставка', 'Петренко Іван', '+380521234567', 'Основний склад', 'вул. Київська, 15', 'Материнська плата ASUS PRIME B660M-A', 20),
('2026-03-05', 'ФОП Громов', 'Громов Олексій', '+380671234567', 'Резервний склад', 'вул. Львівська, 8', 'Процесор AMD Ryzen 5 5600X', 30),
('2026-03-05', 'ФОП Громов', 'Громов Олексій', '+380671234567', 'Резервний склад', 'вул. Львівська, 8', 'Відеокарта NVIDIA GeForce RTX 3060', 10);

-- ==============================================================================
-- ЕТАП 2: Нормалізована структура (3NF)
-- ==============================================================================

-- 1. Довідник постачальників (усуває транзитивну залежність)
CREATE TABLE supplier_normalized (
    supplier_id    SERIAL PRIMARY KEY,
    company_name   VARCHAR(150) NOT NULL UNIQUE,
    contact_person VARCHAR(100),
    phone          VARCHAR(20) NOT NULL
);

-- 2. Довідник складів (усуває транзитивну залежність)
CREATE TABLE warehouse_normalized (
    warehouse_id SERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL UNIQUE,
    address      VARCHAR(200) NOT NULL
);

-- 3. Довідник товарів
CREATE TABLE product_normalized (
    product_id   SERIAL PRIMARY KEY,
    name         VARCHAR(200) NOT NULL UNIQUE
);

-- 4. Заголовок документа надходження (усуває часткову залежність)
CREATE TABLE supply_header (
    supply_id    SERIAL PRIMARY KEY,
    supply_date  DATE NOT NULL,
    supplier_id  INTEGER NOT NULL REFERENCES supplier_normalized(supplier_id),
    warehouse_id INTEGER NOT NULL REFERENCES warehouse_normalized(warehouse_id)
);

-- 5. Рядки документа надходження (зв'язок багато-до-багатьох)
CREATE TABLE supply_line (
    supply_id    INTEGER NOT NULL REFERENCES supply_header(supply_id) ON DELETE CASCADE,
    product_id   INTEGER NOT NULL REFERENCES product_normalized(product_id),
    quantity     INTEGER NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (supply_id, product_id)
);

-- ==============================================================================
-- ЕТАП 3: Заповнення нормалізованих таблиць чистими даними
-- ==============================================================================

-- Заповнення довідників
INSERT INTO supplier_normalized (company_name, contact_person, phone) VALUES
('ТОВ ТехноПоставка', 'Петренко Іван', '+380521234567'),
('ФОП Громов', 'Громов Олексій', '+380671234567');

INSERT INTO warehouse_normalized (name, address) VALUES
('Основний склад', 'вул. Київська, 15'),
('Резервний склад', 'вул. Львівська, 8');

INSERT INTO product_normalized (name) VALUES
('Процесор Intel Core i5-12400F'),
('Материнська плата ASUS PRIME B660M-A'),
('Процесор AMD Ryzen 5 5600X'),
('Відеокарта NVIDIA GeForce RTX 3060');

-- Фіксація факту поставок (лише 2 записи замість 4)
INSERT INTO supply_header (supply_date, supplier_id, warehouse_id) VALUES
('2026-03-01', 1, 1), 
('2026-03-05', 2, 2); 

-- Деталізація: які товари та в якій кількості були у поставках
INSERT INTO supply_line (supply_id, product_id, quantity) VALUES
(1, 1, 50), 
(1, 2, 20), 
(2, 3, 30), 
(2, 4, 10); 
