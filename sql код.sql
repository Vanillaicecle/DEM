-- Создание базы данных и настройка текущей схемы
CREATE DATABASE IF NOT EXISTS mosaic_enterprise;
USE mosaic_enterprise;

-- Создание таблицы типов материалов для классификации материалов
CREATE TABLE MaterialTypes (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- Создание таблицы поставщиков
CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    supplier_type VARCHAR(50),
    inn VARCHAR(20) UNIQUE,
    director_name VARCHAR(100),
    contact_phone VARCHAR(20),
    contact_email VARCHAR(100),
    rating DECIMAL(3,2),
    start_date DATE,
    legal_address TEXT,
    contract_status VARCHAR(50) DEFAULT 'active'
);

-- Создание таблицы материалов
CREATE TABLE Materials (
    material_id INT AUTO_INCREMENT PRIMARY KEY,
    material_name VARCHAR(100) NOT NULL,
    type_id INT,
    supplier_id INT,
    quantity_in_stock DECIMAL(10,2) NOT NULL,
    unit_of_measure VARCHAR(20) NOT NULL,
    quantity_per_package INT NOT NULL,
    min_quantity DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    description TEXT,
    quality_check_date DATE,
    FOREIGN KEY (type_id) REFERENCES MaterialTypes(type_id) ON DELETE SET NULL,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE SET NULL,
    CHECK (unit_price >= 0),
    CHECK (min_quantity >= 0),
    CHECK (quantity_in_stock >= 0)
);

-- Создание таблицы типов продукции
CREATE TABLE ProductTypes (
    product_type_id INT AUTO_INCREMENT PRIMARY KEY,
    product_type_name VARCHAR(100) NOT NULL,
    type_coefficient DECIMAL(10,2) NOT NULL
);

-- Создание таблицы сотрудников
CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_date DATE,
    passport_data VARCHAR(100),
    bank_details VARCHAR(100),
    health_status TEXT,
    position VARCHAR(100),
    department VARCHAR(100)
);

-- Создание таблицы партнеров
CREATE TABLE Partners (
    partner_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    partner_type VARCHAR(50),
    legal_address TEXT,
    inn VARCHAR(20) UNIQUE,
    director_name VARCHAR(100),
    contact_phone VARCHAR(20),
    contact_email VARCHAR(100),
    last_contact_date DATE,
    rating DECIMAL(3,2),
    sales_volume DECIMAL(12,2)
);

-- Создание таблицы продукции
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_type VARCHAR(50),
    description TEXT,
    production_status VARCHAR(50) DEFAULT 'planned',
    min_partner_price DECIMAL(10,2),
    package_length DECIMAL(6,2),
    package_width DECIMAL(6,2),
    package_height DECIMAL(6,2),
    net_weight DECIMAL(6,2),
    gross_weight DECIMAL(6,2),
    production_time INT,
    cost_price DECIMAL(10,2),
    workshop_number INT,
    material_id INT,
    FOREIGN KEY (material_id) REFERENCES Materials(material_id) ON DELETE SET NULL
);

-- Создание таблицы заявок
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    partner_id INT,
    manager_id INT,
    product_id INT,
    order_date DATETIME NOT NULL,
    status ENUM('new', 'confirmed', 'paid', 'production', 'completed', 'canceled'),
    prepayment_date DATETIME,
    completion_date DATETIME,
    total_amount DECIMAL(12,2),
    notes TEXT,
    FOREIGN KEY (partner_id) REFERENCES Partners(partner_id) ON DELETE SET NULL,
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id) ON DELETE SET NULL,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE SET NULL
);

-- Заполнение таблицы типов материалов
INSERT INTO MaterialTypes (type_name, description, is_active) VALUES
('Пластичные материалы', 'Материалы с пластичными свойствами', TRUE),
('Добавка', 'Различные добавки для производства', TRUE),
('Электролит', 'Электролитические материалы', TRUE),
('Глазурь', 'Материалы для глазурования', TRUE),
('Пигмент', 'Красящие пигменты', TRUE);

-- Заполнение таблицы поставщиков
INSERT INTO Suppliers (supplier_name, supplier_type, inn, rating, start_date, contract_status) VALUES
('БрянскСтройресурс', 'ЗАО', '9432455179', 8.00, '2015-12-20', 'active'),
('Стройкомплект', 'ЗАО', '7803888520', 7.00, '2017-09-13', 'active'),
('Железногорская руда', 'ООО', '8430391035', 7.00, '2016-12-23', 'active'),
('Белая гора', 'ООО', '4318170454', 8.00, '2019-05-27', 'active'),
('Тульский обрабатывающий завод', 'ООО', '7687851800', 7.00, '2015-06-16', 'active'),
('ГорТехРазработка', 'ПАО', '6119144874', 9.00, '2021-12-27', 'active'),
('Сапфир', 'ОАО', '1122170258', 3.00, '2022-04-10', 'active'),
('ХимБытСервис', 'ПАО', '8355114917', 5.00, '2022-03-13', 'active'),
('ВоронежРудоКомбинат', 'ОАО', '3532367439', 8.00, '2023-11-11', 'active'),
('Смоленский добывающий комбинат', 'ОАО', '2362431140', 3.00, '2018-11-23', 'active'),
('МосКарьер', 'ПАО', '4159215346', 2.00, '2012-07-07', 'active'),
('КурскРесурс', 'ЗАО', '9032455179', 4.00, '2021-07-23', 'active'),
('Нижегородская разработка', 'ОАО', '3776671267', 9.00, '2016-05-23', 'active'),
('Речная долина', 'ОАО', '7447864518', 8.00, '2015-06-25', 'active'),
('Карелия добыча', 'ПАО', '9037040523', 6.00, '2017-03-09', 'active'),
('Московский ХимЗавод', 'ПАО', '6221520857', 4.00, '2015-05-07', 'active'),
('Горная компания', 'ЗАО', '2262431140', 3.00, '2020-12-22', 'active'),
('Минерал Ресурс', 'ООО', '4155215346', 7.00, '2015-05-22', 'active'),
('Арсенал', 'ЗАО', '3961234561', 5.00, '2010-11-25', 'active'),
('КамчаткаСтройМинералы', 'ЗАО', '9600275878', 7.00, '2016-12-20', 'active');

-- Заполнение таблицы материалов (без supplier_id)
INSERT INTO Materials (material_name, type_id, quantity_in_stock, unit_of_measure, quantity_per_package, min_quantity, unit_price) VALUES
('Глина', 1, 1570.00, 'кг', 30, 5500.00, 15.29),
('Каолин', 1, 1030.00, 'кг', 25, 3500.00, 18.20),
('Гидрослюда', 1, 2147.00, 'кг', 25, 3500.00, 17.20),
('Монтмориллонит', 1, 3000.00, 'кг', 30, 3000.00, 17.67),
('Перлит', 2, 150.00, 'л', 50, 1000.00, 13.99),
('Стекло', 2, 3000.00, 'кг', 500, 1500.00, 2.40),
('Дегидратированная глина', 2, 3000.00, 'кг', 20, 2500.00, 21.95),
('Шамот', 2, 2300.00, 'кг', 20, 1960.00, 27.50),
('Техническая сода', 3, 1200.00, 'кг', 25, 1500.00, 54.55),
('Жидкое стекло', 3, 500.00, 'кг', 15, 1500.00, 76.59),
('Кварц', 4, 1500.00, 'кг', 10, 2500.00, 375.96),
('Полевой шпат', 4, 750.00, 'кг', 100, 1500.00, 15.99),
('Краска-раствор', 5, 1496.00, 'л', 5, 2500.00, 200.90),
('Порошок цветной', 5, 511.00, 'кг', 25, 1750.00, 84.39),
('Кварцевый песок', 2, 3000.00, 'кг', 50, 1600.00, 4.29),
('Жильный кварц', 2, 2556.00, 'кг', 25, 1600.00, 18.60),
('Барий углекислый', 4, 340.00, 'кг', 25, 1500.00, 303.64),
('Бура техническая', 4, 165.00, 'кг', 25, 1300.00, 125.99),
('Углещелочной реагент', 3, 450.00, 'кг', 25, 1100.00, 3.45),
('Пирофосфат натрия', 3, 356.00, 'кг', 25, 1200.00, 700.99);

-- Обновление supplier_id для материалов
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'Белая гора') WHERE material_name = 'Глина';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'БрянскСтройресурс') WHERE material_name = 'Каолин';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'Железногорская руда') WHERE material_name = 'Гидрослюда';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'ВоронежРудоКомбинат') WHERE material_name = 'Монтмориллонит';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'ГорТехРазработка') WHERE material_name = 'Перлит';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'Арсенал') WHERE material_name = 'Стекло';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'ВоронежРудоКомбинат') WHERE material_name = 'Дегидратированная глина';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'Горная компания') WHERE material_name = 'Шамот';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'Минерал Ресурс') WHERE material_name = 'Техническая сода';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'КурскРесурс') WHERE material_name = 'Жидкое стекло';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'МосКарьер') WHERE material_name = 'Кварц';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'Белая гора') WHERE material_name = 'Полевой шпат';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'Арсенал') WHERE material_name = 'Краска-раствор';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'Арсенал') WHERE material_name = 'Порошок цветной';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'БрянскСтройресурс') WHERE material_name = 'Кварцевый песок';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'Горная компания') WHERE material_name = 'Жильный кварц';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'Горная компания') WHERE material_name = 'Барий углекислый';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'КамчаткаСтройМинералы') WHERE material_name = 'Бура техническая';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'Московский ХимЗавод') WHERE material_name = 'Углещелочной реагент';
UPDATE Materials SET supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'КамчаткаСтройМинералы') WHERE material_name = 'Пирофосфат натрия';

-- Заполнение таблицы типов продукции
INSERT INTO ProductTypes (product_type_name, type_coefficient) VALUES
('Тип продукции 1', 1.20),
('Тип продукции 2', 8.59),
('Тип продукции 3', 3.45),
('Тип продукции 4', 5.60);

-- Добавление тестовых данных в другие таблицы
INSERT INTO Employees (full_name, position, department) VALUES
('Иванов Иван Иванович', 'Менеджер по продажам', 'Отдел продаж'),
('Петрова Анна Сергеевна', 'Технолог', 'Производственный отдел');

INSERT INTO Partners (company_name, partner_type, inn, rating) VALUES
('ООО "СтройМаркет"', 'Розничная сеть', '1234567890', 8.5),
('АО "Строительные технологии"', 'Оптовый покупатель', '0987654321', 9.2);

INSERT INTO Products (product_name, product_type, production_status, material_id) VALUES
('Керамическая плитка "Белая"', 'Тип продукции 1', 'planned', 1),
('Декоративная плитка "Мрамор"', 'Тип продукции 2', 'planned', 3);

INSERT INTO Orders (partner_id, manager_id, product_id, order_date, status, total_amount) VALUES
(1, 1, 1, '2023-10-01 10:00:00', 'completed', 150000.00),
(2, 1, 2, '2023-10-05 11:30:00', 'production', 225000.00);