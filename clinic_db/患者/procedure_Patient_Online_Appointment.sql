DELIMITER //

CREATE PROCEDURE Patient_Online_Appointment(
    IN p_name VARCHAR(50),
    IN p_phone VARCHAR(20),
    IN p_dept_id INT,
    IN p_expected_time DATETIME
)
BEGIN
    DECLARE v_patient_id INT;
    
    -- 获取患者ID
    SELECT patient_id INTO v_patient_id
    FROM Patient
    WHERE name = p_name
    LIMIT 1;
    
    IF v_patient_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '患者不存在，请先到院登记';
    END IF;
    
    -- 插入预约
    INSERT INTO Appointment(patient_id, phone, dept_id, expected_time)
    VALUES(v_patient_id, p_phone, p_dept_id, p_expected_time);
END;
//

DELIMITER ;
