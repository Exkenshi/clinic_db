--创建前台模块触发器

--防止重复缴费
DELIMITER //

CREATE TRIGGER trg_fd_no_duplicate_payment
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Payment
        WHERE visit_id = NEW.visit_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '禁止重复缴费';
    END IF;
END;
//

DELIMITER ;

--已出院的无法修改
DELIMITER //

CREATE TRIGGER trg_fd_lock_visit
BEFORE UPDATE ON Visit
FOR EACH ROW
BEGIN
    IF OLD.status = '已出院' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '已出院记录不可修改';
    END IF;
END;
//

DELIMITER ;
