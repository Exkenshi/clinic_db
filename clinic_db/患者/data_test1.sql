-- =============================
-- 清空所有表数据（保留表结构）
-- =============================

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Payment;
TRUNCATE TABLE Medical_Record;
TRUNCATE TABLE Visit;
TRUNCATE TABLE Appointment;IF search_condition THEN
	statement_list
ELSE
	statement_list
END IF;

TRUNCATE TABLE Doctor_Schedule;
TRUNCATE TABLE ClinicRoom;
TRUNCATE TABLE Doctor;
TRUNCATE TABLE Patient;
TRUNCATE TABLE Staff;
TRUNCATE TABLE Department;

SET FOREIGN_KEY_CHECKS = 1;

/* =============================
   1. 部门数据 (Department)
   ============================= */
INSERT INTO Department(dept_id, dept_name) VALUES
(1, '内科'),
(2, '外科'),
(3, '儿科');

/* =============================
   2. 患者数据 (Patient)
   ============================= */
INSERT INTO Patient(patient_id, name, gender, age, id_card, phone) VALUES
(1, '张三', '男', 30, '110101199001010001', '13800000001'),
(2, '李四', '女', 25, '110101199601010002', '13800000002'),
(3, '王五', '男', 40, '110101198301010003', '13800000003');

/* =============================
   3. 医生数据 (Doctor)
   ============================= */
INSERT INTO Doctor(doctor_id, name, title, dept_id, phone) VALUES
(1, '赵医生', '主任医师', 1, '13900000001'),
(2, '钱医生', '副主任医师', 2, '13900000002'),
(3, '孙医生', '主治医师', 3, '13900000003');

/* =============================
   4. 诊室数据 (ClinicRoom)
   ============================= */
INSERT INTO ClinicRoom(room_id, room_number, dept_id) VALUES
(1, '101', 1),
(2, '102', 2),
(3, '103', 3);

/* =============================
   5. 医生排班 (Doctor_Schedule)
   ============================= */
INSERT INTO Doctor_Schedule(schedule_id, doctor_id, room_id, work_date, time_slot) VALUES
(1, 1, 1, '2026-01-13', '08:00-12:00'),
(2, 2, 2, '2026-01-13', '08:00-12:00'),
(3, 3, 3, '2026-01-13', '13:00-17:00');

/* =================================================
   6. 阶段一：线上预约（调用存储过程）
   ================================================= */
CALL Patient_Online_Appointment(
    '张三',
    '13800000001',
    1,
    '2026-01-13 08:30:00'
);

CALL Patient_Online_Appointment(
    '李四',
    '13800000002',
    2,
    '2026-01-13 09:00:00'
);

CALL Patient_Online_Appointment(
    '王五',
    '13800000003',
    3,
    '2026-01-13 10:00:00'
);

/* =================================================
   查询一：线上预约完成后的结果
   ================================================= */
SELECT
    appointment_id,
    patient_id,
    dept_id,
    expected_time,
    status
FROM Appointment
ORDER BY appointment_id;


/* =================================================
   7. 阶段二：到院登记（调用存储过程）
   ================================================= */
CALL Patient_Visit_Register(
    '张三',
    '男',
    '110101199001010001',
    '13800000001',
    1
);

CALL Patient_Visit_Register(
    '李四',
    '女',
    '110101199601010002',
    '13800000002',
    2
);

CALL Patient_Visit_Register(
    '王五',
    '男',
    '110101198301010003',
    '13800000003',
    3
);

/* =================================================
   查询二：到院登记后的就诊记录
   （Visit 表不包含 appointment_id）
   ================================================= */
SELECT
    visit_id,
    patient_id,
    room_id,
    status,
    visit_time
FROM Visit
ORDER BY visit_id;


/* =================================================
   查询三：到院后的预约状态变化
   ================================================= */
SELECT
    appointment_id,
    patient_id,
    status
FROM Appointment
ORDER BY appointment_id;


/* =============================
   8. 病历数据 (Medical_Record)
   ============================= */
INSERT INTO Medical_Record(record_id, visit_id, diagnosis, treatment) VALUES
(1, 1, '感冒', '休息+多喝水'),
(2, 2, '扭伤', '冰敷+休息'),
(3, 3, '发热', '退烧药+观察');

/* =============================
   9. 缴费数据 (Payment)
   ============================= */
INSERT INTO Payment(payment_id, visit_id, total_amount, insurance_amount, self_pay_amount) VALUES
(1, 1, 200.00, 50.00, 150.00),
(2, 2, 500.00, 200.00, 300.00),
(3, 3, 300.00, 100.00, 200.00);

/* =============================
   10. 员工数据 (Staff)
   ============================= */
INSERT INTO Staff(staff_id, name, role, dept_id, phone) VALUES
(1, '张护士', '护士', 1, '13700000001'),
(2, '李行政', '行政', 2, '13700000002'),
(3, '王护士', '护士', 3, '13700000003');
