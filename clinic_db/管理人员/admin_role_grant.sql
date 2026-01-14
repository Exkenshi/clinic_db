-- 创建管理人员角色
CREATE ROLE admin_role;
-- 1. 排班管理权限
GRANT SELECT ON Admin_Schedule_View TO admin_role;
-- 允许对排班表进行增删改
GRANT SELECT, INSERT, UPDATE, DELETE ON Doctor_Schedule TO admin_role;
-- 允许对诊室信息进行维护
GRANT SELECT, INSERT, UPDATE ON ClinicRoom TO admin_role;
-- 2. 账单查询权限
GRANT SELECT ON Admin_Bill_Stats_View TO admin_role;
-- 3. 患者信息查询权限
GRANT SELECT ON Admin_Patient_Detail_View TO admin_role;
-- 允许直接查询基础表以支持灵活的 WHERE 子句筛选
GRANT SELECT ON Patient TO admin_role;
GRANT SELECT ON Visit TO admin_role;
GRANT SELECT ON Medical_Record TO admin_role;
-- 4. 员工管理权限
GRANT SELECT ON Admin_Staff_View TO admin_role;
GRANT SELECT, INSERT, UPDATE ON Staff TO admin_role;
GRANT SELECT, UPDATE ON Doctor TO admin_role;
-- 5. 基础字典表权限
GRANT SELECT ON Department TO admin_role;
-- 6.授予管理员角色执行存储过程的权限
GRANT EXECUTE ON PROCEDURE Admin_Add_Schedule TO admin_role;
GRANT EXECUTE ON PROCEDURE Admin_Stat_Bill_By_Date TO admin_role;
GRANT EXECUTE ON PROCEDURE Admin_Stat_Bill_By_Dept TO admin_role;
GRANT EXECUTE ON PROCEDURE Admin_Stat_Bill_By_Doctor TO admin_role;
GRANT EXECUTE ON PROCEDURE Admin_Search_Patient_Details TO admin_role;
GRANT EXECUTE ON PROCEDURE Admin_Search_Patient TO admin_role;
GRANT EXECUTE ON PROCEDURE Admin_Update_Schedule TO admin_role;
GRANT EXECUTE ON PROCEDURE Admin_Update_ClinicRoom TO admin_role;
GRANT EXECUTE ON PROCEDURE Admin_Add_ClinicRoom TO admin_role;
GRANT EXECUTE ON PROCEDURE Admin_Search_Staff_Details TO admin_role;