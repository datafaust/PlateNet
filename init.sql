CREATE DATABASE platenet;
USE platenet;
SET SQL_SAFE_UPDATES = 0;
CREATE TABLE IF NOT EXISTS plates_recorded(
     plate VARCHAR(100),
     time_stamp DATETIME
     );

CREATE TABLE IF NOT EXISTS plate_data(
      plate VARCHAR(100)
      violation_id INT,
      time_stamp DATETIME
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

INSERT INTO platenet.plate_data
    (plate,violation_id,time_stamp)
VALUES
    ('MH01AV8866',1,'2019-01-01 12:01:23'),
    ('MH01AV8866',2,'2019-07-01 18:07:10'),
    ('BALENO',1,'2019-02-01 15:14:10'),
    ('BALENO',2,'2019-03-01 04:04:04'),
    ('HR26BP3543',1,'2019-12-01 16:07:10'),
    ('HR26BP3543',2,'2019-10-01 16:07:10'),
    ('HR26BP3543',3,'2019-06-01 16:07:10')