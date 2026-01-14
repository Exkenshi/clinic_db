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

SELECT
    v.visit_id,
    p.name        AS patient_name,
    c.room_number,
    v.status,
    v.visit_time
FROM Visit v
JOIN Patient p    ON v.patient_id = p.patient_id
JOIN ClinicRoom c ON v.room_id = c.room_id
ORDER BY v.visit_id;

SELECT
    a.appointment_id,
    p.name AS patient_name,
    d.dept_name,
    a.status
FROM Appointment a
JOIN Patient p    ON a.patient_id = p.patient_id
JOIN Department d ON a.dept_id = d.dept_id
ORDER BY a.appointment_id;
