-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 16-04-2014 a las 03:29:33
-- Versión del servidor: 5.5.35
-- Versión de PHP: 5.3.10-1ubuntu3.10

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `ehcontrol`
--

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `addcommandprogram`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `addcommandprogram`( IN u VARCHAR(50), IN c VARCHAR(50), IN idpa INTEGER, IN n INTEGER)
    COMMENT 'add an acction to a command.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE ida, idu, idh, idc INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

end_proc:begin
	IF (u IS NULL OR c IS NULL OR idpa IS NULL OR n IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), USERS.IDUSER INTO num, idu
	FROM PROGRAMACTIONS, USERS
	WHERE IDPROGRAM = idpa AND PROGRAMACTIONS.IDUSER = USERS.IDUSER AND USERNAME = u;
	
	CASE num 
	WHEN 1 THEN
	
		SELECT COUNT(*), IDCOMMAND INTO num, idc
		FROM COMMANDS
		WHERE COMMANDNAME = c AND IDUSER = idu;
		
		CASE num
		WHEN 1 THEN
			SELECT COUNT(*) INTO num
			FROM COMMAND_PROGRAM
			WHERE IDCOMMAND = idc AND POS = n;
			
			CASE num
			WHEN 0 THEN
				IF (n > 0) THEN 
					INSERT INTO COMMAND_PROGRAM (IDCOMMAND, IDPROGRAM, POS) VALUE (idc, idpa, n);
					SET err = 56;
				ELSE
					SET err = 57;
				END IF;
			ELSE
				SET err = 55;
			END CASE;
		ELSE
			SET err = 60;
		END CASE;
	WHEN 0 THEN
		SET err = 33;
	ELSE
		SET err = 4;
	END CASE;
	
	SELECT IDHOUSE INTO idh
	FROM loginVIEW
	WHERE IDACTION = ida AND USERNAME = u;
end;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    idh,  IF(err = 56, 0, err),  28, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 56, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `addtaskprogram`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `addtaskprogram`( IN u VARCHAR(50), IN idta INTEGER,IN idpa INTEGER)
    COMMENT 'add an acction to a task.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE ida, idu, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

end_proc:begin
	IF (u IS NULL OR idta IS NULL OR idpa IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IDACTION, USERS.IDUSER INTO num, ida, idu
	FROM PROGRAMACTIONS, USERS
	WHERE IDPROGRAM = idpa AND PROGRAMACTIONS.IDUSER = USERS.IDUSER AND USERNAME = u;
	
	CASE num 
	WHEN 1 THEN
	
		SELECT COUNT(*) INTO num
		FROM TASKS
		WHERE IDTASK = idta AND IDUSER = idu;
		
		CASE num
		WHEN 1 THEN
			SELECT COUNT(*) INTO num
			FROM TASKPROGRAM
			WHERE IDTASK = idta AND IDPROGRAM = idpa;
			
			CASE num
			WHEN 0 THEN
				INSERT INTO TASKPROGRAM (IDTASK, IDPROGRAM) VALUE (idta, idpa);
				SET err = 34;
			ELSE
				SET err = 37;
			END CASE;
		ELSE
			SET err = 32;
		END CASE;
	WHEN 0 THEN
		SET err = 33;
	ELSE
		SET err = 4;
	END CASE;
	
	SELECT IDHOUSE INTO idh
	FROM loginVIEW 
	WHERE IDACTION = ida AND IDUSER = idu;
end;
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    idh,  IF(err = 34, 0, err),  21, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 34, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `createaccesshouse`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `createaccesshouse`( IN u VARCHAR(50), IN h VARCHAR(50), IN u2 VARCHAR(50), IN n INTEGER)
    COMMENT 'An admistrator grant access somobody to a house.'
begin

	DECLARE num,acc INTEGER DEFAULT 0;
	DECLARE idu, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

end_proc:begin
	IF (u IS NULL OR h IS NULL OR u2 IS NULL OR n IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), IDUSER, IDHOUSE INTO num, acc, idu, idh
	FROM loginVIEW
	WHERE USERNAME = u AND HOUSENAME = h;
			
	CASE num 
	WHEN 1 THEN 
		CASE acc
		WHEN 1 THEN 
			SELECT COUNT(*), IDUSER INTO num, idu 
			FROM USERS
			WHERE USERNAME = u2;

			IF (num <> 0) THEN 
				DELETE FROM ACCESSHOUSE WHERE IDUSER=idu AND IDHOUSE = idh;
				INSERT INTO ACCESSHOUSE (IDUSER, IDHOUSE, ACCESSNUMBER, DATEBEGIN) VALUES
										(idu,    idh, n, CURRENT_TIMESTAMP);
				SET err = 40;
			ELSE
				SET err = 3;
			END IF;
		WHEN 0 THEN
			SET err = 11;
		ELSE
			SET err = 39;
		END CASE;
	WHEN 0 THEN
		SET err = 11;
	ELSE
		SET err = 4;
	END CASE;
end;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 40, 0, err),  24, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 40, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `createcommand`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `createcommand`( IN u VARCHAR(50), IN c VARCHAR(50))
    COMMENT 'Create a new command (conjunto de mandatos)'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

end_proc:begin
	IF (u IS NULL OR c IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

    SELECT COUNT(*), IDUSER INTO num, idu
	FROM USERS
	WHERE USERNAME = u;
			
	CASE num 
	WHEN 1 THEN 
		SELECT COUNT(*) INTO num
		FROM COMMANDS
		WHERE COMMANDNAME = c AND IDUSER = idu;

		CASE num
		WHEN 0 THEN
			INSERT INTO COMMANDS (IDCOMMAND, COMMANDNAME, IDUSER) VALUES
								(NULL, c, idu);
			SET err = 52; 
		ELSE
			SET err = 51;
		END CASE;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;
end;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    NULL,  IF(err = 52, 0, err),  26, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 52, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `createdevice`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `createdevice`( IN u VARCHAR(50), IN ip VARCHAR(500), IN s VARCHAR(50), IN d VARCHAR(50))
    COMMENT 'Create a new device.'
begin

	DECLARE num, v INTEGER DEFAULT 0;
	DECLARE idu, idd, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

end_proc:begin
	IF (u IS NULL OR d IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IDUSER INTO num, idu
	FROM USERS
	WHERE USERNAME = u;
			
	CASE num 
	WHEN 1 THEN 
			SELECT COUNT(*), IDDEVICE INTO num, idd
			FROM DEVICES
			WHERE SERIAL = s AND IPADDRESS = ip;
				
			CASE num
			WHEN 0 THEN 
				SELECT COUNT(*),VERSION INTO num, v
				FROM DEVICES
				WHERE DEVICENAME = d AND IDUSER IS NULL AND IPADDRESS IS NULL AND SERIAL IS NULL;
				
				CASE num 
				WHEN 1 THEN
					INSERT INTO DEVICES (IDDEVICE, IDUSER, IPADDRESS, SERIAL, DEVICENAME, ENGLISH, SPANISH, `DATE`, VERSION) VALUES 
										(NULL,   idu,    ip,    s,   d,   NULL,   NULL,   CURRENT_TIMESTAMP,   v);
					SET err = 49;
				ELSE
					SET err = 48;
				END CASE;
			ELSE
				SET err = 47;
			END CASE;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;
end;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 49, 0, err),  25, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 49, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `createhouse`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `createhouse`( IN u VARCHAR(50), IN h VARCHAR(50), IN c VARCHAR(50), IN ctry VARCHAR(50))
    COMMENT 'Create a new house if not exist.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

end_proc:begin
	IF (u IS NULL OR h IS NULL OR c IS NULL OR ctry IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IDUSER INTO num, idu
	FROM USERS
	WHERE USERNAME = u;
			
	CASE num 
	WHEN 1 THEN 
			SELECT COUNT(*), IDHOUSE INTO num, idh
			FROM HOUSES
			WHERE HOUSENAME = h;
				
			CASE num
			WHEN 0 THEN 
				INSERT INTO HOUSES  (IDHOUSE, IDUSER, HOUSENAME, IDIMAGE, CITY, COUNTRY, GPS, DATEBEGIN) VALUES
									(null, idu, h,NULL, c, ctry ,NULL,CURRENT_TIMESTAMP);
				SELECT IDHOUSE INTO idh
				FROM HOUSES
				WHERE HOUSENAME = h;
				
				INSERT INTO ACCESSHOUSE (IDUSER, IDHOUSE, ACCESSNUMBER, DATEBEGIN) VALUES
										(idu,    idh, 1, CURRENT_TIMESTAMP);
				SET err = 17;
			WHEN 1 THEN
				SET err = 22;
			ELSE
				SET err = 4;
			END CASE;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;
end;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 17, 0, err),  7, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 17, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `createprogramaction`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `createprogramaction`( IN u VARCHAR(50), IN h VARCHAR(50),IN r VARCHAR(50),IN s VARCHAR(50), IN a VARCHAR(50),IN dat VARCHAR(50), IN t timestamp, IN d timestamp)
    COMMENT 'Program an action to be done.'
begin
	DECLARE num, acc INTEGER DEFAULT 0;
	DECLARE ida, idu, idh, ids INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;
	
end_proc:begin
	IF (u IS NULL OR h IS NULL OR r IS NULL OR s IS NULL OR a IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IDACTION, IDSERVICE, IDHOUSE INTO num, ida, ids, idh
	FROM houseRoomServiceActionVIEW
	WHERE HOUSENAME = h AND ROOMNAME = r AND SERVICENAME = s AND ACTIONNAME = a; 
	
	CASE num  
	WHEN 1 THEN  
			SELECT COUNT(*), IDUSER, IFNULL(ACCESSNUMBER, 0) INTO num, idu, acc 
			FROM loginVIEW
			WHERE USERNAME = u AND IDHOUSE = idh ;
			
			CASE num
			WHEN 0 THEN
				SET err = 11; 
			ELSE
				CASE acc
				WHEN 1 THEN
					INSERT INTO `PROGRAMACTIONS` (`IDPROGRAM`, `IDUSER`, `IDACTION`, `DATA`, `STARTTIME`, `DATEBEGIN`)
										 VALUES (NULL, idu, ida, dat, t, d);
					SET err = 27;
				ELSE
					SELECT COUNT(*), IFNULL(PERMISSIONNUMBER, 0) INTO num, acc 
					FROM PERMISSIONS
					WHERE IDUSER = idu AND IDSERVICE= ids ;
					
					CASE acc
					WHEN 1 THEN
						INSERT INTO `PROGRAMACTIONS` (`IDPROGRAM`, `IDUSER`, `IDACTION`, `DATA`, `STARTTIME`, `DATEBEGIN`) 
										VALUES 		 (NULL, idu, ida, dat, t, d);
						SET err = 27;
					ELSE
						SET err = 10;
					END CASE;
				END CASE;
			END CASE;
	WHEN 0 THEN
		SET err = 21;
	ELSE
		SET err = 4;
	END CASE;
end;

	SELECT IDHOUSE INTO  idh
	FROM HOUSES
	WHERE HOUSENAME = h;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    idh,  IF(err = 27, 0, err),  14, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 27, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `createroom`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `createroom`( IN u VARCHAR(50), IN h VARCHAR(50), IN r VARCHAR(50))
    COMMENT 'Create a new room if not exist.'
begin

	DECLARE num, acc INTEGER DEFAULT 0;
	DECLARE idu, idh, idr INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

end_proc:begin
	IF (u IS NULL OR h IS NULL OR r IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), IDUSER, IDHOUSE INTO num, acc, idu, idh
	FROM loginVIEW
	WHERE USERNAME = u AND HOUSENAME = h;
			
	CASE num 
	WHEN 1 THEN 
		CASE acc
		WHEN 1 THEN 
			SELECT COUNT(*) INTO num
			FROM ROOMS
			WHERE ROOMNAME = r AND IDHOUSE = idh;
				
			CASE num
			WHEN 0 THEN 
				INSERT INTO ROOMS  (IDROOM, IDHOUSE, IDUSER, ROOMNAME, DATEBEGIN) VALUES
									(null, idh, idu, r, CURRENT_TIMESTAMP);
				SET err = 44;
			WHEN 1 THEN
				SET err = 43;
			ELSE
				SET err = 4;
			END CASE;
		WHEN 0 THEN
			SET err = 11;
		ELSE
			SET err = 39;
		END CASE;
			
	WHEN 0 THEN
		SET err = 11;
	ELSE
		SET err = 4;
	END CASE;
end;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 44, 0, err),  17, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 44, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `createtask`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `createtask`( IN u VARCHAR(50), IN ta VARCHAR(50),IN des VARCHAR(50),IN fre timestamp)
    COMMENT 'Create a task, will group programaction.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;
	
end_proc:begin
	IF (u IS NULL OR ta IS NULL) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IDUSER INTO num, idu
	FROM USERS
	WHERE USERNAME = u;
	
	CASE num 
	WHEN 1 THEN 
		SELECT COUNT(*) INTO num
		FROM TASKS
		WHERE IDUSER = idu AND TASKNAME = ta;
		
		CASE num 
		WHEN 0 THEN 
			INSERT INTO `TASKS` (`IDTASK`, `TASKNAME`, `IDUSER`, `DESCRIPTION`, ` FREQUENCY`, `DATEBEGIN`) 
					VALUES	(NULL, ta, idu, des, fre, CURRENT_TIMESTAMP);
			SET err = 29;
		WHEN 1 THEN 
			SET err = 24;
		ELSE
			SET err = 4;
		END CASE;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;
end;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    null,  IF(err = 29, 0, err),  11, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 29, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `createuser`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `createuser`( IN u VARCHAR(50), IN p VARCHAR(50), IN mail VARCHAR(50), h VARCHAR(50))
    COMMENT 'Create a new user if username not exist and email have not an account yet.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

end_proc:begin
	IF (u IS NULL OR p IS NULL OR mail IS NULL OR h IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

        SELECT COUNT(*), IDUSER INTO num, idu
	FROM USERS
	WHERE USERNAME = u;
			
	CASE num 
	WHEN 0 THEN 
			SELECT COUNT(*) INTO num
			FROM USERS
			WHERE EMAIL = mail ;

			CASE num
			WHEN 0 THEN 
				INSERT INTO `USERS` (`IDUSER`, `USERNAME`, `PASSWORD`, `EMAIL`, `HINT`, `DATEBEGIN`) VALUES
									(NULL, u, p, mail, h, CURRENT_TIMESTAMP);

                               SELECT IDUSER INTO  idu
	                       FROM USERS
	                       WHERE USERNAME = u;

				SET err = 13;
			WHEN 1 THEN

                               SELECT IDUSER INTO  idu
	                       FROM USERS
	                       WHERE EMAIL = mail;

				SET err = 7; 
			ELSE
				SET err = 4;
			END CASE;
	WHEN 1 THEN
		SET err = 6;
	ELSE
		SET err = 4;
	END CASE;
end;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    NULL,  IF(err = 13, 0, err),  3, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 13, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `deleteaccesshouse`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `deleteaccesshouse`( IN u VARCHAR(50), IN h VARCHAR(50), IN u2 VARCHAR(50))
    COMMENT 'Delete the access to a house of an user.'
begin

	DECLARE num,acc INTEGER DEFAULT 0;
	DECLARE idu, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

end_proc:begin
	IF (u IS NULL OR h IS NULL OR u2 IS NULL) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), IDUSER, IDHOUSE INTO num, acc, idu, idh
	FROM loginVIEW
	WHERE USERNAME = u AND HOUSENAME = h;
			
	CASE num 
	WHEN 1 THEN 
		CASE acc
		WHEN 1 THEN 
			SELECT COUNT(*), IDUSER INTO num, idu
			FROM USERS
			WHERE USERNAME = u2;

			IF (num <> 0) THEN 
				DELETE FROM ACCESSHOUSE WHERE IDUSER=idu AND IDHOUSE = idh;
				SET err = 41;
			ELSE
				SET err = 3;
			END IF;
		WHEN 0 THEN
			SET err = 11;
		ELSE
			SET err = 39;
		END CASE;
	WHEN 0 THEN
		SET err = 11;
	ELSE
		SET err = 4;
	END CASE;
end;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 41, 0, err),  24, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 41, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `deletecommand`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `deletecommand`( IN u VARCHAR(50), IN c VARCHAR(50))
    COMMENT 'Delete a command from an user (conjunto de mandatos)'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

end_proc:begin
	IF (u IS NULL OR c IS NULL OR idpa IS NULL OR n IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

    SELECT COUNT(*), IDUSER INTO num, idu
	FROM USERS
	WHERE USERNAME = u;
			
	CASE num 
	WHEN 1 THEN 
		SELECT COUNT(*) INTO num
		FROM COMMANDS
		WHERE COMMANDNAME = c AND IDUSER = idu;

		CASE num
		WHEN 1 THEN
			DELETE FROM COMMANDS WHERE COMMANDNAME = c AND IDUSER = idu;
			SET err = 54; 
		ELSE
			SET err = 53;
		END CASE;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;
end;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    NULL,  IF(err = 54, 0, err),  27, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 54, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `deletedevice`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `deletedevice`( IN u VARCHAR(50),IN p VARCHAR(50), IN idd INTEGER)
    COMMENT 'Delete a device.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu INTEGER DEFAULT NULL;  
	DECLARE err INTEGER DEFAULT 0; 
	DECLARE pass VARCHAR(50); 

end_proc:begin
	IF (u IS NULL OR p IS NULL OR idd IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IDUSER, PASSWORD INTO num, idu, pass
	FROM USERS
	WHERE USERNAME = u;
			 
	CASE num 
	WHEN 1 THEN 
		IF (pass = p) THEN
			SELECT COUNT(*) INTO num
			FROM DEVICES
			WHERE IDUSER = idu AND IDDEVICE = idd;
			
			CASE num 
			WHEN 1 THEN 
				DELETE FROM DEVICES WHERE IDDEVICE = idd;
				
				SET err = 62;
			ELSE
				SET err = 39;
			END CASE;
		ELSE
			SET err = 2;
		END IF;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;
end;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   NULL,  IF(err = 62, 0, err),  30, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 62, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `deletehouse`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `deletehouse`( IN u VARCHAR(50),IN p VARCHAR(50), IN h VARCHAR(50))
    COMMENT 'Delete a house if exist and the user is an administrator.'
begin

	DECLARE num, acc INTEGER DEFAULT 0;
	DECLARE idu, idh INTEGER DEFAULT NULL;  
	DECLARE err INTEGER DEFAULT 0; 
	DECLARE pass VARCHAR(50); 

end_proc:begin
	IF (u IS NULL OR p IS NULL OR h IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), IDUSER, IDHOUSE, PASSWORD INTO num, acc, idu, idh, pass
	FROM loginVIEW
	WHERE USERNAME = u AND HOUSENAME = h;
			 
	CASE num 
	WHEN 1 THEN 
		CASE acc
		WHEN 1 THEN 
			IF (pass = p) THEN
				DELETE FROM HOUSES WHERE IDHOUSE= idh;
				SET err = 19;
			ELSE
				SET err = 2;
			END IF;
		WHEN 0 THEN
			SET err = 11;
		ELSE
			SET err = 39;
		END CASE;
	WHEN 0 THEN
		SET err = 11;
	ELSE
		SET err = 4;
	END CASE;
end;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 19, 0, err),  9, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 19, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `deleteprogramaction`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `deleteprogramaction`( IN u VARCHAR(50), IN idpa INTEGER)
    COMMENT 'Delete program action.'
begin
	DECLARE num, acc, per INTEGER DEFAULT 0;
	DECLARE ida, idu, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;
	
end_proc:begin
	IF (u IS NULL OR idpa IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IFNULL(IDACTION, 0) INTO num, ida
	FROM PROGRAMACTIONS
	WHERE IDPROGRAM = idpa ;
	
	CASE num 
	WHEN 1 THEN
		SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), IDUSER, IDHOUSE,PERMISSIONNUMBER INTO num, acc, idu, idh, per
		FROM loginVIEW
		WHERE IDACTION = ida AND USERNAME = u;
	
		CASE num
		WHEN 1 THEN
			CASE acc
			WHEN 1 THEN 
				DELETE FROM PROGRAMACTIONS WHERE IDPROGRAM= idpa;
				SET err = 28;
			WHEN 0 THEN
				SET err = 11;
			ELSE
				
				CASE num
				WHEN 1 THEN
					CASE per
					WHEN 1 THEN
						DELETE FROM PROGRAMACTIONS WHERE IDPROGRAM= idpa;
						SET err = 28;
					ELSE
						SET err = 10;
					END CASE;
				ELSE
					SET err = 10;
				END CASE;
			END CASE;
		ELSE
			SET err = 11;
		END CASE;
	ELSE 
		SET err = 21;
	END CASE;
end;	

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    idh,  IF(err = 28, 0, err),  15, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 28, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `deleteroom`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `deleteroom`( IN u VARCHAR(50),IN p VARCHAR(50), IN h VARCHAR(50), IN r VARCHAR(50))
    COMMENT 'Delete a room if exist.'
begin

	DECLARE num, acc INTEGER DEFAULT 0;
	DECLARE idu, idh, idr INTEGER DEFAULT NULL;  
	DECLARE err INTEGER DEFAULT 0; 
	DECLARE pass VARCHAR(50); 

end_proc:begin
	IF (u IS NULL OR h IS NULL OR r IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), IDUSER, IDHOUSE, IDROOM, PASSWORD INTO num, acc, idu, idh, idr, pass
	FROM loginVIEW
	WHERE USERNAME = u AND HOUSENAME = h AND ROOMNAME = r;
			 
	CASE num 
	WHEN 1 THEN 
		CASE acc
		WHEN 1 THEN 
			IF (pass = p) THEN
				DELETE FROM ROOMS WHERE IDROOM = idr;
				SET err = 45;
			ELSE
				SET err = 2;
			END IF;
		WHEN 0 THEN
			SET err = 11;
		ELSE
			SET err = 39;
		END CASE;
	WHEN 0 THEN
		SET err = 46;
	ELSE
		SET err = 4;
	END CASE;
end;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 45, 0, err),  18, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 45, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `deletetask`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `deletetask`( IN u VARCHAR(50), IN ta VARCHAR(50))
    COMMENT 'Delete a user task.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu, idta INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;
	
end_proc:begin
	IF (u IS NULL OR ta IS NULL) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IDUSER INTO num, idu
	FROM USERS
	WHERE USERNAME = u;
	
	CASE num 
	WHEN 1 THEN 
		SELECT COUNT(*), IDTASK INTO num, idta
		FROM TASKS
		WHERE IDUSER = idu AND TASKNAME = ta;
		
		CASE num 
		WHEN 1 THEN 
			DELETE FROM TASKPROGRAM WHERE IDTASK = idta;
			DELETE FROM TASKS WHERE IDTASK = idta;
			SET err = 30;
		WHEN 0 THEN 
			SET err = 31;
		ELSE
			SET err = 4;
		END CASE;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;
end;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    null,  IF(err = 30, 0, err),  12, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 30, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `deleteuser`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `deleteuser`( IN u VARCHAR(50), IN p VARCHAR(50))
    COMMENT 'Delete user if posible by deleting all information restring.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;
	DECLARE pass VARCHAR(50);

end_proc:begin
	IF (u IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;
	
	SELECT COUNT(*), IDUSER, PASSWORD INTO num , idu, pass
	FROM USERS
	WHERE USERNAME = u;
			
	CASE num 
	WHEN 1 THEN 
			IF (pass = p) THEN 
				DELETE FROM `USERS` WHERE IDUSER = idu;
				SET err = 14;
			ELSE 
				SET err = 2;
			END IF;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;
end;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,   idu,    NULL,  IF(err = 14, 0, err),  4, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 14, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `loginJSON`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `loginJSON`( in u VARCHAR(50))
begin

SELECT *
	FROM  loginVIEW
	WHERE USERNAME = u ;

end$$

DROP PROCEDURE IF EXISTS `modifyhouse`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `modifyhouse`( IN u VARCHAR(50), IN h VARCHAR(50), IN n_h VARCHAR(50), IN idim INTEGER, IN c VARCHAR(50), IN ctry VARCHAR(50))
    COMMENT 'Modify house information.'
begin

	DECLARE num, acc INTEGER DEFAULT 0;
	DECLARE idu, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

end_proc:begin
	IF (u IS NULL OR h IS NULL OR n_h IS NULL) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), IDUSER, IDHOUSE INTO num, acc, idu, idh
	FROM loginVIEW
	WHERE USERNAME = u AND HOUSENAME = h;
			
	CASE num 
	WHEN 1 THEN 
		CASE acc
		WHEN 1 THEN 
SELECT COUNT(*) INTO num
				FROM HOUSES
				WHERE HOUSENAME = n_h AND IDHOUSE <> idh;
						
				CASE num 
				WHEN 0 THEN 
					UPDATE HOUSES SET HOUSENAME=n_h, IDIMAGE=idim, CITY=c, COUNTRY=ctry WHERE IDHOUSE = idh;
					SET err = 42;
				WHEN 1 THEN
					SET err = 22;
				ELSE
					SET err = 4;
				END CASE;
		WHEN 0 THEN
			SET err = 11;
		ELSE
			SET err = 39;
		END CASE;
	WHEN 0 THEN
		SET err = 11;
	ELSE
		SET err = 4;
	END CASE;
end;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 42, 0, err),  20, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 42, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `modifyuser`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `modifyuser`( IN u VARCHAR(50), IN p VARCHAR(50), IN n_u VARCHAR(50), IN n_p VARCHAR(50), IN n_mail VARCHAR(50), n_h VARCHAR(50))
    COMMENT 'Mdify the especcification of an existing user.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu INTEGER DEFAULT NULL;
	DECLARE pass VARCHAR(50);
	DECLARE err INTEGER DEFAULT 0;

end_proc:begin
	IF (u IS NULL OR n_u IS NULL OR n_mail IS NULL) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IDUSER, PASSWORD INTO num, idu, pass
	FROM USERS
	WHERE USERNAME = u;
			
	CASE num 
	WHEN 1 THEN 
		IF (pass = p) THEN 
				SELECT COUNT(*) INTO num
				FROM USERS
				WHERE USERNAME = n_u AND IDUSER <> idu;
						
				CASE num 
				WHEN 0 THEN 
						SELECT COUNT(*) INTO num
						FROM USERS
						WHERE EMAIL = n_mail AND IDUSER <> idu;
						CASE num
						WHEN 0 THEN 
							UPDATE USERS SET USERNAME=n_u, PASSWORD=n_p, EMAIL=n_mail, HINT=n_h
								WHERE IDUSER = idu;
							SET err = 15;
						WHEN 1 THEN
							SET err = 7; 
						ELSE
							SET err = 4;
						END CASE;
				WHEN 1 THEN
					SET err = 6;
				ELSE
					SET err = 4;
				END CASE;
		ELSE 
			SET err = 2;
		END IF;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;
end;
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,   idu,    NULL,  IF(err = 15, 0, err),  5, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 15, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `ProG`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `ProG`()
begin 
SELECT * FROM USERS;
end$$

DROP PROCEDURE IF EXISTS `recoveryuser`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `recoveryuser`( IN u VARCHAR(50), IN p VARCHAR(50))
    COMMENT 'Generate a password to recovery user.'
begin
	DECLARE idu INTEGER DEFAULT NULL;
        DECLARE e VARCHAR(50) DEFAULT NULL;

	UPDATE USERS SET PASSWORD = p
	WHERE USERNAME = u;
        
	SELECT  IDUSER, EMAIL INTO  idu, e
	FROM USERS
	WHERE USERNAME = u;

	INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   idu,    NULL,  0,  2, CURRENT_TIMESTAMP);

        SELECT e AS EMAIL;
end$$

DROP PROCEDURE IF EXISTS `removecommandprogram`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `removecommandprogram`( IN u VARCHAR(50), IN c VARCHAR(50), IN idpa INTEGER, IN n INTEGER)
    COMMENT 'Remove an acction of a command.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE ida, idu, idh, idc INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;
	
end_proc:begin
	IF (u IS NULL OR c IS NULL OR idpa IS NULL OR n IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IDUSER INTO  num, idu
	FROM PROGRAMACTIONS 
	WHERE IDPROGRAM = idpa AND IDUSER IN ( SELECT IDUSER 
										FROM USERS 
										WHERE USERNAME = u);
	
	CASE num 
	WHEN 1 THEN
	
		SELECT COUNT(*), IDCOMMAND INTO num, idc
		FROM COMMANDS
		WHERE COMMANDNAME = c AND IDUSER = idu;
		
		CASE num
		WHEN 1 THEN
			SELECT COUNT(*) INTO num
			FROM COMMAND_PROGRAM
			WHERE IDCOMMAND = idc AND POS = n;
			
			CASE num
			WHEN 1 THEN
				DELETE FROM COMMAND_PROGRAM WHERE IDCOMMAND = idc AND IDPROGRAM = idpa AND POS = n;
				SET err = 59;
			ELSE
				SET err = 58;
			END CASE;
		ELSE
			SET err = 60;
		END CASE;
	WHEN 0 THEN
		SET err = 33;
	ELSE
		SET err = 4;
	END CASE;
end;
	
	SELECT IDHOUSE INTO idh
	FROM houseRoomServiceActionVIEW
	WHERE IDACTION = ida;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    idh,  IF(err = 59, 0, err),  29, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 59, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `removetaskprogram`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `removetaskprogram`( IN u VARCHAR(50), IN idta INTEGER, IN idpa INTEGER)
    COMMENT 'Add an acction to a task.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE ida, idu, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;
	
end_proc:begin
	IF (u IS NULL OR idta IS NULL OR idpa IS NULL ) THEN 
		SET err = 61;
		LEAVE end_proc;
	END IF;

	SELECT COUNT(*), IDUSER INTO  num, idu
	FROM PROGRAMACTIONS 
	WHERE IDPROGRAM = idpa AND IDUSER IN ( SELECT IDUSER 
										FROM USERS 
										WHERE USERNAME = u);
	
	CASE num 
	WHEN 1 THEN
	
		SELECT COUNT(*) INTO num
		FROM TASKS
		WHERE IDTASK = idta AND IDUSER = idu;
		
		CASE num
		WHEN 1 THEN
			SELECT COUNT(*) INTO num
			FROM TASKPROGRAM
			WHERE IDTASK = idta AND IDPROGRAM = idpa;
			
			CASE num
			WHEN 1 THEN
				DELETE FROM TASKPROGRAM WHERE IDTASK = idta;
				SET err = 35;
			ELSE
				SET err = 36;
			END CASE;
		ELSE
			SET err = 32;
		END CASE;
	WHEN 0 THEN
		SET err = 33;
	ELSE
		SET err = 4;
	END CASE;
	
	SELECT IDHOUSE INTO idh
	FROM houseRoomServiceActionVIEW
	WHERE IDACTION = ida;
end;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    idh,  IF(err = 35, 0, err),  22, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 35, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `schedule`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `schedule`( IN h VARCHAR(15))
    COMMENT 'Request for all task afected to a house, by a user.'
begin

		SELECT *
	FROM ACTIONS, PROGRAMACTIONS
	LEFT JOIN (TASKPROGRAM, TASKS) ON (  TASKPROGRAM.IDPROGRAM = PROGRAMACTIONS.IDPROGRAM
										AND TASKPROGRAM.IDTASK = TASKS.IDTASK )
	JOIN SERVICES
	JOIN ROOMS 	ON ( ROOMS.IDROOM = SERVICES.IDROOM )
	JOIN HOUSES ON ( HOUSES.IDHOUSE = ROOMS.IDHOUSE )
	WHERE 	ACTIONS.IDACTION = PROGRAMACTIONS.IDACTION
		AND SERVICES.IDSERVICE = ACTIONS.IDSERVICE
		AND HOUSES.HOUSENAME = h
	ORDER BY TASKNAME DESC, PROGRAMACTIONS.IDPROGRAM ASC;

end$$

DROP PROCEDURE IF EXISTS `selectiduser`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `selectiduser`( in u VARCHAR(20), out id integer)
BEGIN
DECLARE idu INTEGER;
SELECT IDUSER into idu FROM USERS WHERE USERNAME=u;
set id = idu;
END$$

DROP PROCEDURE IF EXISTS `streaminghour`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `streaminghour`(ini TIMESTAMP, p INT)
BEGIN
DROP  TABLE IF EXISTS STADISTICS  ;
CREATE TABLE STADISTICS SELECT COUNT(*) AS Y, X
FROM (SELECT TRUNC_N_MINUTES(DATESTAMP, 60/p) AS X
		FROM HISTORYACCESS 
		WHERE DATESTAMP>= ini)AS T
GROUP BY X
ORDER BY X; 
END$$

DROP PROCEDURE IF EXISTS `userexist`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `userexist`(u VARCHAR(15), p VARCHAR(40), error INTEGER)
BEGIN 
declare pass varchar(40);
SELECT PASSWORD INTO pass FROM USERS WHERE USERNAME=u;
IF (pass <> p) THEN 
  set error = 2;
ELSE 
SET error = 0;
END IF;



END$$

--
-- Funciones
--
DROP FUNCTION IF EXISTS `ROUND_HOUR`$$
CREATE DEFINER=`alex`@`localhost` FUNCTION `ROUND_HOUR`(datestamp DATETIME) RETURNS datetime
    NO SQL
    DETERMINISTIC
    COMMENT 'returns nearest hour'
RETURN DATE_FORMAT(datestamp + INTERVAL 30 MINUTE, '%Y-%m-%d %H:00')$$

DROP FUNCTION IF EXISTS `TRUNC_N_HOURS`$$
CREATE DEFINER=`alex`@`localhost` FUNCTION `TRUNC_N_HOURS`(datestamp DATETIME, n INT) RETURNS datetime
    NO SQL
    DETERMINISTIC
    COMMENT 'truncate to N hour boundary. For example,\n           TRUNCATE_N_HOURS(sometime, 12) gives the nearest\n           preceding half-day (noon, or midnight'
RETURN DATE(datestamp) +
                INTERVAL (HOUR(datestamp) -
                          HOUR(datestamp) MOD n) HOUR$$

DROP FUNCTION IF EXISTS `TRUNC_N_MINUTES`$$
CREATE DEFINER=`alex`@`localhost` FUNCTION `TRUNC_N_MINUTES`(datestamp DATETIME, n INT) RETURNS datetime
    NO SQL
    DETERMINISTIC
    COMMENT 'truncate to N minute boundary. For example,\n           TRUNCATE_N_MINUTES(sometime, 15) gives the nearest\n           preceding quarter hour'
RETURN DATE_FORMAT(datestamp,'%Y-%m-%d %H:00') +
                INTERVAL (MINUTE(datestamp) -
                          MINUTE(datestamp) MOD n) MINUTE$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ACCESSHOUSE`
--
-- Creación: 13-04-2014 a las 22:59:04
--

DROP TABLE IF EXISTS `ACCESSHOUSE`;
CREATE TABLE IF NOT EXISTS `ACCESSHOUSE` (
  `IDUSER` int(11) NOT NULL DEFAULT '0',
  `IDHOUSE` int(11) NOT NULL DEFAULT '0',
  `ACCESSNUMBER` int(11) DEFAULT '1',
  `DATEBEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDUSER`,`IDHOUSE`),
  KEY `IDHOUSE` (`IDHOUSE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- RELACIONES PARA LA TABLA `ACCESSHOUSE`:
--   `IDHOUSE`
--       `HOUSES` -> `IDHOUSE`
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ACTIONMESSAGES`
--
-- Creación: 15-04-2014 a las 19:48:45
--

DROP TABLE IF EXISTS `ACTIONMESSAGES`;
CREATE TABLE IF NOT EXISTS `ACTIONMESSAGES` (
  `IDMESSAGE` int(11) NOT NULL AUTO_INCREMENT,
  `IDACTION` int(11) NOT NULL,
  `RETURNCODE` varchar(50) NOT NULL,
  `EXIT` tinyint(1) NOT NULL,
  `ENGLISH` varchar(50) DEFAULT NULL,
  `SPANISH` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IDMESSAGE`),
  UNIQUE KEY `IDACTION_RETURNCODE` (`IDACTION`,`RETURNCODE`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=22 ;

--
-- RELACIONES PARA LA TABLA `ACTIONMESSAGES`:
--   `IDACTION`
--       `ACTIONS` -> `IDACTION`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ACTIONS`
--
-- Creación: 15-04-2014 a las 19:49:07
--

DROP TABLE IF EXISTS `ACTIONS`;
CREATE TABLE IF NOT EXISTS `ACTIONS` (
  `IDACTION` int(11) NOT NULL AUTO_INCREMENT,
  `IDSERVICE` int(11) DEFAULT NULL,
  `ACTIONNAME` varchar(50) NOT NULL,
  `ENGLISH` varchar(50) NOT NULL,
  `SPANISH` varchar(50) NOT NULL,
  `FCODE` varchar(20) NOT NULL,
  PRIMARY KEY (`IDACTION`),
  UNIQUE KEY `UNQ_ACTIONKEY` (`IDSERVICE`,`ACTIONNAME`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=93 ;

--
-- RELACIONES PARA LA TABLA `ACTIONS`:
--   `IDSERVICE`
--       `SERVICES` -> `IDSERVICE`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `COMMANDS`
--
-- Creación: 15-04-2014 a las 19:49:30
--

DROP TABLE IF EXISTS `COMMANDS`;
CREATE TABLE IF NOT EXISTS `COMMANDS` (
  `IDCOMMAND` int(11) NOT NULL AUTO_INCREMENT,
  `COMMANDNAME` varchar(50) NOT NULL,
  `IDUSER` int(11) NOT NULL,
  PRIMARY KEY (`IDCOMMAND`),
  KEY `IDUSER` (`IDUSER`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- RELACIONES PARA LA TABLA `COMMANDS`:
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `commandVIEW`
--
DROP VIEW IF EXISTS `commandVIEW`;
CREATE TABLE IF NOT EXISTS `commandVIEW` (
`IDCOMMAND` int(11)
,`COMMANDNAME` varchar(50)
,`POS` int(11)
,`IDPROGRAM` int(11)
,`IDACTION` int(11)
,`IDHOUSE` int(11)
,`HOUSENAME` varchar(50)
,`IDROOM` int(11)
,`ROOMNAME` varchar(50)
,`IDSERVICE` int(11)
,`SERVICENAME` varchar(50)
,`DATA` varchar(50)
,`STARTTIME` timestamp
);
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `COMMAND_PROGRAM`
--
-- Creación: 15-04-2014 a las 14:24:32
--

DROP TABLE IF EXISTS `COMMAND_PROGRAM`;
CREATE TABLE IF NOT EXISTS `COMMAND_PROGRAM` (
  `IDCOMMAND` int(11) NOT NULL,
  `IDPROGRAM` int(11) NOT NULL,
  `POS` int(11) NOT NULL,
  UNIQUE KEY `IDCOMMAND_2` (`IDCOMMAND`,`IDPROGRAM`,`POS`),
  KEY `IDCOMMAND` (`IDCOMMAND`),
  KEY `IDPROGRAM` (`IDPROGRAM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- RELACIONES PARA LA TABLA `COMMAND_PROGRAM`:
--   `IDPROGRAM`
--       `PROGRAMACTIONS` -> `IDPROGRAM`
--   `IDCOMMAND`
--       `COMMANDS` -> `IDCOMMAND`
--

--
-- Disparadores `COMMAND_PROGRAM`
--
DROP TRIGGER IF EXISTS `checkPOS_natural`;
DELIMITER //
CREATE TRIGGER `checkPOS_natural` BEFORE INSERT ON `COMMAND_PROGRAM`
 FOR EACH ROW BEGIN
  IF NEW.POS < 1 THEN
    SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'POS must be natural';
  END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `countHitsVIEW`
--
DROP VIEW IF EXISTS `countHitsVIEW`;
CREATE TABLE IF NOT EXISTS `countHitsVIEW` (
`USERNAME` varchar(50)
,`FUNCTION` varchar(50)
,`TOTAL` bigint(21)
,`SUCCESS` decimal(23,0)
,`ERROR` decimal(23,0)
,`PASSWORD` decimal(23,0)
,`INTEGRITY` decimal(23,0)
);
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `DEVICES`
--
-- Creación: 15-04-2014 a las 23:49:58
--

DROP TABLE IF EXISTS `DEVICES`;
CREATE TABLE IF NOT EXISTS `DEVICES` (
  `IDDEVICE` int(11) NOT NULL AUTO_INCREMENT,
  `IDUSER` int(11) DEFAULT NULL,
  `IPADDRESS` varchar(500) DEFAULT NULL,
  `SERIAL` varchar(50) DEFAULT NULL,
  `DEVICENAME` varchar(50) DEFAULT NULL,
  `ENGLISH` varchar(500) DEFAULT NULL,
  `SPANISH` varchar(500) DEFAULT NULL,
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `VERSION` int(11) NOT NULL,
  PRIMARY KEY (`IDDEVICE`),
  UNIQUE KEY `SERIAL` (`SERIAL`),
  KEY `IDUSER` (`IDUSER`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=20 ;

--
-- RELACIONES PARA LA TABLA `DEVICES`:
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ERRORS`
--
-- Creación: 12-04-2014 a las 14:42:05
--

DROP TABLE IF EXISTS `ERRORS`;
CREATE TABLE IF NOT EXISTS `ERRORS` (
  `ERRORCODE` int(11) NOT NULL AUTO_INCREMENT,
  `ENGLISH` varchar(50) NOT NULL,
  `SPANISH` varchar(50) NOT NULL,
  PRIMARY KEY (`ERRORCODE`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=63 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `FUNCTIONS`
--
-- Creación: 15-04-2014 a las 19:50:51
--

DROP TABLE IF EXISTS `FUNCTIONS`;
CREATE TABLE IF NOT EXISTS `FUNCTIONS` (
  `FUNCT` int(11) NOT NULL AUTO_INCREMENT,
  `FUNCTION` varchar(50) NOT NULL,
  PRIMARY KEY (`FUNCT`),
  UNIQUE KEY `FUNCTION` (`FUNCTION`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=31 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HISTORYACCESS`
--
-- Creación: 13-04-2014 a las 22:08:26
--

DROP TABLE IF EXISTS `HISTORYACCESS`;
CREATE TABLE IF NOT EXISTS `HISTORYACCESS` (
  `IDHISTORY` int(11) NOT NULL AUTO_INCREMENT,
  `IDUSER` int(11) DEFAULT NULL,
  `IDHOUSE` int(11) DEFAULT NULL,
  `ERROR` int(11) DEFAULT NULL,
  `FUNCT` int(11) DEFAULT NULL,
  `DATESTAMP` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDHISTORY`),
  KEY `ERROR` (`ERROR`),
  KEY `FUNCT` (`FUNCT`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3219 ;

--
-- RELACIONES PARA LA TABLA `HISTORYACCESS`:
--   `IDHOUSE`
--       `HOUSES` -> `IDHOUSE`
--   `IDUSER`
--       `USERS` -> `IDUSER`
--   `ERROR`
--       `ERRORS` -> `ERRORCODE`
--   `FUNCT`
--       `FUNCTIONS` -> `FUNCT`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HISTORYACTION`
--
-- Creación: 15-04-2014 a las 19:51:13
--

DROP TABLE IF EXISTS `HISTORYACTION`;
CREATE TABLE IF NOT EXISTS `HISTORYACTION` (
  `IDHISTORYACTION` int(11) NOT NULL AUTO_INCREMENT,
  `IDACTION` int(11) NOT NULL,
  `IDPROGRAM` int(11) DEFAULT NULL,
  `IDUSER` int(11) DEFAULT NULL,
  `RETURNCODE` varchar(50) NOT NULL,
  `DATESTAMP` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDHISTORYACTION`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=225 ;

--
-- RELACIONES PARA LA TABLA `HISTORYACTION`:
--   `IDACTION`
--       `ACTIONS` -> `IDACTION`
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `houseRoomServiceActionVIEW`
--
DROP VIEW IF EXISTS `houseRoomServiceActionVIEW`;
CREATE TABLE IF NOT EXISTS `houseRoomServiceActionVIEW` (
`IDHOUSE` int(11)
,`HOUSENAME` varchar(50)
,`IDROOM` int(11)
,`ROOMNAME` varchar(50)
,`IDSERVICE` int(11)
,`SERVICENAME` varchar(50)
,`IDACTION` int(11)
,`ACTIONNAME` varchar(50)
);
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HOUSES`
--
-- Creación: 16-04-2014 a las 00:24:52
--

DROP TABLE IF EXISTS `HOUSES`;
CREATE TABLE IF NOT EXISTS `HOUSES` (
  `IDHOUSE` int(11) NOT NULL AUTO_INCREMENT,
  `IDUSER` int(11) NOT NULL,
  `HOUSENAME` varchar(50) NOT NULL,
  `IDIMAGE` int(11) DEFAULT NULL,
  `CITY` varchar(50) DEFAULT NULL,
  `COUNTRY` varchar(50) DEFAULT NULL,
  `GPS` varchar(50) DEFAULT NULL,
  `DATEBEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDHOUSE`),
  UNIQUE KEY `HOUSENAME` (`HOUSENAME`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=25 ;

--
-- RELACIONES PARA LA TABLA `HOUSES`:
--   `IDIMAGE`
--       `IMAGES` -> `IDIMAGE`
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `IMAGES`
--
-- Creación: 15-04-2014 a las 19:52:15
--

DROP TABLE IF EXISTS `IMAGES`;
CREATE TABLE IF NOT EXISTS `IMAGES` (
  `IDIMAGE` int(11) NOT NULL AUTO_INCREMENT,
  `IMAGE` mediumblob,
  `URL` varchar(500) DEFAULT NULL,
  `TYPE` varchar(50) NOT NULL,
  PRIMARY KEY (`IDIMAGE`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=37 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `IRCODES`
--
-- Creación: 15-04-2014 a las 19:52:36
--

DROP TABLE IF EXISTS `IRCODES`;
CREATE TABLE IF NOT EXISTS `IRCODES` (
  `IDCODE` int(11) NOT NULL AUTO_INCREMENT,
  `TYPE` varchar(50) NOT NULL,
  `POWER` int(11) DEFAULT NULL,
  `SETUP` int(11) DEFAULT NULL,
  `MUTE` int(11) DEFAULT NULL,
  `FUNCTION` int(11) DEFAULT NULL,
  `UNO` int(11) DEFAULT NULL,
  `DOS` int(11) DEFAULT NULL,
  `TRES` int(11) DEFAULT NULL,
  `CUATRO` int(11) DEFAULT NULL,
  `CINCO` int(11) DEFAULT NULL,
  `SEIS` int(11) DEFAULT NULL,
  `SIETE` int(11) DEFAULT NULL,
  `OCHO` int(11) DEFAULT NULL,
  `NUEVE` int(11) DEFAULT NULL,
  `CERO` int(11) DEFAULT NULL,
  `FAV` int(11) DEFAULT NULL,
  `UP` int(11) DEFAULT NULL,
  `LEFT` int(11) DEFAULT NULL,
  `PLAY` int(11) DEFAULT NULL,
  `RIGHT` int(11) DEFAULT NULL,
  PRIMARY KEY (`IDCODE`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `loginVIEW`
--
DROP VIEW IF EXISTS `loginVIEW`;
CREATE TABLE IF NOT EXISTS `loginVIEW` (
`IDUSER` int(11)
,`USERNAME` varchar(50)
,`PASSWORD` varchar(50)
,`IDHOUSE` int(11)
,`HOUSENAME` varchar(50)
,`IDROOM` int(11)
,`ROOMNAME` varchar(50)
,`IDSERVICE` int(11)
,`SERVICENAME` varchar(50)
,`IDACTION` int(11)
,`ACTIONNAME` varchar(50)
,`ACCESSNUMBER` int(11)
,`PERMISSIONNUMBER` int(11)
,`IDDEVICE` int(11)
,`IPADDRESS` varchar(500)
,`CITY` varchar(50)
,`COUNTRY` varchar(50)
);
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PERMISSIONS`
--
-- Creación: 12-04-2014 a las 14:42:08
--

DROP TABLE IF EXISTS `PERMISSIONS`;
CREATE TABLE IF NOT EXISTS `PERMISSIONS` (
  `IDUSER` int(11) NOT NULL DEFAULT '0',
  `IDSERVICE` int(11) NOT NULL,
  `PERMISSIONNUMBER` int(11) NOT NULL,
  `DATEBEGIN` date DEFAULT NULL,
  PRIMARY KEY (`IDUSER`,`IDSERVICE`),
  KEY `IDSERVICE` (`IDSERVICE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- RELACIONES PARA LA TABLA `PERMISSIONS`:
--   `IDSERVICE`
--       `SERVICES` -> `IDSERVICE`
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PROGRAMACTIONS`
--
-- Creación: 15-04-2014 a las 19:53:10
--

DROP TABLE IF EXISTS `PROGRAMACTIONS`;
CREATE TABLE IF NOT EXISTS `PROGRAMACTIONS` (
  `IDPROGRAM` int(11) NOT NULL AUTO_INCREMENT,
  `IDUSER` int(11) NOT NULL,
  `IDACTION` int(11) NOT NULL,
  `DATA` varchar(50) DEFAULT NULL,
  `STARTTIME` timestamp NULL DEFAULT NULL,
  `DATEBEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDPROGRAM`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=61 ;

--
-- RELACIONES PARA LA TABLA `PROGRAMACTIONS`:
--   `IDACTION`
--       `ACTIONS` -> `IDACTION`
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ROOMS`
--
-- Creación: 15-04-2014 a las 19:53:32
--

DROP TABLE IF EXISTS `ROOMS`;
CREATE TABLE IF NOT EXISTS `ROOMS` (
  `IDROOM` int(11) NOT NULL AUTO_INCREMENT,
  `IDHOUSE` int(11) DEFAULT NULL,
  `IDUSER` int(11) DEFAULT NULL,
  `ROOMNAME` varchar(50) NOT NULL,
  `DATEBEGIN` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDROOM`),
  UNIQUE KEY `ROOMNAME` (`ROOMNAME`,`IDHOUSE`),
  KEY `IDHOUSE` (`IDHOUSE`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=25 ;

--
-- RELACIONES PARA LA TABLA `ROOMS`:
--   `IDUSER`
--       `USERS` -> `IDUSER`
--   `IDHOUSE`
--       `HOUSES` -> `IDHOUSE`
--

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `scheduleVIEW`
--
DROP VIEW IF EXISTS `scheduleVIEW`;
CREATE TABLE IF NOT EXISTS `scheduleVIEW` (
`IDTASK` int(11)
,`TASKNAME` varchar(50)
,`IDPROGRAM` int(11)
,`IDACTION` int(11)
,`IDHOUSE` int(11)
,`HOUSENAME` varchar(50)
,`IDROOM` int(11)
,`ROOMNAME` varchar(50)
,`IDSERVICE` int(11)
,`SERVICENAME` varchar(50)
,`DATA` varchar(50)
,`STARTTIME` timestamp
);
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `SERVICES`
--
-- Creación: 15-04-2014 a las 19:53:47
--

DROP TABLE IF EXISTS `SERVICES`;
CREATE TABLE IF NOT EXISTS `SERVICES` (
  `IDSERVICE` int(11) NOT NULL AUTO_INCREMENT,
  `IDROOM` int(11) DEFAULT NULL,
  `IDDEVICE` int(11) DEFAULT NULL,
  `SERVICENAME` varchar(50) NOT NULL,
  `SERVICEINTERFACE` int(11) NOT NULL,
  `FCODE` int(11) DEFAULT NULL,
  `ENGLISH` varchar(50) DEFAULT NULL,
  `SPANISH` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IDSERVICE`),
  UNIQUE KEY `UNQ_IDROOM_IDDEVICE_SERVICENAME` (`IDROOM`,`IDDEVICE`,`SERVICENAME`),
  KEY `IDDEVICE` (`IDDEVICE`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=61 ;

--
-- RELACIONES PARA LA TABLA `SERVICES`:
--   `IDROOM`
--       `ROOMS` -> `IDROOM`
--   `IDDEVICE`
--       `DEVICES` -> `IDDEVICE`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `SOFTWARE`
--
-- Creación: 15-04-2014 a las 19:54:17
--

DROP TABLE IF EXISTS `SOFTWARE`;
CREATE TABLE IF NOT EXISTS `SOFTWARE` (
  `DEVICE` int(11) NOT NULL,
  `VERSION` int(11) NOT NULL,
  `URL` varchar(500) NOT NULL,
  UNIQUE KEY `DEVICE` (`DEVICE`,`VERSION`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `STADISTICS`
--
-- Creación: 12-04-2014 a las 14:42:06
--

DROP TABLE IF EXISTS `STADISTICS`;
CREATE TABLE IF NOT EXISTS `STADISTICS` (
  `Y` bigint(21) NOT NULL DEFAULT '0',
  `X` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `TASKPROGRAM`
--
-- Creación: 12-04-2014 a las 14:42:09
--

DROP TABLE IF EXISTS `TASKPROGRAM`;
CREATE TABLE IF NOT EXISTS `TASKPROGRAM` (
  `IDTASK` int(11) NOT NULL,
  `IDPROGRAM` int(11) NOT NULL,
  UNIQUE KEY `1_ACTION_1_TASK` (`IDTASK`,`IDPROGRAM`),
  KEY `IDPROGRAM` (`IDPROGRAM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- RELACIONES PARA LA TABLA `TASKPROGRAM`:
--   `IDPROGRAM`
--       `PROGRAMACTIONS` -> `IDPROGRAM`
--   `IDTASK`
--       `TASKS` -> `IDTASK`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `TASKS`
--
-- Creación: 15-04-2014 a las 19:55:00
--

DROP TABLE IF EXISTS `TASKS`;
CREATE TABLE IF NOT EXISTS `TASKS` (
  `IDTASK` int(11) NOT NULL AUTO_INCREMENT,
  `TASKNAME` varchar(50) NOT NULL,
  `IDUSER` int(11) DEFAULT NULL,
  `DESCRIPTION` varchar(50) DEFAULT NULL,
  ` FREQUENCY` timestamp NULL DEFAULT NULL,
  `DATEBEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDTASK`),
  KEY `IDUSER` (`IDUSER`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=23 ;

--
-- RELACIONES PARA LA TABLA `TASKS`:
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `USERS`
--
-- Creación: 15-04-2014 a las 19:55:29
--

DROP TABLE IF EXISTS `USERS`;
CREATE TABLE IF NOT EXISTS `USERS` (
  `IDUSER` int(11) NOT NULL AUTO_INCREMENT,
  `USERNAME` varchar(50) NOT NULL,
  `PASSWORD` varchar(50) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `HINT` varchar(50) DEFAULT NULL,
  `DATEBEGIN` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDUSER`),
  UNIQUE KEY `USERNAME` (`USERNAME`),
  UNIQUE KEY `EMAIL` (`EMAIL`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=104 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `commandVIEW`
--
DROP TABLE IF EXISTS `commandVIEW`;

CREATE ALGORITHM=UNDEFINED DEFINER=`alex`@`localhost` SQL SECURITY DEFINER VIEW `commandVIEW` AS select `COMMANDS`.`IDCOMMAND` AS `IDCOMMAND`,`COMMANDS`.`COMMANDNAME` AS `COMMANDNAME`,`COMMAND_PROGRAM`.`POS` AS `POS`,`PROGRAMACTIONS`.`IDPROGRAM` AS `IDPROGRAM`,`PROGRAMACTIONS`.`IDACTION` AS `IDACTION`,`HOUSES`.`IDHOUSE` AS `IDHOUSE`,`HOUSES`.`HOUSENAME` AS `HOUSENAME`,`ROOMS`.`IDROOM` AS `IDROOM`,`ROOMS`.`ROOMNAME` AS `ROOMNAME`,`SERVICES`.`IDSERVICE` AS `IDSERVICE`,`SERVICES`.`SERVICENAME` AS `SERVICENAME`,`PROGRAMACTIONS`.`DATA` AS `DATA`,`PROGRAMACTIONS`.`STARTTIME` AS `STARTTIME` from (`ACTIONS` join ((((`PROGRAMACTIONS` left join (`COMMAND_PROGRAM` join `COMMANDS`) on(((`COMMAND_PROGRAM`.`IDPROGRAM` = `PROGRAMACTIONS`.`IDPROGRAM`) and (`COMMAND_PROGRAM`.`IDCOMMAND` = `COMMANDS`.`IDCOMMAND`)))) join `SERVICES`) join `ROOMS` on((`ROOMS`.`IDROOM` = `SERVICES`.`IDROOM`))) join `HOUSES` on((`HOUSES`.`IDHOUSE` = `ROOMS`.`IDHOUSE`)))) where ((`ACTIONS`.`IDACTION` = `PROGRAMACTIONS`.`IDACTION`) and (`SERVICES`.`IDSERVICE` = `ACTIONS`.`IDSERVICE`)) order by `COMMANDS`.`COMMANDNAME` desc,`COMMAND_PROGRAM`.`POS`,`PROGRAMACTIONS`.`IDPROGRAM`;

-- --------------------------------------------------------

--
-- Estructura para la vista `countHitsVIEW`
--
DROP TABLE IF EXISTS `countHitsVIEW`;

CREATE ALGORITHM=UNDEFINED DEFINER=`alex`@`localhost` SQL SECURITY DEFINER VIEW `countHitsVIEW` AS select `USERS`.`USERNAME` AS `USERNAME`,`FUNCTIONS`.`FUNCTION` AS `FUNCTION`,count(0) AS `TOTAL`,sum(if((`HISTORYACCESS`.`ERROR` = 0),1,0)) AS `SUCCESS`,sum(if((`HISTORYACCESS`.`ERROR` <> 0),1,0)) AS `ERROR`,sum(if((`HISTORYACCESS`.`ERROR` = 2),1,0)) AS `PASSWORD`,sum(if((`HISTORYACCESS`.`ERROR` = 4),1,0)) AS `INTEGRITY` from (((`USERS` left join `HISTORYACCESS` on((`USERS`.`IDUSER` = `HISTORYACCESS`.`IDUSER`))) left join `FUNCTIONS` on((`HISTORYACCESS`.`FUNCT` = `FUNCTIONS`.`FUNCT`))) join `ERRORS` on((`ERRORS`.`ERRORCODE` = `HISTORYACCESS`.`ERROR`))) group by `USERS`.`USERNAME`,`FUNCTIONS`.`FUNCTION` order by count(0) desc;

-- --------------------------------------------------------

--
-- Estructura para la vista `houseRoomServiceActionVIEW`
--
DROP TABLE IF EXISTS `houseRoomServiceActionVIEW`;

CREATE ALGORITHM=UNDEFINED DEFINER=`alex`@`localhost` SQL SECURITY DEFINER VIEW `houseRoomServiceActionVIEW` AS select `HOUSES`.`IDHOUSE` AS `IDHOUSE`,`HOUSES`.`HOUSENAME` AS `HOUSENAME`,`ROOMS`.`IDROOM` AS `IDROOM`,`ROOMS`.`ROOMNAME` AS `ROOMNAME`,`SERVICES`.`IDSERVICE` AS `IDSERVICE`,`SERVICES`.`SERVICENAME` AS `SERVICENAME`,`ACTIONS`.`IDACTION` AS `IDACTION`,`ACTIONS`.`ACTIONNAME` AS `ACTIONNAME` from (((`HOUSES` join `ROOMS` on((`HOUSES`.`IDHOUSE` = `ROOMS`.`IDHOUSE`))) join `SERVICES` on((`ROOMS`.`IDROOM` = `SERVICES`.`IDROOM`))) join `ACTIONS` on((`SERVICES`.`IDSERVICE` = `ACTIONS`.`IDSERVICE`))) order by `HOUSES`.`IDHOUSE`,`ROOMS`.`IDROOM`,`SERVICES`.`IDSERVICE`,`ACTIONS`.`IDACTION`;

-- --------------------------------------------------------

--
-- Estructura para la vista `loginVIEW`
--
DROP TABLE IF EXISTS `loginVIEW`;

CREATE ALGORITHM=UNDEFINED DEFINER=`alex`@`localhost` SQL SECURITY DEFINER VIEW `loginVIEW` AS select `USERS`.`IDUSER` AS `IDUSER`,`USERS`.`USERNAME` AS `USERNAME`,`USERS`.`PASSWORD` AS `PASSWORD`,`HOUSES`.`IDHOUSE` AS `IDHOUSE`,`HOUSES`.`HOUSENAME` AS `HOUSENAME`,`ROOMS`.`IDROOM` AS `IDROOM`,`ROOMS`.`ROOMNAME` AS `ROOMNAME`,`SERVICES`.`IDSERVICE` AS `IDSERVICE`,`SERVICES`.`SERVICENAME` AS `SERVICENAME`,`ACTIONS`.`IDACTION` AS `IDACTION`,`ACTIONS`.`ACTIONNAME` AS `ACTIONNAME`,`ACCESSHOUSE`.`ACCESSNUMBER` AS `ACCESSNUMBER`,`PERMISSIONS`.`PERMISSIONNUMBER` AS `PERMISSIONNUMBER`,`DEVICES`.`IDDEVICE` AS `IDDEVICE`,`DEVICES`.`IPADDRESS` AS `IPADDRESS`,`HOUSES`.`CITY` AS `CITY`,`HOUSES`.`COUNTRY` AS `COUNTRY` from (((((((`USERS` left join `ACCESSHOUSE` on((`USERS`.`IDUSER` = `ACCESSHOUSE`.`IDUSER`))) left join `HOUSES` on((`ACCESSHOUSE`.`IDHOUSE` = `HOUSES`.`IDHOUSE`))) left join `ROOMS` on((`ACCESSHOUSE`.`IDHOUSE` = `ROOMS`.`IDHOUSE`))) left join `SERVICES` on((`ROOMS`.`IDROOM` = `SERVICES`.`IDROOM`))) left join `DEVICES` on((`SERVICES`.`IDDEVICE` = `DEVICES`.`IDDEVICE`))) left join `ACTIONS` on((`SERVICES`.`IDSERVICE` = `ACTIONS`.`IDSERVICE`))) left join `PERMISSIONS` on(((`PERMISSIONS`.`IDUSER` = `USERS`.`IDUSER`) and (`PERMISSIONS`.`IDSERVICE` = `SERVICES`.`IDSERVICE`)))) where 1 order by `USERS`.`USERNAME`,`HOUSES`.`HOUSENAME`,`ROOMS`.`ROOMNAME`,`SERVICES`.`SERVICENAME`,`ACTIONS`.`ACTIONNAME` desc;

-- --------------------------------------------------------

--
-- Estructura para la vista `scheduleVIEW`
--
DROP TABLE IF EXISTS `scheduleVIEW`;

CREATE ALGORITHM=UNDEFINED DEFINER=`alex`@`localhost` SQL SECURITY DEFINER VIEW `scheduleVIEW` AS select `TASKS`.`IDTASK` AS `IDTASK`,`TASKS`.`TASKNAME` AS `TASKNAME`,`PROGRAMACTIONS`.`IDPROGRAM` AS `IDPROGRAM`,`PROGRAMACTIONS`.`IDACTION` AS `IDACTION`,`HOUSES`.`IDHOUSE` AS `IDHOUSE`,`HOUSES`.`HOUSENAME` AS `HOUSENAME`,`ROOMS`.`IDROOM` AS `IDROOM`,`ROOMS`.`ROOMNAME` AS `ROOMNAME`,`SERVICES`.`IDSERVICE` AS `IDSERVICE`,`SERVICES`.`SERVICENAME` AS `SERVICENAME`,`PROGRAMACTIONS`.`DATA` AS `DATA`,`PROGRAMACTIONS`.`STARTTIME` AS `STARTTIME` from (`ACTIONS` join ((((`PROGRAMACTIONS` left join (`TASKPROGRAM` join `TASKS`) on(((`TASKPROGRAM`.`IDPROGRAM` = `PROGRAMACTIONS`.`IDPROGRAM`) and (`TASKPROGRAM`.`IDTASK` = `TASKS`.`IDTASK`)))) join `SERVICES`) join `ROOMS` on((`ROOMS`.`IDROOM` = `SERVICES`.`IDROOM`))) join `HOUSES` on((`HOUSES`.`IDHOUSE` = `ROOMS`.`IDHOUSE`)))) where ((`ACTIONS`.`IDACTION` = `PROGRAMACTIONS`.`IDACTION`) and (`SERVICES`.`IDSERVICE` = `ACTIONS`.`IDSERVICE`)) order by `TASKS`.`TASKNAME` desc,`PROGRAMACTIONS`.`IDPROGRAM`;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ACCESSHOUSE`
--
ALTER TABLE `ACCESSHOUSE`
  ADD CONSTRAINT `ACCESSHOUSE_ibfk_4` FOREIGN KEY (`IDHOUSE`) REFERENCES `HOUSES` (`IDHOUSE`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ACCESSHOUSE_ibfk_3` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ACTIONMESSAGES`
--
ALTER TABLE `ACTIONMESSAGES`
  ADD CONSTRAINT `ACTIONMESSAGES_ibfk_2` FOREIGN KEY (`IDACTION`) REFERENCES `ACTIONS` (`IDACTION`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ACTIONS`
--
ALTER TABLE `ACTIONS`
  ADD CONSTRAINT `ACTIONS_ibfk_2` FOREIGN KEY (`IDSERVICE`) REFERENCES `SERVICES` (`IDSERVICE`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `COMMANDS`
--
ALTER TABLE `COMMANDS`
  ADD CONSTRAINT `COMMANDS_ibfk_1` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `COMMAND_PROGRAM`
--
ALTER TABLE `COMMAND_PROGRAM`
  ADD CONSTRAINT `COMMAND_PROGRAM_ibfk_2` FOREIGN KEY (`IDPROGRAM`) REFERENCES `PROGRAMACTIONS` (`IDPROGRAM`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `COMMAND_PROGRAM_ibfk_3` FOREIGN KEY (`IDCOMMAND`) REFERENCES `COMMANDS` (`IDCOMMAND`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `DEVICES`
--
ALTER TABLE `DEVICES`
  ADD CONSTRAINT `DEVICES_ibfk_1` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `HISTORYACCESS`
--
ALTER TABLE `HISTORYACCESS`
  ADD CONSTRAINT `HISTORYACCESS_ibfk_3` FOREIGN KEY (`ERROR`) REFERENCES `ERRORS` (`ERRORCODE`),
  ADD CONSTRAINT `HISTORYACCESS_ibfk_4` FOREIGN KEY (`FUNCT`) REFERENCES `FUNCTIONS` (`FUNCT`);

--
-- Filtros para la tabla `PERMISSIONS`
--
ALTER TABLE `PERMISSIONS`
  ADD CONSTRAINT `PERMISSIONS_ibfk_4` FOREIGN KEY (`IDSERVICE`) REFERENCES `SERVICES` (`IDSERVICE`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `PERMISSIONS_ibfk_3` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ROOMS`
--
ALTER TABLE `ROOMS`
  ADD CONSTRAINT `ROOMS_ibfk_2` FOREIGN KEY (`IDHOUSE`) REFERENCES `HOUSES` (`IDHOUSE`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `SERVICES`
--
ALTER TABLE `SERVICES`
  ADD CONSTRAINT `SERVICES_ibfk_3` FOREIGN KEY (`IDROOM`) REFERENCES `ROOMS` (`IDROOM`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `SERVICES_ibfk_4` FOREIGN KEY (`IDDEVICE`) REFERENCES `DEVICES` (`IDDEVICE`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `TASKPROGRAM`
--
ALTER TABLE `TASKPROGRAM`
  ADD CONSTRAINT `TASKPROGRAM_ibfk_4` FOREIGN KEY (`IDPROGRAM`) REFERENCES `PROGRAMACTIONS` (`IDPROGRAM`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `TASKPROGRAM_ibfk_3` FOREIGN KEY (`IDTASK`) REFERENCES `TASKS` (`IDTASK`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `TASKS`
--
ALTER TABLE `TASKS`
  ADD CONSTRAINT `TASKS_ibfk_2` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
