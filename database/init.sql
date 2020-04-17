CREATE DATABASE platenet;
USE platenet;
SET SQL_SAFE_UPDATES = 0;

ALTER USER 'root' IDENTIFIED WITH mysql_native_password BY 'password';
flush privileges;


CREATE TABLE IF NOT EXISTS plates_recorded(
     plate VARCHAR(100),
     time_stamp DATETIME,
     lat float,
     lon float
     );

CREATE TABLE IF NOT EXISTS plate_data_stg (
     plate VARCHAR(100),
     state VARCHAR(100),
     license_type VARCHAR(100),
     summons_number VARCHAR(10),
     issue_date DATE,
     violation_time VARCHAR(10),
     violation VARCHAR(100),
     judgment_entry_date DATE,
     fine_amount FLOAT,
     penalty_amount FLOAT,
     interest_amount FLOAT,
     reduction_amount FLOAT,
     payment_amount FLOAT,
     amount_due FLOAT,
     precinct INT(3),
     county VARCHAR(2),
     issuing_agency VARCHAR(100),
     violation_status VARCHAR(100),
     summons_image VARCHAR(2083)
     );

CREATE TABLE IF NOT EXISTS plate_data_prd (
     unique_id VARCHAR(100) PRIMARY KEY,
     plate VARCHAR(100),
     state VARCHAR(100),
     license_type VARCHAR(100),
     summons_number VARCHAR(10),
     violation_datetime DATETIME,
     violation VARCHAR(100),
     judgment_entry_date DATE,
     fine_amount FLOAT,
     penalty_amount FLOAT,
     interest_amount FLOAT,
     reduction_amount FLOAT,
     payment_amount FLOAT,
     amount_due FLOAT,
     precinct INT(3),
     county VARCHAR(2),
     issuing_agency VARCHAR(100),
     violation_status VARCHAR(100),
     summons_image VARCHAR(2083)
     );

CREATE TABLE IF NOT EXISTS errors (
     id int(11) AUTO_INCREMENT NOT NULL,
     code varchar(30) NOT NULL,
     message TEXT NOT NULL,
     query_type varchar(50) NOT NULL,
     record_id int(11) NOT NULL,
     on_db varchar(50) NOT NULL,
     on_table varchar(50) NOT NULL,
     emailed TINYINT DEFAULT 0,
     created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
     PRIMARY KEY (id)
);

