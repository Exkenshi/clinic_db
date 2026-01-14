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

SELECT
    a.appointment_id,
    p.name        AS patient_name,
    d.dept_name,
    a.expected_time,
    a.status
FROM Appointment a
JOIN Patient p    ON a.patient_id = p.patient_id
JOIN Department d ON a.dept_id = d.dept_id
ORDER BY a.appointment_id;
