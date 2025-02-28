CREATE DATABASE franca_food;
USE franca_food;

CREATE TABLE Users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('customer', 'admin') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Restaurants (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(15),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Menus (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id BIGINT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    restaurant_id BIGINT,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'completed', 'cancelled') DEFAULT 'pending',
    delivery_address VARCHAR(255),
    payment_status ENUM('pending', 'paid', 'failed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(id)
);

CREATE TABLE OrderItems (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT,
    menu_id BIGINT,
    quantity INT DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (menu_id) REFERENCES Menus(id)
);

CREATE TABLE DeliveryAddresses (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    state VARCHAR(255) NOT NULL,
    zip_code VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE Payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT,
    payment_method ENUM('credit_card', 'debit_card', 'cash') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(id)
);

INSERT INTO Users (name, email, password, role)
VALUES ('João Silva', 'joao.silva@gmail.com', 'senha123', 'customer');

INSERT INTO Restaurants (name, address, phone, description)
VALUES ('Restaurante Saboroso', 'Rua Principal, 123, Franca', '(16) 1234-5678', 'Restaurante de comida caseira com pratos deliciosos');

INSERT INTO Menus (restaurant_id, name, description, price)
VALUES (
    (SELECT id FROM Restaurants WHERE name = 'Restaurante Saboroso'),
    'Feijoada Completa',
    'Feijão preto com arroz, carne de porco e farofa.',
    30.00
);

INSERT INTO Orders (user_id, restaurant_id, total_price, status, delivery_address, payment_status)
VALUES (
    (SELECT id FROM Users WHERE email = 'joao.silva@gmail.com'),
    (SELECT id FROM Restaurants WHERE name = 'Restaurante Saboroso'),
    30.00,
    'pending',
    'Rua das Flores, 456, Franca',
    'pending'
);

INSERT INTO OrderItems (order_id, menu_id, quantity, price)
VALUES (
    (SELECT id FROM Orders WHERE user_id = (SELECT id FROM Users WHERE email = 'joao.silva@gmail.com') LIMIT 1),
    (SELECT id FROM Menus WHERE name = 'Feijoada Completa' LIMIT 1),
    1,
    30.00
);

INSERT INTO DeliveryAddresses (user_id, address, city, state, zip_code)
VALUES (
    (SELECT id FROM Users WHERE email = 'joao.silva@gmail.com'),
    'Rua das Flores, 456',
    'Franca',
    'SP',
    '14400-000'
);

INSERT INTO Payments (order_id, payment_method, amount, payment_status)
VALUES (
    (SELECT id FROM Orders WHERE user_id = (SELECT id FROM Users WHERE email = 'joao.silva@gmail.com') LIMIT 1),
    'credit_card',
    30.00,
    'pending'
);



SELECT * FROM Users;
SELECT * FROM Restaurants;
SELECT * FROM Menus;
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM DeliveryAddresses;
SELECT * FROM Payments;



