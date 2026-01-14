DROP TRIGGER IF EXISTS Appointment_Insert;
DELIMITER //

CREATE TRIGGER Appointment_Insert
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    -- 如果是患者角色，自助预约 → 自动绑定
    IF CURRENT_ROLE() = 'patient_role' THEN
        SET NEW.patient_id = (
            SELECT patient_id
            FROM Patient
            WHERE name = SUBSTRING_INDEX(CURRENT_USER(), '@', 1)
        );
    END IF;

    -- 如果是前台角色 → 必须显式指定 patient_id
    IF CURRENT_ROLE() = 'frontdesk_role' THEN
        IF NEW.patient_id IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '前台预约必须指定患者';
        END IF;
    END IF;
END;
//
DELIMITER ;
