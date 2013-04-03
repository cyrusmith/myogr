ALTER TABLE  `ibf_members`
ADD  `is_verified` TINYINT( 1 ) DEFAULT 0,
ADD  `verification_code` VARCHAR( 32 ) NOT NULL ,
ADD  `verification_code_sent` INT NOT NULL ,
ADD INDEX (  `is_verified` );
