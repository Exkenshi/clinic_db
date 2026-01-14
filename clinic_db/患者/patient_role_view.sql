-- Patient 信息视图
CREATE VIEW Patient_View AS
SELECT patient_id, name, gender, age, id_card, phone, created_at
FROM Patient
WHERE name = CURRENT_USER();

-- Appointment 视图
CREATE VIEW Appointment_View AS
SELECT appointment_id, patient_id, dept_id, expected_time, status, create_time, phone
FROM Appointment
WHERE patient_id = (SELECT patient_id FROM Patient WHERE name = CURRENT_USER());

-- Visit 视图
CREATE VIEW Visit_View AS
SELECT visit_id, patient_id, doctor_id, room_id, visit_time, status
FROM Visit
WHERE patient_id = (SELECT patient_id FROM Patient WHERE name = CURRENT_USER());


-- Medical_Record 视图
CREATE VIEW Medical_Record_View AS
SELECT record_id, visit_id, diagnosis, treatment
FROM Medical_Record
WHERE visit_id IN (
    SELECT visit_id 
    FROM Visit 
    WHERE patient_id = (SELECT patient_id FROM Patient WHERE name = CURRENT_USER())
);


-- Payment 视图
CREATE VIEW Payment_View AS
SELECT payment_id, visit_id, total_amount, insurance_amount, self_pay_amount, pay_time
FROM Payment
WHERE visit_id IN (
    SELECT visit_id 
    FROM Visit 
    WHERE patient_id = (SELECT patient_id FROM Patient WHERE name = CURRENT_USER())
);
