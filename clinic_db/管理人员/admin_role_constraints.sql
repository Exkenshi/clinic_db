DELIMITER //

-- 触发器 1: 排班日期校验
CREATE TRIGGER Doctor_Schedule_Before_Insert BEFORE INSERT ON Doctor_Schedule
FOR EACH ROW
BEGIN
    IF NEW.work_date < CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误：排班日期不能早于当前日期';
    END IF;
END;
//

-- 触发器 2: 员工离职校验
CREATE TRIGGER Staff_Before_Update_Status BEFORE UPDATE ON Staff
FOR EACH ROW
BEGIN
    DECLARE future_schedule_count INT;
    DECLARE target_doctor_id INT;

    -- 只有当状态从'在职'改为'离职'，且角色为'医生'时执行检查
    IF OLD.status = '在职' AND NEW.status = '离职' AND OLD.role = '医生' THEN
        
        -- 尝试根据姓名在 Doctor 表中找到对应的 ID
        SELECT doctor_id INTO target_doctor_id FROM Doctor WHERE name = OLD.name LIMIT 1;
        
        IF target_doctor_id IS NOT NULL THEN
            -- 检查该医生在未来是否有排班
            SELECT COUNT(*) INTO future_schedule_count
            FROM Doctor_Schedule
            WHERE doctor_id = target_doctor_id AND work_date >= CURRENT_DATE;
            
            IF future_schedule_count > 0 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误：该医生尚有未来的排班计划，无法办理离职';
            END IF;
        END IF;
    END IF;
END;
//

DELIMITER ;