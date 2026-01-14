-- 查看各表记录数量
SELECT 'Patient', COUNT(*) FROM Patient;
SELECT 'Department', COUNT(*) FROM Department;
SELECT 'Doctor', COUNT(*) FROM Doctor;
SELECT 'ClinicRoom', COUNT(*) FROM ClinicRoom;
SELECT 'Doctor_Schedule', COUNT(*) FROM Doctor_Schedule;
SELECT 'Appointment', COUNT(*) FROM Appointment;
SELECT 'Visit', COUNT(*) FROM Visit;
SELECT 'Medical_Record', COUNT(*) FROM Medical_Record;
SELECT 'Payment', COUNT(*) FROM Payment;
SELECT 'Staff', COUNT(*) FROM Staff;

-- 验证 Appointment 与 Patient 的关联
SELECT a.appointment_id, p.name, a.status 
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id;

-- 验证 Visit 与 Doctor/ClinicRoom 的关联
SELECT v.visit_id, p.name AS patient_name, d.name AS doctor_name, c.room_number, v.status
FROM Visit v
JOIN Patient p ON v.patient_id = p.patient_id
JOIN Doctor d ON v.doctor_id = d.doctor_id
JOIN ClinicRoom c ON v.room_id = c.room_id;

-- 验证病历与就诊记录
SELECT m.record_id, v.visit_id, m.diagnosis, m.treatment
FROM Medical_Record m
JOIN Visit v ON m.visit_id = v.visit_id;

-- 验证缴费记录与就诊记录
SELECT pay.payment_id, v.visit_id, pay.total_amount, pay.self_pay_amount
FROM Payment pay
JOIN Visit v ON pay.visit_id = v.visit_id;

-- 验证医生排班
SELECT s.schedule_id, d.name AS doctor_name, c.room_number, s.work_date, s.time_slot
FROM Doctor_Schedule s
JOIN Doctor d ON s.doctor_id = d.doctor_id
JOIN ClinicRoom c ON s.room_id = c.room_id;
