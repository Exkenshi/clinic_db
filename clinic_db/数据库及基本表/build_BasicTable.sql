-- 患者基本信息表
CREATE TABLE Patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY, -- 患者唯一编号
    name VARCHAR(50) NOT NULL,                  -- 患者姓名
    gender ENUM('男','女') NOT NULL,            -- 患者性别
    age INT NOT NULL,                           -- 患者年龄
    id_card VARCHAR(18) UNIQUE NOT NULL,        -- 身份证号码
    phone VARCHAR(20) NOT NULL,                 -- 联系电话
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- 建档时间
);

-- 医院科室信息表
CREATE TABLE Department (
    dept_id INT AUTO_INCREMENT PRIMARY KEY, -- 科室编号
    dept_name VARCHAR(50) NOT NULL UNIQUE   -- 科室名称
);

-- 医生基本信息表
CREATE TABLE Doctor (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY, -- 医生编号
    name VARCHAR(50) NOT NULL,                 -- 医生姓名
    title VARCHAR(50),                         -- 职称
    dept_id INT,                               -- 所属科室
    phone VARCHAR(20),                         -- 联系电话
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- 医院诊室信息表
CREATE TABLE ClinicRoom (
    room_id INT AUTO_INCREMENT PRIMARY KEY, -- 诊室编号
    room_number VARCHAR(20) NOT NULL UNIQUE,-- 诊室号
    dept_id INT,                            -- 所属科室
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- 医生排班信息表
CREATE TABLE Doctor_Schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY, -- 排班编号
    doctor_id INT,                              -- 医生编号
    room_id INT,                                -- 诊室编号
    work_date DATE,                             -- 排班日期
    time_slot VARCHAR(50),                      -- 接诊时间段
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (room_id) REFERENCES ClinicRoom(room_id)
);

-- 患者预约挂号信息表
CREATE TABLE Appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY, -- 预约编号
    patient_id INT,                                -- 患者编号
    phone VARCHAR(20),                             -- 联系电话
    dept_id INT,                                   -- 预约科室
    expected_time DATETIME,                        -- 预约时间
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,-- 预约创建时间（修复：把CURRENT_DATE改成CURRENT_TIMESTAMP）
    status ENUM('未到院','已完成','已取消') DEFAULT '未到院', -- 预约状态
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- 患者现场就诊登记表
CREATE TABLE Visit (
    visit_id INT AUTO_INCREMENT PRIMARY KEY, -- 就诊记录编号
    patient_id INT,                          -- 患者编号
    doctor_id INT,                           -- 接诊医生编号
    room_id INT,                             -- 诊室编号
    visit_time DATETIME DEFAULT CURRENT_TIMESTAMP, -- 登记时间
    status ENUM('就诊中','已完成','已离院') DEFAULT '就诊中', -- 就诊状态
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (room_id) REFERENCES ClinicRoom(room_id)
);

-- 患者病历信息表
CREATE TABLE Medical_Record (
    record_id INT AUTO_INCREMENT PRIMARY KEY, -- 病历编号
    visit_id INT,                             -- 对应就诊记录
    diagnosis TEXT,                           -- 诊断结果
    treatment TEXT,                           -- 治疗方案
    FOREIGN KEY (visit_id) REFERENCES Visit(visit_id)
);

CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY, -- 缴费编号
    visit_id INT,                              -- 就诊编号
    total_amount DECIMAL(10,2),                -- 总费用
    insurance_amount DECIMAL(10,2),            -- 医保报销
    self_pay_amount DECIMAL(10,2),             -- 自费金额
    pay_time DATETIME DEFAULT CURRENT_TIMESTAMP, -- 缴费时间
    FOREIGN KEY(visit_id) REFERENCES Visit(visit_id) -- 修复：visit 改为 Visit（和表名一致）
);

-- 医院员工信息表
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY, -- 员工编号
    name VARCHAR(50),                        -- 员工姓名
    role ENUM('医生','护士','行政'),         -- 岗位
    dept_id INT,                             -- 所属科室
    phone VARCHAR(20),                       -- 联系方式
    status ENUM('在职','离职') DEFAULT '在职',-- 工作状态
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);
