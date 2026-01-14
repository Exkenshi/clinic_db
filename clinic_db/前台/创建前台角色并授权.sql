--创建角色
CREATE ROLE IF NOT EXISTS frontdesk_role;

--授权
GRANT SELECT ON FrontDesk_Patient_Summary_View TO frontdesk_role;
GRANT SELECT ON FrontDesk_Income_Report_View TO frontdesk_role;

GRANT EXECUTE ON PROCEDURE FrontDesk_Visit_Payment TO frontdesk_role;
GRANT EXECUTE ON PROCEDURE Patient_Visit_Register TO frontdesk_role;

GRANT SELECT, UPDATE ON Visit TO frontdesk_role;
GRANT INSERT ON Payment TO frontdesk_role;
