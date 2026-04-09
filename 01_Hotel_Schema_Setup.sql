-- ============================================================
-- 01_Hotel_Schema_Setup.sql
-- Table creation and sample data insertion for Hotel System
-- ============================================================

-- Drop tables if they exist (for clean re-runs)
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;

-- ============================================================
-- TABLE CREATION
-- ============================================================

CREATE TABLE users (
    user_id        VARCHAR(50) PRIMARY KEY,
    name           VARCHAR(100),
    phone_number   VARCHAR(20),
    mail_id        VARCHAR(100),
    billing_address TEXT
);

CREATE TABLE items (
    item_id    VARCHAR(50) PRIMARY KEY,
    item_name  VARCHAR(100),
    item_rate  DECIMAL(10,2)
);

CREATE TABLE bookings (
    booking_id   VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME,
    room_no      VARCHAR(50),
    user_id      VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE booking_commercials (
    id            VARCHAR(50) PRIMARY KEY,
    booking_id    VARCHAR(50),
    bill_id       VARCHAR(50),
    bill_date     DATETIME,
    item_id       VARCHAR(50),
    item_quantity DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id)    REFERENCES items(item_id)
);

-- ============================================================
-- SAMPLE DATA INSERTION
-- ============================================================

INSERT INTO users VALUES
('21wrcxuy-67erfn', 'John Doe',   '9700000001', 'john.doe@example.com',  '10, Street A, City X'),
('u2-abc123-xyz99', 'Jane Smith', '9700000002', 'jane.smith@example.com','22, Street B, City Y'),
('u3-def456-mno88', 'Bob Raj',    '9700000003', 'bob.raj@example.com',   '33, Street C, City Z'),
('u4-ghi789-pqr77', 'Alice Kumar','9700000004', 'alice.k@example.com',   '44, Street D, City W');

INSERT INTO items VALUES
('itm-a9e8-q8fu',  'Tawa Paratha',    18.00),
('itm-a07vh-aer8', 'Mix Veg',         89.00),
('itm-w978-23u4',  'Masala Chai',     30.00),
('itm-b123-cd45',  'Butter Naan',     25.00),
('itm-c678-ef90',  'Paneer Tikka',   150.00),
('itm-d111-gh22',  'Dal Tadka',       80.00),
('itm-e333-ij44',  'Chicken Curry',  180.00),
('itm-f555-kl66',  'Fried Rice',     120.00);

INSERT INTO bookings VALUES
('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn'),
('bk-10f4g-86ik', '2021-10-05 09:00:00', 'rm-cjg0-bfskn', 'u2-abc123-xyz99'),
('bk-11h5j-77lm', '2021-10-15 14:30:00', 'rm-dhh1-cgtkn', 'u3-def456-mno88'),
('bk-12i6k-68no', '2021-11-02 11:00:00', 'rm-eii2-dhukn', '21wrcxuy-67erfn'),
('bk-13j7l-59pq', '2021-11-10 16:45:00', 'rm-fjj3-eivln', 'u4-ghi789-pqr77'),
('bk-14k8m-50rs', '2021-11-20 08:00:00', 'rm-gkk4-fjwmn', 'u2-abc123-xyz99'),
('bk-15l9n-41tu', '2021-12-01 10:00:00', 'rm-hll5-gkxnn', 'u3-def456-mno88'),
('bk-16m0o-32vw', '2021-09-23 07:36:48', 'rm-imm6-hlyno', '21wrcxuy-67erfn');

-- booking_commercials: id, booking_id, bill_id, bill_date, item_id, item_quantity
INSERT INTO booking_commercials VALUES
-- September booking (bk-09f3e-95hj) -> bill bl-0a87y-q340
('q34r-3q4o8-q34u', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu',  3),
('q3o4-ahf32-o2u4', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1),
('134l-oyfo8-3qk4', 'bk-09f3e-95hj', 'bl-34qhd-r7h8', '2021-09-23 12:05:37', 'itm-w978-23u4',  2),

-- October booking 1 (bk-10f4g-86ik) -> bl-oct1-0001
('oct1-row1-0001',  'bk-10f4g-86ik', 'bl-oct1-0001',  '2021-10-05 12:00:00', 'itm-b123-cd45',  5),
('oct1-row2-0002',  'bk-10f4g-86ik', 'bl-oct1-0001',  '2021-10-05 12:00:00', 'itm-c678-ef90',  3),
('oct1-row3-0003',  'bk-10f4g-86ik', 'bl-oct1-0001',  '2021-10-05 12:00:00', 'itm-d111-gh22',  4),

-- October booking 2 (bk-11h5j-77lm) -> bl-oct2-0002 (total > 1000)
('oct2-row1-0004',  'bk-11h5j-77lm', 'bl-oct2-0002',  '2021-10-15 15:00:00', 'itm-e333-ij44',  4),
('oct2-row2-0005',  'bk-11h5j-77lm', 'bl-oct2-0002',  '2021-10-15 15:00:00', 'itm-f555-kl66',  5),

-- November booking 1 (bk-12i6k-68no)
('nov1-row1-0006',  'bk-12i6k-68no', 'bl-nov1-0003',  '2021-11-02 13:00:00', 'itm-a9e8-q8fu',  2),
('nov1-row2-0007',  'bk-12i6k-68no', 'bl-nov1-0003',  '2021-11-02 13:00:00', 'itm-c678-ef90',  2),
('nov1-row3-0008',  'bk-12i6k-68no', 'bl-nov1-0003',  '2021-11-02 13:00:00', 'itm-e333-ij44',  3),

-- November booking 2 (bk-13j7l-59pq)
('nov2-row1-0009',  'bk-13j7l-59pq', 'bl-nov2-0004',  '2021-11-10 17:00:00', 'itm-b123-cd45',  3),
('nov2-row2-0010',  'bk-13j7l-59pq', 'bl-nov2-0004',  '2021-11-10 17:00:00', 'itm-d111-gh22',  2),
('nov2-row3-0011',  'bk-13j7l-59pq', 'bl-nov2-0004',  '2021-11-10 17:00:00', 'itm-f555-kl66',  4),

-- November booking 3 (bk-14k8m-50rs)
('nov3-row1-0012',  'bk-14k8m-50rs', 'bl-nov3-0005',  '2021-11-20 09:00:00', 'itm-a07vh-aer8', 5),
('nov3-row2-0013',  'bk-14k8m-50rs', 'bl-nov3-0005',  '2021-11-20 09:00:00', 'itm-c678-ef90',  4),

-- December booking (bk-15l9n-41tu)
('dec1-row1-0014',  'bk-15l9n-41tu', 'bl-dec1-0006',  '2021-12-01 11:00:00', 'itm-w978-23u4',  3),
('dec1-row2-0015',  'bk-15l9n-41tu', 'bl-dec1-0006',  '2021-12-01 11:00:00', 'itm-e333-ij44',  2),

-- Another September booking (bk-16m0o-32vw)
('sep2-row1-0016',  'bk-16m0o-32vw', 'bl-sep2-0007',  '2021-09-23 08:00:00', 'itm-a9e8-q8fu',  10),
('sep2-row2-0017',  'bk-16m0o-32vw', 'bl-sep2-0007',  '2021-09-23 08:00:00', 'itm-f555-kl66',  6);
