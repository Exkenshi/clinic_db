SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Payment;
TRUNCATE TABLE Medical_Record;
TRUNCATE TABLE Visit;
TRUNCATE TABLE Appointment;
TRUNCATE TABLE Doctor_Schedule;
TRUNCATE TABLE ClinicRoom;
TRUNCATE TABLE Doctor;
TRUNCATE TABLE Patient;
TRUNCATE TABLE Staff;
TRUNCATE TABLE Department;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO Department(dept_id, dept_name) VALUES
(1, '内科'),
(2, '外科'),
(3, '儿科');

INSERT INTO ClinicRoom(room_id, room_number, dept_id) VALUES
(1, '101', 1),
(2, '102', 2),
(3, '103', 3);

INSERT INTO Patient(patient_id, name, gender, age, id_card, phone) VALUES
(1, '张三', '男', 30, '110101199001010001', '13800000001'),
(2, '李四', '女', 25, '110101199601010002', '13800000002'),
(3, '王五', '男', 40, '110101198301010003', '13800000003');
