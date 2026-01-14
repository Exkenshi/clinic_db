--创建缴费结算过程
DELIMITER //

CREATE PROCEDURE FrontDesk_Visit_Payment(
    IN p_visit_id INT,
    IN p_total_amount DECIMAL(10,2),
    IN p_insurance_amount DECIMAL(10,2),
    IN p_self_pay_amount DECIMAL(10,2)
)
BEGIN
    DECLARE v_status VARCHAR(20);

    SELECT status INTO v_status
    FROM Visit
    WHERE visit_id = p_visit_id;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '就诊记录不存在';
    END IF;

    IF v_status = '已离院' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '该就诊已完成缴费';
    END IF;

    INSERT INTO Payment(
        visit_id, total_amount, insurance_amount, self_pay_amount
    )
    VALUES (
        p_visit_id, p_total_amount, p_insurance_amount, p_self_pay_amount
    );

    UPDATE Visit
    SET status = '已离院'
    WHERE visit_id = p_visit_id;
END;
//

DELIMITER ;
