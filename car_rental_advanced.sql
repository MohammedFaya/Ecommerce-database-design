-- Car Rental Management System - Advanced Features
-- PostgreSQL Implementation
-- Views, Triggers, and Stored Procedures/Functions

-- ============================================
-- VIEWS (5 points)
-- ============================================

-- View 1: Available Vehicles Summary
CREATE OR REPLACE VIEW vw_available_vehicles AS
SELECT 
    v.vehicle_id,
    v.registration_number,
    v.make,
    v.model,
    v.year,
    v.color,
    vc.category_name,
    v.daily_rate,
    vc.passenger_capacity,
    v.fuel_type,
    v.transmission_type,
    v.mileage,
    v.last_service_date
FROM VEHICLE v
JOIN VEHICLE_CATEGORY vc ON v.category_id = vc.category_id
WHERE v.status = 'Available';

-- View 2: Active Reservations with Customer Details
CREATE OR REPLACE VIEW vw_active_reservations AS
SELECT 
    r.reservation_id,
    r.pickup_date,
    r.return_date,
    r.pickup_location,
    r.return_location,
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    c.phone,
    v.vehicle_id,
    v.registration_number,
    v.make || ' ' || v.model AS vehicle,
    vc.category_name,
    r.total_amount,
    r.status,
    e.first_name || ' ' || e.last_name AS processed_by
FROM RESERVATION r
JOIN CUSTOMER c ON r.customer_id = c.customer_id
JOIN VEHICLE v ON r.vehicle_id = v.vehicle_id
JOIN VEHICLE_CATEGORY vc ON v.category_id = vc.category_id
JOIN EMPLOYEE e ON r.employee_id = e.employee_id
WHERE r.status IN ('Confirmed', 'Active');

-- View 3: Customer Revenue Summary
CREATE OR REPLACE VIEW vw_customer_revenue AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    c.customer_type,
    COUNT(r.reservation_id) AS total_reservations,
    SUM(p.amount + p.late_fee + p.damage_charge) AS total_revenue,
    AVG(p.amount) AS avg_reservation_value,
    SUM(p.late_fee) AS total_late_fees,
    SUM(p.damage_charge) AS total_damage_charges,
    MAX(r.reservation_date) AS last_reservation_date
FROM CUSTOMER c
LEFT JOIN RESERVATION r ON c.customer_id = r.customer_id
LEFT JOIN PAYMENT p ON r.reservation_id = p.reservation_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.customer_type;

-- View 4: Vehicle Maintenance History
CREATE OR REPLACE VIEW vw_vehicle_maintenance AS
SELECT 
    v.vehicle_id,
    v.registration_number,
    v.make || ' ' || v.model AS vehicle,
    vc.category_name,
    v.year,
    v.mileage,
    COUNT(m.maintenance_id) AS maintenance_count,
    COALESCE(SUM(m.cost), 0) AS total_maintenance_cost,
    MAX(m.maintenance_date) AS last_maintenance_date,
    MAX(m.next_service_date) AS next_service_due
FROM VEHICLE v
JOIN VEHICLE_CATEGORY vc ON v.category_id = vc.category_id
LEFT JOIN MAINTENANCE m ON v.vehicle_id = m.vehicle_id
GROUP BY v.vehicle_id, v.registration_number, v.make, v.model, vc.category_name, v.year, v.mileage;

-- View 5: Monthly Revenue Report
CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT 
    TO_CHAR(p.payment_date, 'YYYY-MM') AS year_month,
    TO_CHAR(p.payment_date, 'Month YYYY') AS month_name,
    COUNT(DISTINCT p.payment_id) AS total_transactions,
    COUNT(DISTINCT p.customer_id) AS unique_customers,
    SUM(p.amount) AS base_revenue,
    SUM(p.late_fee) AS late_fee_revenue,
    SUM(p.damage_charge) AS damage_revenue,
    SUM(p.amount + p.late_fee + p.damage_charge) AS total_revenue,
    AVG(p.amount) AS avg_transaction_value
FROM PAYMENT p
WHERE p.payment_status = 'Completed'
GROUP BY TO_CHAR(p.payment_date, 'YYYY-MM'), TO_CHAR(p.payment_date, 'Month YYYY');

-- ============================================
-- TRIGGERS (8 points)
-- ============================================

-- Trigger 1: Automatically update vehicle status when reservation is confirmed
CREATE OR REPLACE FUNCTION update_vehicle_status_on_reservation()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Confirmed' OR NEW.status = 'Active' THEN
        UPDATE VEHICLE
        SET status = 'Rented'
        WHERE vehicle_id = NEW.vehicle_id;
    ELSIF NEW.status = 'Completed' OR NEW.status = 'Cancelled' THEN
        UPDATE VEHICLE
        SET status = 'Available'
        WHERE vehicle_id = NEW.vehicle_id
        AND NOT EXISTS (
            SELECT 1 FROM RESERVATION
            WHERE vehicle_id = NEW.vehicle_id
            AND status IN ('Confirmed', 'Active')
            AND reservation_id != NEW.reservation_id
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_vehicle_status
AFTER INSERT OR UPDATE OF status ON RESERVATION
FOR EACH ROW
EXECUTE FUNCTION update_vehicle_status_on_reservation();

-- Trigger 2: Calculate late fees automatically
CREATE OR REPLACE FUNCTION calculate_late_fee()
RETURNS TRIGGER AS $$
DECLARE
    days_late INTEGER;
    daily_rate DECIMAL(10,2);
BEGIN
    IF NEW.actual_return_date > (SELECT return_date FROM RESERVATION WHERE reservation_id = NEW.reservation_id) THEN
        SELECT (NEW.actual_return_date - return_date),
               (SELECT daily_rate FROM VEHICLE v 
                JOIN RESERVATION r ON v.vehicle_id = r.vehicle_id 
                WHERE r.reservation_id = NEW.reservation_id)
        INTO days_late, daily_rate
        FROM RESERVATION
        WHERE reservation_id = NEW.reservation_id;
        
        NEW.late_fee := days_late * daily_rate * 0.5; -- 50% of daily rate as late fee per day
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calculate_late_fee
BEFORE INSERT OR UPDATE ON PAYMENT
FOR EACH ROW
EXECUTE FUNCTION calculate_late_fee();

-- Trigger 3: Prevent vehicle deletion if it has active reservations
CREATE OR REPLACE FUNCTION prevent_vehicle_deletion()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM RESERVATION
        WHERE vehicle_id = OLD.vehicle_id
        AND status IN ('Confirmed', 'Active')
    ) THEN
        RAISE EXCEPTION 'Cannot delete vehicle with active reservations';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_vehicle_deletion
BEFORE DELETE ON VEHICLE
FOR EACH ROW
EXECUTE FUNCTION prevent_vehicle_deletion();

-- Trigger 4: Log maintenance and update vehicle service date
CREATE OR REPLACE FUNCTION update_last_service_date()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Completed' THEN
        UPDATE VEHICLE
        SET last_service_date = NEW.maintenance_date
        WHERE vehicle_id = NEW.vehicle_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_service_date
AFTER INSERT OR UPDATE OF status ON MAINTENANCE
FOR EACH ROW
EXECUTE FUNCTION update_last_service_date();

-- Trigger 5: Validate reservation dates
CREATE OR REPLACE FUNCTION validate_reservation_dates()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if pickup date is in the past
    IF NEW.pickup_date < CURRENT_DATE THEN
        RAISE EXCEPTION 'Pickup date cannot be in the past';
    END IF;
    
    -- Check if return date is after pickup date
    IF NEW.return_date <= NEW.pickup_date THEN
        RAISE EXCEPTION 'Return date must be after pickup date';
    END IF;
    
    -- Check for overlapping reservations for the same vehicle
    IF EXISTS (
        SELECT 1 FROM RESERVATION
        WHERE vehicle_id = NEW.vehicle_id
        AND reservation_id != COALESCE(NEW.reservation_id, 0)
        AND status IN ('Confirmed', 'Active')
        AND (
            (NEW.pickup_date BETWEEN pickup_date AND return_date)
            OR (NEW.return_date BETWEEN pickup_date AND return_date)
            OR (pickup_date BETWEEN NEW.pickup_date AND NEW.return_date)
        )
    ) THEN
        RAISE EXCEPTION 'Vehicle is already reserved for the selected dates';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_reservation_dates
BEFORE INSERT OR UPDATE ON RESERVATION
FOR EACH ROW
EXECUTE FUNCTION validate_reservation_dates();

-- ============================================
-- STORED PROCEDURES/FUNCTIONS (7 points)
-- ============================================

-- Function 1: Calculate rental cost based on dates and vehicle
CREATE OR REPLACE FUNCTION calculate_rental_cost(
    p_vehicle_id INTEGER,
    p_pickup_date DATE,
    p_return_date DATE
)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_daily_rate DECIMAL(10,2);
    v_insurance_rate DECIMAL(10,2);
    v_days INTEGER;
    v_total DECIMAL(10,2);
BEGIN
    -- Calculate number of days
    v_days := p_return_date - p_pickup_date;
    
    -- Get vehicle rates
    SELECT v.daily_rate, vc.insurance_rate
    INTO v_daily_rate, v_insurance_rate
    FROM VEHICLE v
    JOIN VEHICLE_CATEGORY vc ON v.category_id = vc.category_id
    WHERE v.vehicle_id = p_vehicle_id;
    
    -- Calculate total
    v_total := (v_daily_rate + v_insurance_rate) * v_days;
    
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- Function 2: Get available vehicles for specific dates and category
CREATE OR REPLACE FUNCTION get_available_vehicles(
    p_pickup_date DATE,
    p_return_date DATE,
    p_category_name VARCHAR DEFAULT NULL
)
RETURNS TABLE(
    vehicle_id INTEGER,
    registration_number VARCHAR,
    vehicle_name VARCHAR,
    category_name VARCHAR,
    daily_rate DECIMAL,
    estimated_cost DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.vehicle_id,
        v.registration_number,
        v.make || ' ' || v.model AS vehicle_name,
        vc.category_name,
        v.daily_rate,
        calculate_rental_cost(v.vehicle_id, p_pickup_date, p_return_date) AS estimated_cost
    FROM VEHICLE v
    JOIN VEHICLE_CATEGORY vc ON v.category_id = vc.category_id
    WHERE v.status = 'Available'
    AND (p_category_name IS NULL OR vc.category_name = p_category_name)
    AND NOT EXISTS (
        SELECT 1 FROM RESERVATION r
        WHERE r.vehicle_id = v.vehicle_id
        AND r.status IN ('Confirmed', 'Active')
        AND (
            (p_pickup_date BETWEEN r.pickup_date AND r.return_date)
            OR (p_return_date BETWEEN r.pickup_date AND r.return_date)
            OR (r.pickup_date BETWEEN p_pickup_date AND p_return_date)
        )
    )
    ORDER BY estimated_cost;
END;
$$ LANGUAGE plpgsql;

-- Procedure 3: Process vehicle return
CREATE OR REPLACE PROCEDURE process_vehicle_return(
    p_reservation_id INTEGER,
    p_actual_return_date DATE,
    p_damage_charge DECIMAL DEFAULT 0
)
LANGUAGE plpgsql AS $$
DECLARE
    v_vehicle_id INTEGER;
BEGIN
    -- Update reservation with actual return date
    UPDATE RESERVATION
    SET actual_return_date = p_actual_return_date,
        status = 'Completed'
    WHERE reservation_id = p_reservation_id
    RETURNING vehicle_id INTO v_vehicle_id;
    
    -- Update payment with damage charges if any
    IF p_damage_charge > 0 THEN
        UPDATE PAYMENT
        SET damage_charge = p_damage_charge,
            amount = amount + p_damage_charge
        WHERE reservation_id = p_reservation_id;
    END IF;
    
    -- Update payment status to completed
    UPDATE PAYMENT
    SET payment_status = 'Completed'
    WHERE reservation_id = p_reservation_id;
    
    -- Set vehicle back to available
    UPDATE VEHICLE
    SET status = 'Available'
    WHERE vehicle_id = v_vehicle_id;
    
    RAISE NOTICE 'Vehicle return processed successfully for reservation %', p_reservation_id;
END;
$$;

-- Function 4: Get customer rental history
CREATE OR REPLACE FUNCTION get_customer_rental_history(p_customer_id INTEGER)
RETURNS TABLE(
    reservation_id INTEGER,
    vehicle_name VARCHAR,
    pickup_date DATE,
    return_date DATE,
    actual_return_date DATE,
    total_amount DECIMAL,
    payment_status VARCHAR,
    reservation_status VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.reservation_id,
        v.make || ' ' || v.model AS vehicle_name,
        r.pickup_date,
        r.return_date,
        r.actual_return_date,
        r.total_amount,
        p.payment_status,
        r.status AS reservation_status
    FROM RESERVATION r
    JOIN VEHICLE v ON r.vehicle_id = v.vehicle_id
    JOIN PAYMENT p ON r.reservation_id = p.reservation_id
    WHERE r.customer_id = p_customer_id
    ORDER BY r.reservation_date DESC;
END;
$$ LANGUAGE plpgsql;

-- Function 5: Get vehicle utilization rate
CREATE OR REPLACE FUNCTION get_vehicle_utilization(
    p_vehicle_id INTEGER,
    p_start_date DATE DEFAULT CURRENT_DATE - INTERVAL '1 year',
    p_end_date DATE DEFAULT CURRENT_DATE
)
RETURNS DECIMAL(5,2) AS $$
DECLARE
    v_total_days INTEGER;
    v_rented_days INTEGER;
    v_utilization DECIMAL(5,2);
BEGIN
    v_total_days := p_end_date - p_start_date;
    
    SELECT COALESCE(SUM(
        CASE 
            WHEN actual_return_date IS NOT NULL 
            THEN actual_return_date - pickup_date
            ELSE return_date - pickup_date
        END
    ), 0)
    INTO v_rented_days
    FROM RESERVATION
    WHERE vehicle_id = p_vehicle_id
    AND pickup_date >= p_start_date
    AND pickup_date <= p_end_date
    AND status IN ('Completed', 'Active');
    
    v_utilization := (v_rented_days::DECIMAL / v_total_days) * 100;
    
    RETURN ROUND(v_utilization, 2);
END;
$$ LANGUAGE plpgsql;

-- Procedure 6: Schedule vehicle maintenance
CREATE OR REPLACE PROCEDURE schedule_maintenance(
    p_vehicle_id INTEGER,
    p_employee_id INTEGER,
    p_maintenance_type VARCHAR,
    p_description TEXT,
    p_estimated_cost DECIMAL,
    p_scheduled_date DATE DEFAULT CURRENT_DATE
)
LANGUAGE plpgsql AS $$
BEGIN
    -- Insert maintenance record
    INSERT INTO MAINTENANCE (
        vehicle_id,
        employee_id,
        maintenance_date,
        maintenance_type,
        description,
        cost,
        status,
        next_service_date
    ) VALUES (
        p_vehicle_id,
        p_employee_id,
        p_scheduled_date,
        p_maintenance_type,
        p_description,
        p_estimated_cost,
        'Scheduled',
        p_scheduled_date + INTERVAL '3 months'
    );
    
    -- Update vehicle status to maintenance
    UPDATE VEHICLE
    SET status = 'Maintenance'
    WHERE vehicle_id = p_vehicle_id;
    
    RAISE NOTICE 'Maintenance scheduled for vehicle % on %', p_vehicle_id, p_scheduled_date;
END;
$$;

-- ============================================
-- EXAMPLE USAGE OF ADVANCED FEATURES
-- ============================================

-- Using Views
-- SELECT * FROM vw_available_vehicles WHERE category_name = 'SUV';
-- SELECT * FROM vw_active_reservations;
-- SELECT * FROM vw_customer_revenue WHERE total_revenue > 500 ORDER BY total_revenue DESC;

-- Using Functions
-- SELECT calculate_rental_cost(1, '2024-12-25', '2024-12-30');
-- SELECT * FROM get_available_vehicles('2024-12-25', '2024-12-30', 'Luxury');
-- SELECT * FROM get_customer_rental_history(1);
-- SELECT vehicle_id, get_vehicle_utilization(vehicle_id) AS utilization_rate FROM VEHICLE LIMIT 5;

-- Using Procedures
-- CALL process_vehicle_return(1, '2024-11-09', 0);
-- CALL schedule_maintenance(11, 3, 'Repair', 'Engine repair needed', 850.00, '2024-12-20');