-- 验证预约列表显示
-- 前台查看患者预约信息
SELECT a.appointment_id, p.name AS patient_name, a.phone, d.dept_name, a.expected_time, a.status
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
JOIN Department d ON a.dept_id = d.dept_id;

-- 验证到院登记生成Visit
-- 前台到院登记时，Visit记录是否正确生成
SELECT v.visit_id, p.name AS patient_name, d.name AS doctor_name,
       c.room_number, v.visit_time, v.status
FROM Visit v
JOIN Patient p ON v.patient_id = p.patient_id
JOIN Doctor d ON v.doctor_id = d.doctor_id
JOIN ClinicRoom c ON v.room_id = c.room_id;

-- 验证病历录入功能
-- 前台医生填写病历是否与Visit关联正确
SELECT mr.record_id, p.name AS patient_name, mr.diagnosis, mr.treatment
FROM Medical_Record mr
JOIN Visit v ON mr.visit_id = v.visit_id
JOIN Patient p ON v.patient_id = p.patient_id;

-- 验证缴费功能
-- 前台缴费是否正确生成支付记录
SELECT pay.payment_id, p.name AS patient_name, pay.total_amount, pay.insurance_amount, pay.self_pay_amount, pay.pay_time
FROM Payment pay
JOIN Visit v ON pay.visit_id = v.visit_id
JOIN Patient p ON v.patient_id = p.patient_id;

-- 验证预约状态自动更新
-- 前台到院完成后，预约状态应更新为已完成
-- 模拟更新一个预约状态
UPDATE Appointment
SET status = '已完成'
WHERE appointment_id = 1;

-- 查看更新结果
SELECT a.appointment_id, p.name AS patient_name, a.status
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id;

-- 验证医生排班显示
-- 前台排班查询功能
SELECT ds.schedule_id, d.name AS doctor_name, c.room_number, ds.work_date, ds.time_slot
FROM Doctor_Schedule ds
JOIN Doctor d ON ds.doctor_id = d.doctor_id
JOIN ClinicRoom c ON ds.room_id = c.room_id;

-- 验证员工查询功能
-- 前台员工管理或选择医生/护士列表
SELECT staff_id, name, role, dept_id, status
FROM Staff
WHERE role = '医生';

SELECT staff_id, name, role, dept_id, status
FROM Staff
WHERE role = '护士';
