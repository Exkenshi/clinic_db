--验证性能并建立索引
--分析查询
EXPLAIN SELECT * FROM FrontDesk_Patient_Summary_View;

--建立索引
CREATE INDEX idx_visit_patient ON Visit(patient_id);
CREATE INDEX idx_payment_visit ON Payment(visit_id);
CREATE INDEX idx_payment_time ON Payment(pay_time);
