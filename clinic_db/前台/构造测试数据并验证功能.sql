--构造一个测试数据
CALL Patient_Visit_Register(
    '李四','男','440101199202021234',
    '13900000000',1,1
);

--验证功能

--查看待收费患者
SELECT * FROM FrontDesk_Patient_Summary_View
WHERE visit_status = '就诊中';

--缴费
CALL FrontDesk_Visit_Payment(1, 150.00, 90.00, 60.00);

--验证
SELECT * FROM Payment;
SELECT status FROM Visit WHERE visit_id = 1;--如果结果为“已出院”则成功
