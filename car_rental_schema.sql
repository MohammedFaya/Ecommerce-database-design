-- Car Rental Management System - Database Schema
-- PostgreSQL Implementation
-- Drop existing tables if they exist (in reverse order of dependencies)

DROP TABLE IF EXISTS MAINTENANCE CASCADE;
DROP TABLE IF EXISTS PAYMENT CASCADE;
DROP TABLE IF EXISTS RESERVATION CASCADE;
DROP TABLE IF EXISTS VEHICLE CASCADE;
DROP TABLE IF EXISTS VEHICLE_CATEGORY CASCADE;
DROP TABLE IF EXISTS EMPLOYEE CASCADE;
DROP TABLE IF EXISTS CUSTOMER CASCADE;

-- ============================================
-- CUSTOMER TABLE
-- ============================================
CREATE TABLE CUSTOMER (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    license_number VARCHAR(20) NOT NULL UNIQUE,
    license_expiry DATE NOT NULL CHECK (license_expiry > CURRENT_DATE),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    customer_type VARCHAR(20) NOT NULL DEFAULT 'Individual' 
        CHECK (customer_type IN ('Individual', 'Corporate', 'VIP'))
);

-- ============================================
-- VEHICLE_CATEGORY TABLE
-- ============================================
CREATE TABLE VEHICLE_CATEGORY (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    passenger_capacity INT NOT NULL CHECK (passenger_capacity > 0 AND passenger_capacity <= 15),
    base_rate DECIMAL(10,2) NOT NULL CHECK (base_rate > 0),
    insurance_rate DECIMAL(10,2) NOT NULL CHECK (insurance_rate >= 0)
);

-- ============================================
-- EMPLOYEE TABLE
-- ============================================
CREATE TABLE EMPLOYEE (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    salary DECIMAL(10,2) NOT NULL CHECK (salary > 0),
    department VARCHAR(50) NOT NULL 
        CHECK (department IN ('Rental Operations', 'Maintenance', 'Administration', 'Customer Service')),
    status VARCHAR(20) NOT NULL DEFAULT 'Active' 
        CHECK (status IN ('Active', 'On Leave', 'Terminated'))
);

-- ============================================
-- VEHICLE TABLE
-- ============================================
CREATE TABLE VEHICLE (
    vehicle_id SERIAL PRIMARY KEY,
    registration_number VARCHAR(20) NOT NULL UNIQUE,
    category_id INT NOT NULL,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL CHECK (year BETWEEN 2000 AND EXTRACT(YEAR FROM CURRENT_DATE) + 1),
    color VARCHAR(30),
    mileage INT NOT NULL DEFAULT 0 CHECK (mileage >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'Available' 
        CHECK (status IN ('Available', 'Rented', 'Maintenance', 'Retired')),
    last_service_date DATE,
    daily_rate DECIMAL(10,2) NOT NULL CHECK (daily_rate > 0),
    fuel_type VARCHAR(20) NOT NULL 
        CHECK (fuel_type IN ('Gasoline', 'Diesel', 'Electric', 'Hybrid')),
    transmission_type VARCHAR(20) NOT NULL 
        CHECK (transmission_type IN ('Automatic', 'Manual')),
    FOREIGN KEY (category_id) REFERENCES VEHICLE_CATEGORY(category_id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

-- ============================================
-- RESERVATION TABLE
-- ============================================
CREATE TABLE RESERVATION (
    reservation_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    employee_id INT NOT NULL,
    reservation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    pickup_date DATE NOT NULL,
    return_date DATE NOT NULL,
    actual_return_date DATE,
    pickup_location VARCHAR(100) NOT NULL,
    return_location VARCHAR(100) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'Pending' 
        CHECK (status IN ('Pending', 'Confirmed', 'Active', 'Completed', 'Cancelled')),
    special_requests TEXT,
    CONSTRAINT check_return_after_pickup CHECK (return_date > pickup_date),
    CONSTRAINT check_actual_return_valid CHECK (actual_return_date IS NULL OR actual_return_date >= pickup_date),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES VEHICLE(vehicle_id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(employee_id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

-- ============================================
-- PAYMENT TABLE
-- ============================================
CREATE TABLE PAYMENT (
    payment_id SERIAL PRIMARY KEY,
    reservation_id INT NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_method VARCHAR(30) NOT NULL 
        CHECK (payment_method IN ('Credit Card', 'Debit Card', 'Cash', 'Bank Transfer', 'PayPal')),
    transaction_id VARCHAR(100) NOT NULL UNIQUE,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending' 
        CHECK (payment_status IN ('Pending', 'Completed', 'Failed', 'Refunded')),
    late_fee DECIMAL(10,2) DEFAULT 0 CHECK (late_fee >= 0),
    damage_charge DECIMAL(10,2) DEFAULT 0 CHECK (damage_charge >= 0),
    FOREIGN KEY (reservation_id) REFERENCES RESERVATION(reservation_id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

-- ============================================
-- MAINTENANCE TABLE
-- ============================================
CREATE TABLE MAINTENANCE (
    maintenance_id SERIAL PRIMARY KEY,
    vehicle_id INT NOT NULL,
    employee_id INT NOT NULL,
    maintenance_date DATE NOT NULL DEFAULT CURRENT_DATE,
    maintenance_type VARCHAR(50) NOT NULL 
        CHECK (maintenance_type IN ('Routine Service', 'Repair', 'Inspection', 'Cleaning', 'Tire Change', 'Oil Change')),
    description TEXT NOT NULL,
    cost DECIMAL(10,2) NOT NULL CHECK (cost >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled' 
        CHECK (status IN ('Scheduled', 'In Progress', 'Completed')),
    next_service_date DATE,
    FOREIGN KEY (vehicle_id) REFERENCES VEHICLE(vehicle_id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(employee_id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================
CREATE INDEX idx_customer_email ON CUSTOMER(email);
CREATE INDEX idx_customer_license ON CUSTOMER(license_number);
CREATE INDEX idx_vehicle_status ON VEHICLE(status);
CREATE INDEX idx_vehicle_category ON VEHICLE(category_id);
CREATE INDEX idx_reservation_customer ON RESERVATION(customer_id);
CREATE INDEX idx_reservation_vehicle ON RESERVATION(vehicle_id);
CREATE INDEX idx_reservation_dates ON RESERVATION(pickup_date, return_date);
CREATE INDEX idx_reservation_status ON RESERVATION(status);
CREATE INDEX idx_payment_reservation ON PAYMENT(reservation_id);
CREATE INDEX idx_payment_status ON PAYMENT(payment_status);
CREATE INDEX idx_maintenance_vehicle ON MAINTENANCE(vehicle_id);
CREATE INDEX idx_maintenance_date ON MAINTENANCE(maintenance_date);

COMMENT ON TABLE CUSTOMER IS 'Stores customer information and licensing details';
COMMENT ON TABLE VEHICLE_CATEGORY IS 'Defines vehicle categories with pricing';
COMMENT ON TABLE EMPLOYEE IS 'Employee information and department assignments';
COMMENT ON TABLE VEHICLE IS 'Vehicle fleet inventory with specifications';
COMMENT ON TABLE RESERVATION IS 'Rental reservations and booking details';
COMMENT ON TABLE PAYMENT IS 'Payment transactions for reservations';
COMMENT ON TABLE MAINTENANCE IS 'Vehicle maintenance and service records';