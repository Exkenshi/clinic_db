DELIMITER //

CREATE DEFINER=`root`@`localhost` PROCEDURE `Patient_Visit_Register`(
    IN p_name VARCHAR(50),
    IN p_gender ENUM('男','女'),
    IN p_id_card VARCHAR(18),
    IN p_phone VARCHAR(20),
    IN p_clinic_room_id INT
)
BEGIN
    DECLARE v_patient_id INT;
    DECLARE v_appointment_id INT;
    DECLARE v_dept_id INT;

    /* 1. 获取诊室所属科室 */
    SELECT dept_id INTO v_dept_id
    FROM ClinicRoom
    WHERE room_id = p_clinic_room_id;

    IF v_dept_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '诊室不存在或未绑定科室';
    END IF;

    /* 2. 判断患者是否存在（按身份证） */
    SELECT patient_id INTO v_patient_id
    FROM Patient
    WHERE id_card = p_id_card
    LIMIT 1;

    IF v_patient_id IS NULL THEN
        -- 新患者
        INSERT INTO Patient(name, gender, id_card, phone, age)
        VALUES(p_name, p_gender, p_id_card, p_phone, 0);
        SET v_patient_id = LAST_INSERT_ID();
    ELSE
        -- 老患者更新电话
        UPDATE Patient
        SET phone = p_phone
        WHERE patient_id = v_patient_id;
    END IF;

    /* 3. 查找该患者同科室的“未到院”预约 */
    SELECT appointment_id INTO v_appointment_id
    FROM Appointment
    WHERE patient_id = v_patient_id
      AND status = '未到院'
      AND dept_id = v_dept_id
    ORDER BY expected_time
    LIMIT 1;

    /* 4. 如果存在预约 → 更新预约状态为已完成 */
    IF v_appointment_id IS NOT NULL THEN
        UPDATE Appointment
        SET status = '已完成'
        WHERE appointment_id = v_appointment_id
          AND status = '未到院';
    END IF;

    /* 5. 插入到院就诊记录（不存 appointment_id） */
    INSERT INTO Visit(
        patient_id,
        doctor_id,
        room_id,
        visit_time,
        status
    )
    VALUES(
        v_patient_id,
        NULL,
        p_clinic_room_id,
        NOW(),
        '就诊中'
    );

END;
//

DELIMITER ;
