
-- 存储过程 1: 医生排班
DELIMITER //

DROP PROCEDURE IF EXISTS Admin_Add_Schedule;

CREATE PROCEDURE Admin_Add_Schedule(
    IN p_doctor_name VARCHAR(50),   -- 输入: 医生姓名
    IN p_room_number VARCHAR(20),   -- 输入: 诊室号
    IN p_work_date DATE,            -- 输入: 排班日期
    IN p_time_slot VARCHAR(50)      -- 输入: 时间段
)
BEGIN
    DECLARE v_doctor_id INT;
    DECLARE v_room_id INT;
    DECLARE v_count INT; -- 用于记录冲突数量

    -- 1. 获取 ID
    SELECT doctor_id INTO v_doctor_id FROM Doctor WHERE name = p_doctor_name LIMIT 1;
    SELECT room_id INTO v_room_id FROM ClinicRoom WHERE room_number = p_room_number LIMIT 1;

    -- 2. 基础校验：医生和诊室是否存在
    IF v_doctor_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误：未找到该姓名的医生';
    ELSEIF v_room_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误：未找到该编号的诊室';
    ELSE
        SELECT COUNT(*) INTO v_count 
        FROM Doctor_Schedule 
        WHERE doctor_id = v_doctor_id 
          AND work_date = p_work_date 
          AND time_slot = p_time_slot;

        IF v_count > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误';
        ELSE
            INSERT INTO Doctor_Schedule (doctor_id, room_id, work_date, time_slot)
            VALUES (v_doctor_id, v_room_id, p_work_date, p_time_slot);
        END IF;
    END IF;
END;
//

DELIMITER ;
-- 存储过程 2: 综合搜索患者
CREATE PROCEDURE Admin_Search_Patient(
    IN p_keyword VARCHAR(50)
)
BEGIN
    SELECT * FROM Admin_Patient_Detail_View
    WHERE patient_name LIKE CONCAT('%', p_keyword, '%')
       OR patient_phone LIKE CONCAT('%', p_keyword, '%')
       OR id_card LIKE CONCAT('%', p_keyword, '%');
END;
//

DELIMITER ;
-- 存储过程 3: 账单查询：
-- 3.1 账单查询：按日期统计
CREATE PROCEDURE Admin_Stat_Bill_By_Date(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT report_date, SUM(visit_count) as total_visits, SUM(total_revenue) as total_income
    FROM Admin_Bill_Stats_View
    WHERE report_date BETWEEN p_start_date AND p_end_date
    GROUP BY report_date;
END;
//

-- 3.2 账单查询：按科室统计
CREATE PROCEDURE Admin_Stat_Bill_By_Dept(
    IN p_dept_name VARCHAR(50) -- 如果传空字符串或NULL，则查所有科室
)
BEGIN
    SELECT dept_name, SUM(visit_count) as total_visits, SUM(total_revenue) as total_income
    FROM Admin_Bill_Stats_View
    WHERE (p_dept_name IS NULL OR p_dept_name = '' OR dept_name = p_dept_name)
    GROUP BY dept_name;
END;
//

-- 3.3 账单查询：按医生统计
CREATE PROCEDURE Admin_Stat_Bill_By_Doctor(
    IN p_doctor_name VARCHAR(50)
)
BEGIN
    SELECT doctor_name, SUM(visit_count) as total_visits, SUM(total_revenue) as total_income
    FROM Admin_Bill_Stats_View
    WHERE doctor_name LIKE CONCAT('%', p_doctor_name, '%')
    GROUP BY doctor_name;
END;
//


DELIMITER ;

-- 存储过程4：排班信息修改
DELIMITER //

CREATE PROCEDURE Admin_Update_Schedule(
    IN p_schedule_id INT,             -- 必填: 要修改的排班ID
    IN p_new_doctor_name VARCHAR(50), -- 选填: 换医生 
    IN p_new_room_number VARCHAR(20), -- 选填: 换诊室 
    IN p_new_work_date DATE,          -- 选填: 改日期 
    IN p_new_time_slot VARCHAR(50)    -- 选填: 改时间段 
)
BEGIN
    DECLARE v_doctor_id INT;
    DECLARE v_room_id INT;
    DECLARE v_old_doctor_id INT;
    DECLARE v_old_room_id INT;

    -- 1. 检查排班是否存在，并获取旧值
    SELECT doctor_id, room_id INTO v_old_doctor_id, v_old_room_id
    FROM Doctor_Schedule WHERE schedule_id = p_schedule_id;

    IF v_old_doctor_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误：找不到该排班记录';
    END IF;

    -- 2. 处理医生 ID
    IF p_new_doctor_name IS NOT NULL THEN
        SELECT doctor_id INTO v_doctor_id FROM Doctor WHERE name = p_new_doctor_name LIMIT 1;
        IF v_doctor_id IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误：找不到该姓名的医生';
        END IF;
    ELSE
        SET v_doctor_id = v_old_doctor_id;
    END IF;

    -- 3. 处理诊室 ID 
    IF p_new_room_number IS NOT NULL THEN
        SELECT room_id INTO v_room_id FROM ClinicRoom WHERE room_number = p_new_room_number LIMIT 1;
        IF v_room_id IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误：找不到该编号的诊室';
        END IF;
    ELSE
        SET v_room_id = v_old_room_id;
    END IF;

    -- 4. 执行更新
    UPDATE Doctor_Schedule
    SET 
        doctor_id = v_doctor_id,
        room_id   = v_room_id,
        work_date = IFNULL(p_new_work_date, work_date),
        time_slot = IFNULL(p_new_time_slot, time_slot)
    WHERE schedule_id = p_schedule_id;

END;
//
DELIMITER ;

DELIMITER //


-- 存储过程5: 增添新诊室
CREATE PROCEDURE Admin_Add_ClinicRoom(
    IN p_room_number VARCHAR(20),  -- 输入: 新诊室号
    IN p_dept_name VARCHAR(50)     -- 输入: 所属科室名称
)
BEGIN
    DECLARE v_dept_id INT;

    -- 1. 根据科室名查找科室ID
    SELECT dept_id INTO v_dept_id FROM Department WHERE dept_name = p_dept_name LIMIT 1;

    -- 2. 校验
    IF v_dept_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误';
    ELSE
        -- 3. 插入数据
        INSERT INTO ClinicRoom (room_number, dept_id)
        VALUES (p_room_number, v_dept_id);
    END IF;
END;
//
DELIMITER ;
DELIMITER //

-- 存储过程6: 增添新诊室

CREATE PROCEDURE Admin_Update_ClinicRoom(
    IN p_old_room_number VARCHAR(20),  -- 必填: 原诊室号
    IN p_new_room_number VARCHAR(20),  -- 选填: 新诊室号
    IN p_new_dept_name VARCHAR(50)     -- 选填: 新所属科室
)
BEGIN
    DECLARE v_room_id INT;
    DECLARE v_dept_id INT;

    -- 1. 找到诊室ID
    SELECT room_id INTO v_room_id FROM ClinicRoom WHERE room_number = p_old_room_number LIMIT 1;
    IF v_room_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误：未找到原诊室';
    END IF;

    -- 2. 如果要改科室，先查科室ID
    IF p_new_dept_name IS NOT NULL THEN
        SELECT dept_id INTO v_dept_id FROM Department WHERE dept_name = p_new_dept_name LIMIT 1;
        IF v_dept_id IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误：未找到该名称的科室';
        END IF;
    END IF;

    -- 3. 更新
    UPDATE ClinicRoom
    SET 
        room_number = IFNULL(p_new_room_number, room_number),
        dept_id     = IF(p_new_dept_name IS NOT NULL, v_dept_id, dept_id)
    WHERE room_id = v_room_id;

END;
//
DELIMITER ;
DELIMITER //

-- 存储过程7: 查询员工详细信息

CREATE PROCEDURE Admin_Search_Staff_Details(
    IN p_keyword VARCHAR(50) -- 输入: 搜索关键字 (例如 '张三', '医生', '内科')
)
BEGIN
    SELECT 
        s.staff_id,      -- 工号
        s.name,          -- 姓名
        s.role,          -- 岗位
        d.dept_name,     -- 所属科室
        s.phone,         -- 联系方式
        s.status         -- 工作状态
    FROM Staff s
    LEFT JOIN Department d ON s.dept_id = d.dept_id
    WHERE 
        (p_keyword IS NULL OR p_keyword = '')
        OR s.name LIKE CONCAT('%', p_keyword, '%')
        OR s.role LIKE CONCAT('%', p_keyword, '%')
        OR d.dept_name LIKE CONCAT('%', p_keyword, '%');
END;
//

DELIMITER ;
DELIMITER //

-- 存储过程8: 修改员工综合信息

CREATE PROCEDURE Admin_Modify_Staff_Info(
    IN p_name VARCHAR(50),          -- 必填: 员工姓名
    IN p_new_phone VARCHAR(20),     -- 选填: 新电话 
    IN p_new_dept_name VARCHAR(50), -- 选填: 新科室名称 
    IN p_new_status VARCHAR(10),    -- 选填: 新状态 '在职'/'离职' 
    IN p_new_title VARCHAR(50)      -- 选填: 新职称
)
BEGIN
    DECLARE v_staff_id INT;
    DECLARE v_role VARCHAR(10);
    DECLARE v_new_dept_id INT;
    DECLARE v_old_dept_id INT;

    -- 1. 检查员工是否存在，并获取当前角色和科室ID
    SELECT staff_id, role, dept_id INTO v_staff_id, v_role, v_old_dept_id
    FROM Staff 
    WHERE name = p_name 
    LIMIT 1;

    IF v_staff_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误';
    END IF;

    -- 2. 如果要修改科室，先根据科室名查找 ID
    IF p_new_dept_name IS NOT NULL THEN
        SELECT dept_id INTO v_new_dept_id FROM Department WHERE dept_name = p_new_dept_name LIMIT 1;
        
        IF v_new_dept_id IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '错误';
        END IF;
    ELSE
        SET v_new_dept_id = v_old_dept_id;
    END IF;

    -- 3. 更新 Staff 表 (通用信息)
    UPDATE Staff
    SET 
        phone   = IFNULL(p_new_phone, phone),
        dept_id = v_new_dept_id,
        status  = IFNULL(p_new_status, status)
    WHERE staff_id = v_staff_id;

    -- 4. 如果该员工是 "医生"，需要同步更新 Doctor 表
    IF v_role = '医生' THEN
        UPDATE Doctor
        SET 
            phone   = IFNULL(p_new_phone, phone),    -- 同步电话
            dept_id = v_new_dept_id,                 -- 同步科室
            title   = IFNULL(p_new_title, title)     -- 更新职称 
        WHERE name = p_name;
    END IF;

END;
//

DELIMITER ;