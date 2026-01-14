-- 1. 财务统计视图
CREATE VIEW Admin_Bill_Stats_View AS
SELECT 
    DATE(Payment.pay_time) AS report_date,          -- 统计日期
    Department.dept_name,                           -- 科室名称
    Doctor.name AS doctor_name,                     -- 医生姓名
    COUNT(Visit.visit_id) AS visit_count,           -- 就诊人次
    SUM(Payment.total_amount) AS total_revenue      -- 总收入
FROM Payment
JOIN Visit ON Payment.visit_id = Visit.visit_id
JOIN Doctor ON Visit.doctor_id = Doctor.doctor_id
JOIN Department ON Doctor.dept_id = Department.dept_id
GROUP BY DATE(Payment.pay_time), Department.dept_name, Doctor.name;

-- 2. 患者详细信息视图
CREATE VIEW Admin_Patient_Detail_View AS
SELECT 
    Patient.patient_id,
    Patient.name AS patient_name,
    Patient.id_card,
    Patient.phone AS patient_phone,
    Visit.visit_time,
    ClinicRoom.room_number,
    Department.dept_name,
    Doctor.name AS doctor_name,
    Medical_Record.diagnosis,
    Medical_Record.treatment,
    Visit.status AS visit_status
FROM Patient
LEFT JOIN Visit ON Patient.patient_id = Visit.patient_id
LEFT JOIN ClinicRoom ON Visit.room_id = ClinicRoom.room_id
LEFT JOIN Department ON ClinicRoom.dept_id = Department.dept_id
LEFT JOIN Doctor ON Visit.doctor_id = Doctor.doctor_id
LEFT JOIN Medical_Record ON Visit.visit_id = Medical_Record.visit_id;

-- 3. 医生排班管理视图
CREATE VIEW Admin_Schedule_View AS
SELECT 
    Doctor_Schedule.schedule_id,
    Doctor_Schedule.work_date,
    Doctor_Schedule.time_slot,
    Doctor.name AS doctor_name,
    Doctor.title AS doctor_title,
    Department.dept_name,
    ClinicRoom.room_number,
    ClinicRoom.room_id,
    Doctor_Schedule.doctor_id
FROM Doctor_Schedule
JOIN Doctor ON Doctor_Schedule.doctor_id = Doctor.doctor_id
JOIN Department ON Doctor.dept_id = Department.dept_id
JOIN ClinicRoom ON Doctor_Schedule.room_id = ClinicRoom.room_id;

-- 4. 员工信息视图
CREATE VIEW Admin_Staff_View AS
SELECT 
    Staff.staff_id,
    Staff.name AS staff_name,
    Staff.role,
    Staff.phone,
    Staff.status,
    Department.dept_name
FROM Staff
LEFT JOIN Department ON Staff.dept_id = Department.dept_id;