-- https://stackoverflow.com/questions/37680461/how-to-store-mysql-trigger-exception-failure-info-into-table-or-in-variables/37853801#37853801  
USE platenet;
-- inserts data from staging to production
DROP PROCEDURE IF EXISTS platenet.insertPrdData;
DELIMITER $$
CREATE PROCEDURE platenet.insertPrdData()
	
    BEGIN
    -- Declare variables to hold diagnostics area information
    -- DECLARE errorCode CHAR(5) DEFAULT '00000';
    -- DECLARE errorMessage TEXT DEFAULT '';

    -- Declare exception handler for failed insert
    -- DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    
 
INSERT IGNORE INTO plate_data_prd
     SELECT
     concat(plate,summons_number) as unique_id,
     plate,
     state,
     license_type,
     summons_number,
     cast(concat(issue_date, ' ', violation_time) as datetime) as violation_datetime,
     violation,
     judgment_entry_date,
     fine_amount,
     penalty_amount,
     interest_amount,
     reduction_amount,
     payment_amount,
     amount_due,
     precinct,
     CASE WHEN county in ('NY', 'MN') THEN 'Manhattan'
          WHEN county = 'BX' THEN 'Bronx'
          WHEN county in ('K','BK') THEN 'Brooklyn'
          WHEN county in ('ST', 'R') THEN 'Staten Island'
          ELSE 'Other'
          END as county,
     issuing_agency,
     violation_status,
     summons_image
     FROM
     plate_data_stg;
-- Check whether the insert was successful
    -- IF errorCode != '00000' THEN
     --   INSERT INTO `errors` (code, message, query_type, record_id, on_db, on_table) VALUES (errorCode, errorMessage, 'insert', NEW.id, 'test_db2', 'users');
    -- END IF;
	END$$
DELIMITER ;


-- deletes data from staging
DROP PROCEDURE IF EXISTS platenet.deleteStgData;
DELIMITER $$
CREATE PROCEDURE deleteStgData()
BEGIN

-- Declare variables to hold diagnostics area information
     -- DECLARE errorCode CHAR(5) DEFAULT '00000';
     -- DECLARE errorMessage TEXT DEFAULT '';

    -- Declare exception handler for failed insert
     -- DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 

    SET SQL_SAFE_UPDATES = 0;
	DELETE FROM plate_data_stg;

    -- Check whether the insert was successful
     -- IF errorCode != '00000' THEN
        -- INSERT INTO `errors` (code, message, query_type, record_id, on_db, on_table) VALUES (errorCode, errorMessage, 'insert', NEW.id, 'test_db2', 'users');
     -- END IF;
END$$
DELIMITER ;


