-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 05-04-2014 a las 10:25:49
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
CREATE DEFINER=`alex`@`localhost` PROCEDURE `loginJSON`( in u VARCHAR(15))
begin

	SELECT *
	FROM  USERS
	LEFT JOIN ACCESSHOUSE USING (IDUSER)
	LEFT JOIN HOUSES USING ( IDHOUSE )
	LEFT JOIN ROOMS USING ( IDHOUSE )
	LEFT JOIN SERVICES USING ( IDROOM  )
	LEFT JOIN PERMISSIONS USING (IDSERVICE, IDUSER)
	LEFT JOIN ACTIONS USING ( IDSERVICE  )
	WHERE USERS.USERNAME = u 
	ORDER BY USERNAME, HOUSENAME, ROOMNAME, SERVICENAME, ACTIONNAME DESC;

end$$

CREATE DEFINER=`alex`@`localhost` PROCEDURE `createuser` 
( IN u VARCHAR(15), IN p VARCHAR(40), IN mail VARCHAR(40), h VARCHAR(30))
LANGUAGE SQL
NOT DETERMINISTIC
SQL SECURITY DEFINER
COMMENT 'Create a new user if not exist.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE id INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;

        SELECT IDUSER INTO id
			FROM USERS
			WHERE USERNAME = u;
	SELECT COUNT(*) INTO num 
	FROM (
			SELECT IDUSER
			FROM USERS
			WHERE USERNAME = u) AS T;
			
	CASE num 
	WHEN 0 THEN 
		begin
			DECLARE num INTEGER DEFAULT 0;
			SELECT COUNT(*) INTO num 
			FROM (
				SELECT IDUSER
				FROM USERS
				WHERE EMAIL = mail) AS T;
			CASE num
			WHEN 0 THEN 
				INSERT INTO `USERS` (`IDUSER`, `USERNAME`, `PASSWORD`, `EMAIL`, `HINT`, `DATEBEGIN`) VALUES
									(NULL, u, p, mail, h, CURRENT_TIMESTAMP);
				SET err = 13;
			WHEN 1 THEN
				SET err = 7; 
			ELSE
				SET err = 4;
			END CASE;
		end;
	WHEN 1 THEN
		SET err = 6;
	ELSE
		SET err = 4;
	END CASE;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,   id,    NULL,  err,  3, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 13, 0, ERRORCODE) AS ERRORCODE, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end

$$


CREATE DEFINER=`alex`@`localhost` PROCEDURE deleteuser 
( IN u VARCHAR(15), IN p VARCHAR(40))
LANGUAGE SQL
NOT DETERMINISTIC
SQL SECURITY DEFINER
COMMENT 'Delete user if posible by deleting all information restring.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE id INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;
	DECLARE pass VARCHAR(40);
	SELECT PASSWORD INTO pass
			FROM USERS
			WHERE IDUSER = u;

	SELECT IDUSER INTO id
			FROM USERS
			WHERE IDUSER = u;
	
	SELECT COUNT(*) INTO num 
	FROM (
			SELECT IDUSER
			FROM USERS
			WHERE IDUSER = u) AS T;
			
	CASE num 
	WHEN 1 THEN 
		begin
			IF (pass = p) THEN 
				DELETE FROM `USERS` WHERE IDUSER = id;
				SET err = 14;
			ELSE 
				SET err = 2;
			END IF;
			
		end;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,   id,    NULL,  err,  4, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 14, 0, ERRORCODE) AS ERRORCODE, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

CREATE DEFINER=`alex`@`localhost` PROCEDURE `modifyuser` 
( IN u VARCHAR(15), IN p VARCHAR(40), IN n_u VARCHAR(15), IN n_p VARCHAR(40), IN n_mail VARCHAR(40), n_h VARCHAR(30))
LANGUAGE SQL
NOT DETERMINISTIC
SQL SECURITY DEFINER
COMMENT 'Mdify the especcification of an existing user.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE id INTEGER DEFAULT 0;
	DECLARE pass INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;

	SELECT COUNT(*) INTO num 
	FROM (
			SELECT IDUSER INTO id, PASSWORD INTO pass
			FROM USERS
			WHERE IDUSER = u);
			
	CASE num 
	WHEN 1 THEN 
		begin
			
			IF pass = p THEN 
				begin 
					DECLARE num INTEGER DEFAULT 0;

					SELECT COUNT(*) INTO num 
					FROM USERS
					WHERE USERNAME = u AND IDUSER <> id;
							
					CASE num 
					WHEN 0 THEN 
						begin
							DECLARE num INTEGER DEFAULT 0;
							SELECT COUNT(*) INTO num 
							FROM (
								SELECT IDUSER INTO id
								FROM USERS
								WHERE EMAIL = mail);
							CASE num
							WHEN 0 THEN 
								UPDATE USERS SET USERNAME=n_u, PASSWORD=n_p, EMAIL=n_mail, HINT=n_h
									WHERE IDUSER = id;
								SET err = 15;
							WHEN 1 THEN
								SET err = 7; --EMAIL repeated
							ELSE
								SET err = 4;
							END CASE;
						end
					WHEN 1 THEN
						SET err = 6;
					ELSE
						SET err = 4;
					END CASE;
					
				end;
			ELSE 
				SET err = 2;
			END IF;
		end
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,   id,    NULL,  err,  5, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 15, 0, ERRORCODE) AS ERRORCODE, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

CREATE DEFINER=`alex`@`localhost` PROCEDURE `createhouse`( IN u VARCHAR(30), IN h VARCHAR(30), IN c VARCHAR(30), IN ctry VARCHAR(30))
    COMMENT 'Create a new house if not exist.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

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
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 17, 0, err),  7, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 17, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$


CREATE DEFINER=`alex`@`localhost` PROCEDURE `deletehouse`
( IN u VARCHAR(30), IN h VARCHAR(30))
    COMMENT 'Create a new house if not exist.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

	SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), IFNULL(USERS.IDUSER, 0), IFNULL(HOUSES.IDHOUSE, 0) INTO num, acc, idu, idh
	FROM HOUSES
	JOIN ACCESSHOUSE ON (HOUSES.IDHOUSE= ACCESSHOUSE.IDHOUSE)
	JOIN USERS 		ON (USERS.IDUSER=ACCESSHOUSE.IDUSER)
	WHERE USERNAME = u AND HOUSENAME = h;
			
	CASE num 
	WHEN 1 THEN 
		CASE acc
		WHEN 1 THEN 
			DELETE FROM HOUSES WHERE IDHOUSE= idh;
			SET err = 19;
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
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 19, 0, err),  9, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 19, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$


CREATE DEFINER=`alex`@`localhost` PROCEDURE `createaccesshouse`
( IN u VARCHAR(30), IN h VARCHAR(30), IN u2 VARCHAR(30), IN n INTEGER)
    COMMENT 'Create a new house if not exist.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

	SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), IFNULL(USERS.IDUSER, 0), IFNULL(HOUSES.IDHOUSE, 0) INTO num, acc, idu, idh
	FROM HOUSES
	JOIN ACCESSHOUSE ON (HOUSES.IDHOUSE= ACCESSHOUSE.IDHOUSE)
	JOIN USERS 		ON (USERS.IDUSER=ACCESSHOUSE.IDUSER)
	WHERE USERNAME = u AND HOUSENAME = h;
			
	CASE num 
	WHEN 1 THEN 
		CASE acc
		WHEN 1 THEN 
			SELECT COUNT(*), IDUSER INTO num, idu
			FROM USERS
			WHERE USERNAME = u2;
			IF (num <> 0) THEN 
				INSERT INTO ACCESSHOUSE (IDUSER, IDHOUSE, ACCESSNUMBER, DATEBEGIN) VALUES
										(idu,    idh, 1, CURRENT_TIMESTAMP);
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
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 40, 0, err),  24, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 40, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$


CREATE DEFINER=`alex`@`localhost` PROCEDURE `deleteccesshouse`
( IN u VARCHAR(30), IN h VARCHAR(30), IN u2 VARCHAR(30))
    COMMENT 'Delete the access to a house of a user.'
begin

	DECLARE num,acc INTEGER DEFAULT 0;
	DECLARE idu, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

	SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), IFNULL(USERS.IDUSER, 0), IFNULL(HOUSES.IDHOUSE, 0) INTO num, acc, idu, idh
	FROM HOUSES
	JOIN ACCESSHOUSE ON (HOUSES.IDHOUSE= ACCESSHOUSE.IDHOUSE)
	JOIN USERS 		ON (USERS.IDUSER=ACCESSHOUSE.IDUSER)
	WHERE USERNAME = u AND HOUSENAME = h;
			
	CASE num 
	WHEN 1 THEN 
		CASE acc
		WHEN 1 THEN 
			DELETE FROM ACCESSHOUSE WHERE IDUSER=idu AND IDHOUSE = idh;
			SET err = 41;
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
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 41, 0, err),  24, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 41, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end


CREATE DEFINER=`alex`@`localhost` PROCEDURE `modifyhouse`
( IN u VARCHAR(30), IN h VARCHAR(30), IN n_h VARCHAR(30), IN idim INTEGER, IN c VARCHAR(30), IN ctry VARCHAR(30))
    COMMENT 'Modify house information.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu, idh INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

	SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), USERS.IDUSER, HOUSES.IDHOUSE INTO num, acc, idu, idh
	FROM HOUSES
	JOIN ACCESSHOUSE ON (HOUSES.IDHOUSE= ACCESSHOUSE.IDHOUSE)
	JOIN USERS 		ON (USERS.IDUSER=ACCESSHOUSE.IDUSER)
	WHERE USERNAME = u AND HOUSENAME = h;
			
	CASE num 
	WHEN 1 THEN 
		CASE acc
		WHEN 1 THEN 
			UPDATE HOUSES SET HOUSENAME=n_h, IDIMAGE=idm, CITY=c, COUNTRY=ctry WHERE IDHOUSE = idh;
			SET err = 42;
		WHEN 0 THEN
			SET err = 11;
		ELSE
			SET err = 39;
		END CASE;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 42, 0, err),  20, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 42, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end

CREATE DEFINER=`alex`@`localhost` PROCEDURE `createroom`
( IN u VARCHAR(30), IN h VARCHAR(30), IN r VARCHAR(30))
    COMMENT 'Create a new room if not exist.'
begin

	DECLARE num, acc INTEGER DEFAULT 0;
	DECLARE idu, idh, idr INTEGER DEFAULT NULL;
	DECLARE err INTEGER DEFAULT 0;

	SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), USERS.IDUSER, HOUSES.IDHOUSE INTO num, acc, idu, idh
	FROM HOUSES
	JOIN ACCESSHOUSE ON (HOUSES.IDHOUSE= ACCESSHOUSE.IDHOUSE)
	JOIN USERS 		ON (USERS.IDUSER=ACCESSHOUSE.IDUSER)
	WHERE USERNAME = u AND HOUSENAME = h;
			
	CASE num 
	WHEN 1 THEN 
		CASE acc
		WHEN 1 THEN 
			SELECT COUNT(*) INTO num
			FROM ROOMS
			WHERE ROOMNAME = h AND IDHOUSE = idh;
				
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
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,    idu,   idh,  IF(err = 44, 0, err),  17, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 44, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$






CREATE DEFINER=`alex`@`localhost` PROCEDURE doaction
($user,$house,$room,$service,$action,$data)
( IN u VARCHAR(15), IN p VARCHAR(40))
LANGUAGE SQL
NOT DETERMINISTIC
SQL SECURITY DEFINER
COMMENT 'Send an action to the house to be done by a Arduino device.'
begin

EXPLAIN SELECT `PERMISSIONS`.`PERMISSIONNUMBER`,`ACCESSHOUSE`.`ACCESSNUMBER`,`USERS`.`IDUSER`,`USERS`.`USERNAME`,`HOUSES`.`HOUSENAME`,`ROOMS`.`ROOMNAME`,`SERVICES`.`SERVICENAME`,`DEVICES`.`IPADDRESS`,`ACTIONS`.`ACTIONNAME` FROM USERSPERMISSIONS
RIGHT JOIN `ehcontrol`.`` ON `PERMISSIONS`.`IDUSER` = `USERS`.`IDUSER` 
LEFT JOIN `ehcontrol`.`SERVICES` ON `PERMISSIONS`.`IDSERVICE` = `SERVICES`.`IDSERVICE` 
LEFT JOIN `ehcontrol`.`ACCESSHOUSE` ON `USERS`.`IDUSER` = `ACCESSHOUSE`.`IDUSER` 
LEFT JOIN `ehcontrol`.`ACTIONS` ON `SERVICES`.`IDSERVICE` = `ACTIONS`.`IDSERVICE` 
LEFT JOIN `ehcontrol`.`HOUSES` ON `USERS`.`IDUSER` = `HOUSES`.`IDUSER` 
LEFT JOIN `ehcontrol`.`ROOMS` ON `USERS`.`IDUSER` = `ROOMS`.`IDUSER` 
LEFT JOIN `ehcontrol`.`DEVICES` ON `SERVICES`.`IDDEVICE` = `DEVICES`.`IDDEVICE` 

SELECT `PERMISSIONS`.`PERMISSIONNUMBER`,`ACCESSHOUSE`.`ACCESSNUMBER`,`USERS`.`IDUSER`,`USERS`.`USERNAME`,`HOUSES`.`HOUSENAME`,`ROOMS`.`ROOMNAME`,`SERVICES`.`SERVICENAME`,`DEVICES`.`IPADDRESS`,`ACTIONS`.`ACTIONNAME`
	FROM  USERS
	LEFT JOIN ACCESSHOUSE USING (IDUSER)
	LEFT JOIN HOUSES USING ( IDHOUSE )
	LEFT JOIN ROOMS USING ( IDHOUSE )
	LEFT JOIN SERVICES USING ( IDROOM  )
	LEFT JOIN PERMISSIONS USING (IDSERVICE, IDUSER)
	LEFT JOIN ACTIONS USING ( IDSERVICE  )
	LEFT JOIN PERMISSIONS USING (IDUSER, IDHOUSE)
	WHERE USERS.USERNAME = u 
	ORDER BY USERNAME, HOUSENAME, ROOMNAME, SERVICENAME, ACTIONNAME DESC;

	SELECT `PERMISSIONS`.`PERMISSIONNUMBER`,`ACCESSHOUSE`.`ACCESSNUMBER`,`USERS`.`IDUSER`,`USERS`.`USERNAME`,`HOUSES`.`HOUSENAME`,`ROOMS`.`ROOMNAME`,`SERVICES`.`SERVICENAME`,`DEVICES`.`IPADDRESS`,`ACTIONS`.`ACTIONNAME`
	FROM  USERS
	LEFT JOIN ACCESSHOUSE USING (IDUSER)
	LEFT JOIN HOUSES USING ( IDHOUSE )
	LEFT JOIN ROOMS USING ( IDHOUSE )
	LEFT JOIN SERVICES USING ( IDROOM  )
	LEFT JOIN PERMISSIONS USING (IDSERVICE, IDUSER)
	LEFT JOIN ACTIONS USING ( IDSERVICE  )
	LEFT JOIN PERMISSIONS ON (PERMISSIONS.IDUSER = USERS.IDUSER AND  PERMISSIONS.IDSERVICE=SERVICES.IDSERVICE)
	WHERE 1
	ORDER BY USERNAME, HOUSENAME, ROOMNAME, SERVICENAME, ACTIONNAME DESC;
	
	
SELECT `PERMISSIONS`.`PERMISSIONNUMBER`,`ACCESSHOUSE`.`ACCESSNUMBER`,`USERS`.`IDUSER`,`USERS`.`USERNAME`,`HOUSES`.`HOUSENAME`,`ROOMS`.`ROOMNAME`,`SERVICES`.`SERVICENAME`,`DEVICES`.`IPADDRESS`,`ACTIONS`.`ACTIONNAME`
	FROM  USERS
	LEFT JOIN ACCESSHOUSE USING (IDUSER)
	LEFT JOIN HOUSES USING ( IDHOUSE )
	LEFT JOIN ROOMS USING ( IDHOUSE )
	LEFT JOIN SERVICES USING ( IDROOM  )
	LEFT JOIN DEVICES USING (IDDEVICE)
	LEFT JOIN ACTIONS USING ( IDSERVICE  )
	LEFT JOIN PERMISSIONS ON (PERMISSIONS.IDUSER = USERS.IDUSER AND  PERMISSIONS.IDSERVICE=SERVICES.IDSERVICE)
	WHERE USERS.USERNAME = u 
	ORDER BY USERNAME, HOUSENAME, ROOMNAME, SERVICENAME, ACTIONNAME DESC
end $$



CREATE DEFINER=`alex`@`localhost` PROCEDURE schedule
( IN h VARCHAR(15))
LANGUAGE SQL
NOT DETERMINISTIC
SQL SECURITY DEFINER
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
	ORDER BY TASKNAME DESC;
	

end $$

call createprogramaction( 'bertoldo','casaBertoldo','cocina','LIGHTS', 'ENCENDER', null, CURRENT_TIMESTAMP)

CREATE DEFINER=`alex`@`localhost` PROCEDURE createprogramaction
( IN pa VARCHAR(15), IN x INTEGER, IN u VARCHAR(15), IN h VARCHAR(15),IN r VARCHAR(15),IN s VARCHAR(15), IN a VARCHAR(15), IN des VARCHAR(15), IN d VARCHAR(15), IN t timestamp)
LANGUAGE SQL
NOT DETERMINISTIC
SQL SECURITY DEFINER
COMMENT 'Request for all task afected to a house, by a user.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE ida, idu, idx INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;
	
	SELECT COUNT(*), IFNULL(IDACTION, 0) INTO num, ida
	FROM HOUSES
	JOIN ROOMS 		USING ( IDHOUSE )
	JOIN SERVICES	USING ( IDROOM )
	JOIN ACTIONS	USING ( IDSERVICE )
	WHERE HOUSENAME = h AND ROOMNAME = r AND SERVICENAME = s AND ACTIONNAME = a;
	
	CASE num 
	WHEN 1 THEN 
		begin
			DECLARE num INTEGER DEFAULT 0;
			SELECT COUNT(*), IFNULL(IDUSER, 0) INTO num, idu
			FROM USERS
			WHERE USERNAME = u ;
			
			CASE num
			WHEN 1 THEN 
				INSERT INTO `PROGRAMACTION(`IDPROGRAM`, `PROGRAMNAME`, `NEXT`, `IDUSER`, `IDACTION`, `DESCRIPTION`, `STARTTIME`) VALUES (NULL, pa, idx, idu, ida, des, t);
				
				SET err = 27;
			WHEN 0 THEN
				SET err = 3; 
			ELSE
				SET err = 4;
			END CASE;
		end;
	WHEN 0 THEN
		SET err = 21;
	ELSE
		SET err = 4;
	END CASE;

	SELECT IFNULL(IDUSER, 0) INTO  id
	FROM USERS
	WHERE USERNAME = u;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  id,    NULL,  IF(err = 27, 0, err),  3, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 27, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end $$

CREATE DEFINER=`alex`@`localhost` PROCEDURE `deleteprogramaction`( IN u VARCHAR(15), IN idpa INTEGER)
    COMMENT 'Delete program action.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE ida, idu, idh, acc INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;
	
	SELECT COUNT(*), IFNULL(IDACTION, 0) INTO num, ida
	FROM PROGRAMACTIONS
	WHERE IDPROGRAM = idpa ;
	
	CASE num 
	WHEN 1 THEN
		SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), IFNULL(IDUSER, 0), IFNULL(IDHOUSE, 0) INTO num, acc, idu, idh
		FROM HOUSES
		JOIN ROOMS 		USING ( IDHOUSE )
		JOIN SERVICES	USING ( IDROOM )
		JOIN ACTIONS	USING ( IDSERVICE )
		JOIN ACCESSHOUSE USING (IDHOUSE)
		JOIN USERS 		USING (IDUSER)
		WHERE IDACTION = ida AND USERNAME = u;
	
		CASE num
		WHEN 1 THEN
			CASE acc
			WHEN 1 THEN 
				DELETE FROM PROGRAMACTIONS WHERE IDACTION = idpa;
				SET err = 28;
			WHEN 0 THEN
				SET err = 11;
			ELSE
				SELECT COUNT(*), IFNULL(PERMISSIONNUMBER, 0) INTO num, per
				FROM USERS 
				JOIN PERMISSIONS USING (IDUSER)
				JOIN ACTIONS	USING ( IDSERVICE )
				WHERE IDACTION = ida AND USERNAME=u;
				
				CASE num
				WHEN 1 THEN
					CASE per
					WHEN 1 THEN
						DELETE FROM PROGRAMACTIONS WHERE IDACTION = idpa;
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
	

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    idh,  IF(err = 28, 0, err),  15, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 28, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$


CREATE DEFINER=`alex`@`localhost` PROCEDURE `createtask`( IN u VARCHAR(15), IN ta VARCHAR(15),IN des VARCHAR(50),IN fre timestamp)
    COMMENT 'Create a task, will group programaction.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;
	
	SELECT COUNT(*), IFNULL(IDUSER, 0) INTO num, idu
	FROM USERS
	WHERE USERNAME = u;
	
	CASE num 
	WHEN 1 THEN 
		SELECT COUNT(*) INTO num
		FROM TASKS
		WHERE IDUSER = idu AND TASKNAME = ta;
		
		CASE num 
		WHEN 0 THEN 
			INSERT INTO `TASKS` (`IDTASK`, `TASKNAME`, `IDUSER`, `DESCRIPTION`, `PERIODICITY`, `DATEBEGIN`) 
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

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    null,  IF(err = 29, 0, err),  11, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 29, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$


CREATE DEFINER=`alex`@`localhost` PROCEDURE `deletetask`( IN u VARCHAR(15), IN ta VARCHAR(15))
    COMMENT 'Delete a user task.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE idu, idta INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;
	
	SELECT COUNT(*), IFNULL(IDUSER, 0) INTO num, idu
	FROM USERS
	WHERE USERNAME = u;
	
	CASE num 
	WHEN 1 THEN 
		SELECT COUNT(*), IFNULL(IDTASK, 0) INTO num, idta
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

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    null,  IF(err = 30, 0, err),  12, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 30, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$



CREATE DEFINER=`alex`@`localhost` PROCEDURE `addtaskprogram`( IN u VARCHAR(15), IN idta INTEGER,IN idpa INTEGER)
    COMMENT 'add an acction to a task.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE ida, idu, idh, acc INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;
	
	SELECT COUNT(*), IFNULL(IDACTION, 0), IFNULL(IDUSER, 0) INTO num, ida, idu
	FROM PROGRAMACTIONS, USERS
	WHERE IDPROGRAM = idpa AND PROGRAMACRIONS.IDUSER = USERS.IDUSER AND USERNAME = u;
	
	CASE num 
	WHEN 1 THEN
	
		SELECT COUNT(*) INTO num
		FROM TASKS
		WHERE IDTASK = idpa AND IDUSER = idu;
		
		CASE num
		WHEN 1 THEN
			INSERT INTO TASKPROGRAM (IDTASK, IDPROGRAM) VALUE (idta, idpa);
			SET err = 34;
		ELSE
			SET err = 32;
		END CASE;
	WHEN 0 THEN
		SET err = 33;
	ELSE
		SET err = 4;
	END CASE;
	
	SELECT IDHOUSE INTO idh
	FROM HOUSES
	JOIN ROOMS 		USING ( IDHOUSE )
	JOIN SERVICES	USING ( IDROOM )
	JOIN ACTIONS	USING ( IDSERVICE )
	WHERE IDACTION = ida;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    idh,  IF(err = 34, 0, err),  21, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 34, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$


CREATE DEFINER=`alex`@`localhost` PROCEDURE `removetaskprogram`( IN u VARCHAR(15), IN idta INTEGER,IN idpa INTEGER)
    COMMENT 'add an acction to a task.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE ida, idu, idh INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;
	
	SELECT COUNT(*), IFNULL(IDACTION, 0), IFNULL(IDUSER, 0) INTO num, ida, idu
	FROM PROGRAMACTIONS, USERS
	WHERE IDPROGRAM = idpa AND PROGRAMACRIONS.IDUSER = USERS.IDUSER AND USERNAME = u;
	
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
	FROM HOUSES
	JOIN ROOMS 		USING ( IDHOUSE )
	JOIN SERVICES	USING ( IDROOM )
	JOIN ACTIONS	USING ( IDSERVICE )
	WHERE IDACTION = ida;
	
	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    idh,  IF(err = 35, 0, err),  22, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 35, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

SELECT month,
       MAX(CASE WHEN unit = 'CS-1' THEN value END) `CS-1`,
       MAX(CASE WHEN unit = 'CS-2' THEN value END) `CS-2`,
       MAX(CASE WHEN unit = 'CS-3' THEN value END) `CS-3`
  FROM
(
  SELECT unit, month,
         CASE month 
            WHEN 'JAN' THEN jan
            WHEN 'FEB' THEN feb
            WHEN 'MAR' THEN mar
            WHEN 'APR' THEN apr
            WHEN 'MAY' THEN may
            WHEN 'JUN' THEN jun
         END value
    FROM table1 t CROSS JOIN
  (
    SELECT 'JAN' month UNION ALL
    SELECT 'FEB' UNION ALL
    SELECT 'MAR' UNION ALL
    SELECT 'APR' UNION ALL
    SELECT 'MAY' UNION ALL
    SELECT 'JUN'
  ) c
) q
 GROUP BY month

 
 mysqlslap --user=alex -p --delimiter=";"   --create="CREATE TABLE a (b int);INSERT INTO a VALUES (23)"  --query="SELECT * FROM a" --concurrency=50 --iterations=200
 
 select `ehcontrol`.`USERS`.`USERNAME` AS `USERNAME`,`ehcontrol`.`FUNCTIONS`.`FUNCTION` AS `FUNCTION`,count(0) AS `TOTAL`,sum(if((`ehcontrol`.`HISTORYACCESS`.`ERROR` = 0),1,0)) AS `SUCCESS`,sum(if((`ehcontrol`.`HISTORYACCESS`.`ERROR` <> 0),1,0)) AS `ERROR`,sum(if((`ehcontrol`.`HISTORYACCESS`.`ERROR` = 2),1,0)) AS `PASSWORD`,sum(if((`ehcontrol`.`HISTORYACCESS`.`ERROR` = 4),1,0)) AS `INTEGRITY` from (((`ehcontrol`.`USERS` left join `ehcontrol`.`HISTORYACCESS` on((`ehcontrol`.`USERS`.`IDUSER` = `ehcontrol`.`HISTORYACCESS`.`IDUSER`))) left join `ehcontrol`.`FUNCTIONS` on((`ehcontrol`.`HISTORYACCESS`.`FUNCT` = `ehcontrol`.`FUNCTIONS`.`FUNCT`))) join `ehcontrol`.`ERRORS` on((`ehcontrol`.`ERRORS`.`ERRORCODE` = `ehcontrol`.`HISTORYACCESS`.`ERROR`))) group by `ehcontrol`.`USERS`.`USERNAME`,`ehcontrol`.`FUNCTIONS`.`FUNCTION` order by count(0) desc
 
 
 mysqlslap --user=alex --password=alex --auto-generate-sql --concurrency=50 --iterations=10 --number-char-cols=4
 
 mysqlslap --user=alex --password=alex --auto-generate-sql --concurrency=100 --iterations=10 --number-char-cols=4
 
  mysqlslap --user=alex --password=alex --create-schema=world --query="SELECT City.Name, City.District FROM City, Country WHERE City.CountryCode = Country.Code AND Country.Code = 'IND';" --concurrency=100 --iterations=5

  mysqlslap --user=alex --password=alex --auto-generate-sql --concurrency=100 --number-of-queries=700 --engine=innodb
 
 
 mysqlslap --user=alex --password=alex --auto-generate-sql --concurrency=100 --number-of-queries=700 --engine=myisam
 
 mysqlslap --user=alex --password=alex --create-schema=ehcontrol --auto-generate-sql --concurrency=100 --number-of-queries=700
 
 mysqlslap --user=alex --password=alex --create-schema=ehcontrol --query="select ehcontrol.USERS.USERNAME AS USERNAME,ehcontrol.FUNCTIONS.FUNCTION AS FUNCTION,count(0) AS TOTAL,sum(if((ehcontrol.HISTORYACCESS.ERROR = 0),1,0)) AS SUCCESS,sum(if((ehcontrol.HISTORYACCESS.ERROR <> 0),1,0)) AS ERROR,sum(if((ehcontrol.HISTORYACCESS.ERROR = 2),1,0)) AS PASSWORD,sum(if((ehcontrol.HISTORYACCESS.ERROR = 4),1,0)) AS INTEGRITY from (((ehcontrol.USERS left join ehcontrol.HISTORYACCESS on((ehcontrol.USERS.IDUSER = ehcontrol.HISTORYACCESS.IDUSER))) left join ehcontrol.FUNCTIONS on((ehcontrol.HISTORYACCESS.FUNCT = ehcontrol.FUNCTIONS.FUNCT))) join ehcontrol.ERRORS on((ehcontrol.ERRORS.ERRORCODE = ehcontrol.HISTORYACCESS.ERROR))) group by ehcontrol.USERS.USERNAME,ehcontrol.FUNCTIONS.FUNCTION order by count(0) desc" --concurrency=100 --number-of-queries=700
 
 
 
 
 
 	Cotejamiento
UPDATE USERS 
latin1_swedish_ci 	



 	utf8_general_ci





DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ACCESSHOUSE`
--

CREATE TABLE IF NOT EXISTS `ACCESSHOUSE` (
  `IDUSER` int(11) NOT NULL DEFAULT '0',
  `IDHOUSE` int(11) NOT NULL DEFAULT '0',
  `ACCESSNUMBER` int(11) DEFAULT NULL,
  `DATEBEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDUSER`,`IDHOUSE`),
  KEY `IDHOUSE` (`IDHOUSE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `ACCESSHOUSE`
--

INSERT INTO `ACCESSHOUSE` (`IDUSER`, `IDHOUSE`, `ACCESSNUMBER`, `DATEBEGIN`) VALUES
(0, 11, 1, '2014-03-25 21:39:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ACTIONMESSAGES`
--

CREATE TABLE IF NOT EXISTS `ACTIONMESSAGES` (
  `IDMESSAGE` int(11) NOT NULL AUTO_INCREMENT,
  `IDACTION` int(11) NOT NULL,
  `RETURNCODE` varchar(20) NOT NULL,
  `EXIT` tinyint(1) NOT NULL,
  `ENGLISH` varchar(50) DEFAULT NULL,
  `SPANISH` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IDMESSAGE`),
  UNIQUE KEY `IDACTION_RETURNCODE` (`IDACTION`,`RETURNCODE`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=22 ;

--
-- Volcado de datos para la tabla `ACTIONMESSAGES`
--

INSERT INTO `ACTIONMESSAGES` (`IDMESSAGE`, `IDACTION`, `RETURNCODE`, `EXIT`, `ENGLISH`, `SPANISH`) VALUES
(2, 0, '0', 0, 'Service off.', 'Servicio apagado.'),
(3, 0, '1', 1, 'Conexion error.', 'Error de conexión.'),
(4, 0, '2', 1, 'Device out of conection.', 'Dispositivo fuera de conexión.'),
(5, 0, '4', 1, 'The function have a bug.', 'La función tiene un bug.'),
(6, 1, '0', 0, 'Reset success.', 'Reseteo satisfactorio.'),
(7, 1, '1', 1, 'Conection failure.', 'Fallo de conexión.'),
(8, 1, '2', 1, 'Connection out.', 'Fuera de conexión.'),
(9, 2, '0', 0, 'Service on.', 'Servicio encendido.'),
(10, 2, '1', 1, 'Service can''t be on.', 'El servicio no puede encenderse.'),
(11, 2, '2', 1, 'Service without battery.', 'Servicio sin batería.'),
(12, 3, '0', 0, 'Proper Shipping.', 'Envío correcto.'),
(13, 3, '1', 1, 'Send failure.', 'Fallo en el envío.'),
(15, 3, '3', 1, 'Shipping unanswered.', 'Envío sin respuesta.'),
(16, 4, '0', 0, 'Data received.', 'Datos recibidos.'),
(17, 4, '1', 1, ' Incorrect data.', 'Datos incorrectos'),
(18, 4, '3', 1, ' Failed connection.', 'Conexión fallida.'),
(19, 5, '0', 0, ' Updated configuration.', 'Configuración actualizada.'),
(20, 5, '2', 1, 'Denial of permission.', 'Denegación de permiso.'),
(21, 5, '1', 1, ' The device does not respond.', 'El dispositivo no responde.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ACTIONS`
--

CREATE TABLE IF NOT EXISTS `ACTIONS` (
  `IDACTION` int(11) NOT NULL AUTO_INCREMENT,
  `IDSERVICE` int(11) DEFAULT NULL,
  `ACTIONNAME` varchar(10) NOT NULL,
  `ENGLISH` varchar(50) NOT NULL,
  `SPANISH` varchar(50) NOT NULL,
  `FCODE` varchar(20) NOT NULL,
  PRIMARY KEY (`IDACTION`),
  UNIQUE KEY `UNQ_ACTIONKEY` (`IDSERVICE`,`ACTIONNAME`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=93 ;

--
-- Volcado de datos para la tabla `ACTIONS`
--

INSERT INTO `ACTIONS` (`IDACTION`, `IDSERVICE`, `ACTIONNAME`, `ENGLISH`, `SPANISH`, `FCODE`) VALUES
(0, NULL, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(1, NULL, 'RESETEAR', 'RESET', 'RESETEAR', '0x002221'),
(2, NULL, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(3, NULL, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(4, NULL, 'RECIBIR', 'RECIVE', 'RECIBIR', '0x002456'),
(5, NULL, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002787');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `DEVICES`
--

CREATE TABLE IF NOT EXISTS `DEVICES` (
  `IDDEVICE` int(11) NOT NULL AUTO_INCREMENT,
  `IPADDRESS` varchar(20) DEFAULT NULL,
  `SERIAL` varchar(20) DEFAULT NULL,
  `NAME` varchar(20) DEFAULT NULL,
  `ENGLISH` varchar(500) DEFAULT NULL,
  `SPANISH` varchar(500) DEFAULT NULL,
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `VERSION` int(11) NOT NULL,
  PRIMARY KEY (`IDDEVICE`),
  UNIQUE KEY `SERIAL` (`SERIAL`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Volcado de datos para la tabla `DEVICES`
--

INSERT INTO `DEVICES` (`IDDEVICE`, `IPADDRESS`, `SERIAL`, `NAME`, `ENGLISH`, `SPANISH`, `DATE`, `VERSION`) VALUES
(0, NULL, NULL, 'Arduino UNO', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1),
(1, NULL, NULL, 'Arduino DUO', '{"Microcontroller":"AT91SAM3X8E","Operating Voltage":"3.3V","Input Voltage (recommended)":"7-12V","Input Voltage (limits)":"6-16V","Digital I/O Pins":"54 (of which 12 provide PWM output)","Analog Input Pins":"12","Analog Outputs Pins":"2 (DAC)","Total DC Output Current on all I/O lines":"130 mA","DC Current for 3.3V Pin":"800 mA","DC Current for 5V Pin":"800 mA","Flash Memory":"512 KB all available for the user applications","SRAM":"96 KB (two banks: 64KB and 32KB)","Clock Speed":"84 MHz"}', '{"Microcontroller":"AT91SAM3X8E","Operating Voltage":"3.3V","Input Voltage (recommended)":"7-12V","Input Voltage (limits)":"6-16V","Digital I/O Pins":"54 (of which 12 provide PWM output)","Analog Input Pins":"12","Analog Outputs Pins":"2 (DAC)","Total DC Output Current on all I/O lines":"130 mA","DC Current for 3.3V Pin":"800 mA","DC Current for 5V Pin":"800 mA","Flash Memory":"512 KB all available for the user applications","SRAM":"96 KB (two banks: 64KB and 32KB)","Clock Speed":"84 MHz"}', '2014-03-23 21:35:50', 1);
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ERRORS`
--

CREATE TABLE IF NOT EXISTS `ERRORS` (
  `ERRORCODE` int(11) NOT NULL AUTO_INCREMENT,
  `ENGLISH` varchar(50) NOT NULL,
  `SPANISH` varchar(50) NOT NULL,
  PRIMARY KEY (`ERRORCODE`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=22 ;

--
-- Volcado de datos para la tabla `ERRORS`
--

INSERT INTO `ERRORS` (`ERRORCODE`, `ENGLISH`, `SPANISH`) VALUES
(0, 'SUCCESS', 'CORRECTO'),
(1, 'Insert abort.', 'Inserción abortada.'),
(2, 'Incorrect password.', 'La contraseña es incorrecta.'),
(3, 'This user does not exist.', 'Este usuario no existe.'),
(4, 'Database integrity break.', 'Integridad de la base de datos rota.'),
(5, 'The action or service does not exist.', 'La acción o servicio no existe.'),
(6, 'This user already exists.', 'Este usuario ya existe.'),
(7, 'This email already has an account associated.', 'Este email ya tiene una cuenta asociada.'),
(8, 'This house does not exist.', 'La casa no existe.'),
(9, 'This room does not exist in the house.', 'Esta habitación no existe en la casa.'),
(10, 'Requires permission.', 'Necesita permisos.'),
(11, 'Requires access.', 'Necesita acceso.'),
(12, 'Email password recovery sent.', 'Correo de recuperacion de contraseña enviado.'),
(13, 'Create new user.', 'Nuevo usuario creado.'),
(14, 'Deleted user.', 'Usuario eliminado.'),
(15, 'User modified.', 'Usuario modificado.'),
(16, 'Action sent.', 'Acción enviada.'),
(17, 'Create new house.', 'Nueva casa creada.'),
(18, 'You have not access to this house.', 'No tiene acceso a la casa.'),
(19, 'House deleted.', 'Casa eliminada.'),
(20, 'This service does not exist for the room.', 'Este servicio no existe para la habitación.'),
(21, 'This action does not exist for this service.', 'Esta acción no existe para este servicio.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `FUNCTIONS`
--

CREATE TABLE IF NOT EXISTS `FUNCTIONS` (
  `FUNCT` int(11) NOT NULL AUTO_INCREMENT,
  `FUNCTION` varchar(20) NOT NULL,
  PRIMARY KEY (`FUNCT`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Volcado de datos para la tabla `FUNCTIONS`
--

INSERT INTO `FUNCTIONS` (`FUNCT`, `FUNCTION`) VALUES
(0, '----'),
(1, 'login'),
(2, 'lostpass'),
(3, 'createuser'),
(4, 'deleteuser'),
(5, 'modifyuser'),
(6, 'doaction'),
(7, 'createhouse'),
(8, 'ipcheck'),
(9, 'deletehouse'),
(10, 'getweather');
(11, 'createhouse'),
(12, 'deletehouse'),
(13, 'modifyhouse'),
(14, 'createroom'),
(15, 'deleteroom'),
(16, 'modifyroom'),
(17, 'createdevice'),
(18, 'deletedevice'),
(19, 'modifydevice'),
(20, 'createtask'),
(21, 'deletetask'),
(22, 'modifytask'),
(23, 'createaction'),
(24, 'deleteaction'),
(25, 'modifyaction'),
(26, 'createprogramaction'),
(27, 'deleteprogramaction'),
(28, 'modifyprogramaction'),
(29, 'createaccess'),
(30, 'deleteaccess'),
(31, 'modifyaccess'),
(32, 'createpermission'),
(33, 'deletepermission'),
(34, 'modifypermission');


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HISTORYACCESS`
--

CREATE TABLE IF NOT EXISTS `HISTORYACCESS` (
  `IDHISTORY` int(11) NOT NULL AUTO_INCREMENT,
  `IDUSER` int(11) NOT NULL,
  `IDHOUSE` int(11) DEFAULT NULL,
  `ERROR` int(11) NOT NULL,
  `FUNCT` int(11) NOT NULL,
  `DATESTAMP` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDHISTORY`),
  KEY `ERROR` (`ERROR`),
  KEY `FUNCT` (`FUNCT`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1524 ;

--
-- Volcado de datos para la tabla `HISTORYACCESS`
--

INSERT INTO `HISTORYACCESS` (`IDHISTORY`, `IDUSER`, `IDHOUSE`, `ERROR`, `FUNCT`, `DATESTAMP`) VALUES
(1235, 10, NULL, 0, 1, '2014-04-02 15:05:50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HISTORYACTION`
--

CREATE TABLE IF NOT EXISTS `HISTORYACTION` (
  `IDHISTORYACTION` int(11) NOT NULL AUTO_INCREMENT,
  `IDACTION` int(11) NOT NULL,
  `IDPROGRAM` int(11) DEFAULT NULL,
  `IDUSER` int(11) DEFAULT NULL,
  `RETURNCODE` varchar(20) NOT NULL,
  `DATESTAMP` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDHISTORYACTION`),
  KEY `IDUSER` (`IDUSER`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=225 ;

--
-- Volcado de datos para la tabla `HISTORYACTION`
--

INSERT INTO `HISTORYACTION` (`IDHISTORYACTION`, `IDACTION`, `IDPROGRAM`, `IDUSER`, `RETURNCODE`, `DATESTAMP`) VALUES
(224, 1, NULL, 29, '013216722135132', '2014-04-04 18:55:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HOUSES`
--

CREATE TABLE IF NOT EXISTS `HOUSES` (
  `IDHOUSE` int(11) NOT NULL AUTO_INCREMENT,
  `IDUSER` int(11) NOT NULL,
  `HOUSENAME` varchar(15) NOT NULL,
  `GPS` varchar(10) DEFAULT NULL,
  `DATEBEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDHOUSE`),
  UNIQUE KEY `HOUSENAME` (`HOUSENAME`),
  KEY `IDUSER` (`IDUSER`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Volcado de datos para la tabla `HOUSES`
--

INSERT INTO `HOUSES` (`IDHOUSE`, `IDUSER`, `HOUSENAME`, `GPS`, `DATEBEGIN`) VALUES
(1, 1, 'mi casa', '37.6735925', '2014-03-04 05:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `IRCODES`
--

CREATE TABLE IF NOT EXISTS `IRCODES` (
  `IDCODE` int(11) NOT NULL AUTO_INCREMENT,
  `TYPE` varchar(20) NOT NULL,
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `IRCODES`
--

INSERT INTO `IRCODES` (`IDCODE`, `TYPE`, `POWER`, `SETUP`, `MUTE`, `FUNCTION`, `UNO`, `DOS`, `TRES`, `CUATRO`, `CINCO`, `SEIS`, `SIETE`, `OCHO`, `NUEVE`, `CERO`, `FAV`, `UP`, `LEFT`, `PLAY`, `RIGHT`) VALUES
(1, 'TV NPG', 16722135, 16771605, 16745085, NULL, 16748655, 16758855, 16775175, 16756815, 16750695, 16767015, 16746615, 16754775, 16771095, 16730295, 16732845, 16769055, 16718055, 16720605, 16773135);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PERMISSIONS`
--

CREATE TABLE IF NOT EXISTS `PERMISSIONS` (
  `IDUSER` int(11) NOT NULL DEFAULT '0',
  `IDSERVICE` int(11) NOT NULL,
  `PERMISSIONNUMBER` int(11) NOT NULL,
  `DATEBEGIN` date DEFAULT NULL,
  PRIMARY KEY (`IDUSER`,`IDSERVICE`),
  KEY `IDSERVICE` (`IDSERVICE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PROGRAMACTIONS`
--

CREATE TABLE IF NOT EXISTS `PROGRAMACTIONS` (
  `IDPROGRAM` int(11) NOT NULL AUTO_INCREMENT,
  `NEXT` int(11) DEFAULT NULL,
  `IDUSER` int(11) NOT NULL,
  `IDACTION` int(11) NOT NULL,
  `DESCRIPTION` varchar(50) DEFAULT NULL,
  `STARTTIME` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `PERIODICITY` int(1) DEFAULT NULL,
  PRIMARY KEY (`IDPROGRAM`),
  UNIQUE KEY `NEXT` (`NEXT`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Volcado de datos para la tabla `PROGRAMACTIONS`
--

INSERT INTO `PROGRAMACTIONS` (`IDPROGRAM`, `NEXT`, `IDUSER`, `IDACTION`, `DESCRIPTION`, `STARTTIME`, `PERIODICITY`) VALUES
(1, NULL, 1, 3, NULL, NULL, NULL),
(2, NULL, 1, 1, NULL, NULL, NULL),
(3, NULL, 12, 4, NULL, NULL, NULL),
(4, NULL, 12, 3, NULL, NULL, NULL),
(5, 1, 1, 15, NULL, NULL, NULL),
(6, 5, 12, 2, NULL, NULL, NULL),
(7, 2, 29, 3, NULL, NULL, NULL),
(10, 3, 10, 2, NULL, NULL, NULL),
(11, 4, 29, 2, NULL, NULL, NULL),
(12, 6, 1, 3, NULL, NULL, NULL),
(13, 7, 10, 4, NULL, NULL, NULL),
(14, NULL, 11, 2, NULL, NULL, NULL),
(15, NULL, 11, 2, NULL, NULL, NULL),
(16, NULL, 10, 2, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ROOMS`
--

CREATE TABLE IF NOT EXISTS `ROOMS` (
  `IDROOM` int(11) NOT NULL AUTO_INCREMENT,
  `IDHOUSE` int(11) DEFAULT NULL,
  `IDUSER` int(11) DEFAULT NULL,
  `ROOMNAME` varchar(10) NOT NULL,
  `DATEBEGIN` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDROOM`),
  UNIQUE KEY `ROOMNAME` (`ROOMNAME`,`IDHOUSE`),
  KEY `IDHOUSE` (`IDHOUSE`),
  KEY `IDUSER` (`IDUSER`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;

--
-- Volcado de datos para la tabla `ROOMS`
--

INSERT INTO `ROOMS` (`IDROOM`, `IDHOUSE`, `IDUSER`, `ROOMNAME`, `DATEBEGIN`) VALUES
(1, 9, 29, 'cocina', '2014-03-23 20:00:53');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `SERVICES`
--

CREATE TABLE IF NOT EXISTS `SERVICES` (
  `IDSERVICE` int(11) NOT NULL AUTO_INCREMENT,
  `IDROOM` int(11) DEFAULT NULL,
  `IDDEVICE` int(11) DEFAULT NULL,
  `SERVICENAME` varchar(20) NOT NULL,
  `FCODE` int(11) DEFAULT NULL,
  `ENGLISH` varchar(50) DEFAULT NULL,
  `SPANISH` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IDSERVICE`),
  UNIQUE KEY `UNQ_IDROOM_IDDEVICE_SERVICENAME` (`IDROOM`,`IDDEVICE`,`SERVICENAME`),
  KEY `IDDEVICE` (`IDDEVICE`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=61 ;

--
-- Volcado de datos para la tabla `SERVICES`
--

INSERT INTO `SERVICES` (`IDSERVICE`, `IDROOM`, `IDDEVICE`, `SERVICENAME`, `FCODE`, `ENGLISH`, `SPANISH`) VALUES
(0, NULL, NULL, 'TV', NULL, 'Universal remote for TV.', 'Mando universal para televición.'),
(1, NULL, NULL, 'IRRIGATION', NULL, 'For plant drink.', 'Riego de plantas.'),
(2, NULL, NULL, 'INFRARED', NULL, 'For control all infrared devices.', 'Control generico de dispositivos infrarrojos.'),
(3, NULL, NULL, 'LIGHTS', NULL, 'Ligths control.', 'Control de las luces.'),
(4, NULL, NULL, 'SENSOR', NULL, 'Control safety sensors.', 'Control de sensores de seguridad.'),
(5, NULL, NULL, 'BLINDS', NULL, 'Control motorized blinds.', 'Control de persianas motorizadas.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `SOFTWARE`
--

CREATE TABLE IF NOT EXISTS `SOFTWARE` (
  `DEVICE` int(11) NOT NULL,
  `VERSION` int(11) NOT NULL,
  `PACKAGE` varchar(1000) NOT NULL,
  UNIQUE KEY `DEVICE` (`DEVICE`,`VERSION`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `TASKS`
--

CREATE TABLE IF NOT EXISTS `TASKS` (
  `IDTASK` int(11) NOT NULL AUTO_INCREMENT,
  `IDUSER` int(11) DEFAULT NULL,
  `IDPROGRAM` int(11) DEFAULT NULL,
  `DESCRIPTION` varchar(50) DEFAULT NULL,
  `STARTTIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `PERIODICITY` int(1) DEFAULT NULL,
  PRIMARY KEY (`IDTASK`),
  KEY `IDPROGRAM` (`IDPROGRAM`),
  KEY `IDUSER` (`IDUSER`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Volcado de datos para la tabla `TASKS`
--

INSERT INTO `TASKS` (`IDTASK`, `IDUSER`, `IDPROGRAM`, `DESCRIPTION`, `STARTTIME`, `PERIODICITY`) VALUES
(1, 1, 7, NULL, '2014-03-13 16:45:44', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `USERS`
--

CREATE TABLE IF NOT EXISTS `USERS` (
  `IDUSER` int(11) NOT NULL AUTO_INCREMENT,
  `USERNAME` varchar(15) NOT NULL,
  `PASSWORD` varchar(40) NOT NULL,
  `EMAIL` varchar(40) NOT NULL,
  `HINT` varchar(30) DEFAULT NULL,
  `DATEBEGIN` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDUSER`),
  UNIQUE KEY `USERNAME` (`USERNAME`),
  UNIQUE KEY `EMAIL` (`EMAIL`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=73 ;

--
-- Volcado de datos para la tabla `USERS`
--

INSERT INTO `USERS` (`IDUSER`, `USERNAME`, `PASSWORD`, `EMAIL`, `HINT`, `DATEBEGIN`) VALUES
(0, 'administrator', '', '', NULL, '2014-03-25 10:36:01');

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ACCESSHOUSE`
--
ALTER TABLE `ACCESSHOUSE`
  ADD CONSTRAINT `ACCESSHOUSE_ibfk_1` FOREIGN KEY (`IDHOUSE`) REFERENCES `HOUSES` (`IDHOUSE`),
  ADD CONSTRAINT `ACCESSHOUSE_ibfk_2` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`);

--
-- Filtros para la tabla `ACTIONMESSAGES`
--
ALTER TABLE `ACTIONMESSAGES`
  ADD CONSTRAINT `ACTIONMESSAGES_ibfk_1` FOREIGN KEY (`IDACTION`) REFERENCES `ACTIONS` (`IDACTION`);

--
-- Filtros para la tabla `ACTIONS`
--
ALTER TABLE `ACTIONS`
  ADD CONSTRAINT `ACTIONS_ibfk_1` FOREIGN KEY (`IDSERVICE`) REFERENCES `SERVICES` (`IDSERVICE`);

--
-- Filtros para la tabla `HISTORYACCESS`
--
ALTER TABLE `HISTORYACCESS`
  ADD CONSTRAINT `HISTORYACCESS_ibfk_3` FOREIGN KEY (`ERROR`) REFERENCES `ERRORS` (`ERRORCODE`),
  ADD CONSTRAINT `HISTORYACCESS_ibfk_4` FOREIGN KEY (`FUNCT`) REFERENCES `FUNCTIONS` (`FUNCT`);

--
-- Filtros para la tabla `HISTORYACTION`
--
ALTER TABLE `HISTORYACTION`
  ADD CONSTRAINT `HISTORYACTION_ibfk_2` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`);

--
-- Filtros para la tabla `HOUSES`
--
ALTER TABLE `HOUSES`
  ADD CONSTRAINT `HOUSES_ibfk_1` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`);

--
-- Filtros para la tabla `PERMISSIONS`
--
ALTER TABLE `PERMISSIONS`
  ADD CONSTRAINT `PERMISSIONS_ibfk_1` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`),
  ADD CONSTRAINT `PERMISSIONS_ibfk_2` FOREIGN KEY (`IDSERVICE`) REFERENCES `SERVICES` (`IDSERVICE`);

--
-- Filtros para la tabla `PROGRAMACTIONS`
--
ALTER TABLE `PROGRAMACTIONS`
  ADD CONSTRAINT `PROGRAMACTIONS_ibfk_1` FOREIGN KEY (`NEXT`) REFERENCES `PROGRAMACTIONS` (`IDPROGRAM`);

--
-- Filtros para la tabla `ROOMS`
--
ALTER TABLE `ROOMS`
  ADD CONSTRAINT `ROOMS_ibfk_1` FOREIGN KEY (`IDHOUSE`) REFERENCES `HOUSES` (`IDHOUSE`),
  ADD CONSTRAINT `ROOMS_ibfk_2` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`);

--
-- Filtros para la tabla `SERVICES`
--
ALTER TABLE `SERVICES`
  ADD CONSTRAINT `SERVICES_ibfk_1` FOREIGN KEY (`IDROOM`) REFERENCES `ROOMS` (`IDROOM`),
  ADD CONSTRAINT `SERVICES_ibfk_2` FOREIGN KEY (`IDDEVICE`) REFERENCES `DEVICES` (`IDDEVICE`);

--
-- Filtros para la tabla `TASKS`
--
ALTER TABLE `TASKS`
  ADD CONSTRAINT `TASKS_ibfk_1` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
