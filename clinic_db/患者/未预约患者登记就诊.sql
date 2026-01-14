CALL Patient_Visit_Register(
    '赵六',
    '男',
    '110101200001010099',
    '13800000999',
    1
);

SELECT
    patient_id,
    name,
    id_card,
    phone
FROM Patient
WHERE name = '赵六';

SELECT
    v.visit_id,
    p.name,
    v.room_id,
    v.status
FROM Visit v
JOIN Patient p ON v.patient_id = p.patient_id
WHERE p.name = '赵六';
