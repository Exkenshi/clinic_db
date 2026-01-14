DELIMITER //

CREATE TRIGGER Patient_Update BEFORE UPDATE ON Patient
FOR EACH ROW
BEGIN
    -- 只能修改自己的记录
    IF OLD.name <> CURRENT_USER() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '只能修改自己的信息';
    END IF;

    -- 姓名、性别、年龄、身份证不可修改
    IF OLD.name <> NEW.name OR OLD.gender <> NEW.gender OR OLD.age <> NEW.age OR OLD.id_card <> NEW.id_card THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '只能修改手机号，其他字段不可修改';
    END IF;

    -- phone 可修改，不需额外处理
END;
//

DELIMITER ;

DELIMITER //

CREATE TRIGGER Appointment_Insert BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    -- 强制绑定当前用户的 patient_id
    SET NEW.patient_id = (SELECT patient_id FROM Patient WHERE name = CURRENT_USER());
END;
//

DELIMITER ;
