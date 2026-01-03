-- Schema for Hospital Appointment System
-- Database: hospitalappointmentsystem

CREATE DATABASE IF NOT EXISTS hospitalappointmentsystem;
USE hospitalappointmentsystem;

-- Users table
CREATE TABLE IF NOT EXISTS users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  role ENUM('admin','doctor','patient') NOT NULL DEFAULT 'patient',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Departments
CREATE TABLE IF NOT EXISTS department (
  department_id INT AUTO_INCREMENT PRIMARY KEY,
  department_name VARCHAR(150) NOT NULL,
  description TEXT
);

-- Doctors
CREATE TABLE IF NOT EXISTS doctor (
  doctor_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(150) UNIQUE,
  department_id INT,
  specialization VARCHAR(150),
  availability TINYINT(1) DEFAULT 1,
  FOREIGN KEY (department_id) REFERENCES department(department_id) ON DELETE SET NULL
);

-- Appointments
CREATE TABLE IF NOT EXISTS appointment (
  appointment_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  doctor_id INT NOT NULL,
  appointment_date DATE NOT NULL,
  appointment_time TIME NOT NULL,
  status VARCHAR(20) DEFAULT 'scheduled',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id) ON DELETE CASCADE
);

-- Payments (Note: storing CVV and card details is NOT PCI-compliant; this schema is for local/testing only)
CREATE TABLE IF NOT EXISTS payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  card_number VARCHAR(32) NOT NULL,
  card_holder_name VARCHAR(150),
  expiry_date VARCHAR(7),
  cvv VARCHAR(10),
  amount DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Sample data
-- users (3 sample rows)
INSERT INTO users (username, password, email, role) VALUES
('alice', '$2a$10$abcdefghijklmnopqrstuv', 'alice@example.com', 'patient'),
('bob', '$2a$10$abcdefghijklmnopqrstuv', 'bob@example.com', 'doctor'),
('admin', '$2a$10$abcdefghijklmnopqrstuv', 'admin@example.com', 'admin');

-- departments (3 sample rows)
INSERT INTO department (department_name, description) VALUES
('General Medicine', 'General health and outpatient services'),
('Pediatrics', 'Child health and pediatric services'),
('Cardiology', 'Heart and cardiovascular care');

-- doctors (3 sample rows)
INSERT INTO doctor (name, email, department_id, specialization, availability) VALUES
('Dr. Sunil Jayasinghe', 'sunil.j@example.com', 1, 'General Physician', 1),
('Dr. Malini Weerasinghe', 'malini.w@example.com', 2, 'Pediatrician', 1),
('Dr. Anura Dissanayake', 'anura.d@example.com', 3, 'Cardiologist', 1);

-- appointments (4 sample rows)
INSERT INTO appointment (patient_id, doctor_id, appointment_date, appointment_time, status) VALUES
(1, 1, '2024-08-01', '10:00:00', 'completed'),
(1, 2, '2024-08-02', '11:00:00', 'scheduled'),
(1, 3, '2024-07-15', '09:30:00', 'cancelled'),
(1, 1, '2024-06-22', '14:00:00', 'scheduled');

-- payments (3 sample rows)
INSERT INTO payments (patient_id, card_number, card_holder_name, expiry_date, cvv, amount) VALUES
(1, '4111111111111111', 'Alice Example', '12/2025', '123', 50.00),
(1, '5555555555554444', 'Alice Example', '11/2024', '321', 75.50),
(1, '4000056655665556', 'Alice Example', '09/2026', '999', 20.00);

-- Notes:
-- - The sample password values above are placeholder bcrypt-looking strings; replace with real hashed passwords for production.
-- - Do NOT store real card numbers or CVVs in production. Integrate with a payment gateway.
