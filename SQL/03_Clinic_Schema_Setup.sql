-- ============================================================
-- 03_Clinic_Schema_Setup.sql
-- Table creation and sample data insertion for Clinic System
-- ============================================================

DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS clinics;

-- ============================================================
-- TABLE CREATION
-- ============================================================

CREATE TABLE clinics (
    cid         VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city        VARCHAR(100),
    state       VARCHAR(100),
    country     VARCHAR(100)
);

CREATE TABLE customer (
    uid    VARCHAR(50) PRIMARY KEY,
    name   VARCHAR(100),
    mobile VARCHAR(20)
);

CREATE TABLE clinic_sales (
    oid          VARCHAR(50) PRIMARY KEY,
    uid          VARCHAR(50),
    cid          VARCHAR(50),
    amount       DECIMAL(12,2),
    datetime     DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid         VARCHAR(50) PRIMARY KEY,
    cid         VARCHAR(50),
    description VARCHAR(200),
    amount      DECIMAL(12,2),
    datetime    DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

INSERT INTO clinics VALUES
('cnc-0100001', 'HealthFirst Clinic',  'Mumbai',    'Maharashtra', 'India'),
('cnc-0100002', 'CureCare Clinic',     'Pune',      'Maharashtra', 'India'),
('cnc-0100003', 'MedLife Clinic',      'Hyderabad', 'Telangana',   'India'),
('cnc-0100004', 'WellBeing Clinic',    'Hyderabad', 'Telangana',   'India'),
('cnc-0100005', 'QuickHeal Clinic',    'Bengaluru', 'Karnataka',   'India'),
('cnc-0100006', 'CityHealth Clinic',   'Bengaluru', 'Karnataka',   'India');

INSERT INTO customer VALUES
('cust-001', 'Jon Doe',      '9700000001'),
('cust-002', 'Priya Sharma', '9700000002'),
('cust-003', 'Rahul Mehta',  '9700000003'),
('cust-004', 'Anita Nair',   '9700000004'),
('cust-005', 'Suresh Babu',  '9700000005');

-- clinic_sales: various months of 2021, multiple channels
INSERT INTO clinic_sales VALUES
('ord-001', 'cust-001', 'cnc-0100001', 24999, '2021-01-10 10:00:00', 'online'),
('ord-002', 'cust-002', 'cnc-0100001', 15000, '2021-01-15 11:00:00', 'walkin'),
('ord-003', 'cust-003', 'cnc-0100002', 8000,  '2021-01-20 09:00:00', 'online'),
('ord-004', 'cust-004', 'cnc-0100003', 30000, '2021-02-05 14:00:00', 'referral'),
('ord-005', 'cust-005', 'cnc-0100003', 12000, '2021-02-12 15:30:00', 'walkin'),
('ord-006', 'cust-001', 'cnc-0100004', 5000,  '2021-02-18 16:00:00', 'online'),
('ord-007', 'cust-002', 'cnc-0100001', 20000, '2021-03-01 10:00:00', 'online'),
('ord-008', 'cust-003', 'cnc-0100005', 18000, '2021-03-10 11:00:00', 'referral'),
('ord-009', 'cust-004', 'cnc-0100005', 22000, '2021-03-22 13:00:00', 'walkin'),
('ord-010', 'cust-005', 'cnc-0100006', 9500,  '2021-04-01 09:00:00', 'online'),
('ord-011', 'cust-001', 'cnc-0100001', 35000, '2021-04-15 10:00:00', 'walkin'),
('ord-012', 'cust-002', 'cnc-0100002', 11000, '2021-05-05 12:00:00', 'online'),
('ord-013', 'cust-003', 'cnc-0100003', 27000, '2021-05-20 14:00:00', 'referral'),
('ord-014', 'cust-004', 'cnc-0100004', 14000, '2021-06-10 10:00:00', 'walkin'),
('ord-015', 'cust-005', 'cnc-0100001', 42000, '2021-06-25 15:00:00', 'online'),
('ord-016', 'cust-001', 'cnc-0100006', 7000,  '2021-07-05 09:00:00', 'walkin'),
('ord-017', 'cust-002', 'cnc-0100005', 19000, '2021-07-18 11:00:00', 'online'),
('ord-018', 'cust-003', 'cnc-0100001', 50000, '2021-08-01 14:00:00', 'referral'),
('ord-019', 'cust-004', 'cnc-0100002', 16000, '2021-08-20 10:00:00', 'online'),
('ord-020', 'cust-005', 'cnc-0100003', 23000, '2021-09-05 12:00:00', 'walkin'),
('ord-021', 'cust-001', 'cnc-0100004', 31000, '2021-09-18 13:00:00', 'online'),
('ord-022', 'cust-002', 'cnc-0100005', 8500,  '2021-10-02 09:00:00', 'referral'),
('ord-023', 'cust-003', 'cnc-0100006', 17000, '2021-10-15 11:00:00', 'walkin'),
('ord-024', 'cust-004', 'cnc-0100001', 28000, '2021-11-01 10:00:00', 'online'),
('ord-025', 'cust-005', 'cnc-0100002', 13000, '2021-11-20 14:00:00', 'walkin'),
('ord-026', 'cust-001', 'cnc-0100003', 45000, '2021-12-05 15:00:00', 'referral'),
('ord-027', 'cust-002', 'cnc-0100004', 6000,  '2021-12-18 09:00:00', 'online');

-- expenses for clinics
INSERT INTO expenses VALUES
('exp-001', 'cnc-0100001', 'medical supplies',   5000,  '2021-01-05 08:00:00'),
('exp-002', 'cnc-0100001', 'staff salaries',     30000, '2021-01-31 00:00:00'),
('exp-003', 'cnc-0100002', 'rent',               15000, '2021-01-01 00:00:00'),
('exp-004', 'cnc-0100003', 'equipment repair',   8000,  '2021-02-10 09:00:00'),
('exp-005', 'cnc-0100003', 'staff salaries',     25000, '2021-02-28 00:00:00'),
('exp-006', 'cnc-0100004', 'utilities',          3000,  '2021-02-15 00:00:00'),
('exp-007', 'cnc-0100001', 'medical supplies',   4500,  '2021-03-05 08:00:00'),
('exp-008', 'cnc-0100005', 'rent',               18000, '2021-03-01 00:00:00'),
('exp-009', 'cnc-0100005', 'staff salaries',     20000, '2021-03-31 00:00:00'),
('exp-010', 'cnc-0100006', 'utilities',          2500,  '2021-04-10 00:00:00'),
('exp-011', 'cnc-0100001', 'staff salaries',     30000, '2021-04-30 00:00:00'),
('exp-012', 'cnc-0100002', 'medical supplies',   6000,  '2021-05-12 08:00:00'),
('exp-013', 'cnc-0100003', 'equipment purchase', 40000, '2021-05-20 00:00:00'),
('exp-014', 'cnc-0100004', 'rent',               12000, '2021-06-01 00:00:00'),
('exp-015', 'cnc-0100001', 'medical supplies',   5500,  '2021-06-15 08:00:00'),
('exp-016', 'cnc-0100006', 'staff salaries',     22000, '2021-07-31 00:00:00'),
('exp-017', 'cnc-0100005', 'utilities',          3500,  '2021-07-15 00:00:00'),
('exp-018', 'cnc-0100001', 'staff salaries',     30000, '2021-08-31 00:00:00'),
('exp-019', 'cnc-0100002', 'rent',               15000, '2021-08-01 00:00:00'),
('exp-020', 'cnc-0100003', 'medical supplies',   7000,  '2021-09-10 08:00:00'),
('exp-021', 'cnc-0100004', 'staff salaries',     18000, '2021-09-30 00:00:00'),
('exp-022', 'cnc-0100005', 'equipment repair',   5000,  '2021-10-05 09:00:00'),
('exp-023', 'cnc-0100006', 'utilities',          2800,  '2021-10-20 00:00:00'),
('exp-024', 'cnc-0100001', 'medical supplies',   6000,  '2021-11-08 08:00:00'),
('exp-025', 'cnc-0100002', 'staff salaries',     20000, '2021-11-30 00:00:00'),
('exp-026', 'cnc-0100003', 'rent',               14000, '2021-12-01 00:00:00'),
('exp-027', 'cnc-0100004', 'utilities',          3200,  '2021-12-15 00:00:00');
