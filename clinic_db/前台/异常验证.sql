--异常验证

--重复缴费测试
CALL FrontDesk_Visit_Payment(1, 100, 50, 50);--报错则禁止重复缴费

--已离院测试不可修改
UPDATE Visit SET status='就诊中' WHERE visit_id=1;