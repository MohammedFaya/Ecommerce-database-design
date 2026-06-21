-- Car Rental Management System - Sample Data
-- PostgreSQL Implementation

-- ============================================
-- INSERT VEHICLE CATEGORIES
-- ============================================
INSERT INTO VEHICLE_CATEGORY (category_name, description, passenger_capacity, base_rate, insurance_rate) VALUES
('Economy', 'Fuel-efficient compact cars perfect for city driving and budget-conscious travelers', 5, 35.00, 10.00),
('Compact', 'Small to medium-sized vehicles offering good fuel economy and easy parking', 5, 45.00, 12.00),
('Midsize', 'Comfortable sedans with ample space for families and longer trips', 5, 55.00, 15.00),
('SUV', 'Sport Utility Vehicles with high ground clearance and spacious interiors', 7, 85.00, 20.00),
('Luxury', 'Premium vehicles with high-end features and superior comfort', 5, 120.00, 25.00),
('Van', 'Large passenger vans ideal for groups and family trips', 8, 95.00, 18.00),
('Truck', 'Pickup trucks for cargo and utility purposes', 5, 75.00, 16.00),
('Sports', 'High-performance vehicles for driving enthusiasts', 2, 150.00, 30.00),
('Electric', 'Eco-friendly electric vehicles with zero emissions', 5, 70.00, 15.00),
('Convertible', 'Open-top vehicles for scenic drives', 4, 110.00, 22.00);

-- ============================================
-- INSERT CUSTOMERS
-- ============================================
INSERT INTO CUSTOMER (first_name, last_name, email, phone, license_number, license_expiry, address, city, state, zip_code, registration_date, customer_type) VALUES
('John', 'Smith', 'john.smith@email.com', '555-0101', 'DL123456789', '2026-08-15', '123 Main St', 'New York', 'NY', '10001', '2023-01-15', 'Individual'),
('Sarah', 'Johnson', 'sarah.j@email.com', '555-0102', 'DL987654321', '2027-03-20', '456 Oak Ave', 'Los Angeles', 'CA', '90001', '2023-02-20', 'VIP'),
('Michael', 'Brown', 'mbrown@email.com', '555-0103', 'DL456789123', '2026-11-10', '789 Pine Rd', 'Chicago', 'IL', '60601', '2023-03-10', 'Individual'),
('Emily', 'Davis', 'emily.davis@email.com', '555-0104', 'DL321654987', '2028-01-25', '321 Elm St', 'Houston', 'TX', '77001', '2023-04-05', 'Corporate'),
('David', 'Wilson', 'dwilson@email.com', '555-0105', 'DL789123456', '2026-06-30', '654 Maple Dr', 'Phoenix', 'AZ', '85001', '2023-05-12', 'Individual'),
('Jessica', 'Martinez', 'jmartinez@email.com', '555-0106', 'DL147258369', '2027-09-15', '987 Cedar Ln', 'Philadelphia', 'PA', '19101', '2023-06-18', 'VIP'),
('Robert', 'Anderson', 'randerson@email.com', '555-0107', 'DL963852741', '2026-12-05', '147 Birch St', 'San Antonio', 'TX', '78201', '2023-07-22', 'Individual'),
('Amanda', 'Taylor', 'ataylor@email.com', '555-0108', 'DL852963741', '2027-04-18', '258 Spruce Ave', 'San Diego', 'CA', '92101', '2023-08-30', 'Corporate'),
('Christopher', 'Thomas', 'cthomas@email.com', '555-0109', 'DL741852963', '2028-02-10', '369 Walnut Rd', 'Dallas', 'TX', '75201', '2023-09-15', 'Individual'),
('Jennifer', 'Moore', 'jmoore@email.com', '555-0110', 'DL159753486', '2026-10-20', '753 Ash Blvd', 'San Jose', 'CA', '95101', '2023-10-08', 'VIP'),
('Matthew', 'Jackson', 'mjackson@email.com', '555-0111', 'DL486159753', '2027-07-12', '951 Poplar Way', 'Austin', 'TX', '73301', '2023-11-20', 'Individual'),
('Lisa', 'White', 'lwhite@email.com', '555-0112', 'DL357159486', '2026-05-28', '159 Willow Ct', 'Jacksonville', 'FL', '32099', '2023-12-05', 'Corporate');

-- ============================================
-- INSERT EMPLOYEES
-- ============================================
INSERT INTO EMPLOYEE (first_name, last_name, email, phone, position, hire_date, salary, department, status) VALUES
('Alice', 'Cooper', 'alice.cooper@carrental.com', '555-1001', 'Rental Manager', '2020-01-15', 55000.00, 'Rental Operations', 'Active'),
('Bob', 'Williams', 'bob.williams@carrental.com', '555-1002', 'Customer Service Rep', '2021-03-20', 38000.00, 'Customer Service', 'Active'),
('Carol', 'Garcia', 'carol.garcia@carrental.com', '555-1003', 'Maintenance Supervisor', '2019-06-10', 52000.00, 'Maintenance', 'Active'),
('Daniel', 'Miller', 'daniel.miller@carrental.com', '555-1004', 'Rental Agent', '2022-02-14', 40000.00, 'Rental Operations', 'Active'),
('Emma', 'Rodriguez', 'emma.rodriguez@carrental.com', '555-1005', 'Mechanic', '2020-08-22', 45000.00, 'Maintenance', 'Active'),
('Frank', 'Martinez', 'frank.martinez@carrental.com', '555-1006', 'Admin Assistant', '2021-11-05', 36000.00, 'Administration', 'Active'),
('Grace', 'Lee', 'grace.lee@carrental.com', '555-1007', 'Senior Rental Agent', '2018-04-18', 48000.00, 'Rental Operations', 'Active'),
('Henry', 'Clark', 'henry.clark@carrental.com', '555-1008', 'Mechanic', '2021-09-30', 44000.00, 'Maintenance', 'Active'),
('Isabel', 'Lewis', 'isabel.lewis@carrental.com', '555-1009', 'Customer Service Rep', '2022-01-12', 37000.00, 'Customer Service', 'Active'),
('Jack', 'Walker', 'jack.walker@carrental.com', '555-1010', 'Rental Agent', '2022-07-20', 39000.00, 'Rental Operations', 'On Leave');

-- ============================================
-- INSERT VEHICLES
-- ============================================
INSERT INTO VEHICLE (registration_number, category_id, make, model, year, color, mileage, status, last_service_date, daily_rate, fuel_type, transmission_type) VALUES
('ABC1234', 1, 'Toyota', 'Corolla', 2023, 'White', 15000, 'Available', '2024-11-15', 35.00, 'Gasoline', 'Automatic'),
('DEF5678', 1, 'Honda', 'Civic', 2023, 'Blue', 12000, 'Available', '2024-11-20', 37.00, 'Gasoline', 'Automatic'),
('GHI9012', 2, 'Mazda', '3', 2022, 'Red', 28000, 'Available', '2024-10-10', 45.00, 'Gasoline', 'Manual'),
('JKL3456', 3, 'Toyota', 'Camry', 2024, 'Silver', 8000, 'Available', '2024-12-01', 55.00, 'Gasoline', 'Automatic'),
('MNO7890', 3, 'Honda', 'Accord', 2023, 'Black', 18000, 'Rented', '2024-10-25', 57.00, 'Hybrid', 'Automatic'),
('PQR2345', 4, 'Ford', 'Explorer', 2024, 'Gray', 5000, 'Available', '2024-11-28', 85.00, 'Gasoline', 'Automatic'),
('STU6789', 4, 'Jeep', 'Grand Cherokee', 2023, 'Green', 22000, 'Available', '2024-11-05', 88.00, 'Gasoline', 'Automatic'),
('VWX0123', 5, 'BMW', '5 Series', 2024, 'Black', 3000, 'Available', '2024-12-10', 125.00, 'Gasoline', 'Automatic'),
('YZA4567', 5, 'Mercedes', 'E-Class', 2024, 'White', 2500, 'Rented', '2024-12-05', 130.00, 'Gasoline', 'Automatic'),
('BCD8901', 6, 'Toyota', 'Sienna', 2023, 'Silver', 35000, 'Available', '2024-09-20', 95.00, 'Hybrid', 'Automatic'),
('EFG2345', 7, 'Ford', 'F-150', 2023, 'Blue', 40000, 'Maintenance', '2024-11-30', 75.00, 'Gasoline', 'Automatic'),
('HIJ6789', 8, 'Porsche', '911', 2024, 'Red', 1200, 'Available', '2024-12-15', 180.00, 'Gasoline', 'Manual'),
('KLM0123', 9, 'Tesla', 'Model 3', 2024, 'White', 6000, 'Available', '2024-11-18', 70.00, 'Electric', 'Automatic'),
('NOP4567', 9, 'Tesla', 'Model Y', 2024, 'Blue', 4500, 'Available', '2024-12-02', 82.00, 'Electric', 'Automatic'),
('QRS8901', 10, 'Mazda', 'MX-5', 2023, 'Yellow', 18000, 'Available', '2024-10-15', 110.00, 'Gasoline', 'Manual');

-- ============================================
-- INSERT RESERVATIONS
-- ============================================
INSERT INTO RESERVATION (customer_id, vehicle_id, employee_id, reservation_date, pickup_date, return_date, actual_return_date, pickup_location, return_location, total_amount, status, special_requests) VALUES
(1, 1, 1, '2024-11-01', '2024-11-05', '2024-11-08', '2024-11-08', 'New York Downtown', 'New York Downtown', 105.00, 'Completed', NULL),
(2, 9, 2, '2024-11-10', '2024-11-15', '2024-11-20', '2024-11-21', 'Los Angeles Airport', 'Los Angeles Airport', 780.00, 'Completed', 'Need GPS'),
(3, 3, 4, '2024-11-12', '2024-11-18', '2024-11-22', '2024-11-22', 'Chicago Downtown', 'Chicago Downtown', 180.00, 'Completed', NULL),
(4, 4, 7, '2024-11-15', '2024-11-25', '2024-11-30', '2024-11-30', 'Houston Airport', 'Houston Downtown', 275.00, 'Completed', 'Child seat required'),
(5, 6, 1, '2024-11-20', '2024-12-01', '2024-12-05', NULL, 'Phoenix Downtown', 'Phoenix Downtown', 340.00, 'Active', NULL),
(6, 7, 2, '2024-11-22', '2024-12-03', '2024-12-10', NULL, 'Philadelphia Airport', 'Philadelphia Airport', 616.00, 'Confirmed', 'Airport pickup service'),
(7, 10, 4, '2024-11-25', '2024-12-05', '2024-12-08', NULL, 'San Antonio Downtown', 'San Antonio Downtown', 285.00, 'Confirmed', NULL),
(8, 13, 7, '2024-11-28', '2024-12-10', '2024-12-15', NULL, 'San Diego Airport', 'San Diego Airport', 350.00, 'Pending', NULL),
(9, 14, 1, '2024-11-30', '2024-12-12', '2024-12-18', NULL, 'Dallas Downtown', 'Dallas Airport', 492.00, 'Pending', NULL),
(10, 8, 2, '2024-12-01', '2024-12-15', '2024-12-20', NULL, 'San Jose Airport', 'San Jose Airport', 625.00, 'Confirmed', 'Premium insurance'),
(1, 2, 4, '2024-12-05', '2024-12-20', '2024-12-23', NULL, 'New York Airport', 'New York Airport', 111.00, 'Pending', NULL),
(11, 12, 7, '2024-12-08', '2024-12-22', '2024-12-27', NULL, 'Austin Downtown', 'Austin Airport', 900.00, 'Pending', 'VIP service'),
(12, 15, 1, '2024-12-10', '2024-12-25', '2025-01-02', NULL, 'Jacksonville Airport', 'Jacksonville Airport', 880.00, 'Pending', NULL),
(3, 1, 2, '2024-10-15', '2024-10-20', '2024-10-25', '2024-10-26', 'Chicago Airport', 'Chicago Airport', 210.00, 'Completed', NULL),
(5, 4, 4, '2024-09-20', '2024-09-25', '2024-09-28', '2024-09-28', 'Phoenix Downtown', 'Phoenix Airport', 165.00, 'Completed', NULL);

-- ============================================
-- INSERT PAYMENTS
-- ============================================
INSERT INTO PAYMENT (reservation_id, customer_id, payment_date, amount, payment_method, transaction_id, payment_status, late_fee, damage_charge) VALUES
(1, 1, '2024-11-05', 105.00, 'Credit Card', 'TXN20241105001', 'Completed', 0, 0),
(2, 2, '2024-11-15', 830.00, 'Credit Card', 'TXN20241115002', 'Completed', 50.00, 0),
(3, 3, '2024-11-18', 180.00, 'Debit Card', 'TXN20241118003', 'Completed', 0, 0),
(4, 4, '2024-11-25', 275.00, 'Bank Transfer', 'TXN20241125004', 'Completed', 0, 0),
(5, 5, '2024-12-01', 340.00, 'Credit Card', 'TXN20241201005', 'Completed', 0, 0),
(6, 6, '2024-12-03', 616.00, 'Credit Card', 'TXN20241203006', 'Completed', 0, 0),
(7, 7, '2024-12-05', 285.00, 'Cash', 'TXN20241205007', 'Completed', 0, 0),
(8, 8, '2024-12-10', 350.00, 'PayPal', 'TXN20241210008', 'Pending', 0, 0),
(9, 9, '2024-12-12', 492.00, 'Credit Card', 'TXN20241212009', 'Pending', 0, 0),
(10, 10, '2024-12-15', 625.00, 'Credit Card', 'TXN20241215010', 'Pending', 0, 0),
(11, 1, '2024-12-20', 111.00, 'Debit Card', 'TXN20241220011', 'Pending', 0, 0),
(12, 11, '2024-12-22', 900.00, 'Bank Transfer', 'TXN20241222012', 'Pending', 0, 0),
(13, 12, '2024-12-25', 880.00, 'Credit Card', 'TXN20241225013', 'Pending', 0, 0),
(14, 3, '2024-10-20', 245.00, 'Credit Card', 'TXN20241020014', 'Completed', 35.00, 0),
(15, 5, '2024-09-25', 165.00, 'Debit Card', 'TXN20240925015', 'Completed', 0, 0);

-- ============================================
-- INSERT MAINTENANCE RECORDS
-- ============================================
INSERT INTO MAINTENANCE (vehicle_id, employee_id, maintenance_date, maintenance_type, description, cost, status, next_service_date) VALUES
(1, 3, '2024-11-15', 'Routine Service', 'Oil change, filter replacement, tire rotation', 150.00, 'Completed', '2025-02-15'),
(2, 5, '2024-11-20', 'Routine Service', 'Oil change and brake inspection', 130.00, 'Completed', '2025-02-20'),
(3, 3, '2024-10-10', 'Repair', 'Replaced front brake pads and rotors', 350.00, 'Completed', '2025-01-10'),
(4, 5, '2024-12-01', 'Inspection', 'Annual safety inspection', 75.00, 'Completed', '2025-12-01'),
(5, 8, '2024-10-25', 'Routine Service', 'Hybrid system check, oil change, tire rotation', 200.00, 'Completed', '2025-01-25'),
(6, 3, '2024-11-28', 'Cleaning', 'Deep interior and exterior detailing', 120.00, 'Completed', NULL),
(7, 5, '2024-11-05', 'Routine Service', 'Oil change, air filter replacement', 140.00, 'Completed', '2025-02-05'),
(8, 8, '2024-12-10', 'Inspection', 'Premium vehicle inspection and detailing', 250.00, 'Completed', '2025-03-10'),
(9, 3, '2024-12-05', 'Routine Service', 'Oil change, tire check, fluid levels', 180.00, 'Completed', '2025-03-05'),
(10, 5, '2024-09-20', 'Repair', 'Transmission service and fluid replacement', 450.00, 'Completed', '2024-12-20'),
(11, 3, '2024-11-30', 'Repair', 'Engine diagnostic and repair', 850.00, 'In Progress', '2025-01-30'),
(12, 8, '2024-12-15', 'Routine Service', 'Performance check and oil change', 300.00, 'Completed', '2025-03-15'),
(13, 5, '2024-11-18', 'Inspection', 'Battery health check and software update', 100.00, 'Completed', '2025-02-18'),
(14, 3, '2024-12-02', 'Cleaning', 'Interior detailing and charging system check', 110.00, 'Completed', NULL),
(15, 8, '2024-10-15', 'Routine Service', 'Oil change and convertible top inspection', 175.00, 'Completed', '2025-01-15'),
(1, 5, '2024-08-15', 'Oil Change', 'Standard oil change service', 80.00, 'Completed', '2024-11-15'),
(6, 8, '2024-10-20', 'Tire Change', 'Replaced all four tires', 600.00, 'Completed', NULL),
(7, 3, '2024-09-10', 'Inspection', 'Pre-purchase inspection', 100.00, 'Completed', NULL);