--创建患者简略信息视图
CREATE OR REPLACE VIEW FrontDesk_Patient_Summary_View AS
SELECT
    p.patient_id,
    p.name AS patient_name,
    d.dept_name,
    c.room_number,
    v.status AS visit_status,
    v.visit_time
FROM Visit v
JOIN Patient p ON v.patient_id = p.patient_id
JOIN ClinicRoom c ON v.room_id = c.room_id
JOIN Department d ON c.dept_id = d.dept_id;

--创建收费报表视图
CREATE OR REPLACE VIEW FrontDesk_Income_Report_View AS
SELECT
    DATE(pay_time) AS income_date,
    COUNT(payment_id) AS visit_count,
    SUM(total_amount) AS total_income,
    SUM(insurance_amount) AS insurance_income,
    SUM(self_pay_amount) AS self_pay_income
FROM Payment
GROUP BY DATE(pay_time);

--验证视图存在
SELECT * FROM FrontDesk_Patient_Summary_View;
SELECT * FROM FrontDesk_Income_Report_View;