CREATE ROLE patient_role;

-- 患者信息
GRANT SELECT, UPDATE(phone) ON Patient_View TO patient_role;

-- 预约信息
GRANT SELECT, INSERT, DELETE ON Appointment_View TO patient_role;

-- 查看就诊记录
GRANT SELECT ON Visit_View TO patient_role;

-- 查看病历
GRANT SELECT ON Medical_Record_View TO patient_role;

-- 查看缴费
GRANT SELECT ON Payment_View TO patient_role;
