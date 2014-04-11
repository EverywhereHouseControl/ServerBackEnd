-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 11-04-2014 a las 22:29:07
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
DROP PROCEDURE IF EXISTS `addtaskprogram`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `addtaskprogram`( IN u VARCHAR(15), IN idta INTEGER,IN idpa INTEGER)
    COMMENT 'add an acction to a task.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE ida, idu, idh INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;
	
	SELECT COUNT(*), IFNULL(IDACTION, 0), IFNULL(USERS.IDUSER, 0) INTO num, ida, idu
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

DROP PROCEDURE IF EXISTS `createprogramaction`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `createprogramaction`( IN u VARCHAR(15), IN h VARCHAR(15),IN r VARCHAR(15),IN s VARCHAR(15), IN a VARCHAR(15),IN dat VARCHAR(30), IN t timestamp, IN d timestamp)
    COMMENT 'Program an action to be done.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE ida, idu, idh, ids, acc INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;
	
	SELECT COUNT(*), IFNULL(IDACTION, 0), IFNULL(IDSERVICE, 0), IFNULL(IDHOUSE, 0) INTO num, ida, ids, idh
	FROM HOUSES 
	JOIN ROOMS 		USING ( IDHOUSE ) 
	JOIN SERVICES	USING ( IDROOM ) 
	JOIN ACTIONS	USING ( IDSERVICE ) 
	WHERE HOUSENAME = h AND ROOMNAME = r AND SERVICENAME = s AND ACTIONNAME = a; 
	
	CASE num  
	WHEN 1 THEN  
		begin 
			DECLARE num INTEGER DEFAULT 0;
			SELECT COUNT(*), IFNULL(USERS.IDUSER, 0), IFNULL(ACCESSNUMBER, 0) INTO num, idu, acc 
			FROM USERS,  ACCESSHOUSE
						WHERE USERNAME = u 
						AND USERS.IDUSER = ACCESSHOUSE.IDUSER 
						AND ACCESSHOUSE.IDHOUSE = idh ;
			
			CASE num
			WHEN 1 THEN 
				CASE acc
				WHEN 1 THEN
					INSERT INTO `PROGRAMACTIONS` (`IDPROGRAM`, `IDUSER`, `IDACTION`, `DATA`, `STARTTIME`, `DATEBEGIN`) VALUES (NULL, idu, ida, dat, t, d);
					SET err = 27;
				ELSE
					SELECT COUNT(*), IFNULL(PERMISSIONNUMBER, 0) INTO num, acc 
					FROM PERMISSIONS
						WHERE IDUSER = idu 
							AND IDSERVICE= ids ;
					
					CASE acc
					WHEN 1 THEN
						INSERT INTO `PROGRAMACTIONS` (`IDPROGRAM`, `IDUSER`, `IDACTION`, `DATA`, `STARTTIME`, `DATEBEGIN`) VALUES (NULL, idu, ida, dat, t, d);
						SET err = 27;
					ELSE
						SET err = 10;
					END CASE;
				END CASE;

			WHEN 0 THEN
				SET err = 11; 
			ELSE
				SET err = 4;
			END CASE;
		end;
	WHEN 0 THEN
		SET err = 21;
	ELSE
		SET err = 4;
	END CASE;

	SELECT IFNULL(IDHOUSE, 0) INTO  idh
	FROM HOUSES
	WHERE HOUSENAME = h;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    idh,  IF(err = 27, 0, err),  14, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 27, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `createtask`$$
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

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    null,  IF(err = 29, 0, err),  11, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 29, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `createuser`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `createuser`( IN u VARCHAR(15), IN p VARCHAR(40), IN mail VARCHAR(40), h VARCHAR(30))
    COMMENT 'Create a new user if not exist.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE id INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;

        SELECT COUNT(*), IFNULL(IDUSER, 0) INTO num, id
	FROM USERS
	WHERE USERNAME = u;
			
	CASE num 
	WHEN 0 THEN 
		begin
			DECLARE num INTEGER DEFAULT 0;
			SELECT COUNT(*) INTO num
			FROM USERS
			WHERE EMAIL = mail ;
			CASE num
			WHEN 0 THEN 
				INSERT INTO `USERS` (`IDUSER`, `USERNAME`, `PASSWORD`, `EMAIL`, `HINT`, `DATEBEGIN`) VALUES
									(NULL, u, p, mail, h, CURRENT_TIMESTAMP);

                               SELECT IFNULL(IDUSER, 0) INTO  id
	                       FROM USERS
	                       WHERE USERNAME = u;

				SET err = 13;
			WHEN 1 THEN

                               SELECT IFNULL(IDUSER, 0) INTO  id
	                       FROM USERS
	                       WHERE EMAIL = mail;

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

	SELECT IFNULL(IDUSER, 0) INTO  id
	FROM USERS
	WHERE USERNAME = u;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  id,    NULL,  IF(err = 13, 0, err),  3, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 13, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;
end$$

DROP PROCEDURE IF EXISTS `deleteprogramaction`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `deleteprogramaction`( IN u VARCHAR(15), IN idpa INTEGER)
    COMMENT 'Delete program action.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE ida, idu, idh, acc, per INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;
	
	SELECT COUNT(*), IFNULL(IDACTION, 0) INTO num, ida
	FROM PROGRAMACTIONS
	WHERE IDPROGRAM = idpa ;
	
	CASE num 
	WHEN 1 THEN
		SELECT COUNT(*), IFNULL(ACCESSNUMBER, 0), IFNULL(USERS.IDUSER, 0), IFNULL(HOUSES.IDHOUSE, 0) INTO num, acc, idu, idh
		FROM HOUSES
		JOIN ROOMS 		USING ( IDHOUSE )
		JOIN SERVICES	USING ( IDROOM )
		JOIN ACTIONS	USING ( IDSERVICE )
		JOIN ACCESSHOUSE ON (HOUSES.IDHOUSE= ACCESSHOUSE.IDHOUSE)
		JOIN USERS 		ON (USERS.IDUSER=ACCESSHOUSE.IDUSER)
		WHERE IDACTION = ida AND USERNAME = u;
	
		CASE num
		WHEN 1 THEN
			CASE acc
			WHEN 1 THEN 
				DELETE FROM TASKPROGRAM WHERE IDPROGRAM= idpa;
				DELETE FROM PROGRAMACTIONS WHERE IDPROGRAM= idpa;
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
						DELETE FROM TASKPROGRAM WHERE IDPROGRAM= idpa;
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
	

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,  idu,    idh,  IF(err = 28, 0, err),  15, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 28, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `deletetask`$$
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

DROP PROCEDURE IF EXISTS `deleteuser`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `deleteuser`( IN u VARCHAR(15), IN p VARCHAR(40))
    COMMENT 'Delete user if posible by deleting all information restring.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE id INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;
	DECLARE pass VARCHAR(40);

	
	SELECT COUNT(*), IFNULL(IDUSER,0), IFNULL(PASSWORD,0) INTO num , id, pass
	FROM USERS
	WHERE USERNAME = u;
			
	CASE num 
	WHEN 1 THEN 
			IF (pass = p) THEN 
				DELETE FROM `ACCESSHOUSE` WHERE IDUSER = id;
				DELETE FROM `PERMISSIONS` WHERE IDUSER = id;
				DELETE FROM `TASKS` WHERE IDUSER = id;
				DELETE FROM `USERS` WHERE IDUSER = id;
				SET err = 14;
			ELSE 
				SET err = 2;
			END IF;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,   id,    NULL,  IF(err = 14, 0, err),  4, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 14, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH, p, pass
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `loginJSON`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `loginJSON`( in u VARCHAR(15))
begin

SELECT *
	FROM  loginVIEW
	WHERE USERNAME = u ;

end$$

DROP PROCEDURE IF EXISTS `modifyuser`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `modifyuser`( IN u VARCHAR(15), IN p VARCHAR(40), IN n_u VARCHAR(15), IN n_p VARCHAR(40), IN n_mail VARCHAR(40), n_h VARCHAR(30))
    COMMENT 'Mdify the especcification of an existing user.'
begin

	DECLARE num INTEGER DEFAULT 0;
	DECLARE id INTEGER DEFAULT 0;
	DECLARE pass VARCHAR(40);
	DECLARE err INTEGER DEFAULT 0;

	SELECT COUNT(*), IFNULL(IDUSER, 0), IFNULL(PASSWORD, 0) INTO num, id, pass
	FROM USERS
	WHERE USERNAME = u;
			
	CASE num 
	WHEN 1 THEN 
		IF (pass = p) THEN 
			begin 
				DECLARE num INTEGER DEFAULT 0;

				SELECT COUNT(*) INTO num
				FROM USERS
				WHERE USERNAME = n_u AND IDUSER <> id;
						
				CASE num 
				WHEN 0 THEN 
					begin
						DECLARE num INTEGER DEFAULT 0;
						SELECT COUNT(*) INTO num
						FROM USERS
						WHERE EMAIL = n_mail AND IDUSER <> id;
						CASE num
						WHEN 0 THEN 
							UPDATE USERS SET USERNAME=n_u, PASSWORD=n_p, EMAIL=n_mail, HINT=n_h
								WHERE IDUSER = id;
							SET err = 15;
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
				
			end;
		ELSE 
			SET err = 2;
		END IF;
	WHEN 0 THEN
		SET err = 3;
	ELSE
		SET err = 4;
	END CASE;

	INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
				VALUES  (     NULL,   id,    NULL,  IF(err = 15, 0, err),  5, CURRENT_TIMESTAMP);
				
	SELECT IF(ERRORCODE = 15, 0, ERRORCODE) AS ERROR, ENGLISH, SPANISH
	FROM ERRORS
	WHERE ERRORCODE = err;

end$$

DROP PROCEDURE IF EXISTS `ProG`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `ProG`()
begin 
SELECT * FROM USERS;
end$$

DROP PROCEDURE IF EXISTS `removetaskprogram`$$
CREATE DEFINER=`alex`@`localhost` PROCEDURE `removetaskprogram`( IN u VARCHAR(15), IN idta INTEGER,IN idpa INTEGER)
    COMMENT 'add an acction to a task.'
begin
	DECLARE num INTEGER DEFAULT 0;
	DECLARE ida, idu, idh INTEGER DEFAULT 0;
	DECLARE err INTEGER DEFAULT 0;
	
	SELECT COUNT(*), IFNULL(IDACTION, 0), IFNULL(USERS.IDUSER, 0) INTO num, ida, idu
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
-- Creación: 23-03-2014 a las 19:19:34
--

DROP TABLE IF EXISTS `ACCESSHOUSE`;
CREATE TABLE IF NOT EXISTS `ACCESSHOUSE` (
  `IDUSER` int(11) NOT NULL DEFAULT '0',
  `IDHOUSE` int(11) NOT NULL DEFAULT '0',
  `ACCESSNUMBER` int(11) DEFAULT NULL,
  `DATEBEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDUSER`,`IDHOUSE`),
  KEY `IDHOUSE` (`IDHOUSE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELACIONES PARA LA TABLA `ACCESSHOUSE`:
--   `IDHOUSE`
--       `HOUSES` -> `IDHOUSE`
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

--
-- Volcado de datos para la tabla `ACCESSHOUSE`
--

INSERT INTO `ACCESSHOUSE` (`IDUSER`, `IDHOUSE`, `ACCESSNUMBER`, `DATEBEGIN`) VALUES
(0, 11, 1, '2014-03-25 21:39:58'),
(0, 12, 1, '2014-03-23 19:56:06'),
(0, 13, 1, '2014-03-23 19:56:06'),
(0, 14, 1, '2014-03-23 19:56:06'),
(0, 15, 1, '2014-03-23 19:56:06'),
(2, 10, 1, '2014-03-25 21:39:58'),
(10, 13, 1, '2014-03-25 21:39:58'),
(10, 16, 1, '2014-03-23 19:56:06'),
(29, 9, 2, '2014-03-25 21:39:58'),
(29, 10, 3, '2014-04-05 10:16:17'),
(29, 15, 1, '2014-03-23 19:56:06'),
(29, 16, 1, '2014-03-23 19:56:06'),
(67, 12, 1, '2014-03-23 19:56:06'),
(67, 13, 1, '2014-03-23 19:56:06'),
(67, 14, 1, '2014-03-23 19:56:06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ACTIONMESSAGES`
--
-- Creación: 23-03-2014 a las 16:09:18
--

DROP TABLE IF EXISTS `ACTIONMESSAGES`;
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
-- RELACIONES PARA LA TABLA `ACTIONMESSAGES`:
--   `IDACTION`
--       `ACTIONS` -> `IDACTION`
--

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
-- Creación: 23-03-2014 a las 15:29:32
--

DROP TABLE IF EXISTS `ACTIONS`;
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
-- RELACIONES PARA LA TABLA `ACTIONS`:
--   `IDSERVICE`
--       `SERVICES` -> `IDSERVICE`
--

--
-- Volcado de datos para la tabla `ACTIONS`
--

INSERT INTO `ACTIONS` (`IDACTION`, `IDSERVICE`, `ACTIONNAME`, `ENGLISH`, `SPANISH`, `FCODE`) VALUES
(0, NULL, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(1, NULL, 'RESETEAR', 'RESET', 'RESETEAR', '0x002221'),
(2, NULL, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(3, NULL, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(4, NULL, 'RECIBIR', 'RECIVE', 'RECIBIR', '0x002456'),
(5, NULL, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002787'),
(24, 0, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(25, 0, 'RESETEAR', 'RESET', 'RESETEAR', '0x002221'),
(26, 0, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(27, 0, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(28, 0, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002334'),
(29, 1, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(30, 1, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(31, 1, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002787'),
(32, 2, 'APAGAR', 'OFF', 'APAGAR', '0x118000'),
(33, 2, 'RESETEAR', 'RESET', 'RESETEAR', '0x180001'),
(34, 2, 'ENCENDER', 'ON', 'ENCENDER', '0x002300'),
(35, 2, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(36, 2, 'RECIBIR', 'RECIVE', 'RECIBIR', '0x002456'),
(37, 2, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002787'),
(38, 3, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(39, 3, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(40, 4, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(41, 4, 'RESETEAR', 'RESET', 'RESETEAR', '0x002221'),
(42, 4, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(43, 4, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(44, 4, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002787'),
(45, 4, 'RECIBIR', 'RECIVE', 'RECIBIR', '0x002456'),
(46, 5, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(49, 5, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(50, 5, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(51, 13, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(52, 13, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(53, 14, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(54, 14, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(55, 14, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(56, 15, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(57, 15, 'RESETEAR', 'RESET', 'RESETEAR', '0x002221'),
(58, 15, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(59, 15, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(60, 15, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002334'),
(61, 16, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(62, 16, 'RESETEAR', 'RESET', 'RESETEAR', '0x002221'),
(63, 16, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(64, 16, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(65, 16, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002787'),
(66, 16, 'RECIBIR', 'RECIVE', 'RECIBIR', '0x002456'),
(69, 52, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(70, 53, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(71, 54, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(72, 55, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(73, 56, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(74, 57, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(75, 58, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(76, 59, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(77, NULL, 'APAGAR', 'qaz', 'wsz', '0az'),
(79, 60, 'ENVIAR', 'SEND', 'ENVIAR', '0'),
(81, 34, 'ENVIAR', '', '', ''),
(82, 35, 'ENVIAR', '', '', ''),
(83, 37, 'ENVIAR', '', '', ''),
(84, 39, 'ENVIAR', '', '', ''),
(85, 40, 'ENVIAR', '', '', ''),
(86, 41, 'ENVIAR', '', '', ''),
(87, 43, 'ENVIAR', '', '', ''),
(88, 45, 'ENVIAR', '', '', ''),
(89, 46, 'ENVIAR', '', '', ''),
(90, 42, 'ENVIAR', '', '', ''),
(91, 44, 'ENVIAR', '', '', ''),
(92, 36, 'ENVIAR', '', '', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `DEVICES`
--
-- Creación: 23-03-2014 a las 21:40:50
--

DROP TABLE IF EXISTS `DEVICES`;
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
(1, NULL, NULL, 'Arduino DUO', '{"Microcontroller":"AT91SAM3X8E","Operating Voltage":"3.3V","Input Voltage (recommended)":"7-12V","Input Voltage (limits)":"6-16V","Digital I/O Pins":"54 (of which 12 provide PWM output)","Analog Input Pins":"12","Analog Outputs Pins":"2 (DAC)","Total DC Output Current on all I/O lines":"130 mA","DC Current for 3.3V Pin":"800 mA","DC Current for 5V Pin":"800 mA","Flash Memory":"512 KB all available for the user applications","SRAM":"96 KB (two banks: 64KB and 32KB)","Clock Speed":"84 MHz"}', '{"Microcontroller":"AT91SAM3X8E","Operating Voltage":"3.3V","Input Voltage (recommended)":"7-12V","Input Voltage (limits)":"6-16V","Digital I/O Pins":"54 (of which 12 provide PWM output)","Analog Input Pins":"12","Analog Outputs Pins":"2 (DAC)","Total DC Output Current on all I/O lines":"130 mA","DC Current for 3.3V Pin":"800 mA","DC Current for 5V Pin":"800 mA","Flash Memory":"512 KB all available for the user applications","SRAM":"96 KB (two banks: 64KB and 32KB)","Clock Speed":"84 MHz"}', '2014-03-23 21:35:50', 1),
(9, '12.45.34.123', '5', 'Arduino UNO', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1),
(10, '12.45.34.123', '52.33PL', 'Arduino UNO', '{"Microcontroller":"ATmega328",\r\n    "Operating Voltage":"5V",\r\n    "Input Voltage (recommended)":"7-12V",\r\n    "Input Voltage (limits)":"6-20V",\r\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\r\n    "Analog Input Pins":"6",\r\n    "DC Current per I/O Pin":"40 mA",\r\n    "DC Current for 3.3V Pin":"50 mA",\r\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\r\n    "SRAM":"2 KB (ATmega328)",\r\n    "EEPROM":"1 KB (ATmega328)",\r\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\r\n    "Operating Voltage":"5V",\r\n    "Input Voltage (recommended)":"7-12V",\r\n    "Input Voltage (limits)":"6-20V",\r\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\r\n    "Analog Input Pins":"6",\r\n    "DC Current per I/O Pin":"40 mA",\r\n    "DC Current for 3.3V Pin":"50 mA",\r\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\r\n    "SRAM":"2 KB (ATmega328)",\r\n    "EEPROM":"1 KB (ATmega328)",\r\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1),
(11, '12.45.34.123', '0', 'Arduino UNO', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1),
(12, '12.45.34.123', '1', 'Arduino UNO', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1),
(13, '12.45.34.123', '2', 'Arduino UNO', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1),
(14, '12.45.34.123', '3', 'Arduino UNO', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1),
(15, '12.45.34.123', '12', 'Arduino UNO', '{"Microcontroller":"ATmega328",\r\n    "Operating Voltage":"5V",\r\n    "Input Voltage (recommended)":"7-12V",\r\n    "Input Voltage (limits)":"6-20V",\r\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\r\n    "Analog Input Pins":"6",\r\n    "DC Current per I/O Pin":"40 mA",\r\n    "DC Current for 3.3V Pin":"50 mA",\r\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\r\n    "SRAM":"2 KB (ATmega328)",\r\n    "EEPROM":"1 KB (ATmega328)",\r\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\r\n    "Operating Voltage":"5V",\r\n    "Input Voltage (recommended)":"7-12V",\r\n    "Input Voltage (limits)":"6-20V",\r\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\r\n    "Analog Input Pins":"6",\r\n    "DC Current per I/O Pin":"40 mA",\r\n    "DC Current for 3.3V Pin":"50 mA",\r\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\r\n    "SRAM":"2 KB (ATmega328)",\r\n    "EEPROM":"1 KB (ATmega328)",\r\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ERRORS`
--
-- Creación: 09-04-2014 a las 12:36:30
--

DROP TABLE IF EXISTS `ERRORS`;
CREATE TABLE IF NOT EXISTS `ERRORS` (
  `ERRORCODE` int(11) NOT NULL AUTO_INCREMENT,
  `ENGLISH` varchar(50) CHARACTER SET utf8 NOT NULL,
  `SPANISH` varchar(50) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`ERRORCODE`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=38 ;

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
(21, 'This action does not exist for this service.', 'Esta acción no existe para este servicio.'),
(22, 'This house already exists.', 'Esta casa ya existe.'),
(23, 'This program action already exists.', 'Esta accion programada ya existe.'),
(24, 'This task already exists.', 'Esta tarea ya existe.'),
(25, 'Not allowed to create cyclic tasks.', 'No esta permitido crear tareas ciclicas.'),
(26, 'Next program action does not exist.', 'La accion programada siguiente no existe.'),
(27, 'Create new program action.', 'Nueva acción programada creada.'),
(28, 'Program action deleted.', 'Acción programada eliminada.'),
(29, 'Created new task.', 'Nueva tarea creada.'),
(30, 'Task deleted.', 'Tarea eliminada.'),
(31, 'This task does not exist.', 'Esta tarea no existe.'),
(32, 'The task does not exist or is not of this user.', 'La tarea no existe o no es de este usuario.'),
(33, 'The action does not exist or is not of this user.', 'La accion no existe o no es de este usuario.'),
(34, 'The action has been included in the task.', 'La acción se ha incluido en la tarea.'),
(35, 'The action has been removed in the task.', 'La acción se ha eliminado en la tarea.'),
(36, 'This action is not in the task.', 'Esta acción no esta en la tarea.'),
(37, 'This action is already in the task.', 'Esta acción ya esta en la tarea.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `FUNCTIONS`
--
-- Creación: 09-04-2014 a las 10:50:14
--

DROP TABLE IF EXISTS `FUNCTIONS`;
CREATE TABLE IF NOT EXISTS `FUNCTIONS` (
  `FUNCT` int(11) NOT NULL AUTO_INCREMENT,
  `FUNCTION` varchar(20) NOT NULL,
  PRIMARY KEY (`FUNCT`),
  UNIQUE KEY `FUNCTION` (`FUNCTION`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=24 ;

--
-- Volcado de datos para la tabla `FUNCTIONS`
--

INSERT INTO `FUNCTIONS` (`FUNCT`, `FUNCTION`) VALUES
(0, '----'),
(21, 'addtaskprogram'),
(7, 'createhouse'),
(14, 'createprogramaction'),
(17, 'createroom'),
(11, 'createtask'),
(3, 'createuser'),
(9, 'deletehouse'),
(15, 'deleteprogramaction'),
(18, 'deleteroom'),
(12, 'deletetask'),
(4, 'deleteuser'),
(6, 'doaction'),
(10, 'getweather'),
(8, 'ipcheck'),
(1, 'login'),
(2, 'lostpass'),
(20, 'modifyhouse'),
(16, 'modifyprogramaction'),
(19, 'modifyroom'),
(13, 'modifytask'),
(5, 'modifyuser'),
(22, 'removetaskprogram'),
(23, 'schedulehouse');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HISTORYACCESS`
--
-- Creación: 25-03-2014 a las 10:51:52
--

DROP TABLE IF EXISTS `HISTORYACCESS`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2578 ;

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

--
-- Volcado de datos para la tabla `HISTORYACCESS`
--

INSERT INTO `HISTORYACCESS` (`IDHISTORY`, `IDUSER`, `IDHOUSE`, `ERROR`, `FUNCT`, `DATESTAMP`) VALUES
(92, 10, NULL, 0, 1, '2014-03-25 22:06:30'),
(93, 60, NULL, 0, 3, '2014-03-25 22:08:02'),
(94, 60, NULL, 6, 3, '2014-03-25 22:08:31'),
(95, 10, NULL, 0, 1, '2014-03-25 22:11:18'),
(96, 10, NULL, 0, 1, '2014-03-25 22:19:22'),
(97, 10, NULL, 0, 1, '2014-03-25 22:24:34'),
(98, 10, NULL, 0, 1, '2014-03-25 22:30:12'),
(99, 10, NULL, 0, 1, '2014-03-25 22:30:39'),
(100, 10, NULL, 0, 1, '2014-03-25 22:32:39'),
(101, 10, NULL, 0, 1, '2014-03-25 22:34:47'),
(102, 10, NULL, 0, 1, '2014-03-25 22:36:07'),
(103, 10, NULL, 0, 1, '2014-03-25 22:38:39'),
(104, 10, NULL, 0, 1, '2014-03-25 22:48:38'),
(105, 10, NULL, 0, 1, '2014-03-25 22:54:38'),
(106, 10, NULL, 0, 1, '2014-03-25 22:57:18'),
(107, 1, NULL, 0, 1, '2014-03-25 22:59:22'),
(108, 10, NULL, 0, 1, '2014-03-25 23:01:04'),
(109, 1, NULL, 0, 1, '2014-03-25 23:01:47'),
(110, 10, NULL, 0, 1, '2014-03-25 23:04:06'),
(111, 10, NULL, 0, 1, '2014-03-25 23:08:58'),
(112, 10, NULL, 0, 1, '2014-03-25 23:12:21'),
(113, 1, NULL, 0, 1, '2014-03-25 23:36:33'),
(114, 1, NULL, 0, 1, '2014-03-25 23:39:46'),
(115, 1, NULL, 0, 1, '2014-03-25 23:41:13'),
(116, 1, NULL, 0, 1, '2014-03-25 23:42:24'),
(117, 1, NULL, 0, 1, '2014-03-25 23:43:27'),
(118, 1, NULL, 0, 1, '2014-03-25 23:44:48'),
(119, 1, NULL, 0, 1, '2014-03-25 23:44:58'),
(120, 1, NULL, 0, 1, '2014-03-25 23:48:48'),
(121, 1, NULL, 0, 1, '2014-03-25 23:53:45'),
(122, 1, NULL, 0, 1, '2014-03-25 23:57:38'),
(123, 1, NULL, 0, 1, '2014-03-25 23:57:58'),
(124, 1, NULL, 0, 1, '2014-03-25 23:58:35'),
(125, 1, NULL, 0, 1, '2014-03-26 00:20:23'),
(126, 1, NULL, 0, 1, '2014-03-26 00:22:09'),
(127, 1, NULL, 0, 1, '2014-03-26 00:24:04'),
(128, 1, NULL, 0, 1, '2014-03-26 00:29:04'),
(129, 1, NULL, 0, 1, '2014-03-26 00:32:02'),
(130, 1, NULL, 0, 1, '2014-03-26 00:32:54'),
(131, 1, NULL, 0, 1, '2014-03-26 00:33:33'),
(132, 1, NULL, 0, 1, '2014-03-26 00:36:30'),
(133, 1, NULL, 0, 1, '2014-03-26 00:40:25'),
(134, 1, NULL, 0, 1, '2014-03-26 00:41:34'),
(135, 1, NULL, 0, 1, '2014-03-26 00:46:48'),
(136, 1, NULL, 0, 1, '2014-03-26 00:48:11'),
(137, 1, NULL, 0, 1, '2014-03-26 00:49:32'),
(138, 1, NULL, 0, 1, '2014-03-26 00:56:34'),
(139, 1, NULL, 0, 1, '2014-03-26 01:13:20'),
(140, 1, NULL, 0, 1, '2014-03-26 01:16:24'),
(141, 1, NULL, 0, 1, '2014-03-26 01:18:10'),
(142, 1, NULL, 0, 1, '2014-03-26 01:21:49'),
(143, 1, NULL, 0, 1, '2014-03-26 01:23:02'),
(144, 1, NULL, 0, 1, '2014-03-26 01:25:54'),
(145, 1, NULL, 0, 1, '2014-03-26 01:28:31'),
(146, 1, NULL, 0, 1, '2014-03-26 01:29:56'),
(147, 1, NULL, 0, 5, '2014-03-26 01:30:11'),
(148, 1, NULL, 0, 1, '2014-03-26 08:12:14'),
(149, 1, NULL, 0, 1, '2014-03-26 08:24:48'),
(150, 1, NULL, 0, 1, '2014-03-26 08:38:07'),
(151, 1, NULL, 0, 5, '2014-03-26 08:38:28'),
(152, 1, NULL, 2, 1, '2014-03-26 08:56:10'),
(153, 1, NULL, 2, 1, '2014-03-26 08:56:13'),
(154, 1, NULL, 2, 1, '2014-03-26 08:56:28'),
(155, 1, NULL, 2, 1, '2014-03-26 08:57:54'),
(156, 10, NULL, 0, 1, '2014-03-26 08:59:01'),
(157, 1, NULL, 0, 1, '2014-03-26 08:59:41'),
(158, 2, NULL, 2, 1, '2014-03-26 09:00:43'),
(159, 2, NULL, 2, 1, '2014-03-26 09:02:52'),
(160, 2, NULL, 2, 1, '2014-03-26 09:03:57'),
(161, 10, NULL, 0, 1, '2014-03-26 09:05:34'),
(162, 10, NULL, 0, 1, '2014-03-26 09:11:03'),
(163, 10, NULL, 0, 1, '2014-03-26 09:11:21'),
(164, 10, NULL, 0, 1, '2014-03-26 09:12:01'),
(165, 10, NULL, 0, 1, '2014-03-26 09:13:04'),
(166, 10, NULL, 0, 1, '2014-03-26 09:13:47'),
(167, 10, NULL, 0, 1, '2014-03-26 09:16:00'),
(168, 10, NULL, 0, 1, '2014-03-26 09:18:48'),
(169, 10, NULL, 0, 1, '2014-03-26 09:23:29'),
(170, 2, NULL, 2, 1, '2014-03-26 09:24:46'),
(171, 2, NULL, 2, 1, '2014-03-26 09:26:05'),
(172, 2, NULL, 2, 1, '2014-03-26 09:26:50'),
(173, 2, NULL, 2, 1, '2014-03-26 09:27:57'),
(174, 2, NULL, 2, 1, '2014-03-26 09:29:14'),
(175, 2, NULL, 2, 1, '2014-03-26 09:33:21'),
(176, 2, NULL, 2, 1, '2014-03-26 09:34:44'),
(177, 2, NULL, 2, 1, '2014-03-26 09:36:23'),
(178, 2, NULL, 2, 1, '2014-03-26 09:36:45'),
(179, 2, NULL, 2, 1, '2014-03-26 09:38:19'),
(180, 2, NULL, 2, 1, '2014-03-26 09:39:15'),
(181, 10, NULL, 0, 1, '2014-03-26 09:45:43'),
(182, 10, NULL, 0, 1, '2014-03-26 09:50:26'),
(183, 10, NULL, 0, 1, '2014-03-26 09:51:42'),
(184, 10, NULL, 0, 1, '2014-03-26 09:53:51'),
(185, 10, NULL, 0, 1, '2014-03-26 09:57:23'),
(186, 2, NULL, 2, 1, '2014-03-26 09:59:57'),
(187, 2, NULL, 2, 1, '2014-03-26 10:00:37'),
(188, 2, NULL, 2, 1, '2014-03-26 10:00:53'),
(189, 2, NULL, 0, 1, '2014-03-26 10:01:53'),
(190, 2, NULL, 0, 1, '2014-03-26 10:03:52'),
(191, 2, NULL, 0, 1, '2014-03-26 10:05:33'),
(192, 2, NULL, 0, 1, '2014-03-26 10:07:33'),
(193, 2, NULL, 0, 1, '2014-03-26 10:09:22'),
(194, 2, NULL, 0, 1, '2014-03-26 10:12:01'),
(195, 2, NULL, 0, 1, '2014-03-26 10:13:29'),
(196, 2, NULL, 0, 1, '2014-03-26 10:14:56'),
(197, 2, NULL, 0, 1, '2014-03-26 10:15:32'),
(198, 2, NULL, 0, 1, '2014-03-26 10:16:36'),
(199, 2, NULL, 0, 1, '2014-03-26 10:19:47'),
(200, 2, NULL, 0, 1, '2014-03-26 10:26:48'),
(201, 2, NULL, 0, 1, '2014-03-26 10:31:12'),
(202, 2, NULL, 0, 1, '2014-03-26 10:31:56'),
(203, 2, NULL, 0, 1, '2014-03-26 10:33:25'),
(204, 2, NULL, 0, 1, '2014-03-26 10:34:02'),
(205, 2, NULL, 0, 1, '2014-03-26 10:35:04'),
(206, 2, NULL, 0, 1, '2014-03-26 10:36:38'),
(207, 2, NULL, 0, 1, '2014-03-26 10:43:11'),
(208, 2, NULL, 0, 1, '2014-03-26 10:44:28'),
(209, 2, NULL, 0, 1, '2014-03-26 10:44:55'),
(210, 2, NULL, 0, 1, '2014-03-26 10:47:14'),
(211, 2, NULL, 0, 1, '2014-03-26 10:48:40'),
(212, 2, NULL, 0, 1, '2014-03-26 10:50:17'),
(213, 2, NULL, 0, 1, '2014-03-26 10:51:06'),
(214, 2, NULL, 0, 1, '2014-03-26 10:51:26'),
(215, 2, NULL, 0, 1, '2014-03-26 10:52:16'),
(216, 2, NULL, 0, 1, '2014-03-26 10:52:50'),
(217, 2, NULL, 0, 1, '2014-03-26 10:53:52'),
(218, 2, NULL, 0, 1, '2014-03-26 10:55:18'),
(219, 2, NULL, 0, 1, '2014-03-26 10:55:33'),
(220, 2, NULL, 0, 1, '2014-03-26 10:55:45'),
(221, 2, NULL, 0, 1, '2014-03-26 10:56:01'),
(222, 2, NULL, 0, 1, '2014-03-26 10:56:36'),
(223, 2, NULL, 0, 1, '2014-03-26 10:58:12'),
(224, 2, NULL, 0, 1, '2014-03-26 11:03:34'),
(225, 2, NULL, 0, 1, '2014-03-26 11:04:01'),
(226, 2, NULL, 0, 1, '2014-03-26 11:04:27'),
(227, 2, NULL, 0, 1, '2014-03-26 11:07:24'),
(228, 2, NULL, 0, 1, '2014-03-26 11:08:37'),
(229, 2, NULL, 0, 1, '2014-03-26 11:09:12'),
(230, 2, NULL, 0, 1, '2014-03-26 11:09:53'),
(231, 61, NULL, 0, 3, '2014-03-26 11:11:56'),
(232, 2, NULL, 0, 1, '2014-03-26 11:12:13'),
(233, 61, NULL, 0, 1, '2014-03-26 11:13:20'),
(234, 61, NULL, 0, 1, '2014-03-26 11:14:28'),
(235, 61, NULL, 2, 1, '2014-03-26 11:18:12'),
(236, 1, NULL, 2, 1, '2014-03-26 11:18:29'),
(237, 61, NULL, 6, 3, '2014-03-26 11:19:18'),
(238, 1, NULL, 6, 3, '2014-03-26 11:21:39'),
(239, 61, NULL, 2, 1, '2014-03-26 11:22:12'),
(240, 61, NULL, 2, 1, '2014-03-26 11:22:42'),
(241, 61, NULL, 0, 1, '2014-03-26 11:22:53'),
(242, 61, NULL, 0, 5, '2014-03-26 11:23:44'),
(243, 61, NULL, 0, 1, '2014-03-26 11:23:58'),
(244, 61, NULL, 0, 1, '2014-03-26 11:25:03'),
(245, 1, NULL, 2, 1, '2014-03-26 11:34:57'),
(246, 1, NULL, 2, 1, '2014-03-26 11:35:00'),
(247, 1, NULL, 2, 1, '2014-03-26 11:35:02'),
(248, 10, NULL, 0, 1, '2014-03-26 11:35:20'),
(249, 10, NULL, 0, 1, '2014-03-26 11:36:38'),
(250, 10, NULL, 0, 1, '2014-03-26 11:38:52'),
(251, 10, NULL, 0, 1, '2014-03-26 11:39:37'),
(252, 10, NULL, 0, 1, '2014-03-26 11:50:24'),
(253, 10, NULL, 0, 1, '2014-03-26 12:28:47'),
(254, 10, NULL, 0, 1, '2014-03-26 13:08:18'),
(255, 10, NULL, 0, 1, '2014-03-26 14:02:35'),
(256, 10, NULL, 0, 1, '2014-03-26 14:20:42'),
(257, 10, NULL, 0, 1, '2014-03-26 14:41:08'),
(258, 10, NULL, 0, 1, '2014-03-26 14:42:17'),
(259, 10, NULL, 0, 1, '2014-03-26 14:43:20'),
(260, 10, NULL, 0, 1, '2014-03-26 14:46:10'),
(261, 10, NULL, 0, 1, '2014-03-26 14:51:47'),
(262, 10, NULL, 0, 1, '2014-03-26 14:57:38'),
(263, 10, NULL, 0, 1, '2014-03-26 15:21:15'),
(264, 10, NULL, 2, 1, '2014-03-26 15:29:47'),
(265, 10, NULL, 2, 1, '2014-03-26 15:32:46'),
(266, 0, NULL, 3, 1, '2014-03-26 15:32:57'),
(267, 10, NULL, 2, 1, '2014-03-26 15:33:03'),
(268, 10, NULL, 0, 1, '2014-03-26 15:33:07'),
(269, 10, NULL, 2, 1, '2014-03-26 15:33:58'),
(270, 10, NULL, 2, 1, '2014-03-26 15:36:51'),
(271, 10, NULL, 0, 1, '2014-03-26 15:36:58'),
(272, 0, NULL, 0, 3, '2014-03-26 15:38:49'),
(273, 10, NULL, 0, 1, '2014-03-26 15:39:24'),
(274, 10, NULL, 0, 1, '2014-03-26 15:46:14'),
(275, 10, NULL, 0, 1, '2014-03-26 15:46:27'),
(276, 29, NULL, 0, 1, '2014-03-26 15:47:18'),
(277, 29, NULL, 2, 1, '2014-03-26 15:47:49'),
(278, 0, NULL, 3, 1, '2014-03-26 15:48:01'),
(279, 29, NULL, 0, 1, '2014-03-26 15:48:16'),
(280, 10, NULL, 0, 1, '2014-03-26 15:55:04'),
(281, 0, NULL, 3, 1, '2014-03-26 16:25:00'),
(282, 0, NULL, 3, 1, '2014-03-26 16:25:03'),
(283, 0, NULL, 3, 1, '2014-03-26 16:25:14'),
(284, 10, NULL, 0, 1, '2014-03-26 16:26:59'),
(285, 0, NULL, 3, 1, '2014-03-26 16:36:57'),
(286, 0, NULL, 3, 1, '2014-03-26 16:37:08'),
(287, 10, NULL, 0, 1, '2014-03-26 16:37:23'),
(288, 29, NULL, 0, 1, '2014-03-26 16:45:07'),
(289, 10, NULL, 0, 1, '2014-03-26 16:48:26'),
(290, 10, NULL, 0, 1, '2014-03-26 16:57:12'),
(291, 28, NULL, 2, 1, '2014-03-26 16:57:57'),
(292, 29, NULL, 0, 1, '2014-03-26 17:20:54'),
(293, 29, NULL, 0, 1, '2014-03-26 17:23:55'),
(294, 0, NULL, 3, 1, '2014-03-26 17:26:53'),
(295, 29, NULL, 0, 1, '2014-03-26 17:27:29'),
(296, 10, NULL, 0, 1, '2014-03-26 17:30:06'),
(297, 10, NULL, 0, 1, '2014-03-26 17:32:21'),
(298, 0, NULL, 3, 1, '2014-03-26 17:34:03'),
(299, 29, NULL, 0, 1, '2014-03-26 17:34:19'),
(300, 29, NULL, 0, 1, '2014-03-26 17:37:06'),
(301, 29, NULL, 0, 1, '2014-03-26 17:39:03'),
(302, 29, NULL, 0, 1, '2014-03-26 17:42:31'),
(303, 29, NULL, 0, 1, '2014-03-26 17:44:57'),
(304, 29, NULL, 0, 1, '2014-03-26 17:47:57'),
(305, 29, NULL, 0, 1, '2014-03-26 17:51:15'),
(306, 29, NULL, 0, 1, '2014-03-26 17:52:16'),
(307, 29, NULL, 0, 1, '2014-03-26 17:54:56'),
(308, 29, NULL, 0, 1, '2014-03-26 17:55:55'),
(309, 0, NULL, 3, 1, '2014-03-26 17:56:45'),
(310, 29, NULL, 0, 1, '2014-03-26 17:56:56'),
(311, 29, NULL, 0, 1, '2014-03-26 17:58:11'),
(312, 10, NULL, 0, 1, '2014-03-26 18:14:58'),
(313, 10, NULL, 0, 1, '2014-03-26 18:47:29'),
(314, 29, NULL, 0, 1, '2014-03-26 18:48:29'),
(315, 10, NULL, 0, 1, '2014-03-26 19:47:07'),
(316, 29, NULL, 0, 1, '2014-03-26 20:28:16'),
(317, 29, NULL, 0, 1, '2014-03-26 20:30:23'),
(318, 29, NULL, 0, 1, '2014-03-26 20:33:24'),
(319, 29, NULL, 0, 1, '2014-03-26 20:40:17'),
(320, 29, NULL, 0, 1, '2014-03-26 20:41:34'),
(321, 29, NULL, 0, 1, '2014-03-26 20:43:50'),
(322, 29, NULL, 0, 1, '2014-03-26 20:45:43'),
(323, 29, NULL, 0, 1, '2014-03-26 20:47:48'),
(324, 29, NULL, 0, 1, '2014-03-26 20:49:42'),
(325, 29, NULL, 0, 1, '2014-03-26 20:51:54'),
(326, 29, NULL, 0, 1, '2014-03-26 20:54:48'),
(327, 29, NULL, 0, 1, '2014-03-26 21:00:19'),
(328, 10, NULL, 0, 1, '2014-03-26 21:04:58'),
(329, 0, NULL, 3, 1, '2014-03-26 21:36:42'),
(330, 29, NULL, 0, 1, '2014-03-26 21:37:06'),
(331, 29, NULL, 0, 1, '2014-03-26 21:44:40'),
(332, 29, NULL, 0, 1, '2014-03-26 21:44:41'),
(333, 2, NULL, 2, 1, '2014-03-26 21:45:27'),
(334, 2, NULL, 0, 1, '2014-03-26 21:45:47'),
(335, 0, NULL, 3, 1, '2014-03-26 22:02:14'),
(336, 0, NULL, 0, 3, '2014-03-26 22:02:48'),
(337, 0, NULL, 3, 1, '2014-03-26 22:02:52'),
(338, 0, NULL, 3, 1, '2014-03-26 22:03:03'),
(339, 0, NULL, 0, 3, '2014-03-26 22:03:54'),
(340, 0, NULL, 3, 1, '2014-03-26 22:03:57'),
(341, 10, NULL, 0, 1, '2014-03-26 22:04:23'),
(342, 0, NULL, 0, 3, '2014-03-26 22:07:37'),
(343, 0, NULL, 3, 1, '2014-03-26 22:07:47'),
(344, 10, NULL, 0, 1, '2014-03-26 22:10:27'),
(345, 29, NULL, 0, 1, '2014-03-26 22:23:14'),
(346, 29, NULL, 0, 1, '2014-03-26 22:33:34'),
(347, 29, NULL, 0, 1, '2014-03-26 22:45:07'),
(348, 29, NULL, 5, 6, '2014-03-26 22:45:07'),
(349, 29, NULL, 0, 1, '2014-03-26 22:47:19'),
(350, 29, NULL, 5, 6, '2014-03-26 22:47:20'),
(351, 29, NULL, 0, 1, '2014-03-26 22:49:41'),
(352, 29, NULL, 5, 6, '2014-03-26 22:49:42'),
(353, 29, NULL, 0, 1, '2014-03-26 22:50:56'),
(354, 29, NULL, 5, 6, '2014-03-26 22:50:57'),
(355, 29, NULL, 0, 1, '2014-03-26 22:59:27'),
(356, 29, NULL, 5, 6, '2014-03-26 22:59:28'),
(357, 29, NULL, 0, 1, '2014-03-26 23:01:45'),
(358, 29, NULL, 5, 6, '2014-03-26 23:01:46'),
(359, 29, NULL, 0, 1, '2014-03-26 23:06:28'),
(360, 29, NULL, 5, 6, '2014-03-26 23:06:29'),
(361, 29, NULL, 0, 1, '2014-03-26 23:23:24'),
(362, 29, NULL, 5, 6, '2014-03-26 23:23:25'),
(363, 29, NULL, 5, 6, '2014-03-26 23:23:33'),
(364, 29, NULL, 5, 6, '2014-03-26 23:27:22'),
(365, 29, NULL, 0, 1, '2014-03-26 23:31:18'),
(366, 29, NULL, 5, 6, '2014-03-26 23:31:19'),
(367, 29, NULL, 0, 5, '2014-03-26 23:32:17'),
(368, 29, NULL, 0, 5, '2014-03-26 23:33:02'),
(369, 29, NULL, 0, 5, '2014-03-26 23:33:07'),
(370, 29, NULL, 0, 1, '2014-03-26 23:38:09'),
(371, 29, NULL, 5, 6, '2014-03-26 23:38:10'),
(372, 29, NULL, 0, 5, '2014-03-26 23:38:43'),
(373, 29, NULL, 0, 5, '2014-03-26 23:38:49'),
(374, 29, NULL, 0, 5, '2014-03-26 23:38:55'),
(375, 29, NULL, 0, 6, '2014-03-26 23:39:00'),
(376, 29, NULL, 0, 1, '2014-03-26 23:40:19'),
(377, 29, NULL, 0, 6, '2014-03-26 23:40:21'),
(378, 29, NULL, 0, 5, '2014-03-26 23:40:44'),
(379, 29, NULL, 0, 1, '2014-03-26 23:42:09'),
(380, 29, NULL, 0, 6, '2014-03-26 23:42:10'),
(381, 29, NULL, 0, 6, '2014-03-26 23:42:28'),
(382, 29, NULL, 0, 1, '2014-03-26 23:45:38'),
(383, 29, NULL, 0, 6, '2014-03-26 23:45:40'),
(384, 29, NULL, 0, 1, '2014-03-26 23:59:38'),
(385, 29, NULL, 0, 6, '2014-03-26 23:59:39'),
(386, 10, NULL, 0, 1, '2014-03-27 02:04:29'),
(387, 0, NULL, 0, 3, '2014-03-27 02:05:06'),
(388, 0, NULL, 3, 1, '2014-03-27 02:05:19'),
(389, 61, NULL, 2, 1, '2014-03-27 02:17:57'),
(390, 61, NULL, 2, 1, '2014-03-27 02:18:06'),
(391, 61, NULL, 0, 1, '2014-03-27 02:18:12'),
(392, 29, NULL, 0, 1, '2014-03-27 08:33:42'),
(393, 29, NULL, 0, 6, '2014-03-27 08:33:46'),
(394, 29, NULL, 0, 1, '2014-03-27 08:38:36'),
(395, 29, NULL, 0, 6, '2014-03-27 08:38:39'),
(396, 29, NULL, 0, 1, '2014-03-27 08:44:05'),
(397, 29, NULL, 0, 6, '2014-03-27 08:44:08'),
(398, 29, NULL, 0, 1, '2014-03-27 08:45:20'),
(399, 29, NULL, 0, 6, '2014-03-27 08:45:23'),
(400, 29, NULL, 0, 1, '2014-03-27 08:49:12'),
(401, 29, NULL, 0, 6, '2014-03-27 08:49:15'),
(402, 29, NULL, 0, 1, '2014-03-27 08:53:09'),
(403, 29, NULL, 0, 6, '2014-03-27 08:53:13'),
(404, 29, NULL, 0, 1, '2014-03-27 08:56:26'),
(405, 29, NULL, 0, 6, '2014-03-27 08:56:33'),
(406, 29, NULL, 0, 1, '2014-03-27 09:01:42'),
(407, 29, NULL, 0, 6, '2014-03-27 09:01:46'),
(408, 29, NULL, 0, 1, '2014-03-27 09:03:47'),
(409, 29, NULL, 0, 6, '2014-03-27 09:03:50'),
(410, 29, NULL, 0, 1, '2014-03-27 09:09:02'),
(411, 29, NULL, 0, 6, '2014-03-27 09:09:05'),
(412, 29, NULL, 0, 1, '2014-03-27 09:12:39'),
(413, 29, NULL, 0, 6, '2014-03-27 09:12:42'),
(414, 29, NULL, 0, 1, '2014-03-27 09:14:41'),
(415, 29, NULL, 0, 6, '2014-03-27 09:14:44'),
(416, 29, NULL, 0, 1, '2014-03-27 09:18:19'),
(417, 29, NULL, 0, 6, '2014-03-27 09:18:23'),
(418, 29, NULL, 0, 1, '2014-03-27 09:21:23'),
(419, 29, NULL, 0, 6, '2014-03-27 09:21:26'),
(420, 29, NULL, 0, 1, '2014-03-27 09:24:47'),
(421, 29, NULL, 0, 6, '2014-03-27 09:24:50'),
(422, 29, NULL, 0, 1, '2014-03-27 09:31:27'),
(423, 29, NULL, 0, 6, '2014-03-27 09:31:30'),
(424, 29, NULL, 0, 1, '2014-03-27 09:33:36'),
(425, 29, NULL, 0, 6, '2014-03-27 09:33:40'),
(426, 29, NULL, 0, 1, '2014-03-27 09:35:13'),
(427, 29, NULL, 0, 6, '2014-03-27 09:35:16'),
(428, 29, NULL, 0, 1, '2014-03-27 09:37:31'),
(429, 29, NULL, 0, 6, '2014-03-27 09:37:34'),
(430, 29, NULL, 0, 1, '2014-03-27 09:43:40'),
(431, 29, NULL, 0, 6, '2014-03-27 09:43:43'),
(432, 29, NULL, 0, 1, '2014-03-27 09:46:22'),
(433, 29, NULL, 0, 6, '2014-03-27 09:46:26'),
(434, 29, NULL, 0, 1, '2014-03-27 09:52:16'),
(435, 29, NULL, 0, 6, '2014-03-27 09:52:19'),
(436, 0, NULL, 3, 2, '2014-03-27 09:55:59'),
(437, 0, NULL, 3, 2, '2014-03-27 09:56:09'),
(438, 0, NULL, 3, 2, '2014-03-27 09:56:14'),
(439, 0, NULL, 3, 2, '2014-03-27 09:56:36'),
(440, 0, NULL, 3, 2, '2014-03-27 09:58:59'),
(441, 0, NULL, 3, 2, '2014-03-27 09:59:08'),
(442, 29, NULL, 0, 1, '2014-03-27 10:13:44'),
(443, 29, NULL, 0, 1, '2014-03-27 10:14:06'),
(444, 29, NULL, 0, 1, '2014-03-27 10:14:33'),
(445, 10, NULL, 0, 1, '2014-03-27 10:15:04'),
(446, 0, NULL, 0, 2, '2014-03-27 10:16:51'),
(447, 29, NULL, 0, 1, '2014-03-27 10:17:07'),
(448, 29, NULL, 0, 6, '2014-03-27 10:17:09'),
(449, 29, NULL, 0, 1, '2014-03-27 10:18:54'),
(450, 29, NULL, 0, 6, '2014-03-27 10:18:57'),
(451, 29, NULL, 0, 1, '2014-03-27 10:23:07'),
(452, 29, NULL, 0, 6, '2014-03-27 10:23:11'),
(453, 29, NULL, 0, 1, '2014-03-27 10:26:35'),
(454, 29, NULL, 0, 6, '2014-03-27 10:26:37'),
(455, 29, NULL, 0, 1, '2014-03-27 10:35:49'),
(456, 29, NULL, 9, 6, '2014-03-27 10:35:52'),
(457, 29, NULL, 9, 6, '2014-03-27 10:37:18'),
(458, 29, NULL, 9, 6, '2014-03-27 10:37:45'),
(459, 29, NULL, 9, 6, '2014-03-27 10:37:56'),
(460, 29, NULL, 0, 1, '2014-03-27 10:38:38'),
(461, 29, NULL, 9, 6, '2014-03-27 10:38:41'),
(462, 29, NULL, 0, 1, '2014-03-27 10:40:06'),
(463, 29, NULL, 9, 6, '2014-03-27 10:40:11'),
(464, 29, NULL, 4, 6, '2014-03-27 10:42:45'),
(465, 29, NULL, 11, 6, '2014-03-27 10:43:57'),
(466, 2, NULL, 11, 6, '2014-03-27 10:44:14'),
(467, 0, NULL, 0, 8, '2014-03-27 10:44:38'),
(468, 29, NULL, 11, 6, '2014-03-27 10:44:50'),
(469, 0, NULL, 0, 8, '2014-03-27 10:45:00'),
(470, 29, NULL, 0, 6, '2014-03-27 10:46:31'),
(471, 0, NULL, 0, 8, '2014-03-27 10:46:39'),
(472, 2, NULL, 11, 6, '2014-03-27 10:46:42'),
(473, 2, NULL, 8, 6, '2014-03-27 10:46:47'),
(474, 2, NULL, 8, 6, '2014-03-27 10:46:54'),
(475, 2, NULL, 9, 6, '2014-03-27 10:47:03'),
(476, 2, NULL, 11, 6, '2014-03-27 10:47:12'),
(477, 29, NULL, 0, 1, '2014-03-27 10:47:25'),
(478, 29, NULL, 11, 6, '2014-03-27 10:47:29'),
(479, 2, NULL, 9, 6, '2014-03-27 10:49:29'),
(480, 2, NULL, 9, 6, '2014-03-27 10:51:52'),
(481, 2, NULL, 20, 6, '2014-03-27 10:52:05'),
(482, 10, NULL, 0, 1, '2014-03-27 10:52:38'),
(483, 2, NULL, 20, 6, '2014-03-27 10:52:42'),
(484, 0, NULL, 3, 1, '2014-03-27 10:53:35'),
(485, 10, NULL, 0, 1, '2014-03-27 10:53:50'),
(486, 2, NULL, 20, 6, '2014-03-27 10:54:45'),
(487, 29, NULL, 20, 6, '2014-03-27 10:55:05'),
(488, 2, NULL, 20, 6, '2014-03-27 10:56:24'),
(489, 2, NULL, 21, 6, '2014-03-27 10:58:28'),
(490, 29, NULL, 21, 6, '2014-03-27 10:58:46'),
(491, 29, NULL, 21, 6, '2014-03-27 10:59:04'),
(492, 29, NULL, 0, 6, '2014-03-27 11:00:24'),
(493, 2, NULL, 11, 6, '2014-03-27 11:00:33'),
(494, 29, NULL, 0, 1, '2014-03-27 11:02:16'),
(495, 29, NULL, 0, 6, '2014-03-27 11:02:18'),
(496, 29, NULL, 0, 1, '2014-03-27 11:14:24'),
(497, 29, NULL, 0, 6, '2014-03-27 11:14:28'),
(501, 0, NULL, 0, 8, '2014-03-27 11:28:42'),
(503, 0, NULL, 0, 8, '2014-03-27 11:29:30'),
(504, 0, NULL, 0, 8, '2014-03-27 11:29:32'),
(511, 29, NULL, 0, 1, '2014-03-27 11:34:07'),
(512, 29, NULL, 0, 6, '2014-03-27 11:34:10'),
(514, 29, NULL, 0, 1, '2014-03-27 12:01:15'),
(515, 29, NULL, 0, 6, '2014-03-27 12:01:17'),
(516, 29, NULL, 0, 1, '2014-03-27 12:04:48'),
(517, 29, NULL, 0, 6, '2014-03-27 12:04:52'),
(518, 0, NULL, 3, 1, '2014-03-27 12:05:59'),
(519, 0, NULL, 3, 1, '2014-03-27 12:06:15'),
(520, 29, NULL, 0, 1, '2014-03-27 12:07:44'),
(521, 29, NULL, 0, 6, '2014-03-27 12:07:46'),
(522, 0, NULL, 3, 1, '2014-03-27 12:10:08'),
(523, 29, NULL, 0, 1, '2014-03-27 12:13:54'),
(524, 0, NULL, 3, 1, '2014-03-27 12:23:21'),
(525, 29, NULL, 0, 1, '2014-03-27 12:23:40'),
(526, 0, NULL, 0, 3, '2014-03-27 12:26:27'),
(527, 0, NULL, 3, 1, '2014-03-27 12:26:51'),
(528, 0, NULL, 3, 1, '2014-03-27 12:27:17'),
(529, 0, NULL, 0, 3, '2014-03-27 12:29:38'),
(530, 0, NULL, 3, 1, '2014-03-27 12:29:58'),
(531, 0, NULL, 3, 1, '2014-03-27 12:30:17'),
(532, 29, NULL, 0, 1, '2014-03-27 12:33:17'),
(533, 29, NULL, 0, 1, '2014-03-27 12:35:09'),
(534, 29, NULL, 0, 1, '2014-03-27 12:37:05'),
(535, 29, NULL, 0, 1, '2014-03-27 12:38:33'),
(536, 29, NULL, 20, 6, '2014-03-27 12:38:44'),
(537, 29, NULL, 20, 6, '2014-03-27 12:38:53'),
(538, 29, NULL, 20, 6, '2014-03-27 12:38:56'),
(539, 29, NULL, 0, 1, '2014-03-27 12:41:46'),
(540, 29, NULL, 20, 6, '2014-03-27 12:41:58'),
(541, 29, NULL, 20, 6, '2014-03-27 12:42:03'),
(542, 29, NULL, 0, 1, '2014-03-27 12:45:46'),
(543, 29, NULL, 0, 6, '2014-03-27 12:45:56'),
(544, 29, NULL, 0, 6, '2014-03-27 12:45:59'),
(545, 29, NULL, 0, 1, '2014-03-27 12:46:33'),
(546, 29, NULL, 0, 6, '2014-03-27 12:46:43'),
(547, 29, NULL, 0, 6, '2014-03-27 12:46:44'),
(548, 29, NULL, 0, 1, '2014-03-27 12:47:25'),
(549, 29, NULL, 20, 6, '2014-03-27 12:47:35'),
(550, 29, NULL, 20, 6, '2014-03-27 12:47:38'),
(551, 29, NULL, 0, 1, '2014-03-27 12:48:50'),
(552, 29, NULL, 20, 6, '2014-03-27 12:49:00'),
(553, 29, NULL, 20, 6, '2014-03-27 12:49:03'),
(554, 29, NULL, 0, 1, '2014-03-27 12:50:05'),
(555, 29, NULL, 20, 6, '2014-03-27 12:50:15'),
(556, 29, NULL, 0, 1, '2014-03-27 12:52:31'),
(557, 29, NULL, 20, 6, '2014-03-27 12:52:43'),
(558, 29, NULL, 20, 6, '2014-03-27 12:52:53'),
(559, 29, NULL, 0, 1, '2014-03-27 12:53:48'),
(560, 29, NULL, 20, 6, '2014-03-27 12:53:58'),
(561, 29, NULL, 0, 1, '2014-03-27 12:55:15'),
(562, 29, NULL, 20, 6, '2014-03-27 12:55:25'),
(563, 29, NULL, 20, 6, '2014-03-27 12:55:27'),
(564, 29, NULL, 0, 1, '2014-03-27 12:56:21'),
(565, 29, NULL, 0, 6, '2014-03-27 12:56:31'),
(566, 29, NULL, 0, 6, '2014-03-27 12:56:32'),
(567, 29, NULL, 0, 1, '2014-03-27 12:57:32'),
(568, 29, NULL, 0, 1, '2014-03-27 13:02:19'),
(569, 29, NULL, 0, 6, '2014-03-27 13:02:28'),
(570, 29, NULL, 0, 6, '2014-03-27 13:02:29'),
(571, 0, NULL, 0, 3, '2014-03-27 13:12:31'),
(572, 0, NULL, 3, 1, '2014-03-27 13:12:45'),
(573, 0, NULL, 3, 1, '2014-03-27 13:12:55'),
(574, 0, NULL, 0, 3, '2014-03-27 13:26:21'),
(575, 0, NULL, 3, 1, '2014-03-27 13:26:32'),
(576, 0, NULL, 0, 3, '2014-03-27 13:27:39'),
(577, 29, NULL, 0, 1, '2014-03-27 13:30:43'),
(578, 29, NULL, 0, 5, '2014-03-27 13:31:23'),
(579, 29, NULL, 0, 1, '2014-03-27 13:31:42'),
(580, 0, NULL, 3, 1, '2014-03-27 13:35:11'),
(581, 29, NULL, 2, 1, '2014-03-27 13:36:54'),
(582, 29, NULL, 0, 1, '2014-03-27 13:37:08'),
(583, 29, NULL, 0, 5, '2014-03-27 13:37:32'),
(584, 0, NULL, 3, 1, '2014-03-27 14:07:12'),
(585, 29, NULL, 0, 1, '2014-03-27 14:07:31'),
(586, 29, NULL, 0, 6, '2014-03-27 14:07:40'),
(587, 29, NULL, 0, 6, '2014-03-27 14:07:41'),
(588, 29, NULL, 0, 1, '2014-03-27 14:13:06'),
(589, 10, NULL, 6, 3, '2014-03-27 14:15:38'),
(590, 0, NULL, 0, 3, '2014-03-27 14:16:37'),
(591, 0, NULL, 3, 1, '2014-03-27 14:16:53'),
(592, 10, NULL, 0, 1, '2014-03-27 14:17:22'),
(593, 2, NULL, 2, 1, '2014-03-27 14:17:59'),
(594, 2, NULL, 0, 1, '2014-03-27 14:18:24'),
(595, 29, NULL, 0, 1, '2014-03-27 14:19:24'),
(596, 0, NULL, 3, 1, '2014-03-27 14:20:07'),
(597, 1, NULL, 2, 1, '2014-03-27 14:20:45'),
(598, 0, NULL, 0, 3, '2014-03-27 14:21:25'),
(599, 0, NULL, 3, 1, '2014-03-27 14:21:41'),
(600, 0, NULL, 0, 3, '2014-03-27 14:22:23'),
(601, 0, NULL, 3, 1, '2014-03-27 14:22:37'),
(602, 0, NULL, 3, 1, '2014-03-27 14:25:51'),
(603, 29, NULL, 0, 1, '2014-03-27 14:26:08'),
(604, 62, NULL, 0, 3, '2014-03-27 14:35:36'),
(605, 62, NULL, 0, 1, '2014-03-27 14:35:45'),
(606, 0, NULL, 3, 1, '2014-03-27 14:38:36'),
(607, 0, NULL, 3, 1, '2014-03-27 14:38:46'),
(608, 29, NULL, 0, 1, '2014-03-27 14:39:12'),
(609, 0, NULL, 3, 1, '2014-03-27 14:39:24'),
(610, 0, NULL, 3, 1, '2014-03-27 14:39:38'),
(611, 29, NULL, 0, 1, '2014-03-27 14:42:01'),
(612, 0, NULL, 0, 3, '2014-03-27 14:45:47'),
(613, 29, NULL, 0, 1, '2014-03-27 15:09:12'),
(614, 29, NULL, 0, 1, '2014-03-27 15:15:24'),
(615, 29, NULL, 21, 6, '2014-03-27 15:16:10'),
(616, 29, NULL, 4, 6, '2014-03-27 15:16:17'),
(617, 29, NULL, 0, 1, '2014-03-27 15:17:00'),
(618, 29, NULL, 4, 6, '2014-03-27 15:17:13'),
(619, 29, NULL, 4, 6, '2014-03-27 15:17:24'),
(620, 29, NULL, 4, 6, '2014-03-27 15:17:25'),
(621, 64, NULL, 0, 3, '2014-03-27 15:17:28'),
(622, 64, NULL, 0, 1, '2014-03-27 15:18:03'),
(623, 29, NULL, 4, 6, '2014-03-27 15:18:09'),
(624, 29, NULL, 0, 1, '2014-03-27 15:22:19'),
(625, 29, NULL, 4, 6, '2014-03-27 15:22:44'),
(626, 0, NULL, 0, 10, '2014-03-27 15:22:56'),
(627, 0, NULL, 0, 10, '2014-03-27 15:23:07'),
(628, 0, NULL, 0, 10, '2014-03-27 15:23:17'),
(629, 29, NULL, 0, 6, '2014-03-27 15:25:21'),
(630, 29, NULL, 0, 6, '2014-03-27 15:25:55'),
(631, 29, NULL, 0, 1, '2014-03-27 15:26:21'),
(632, 29, NULL, 0, 6, '2014-03-27 15:27:06'),
(633, 0, NULL, 0, 10, '2014-03-27 15:37:03'),
(634, 0, NULL, 0, 10, '2014-03-27 15:37:12'),
(635, 0, NULL, 0, 10, '2014-03-27 15:37:33'),
(636, 0, NULL, 0, 10, '2014-03-27 15:37:41'),
(637, 0, NULL, 0, 10, '2014-03-27 15:39:05'),
(638, 0, NULL, 0, 10, '2014-03-27 15:39:23'),
(639, 0, NULL, 0, 10, '2014-03-27 15:39:56'),
(640, 0, NULL, 0, 10, '2014-03-27 15:41:04'),
(641, 0, NULL, 0, 10, '2014-03-27 15:41:11'),
(642, 0, NULL, 0, 10, '2014-03-27 15:41:32'),
(643, 0, NULL, 0, 10, '2014-03-27 15:41:47'),
(644, 29, NULL, 0, 1, '2014-03-27 15:46:31'),
(645, 29, NULL, 0, 1, '2014-03-27 15:51:22'),
(646, 0, NULL, 0, 10, '2014-03-27 15:53:50'),
(647, 0, NULL, 0, 10, '2014-03-27 15:54:00'),
(648, 0, NULL, 0, 10, '2014-03-27 15:54:28'),
(649, 29, NULL, 0, 1, '2014-03-27 15:54:41'),
(650, 0, NULL, 3, 6, '2014-03-27 15:54:48'),
(651, 29, NULL, 0, 6, '2014-03-27 15:55:03'),
(652, 0, NULL, 0, 10, '2014-03-27 15:55:22'),
(653, 0, NULL, 0, 10, '2014-03-27 15:55:25'),
(654, 0, NULL, 0, 10, '2014-03-27 15:55:40'),
(655, 64, NULL, 0, 1, '2014-03-27 15:56:28'),
(656, 29, NULL, 0, 1, '2014-03-27 15:57:10'),
(657, 0, NULL, 3, 1, '2014-03-27 15:57:24'),
(658, 65, NULL, 0, 3, '2014-03-27 15:58:12'),
(659, 65, NULL, 2, 1, '2014-03-27 15:58:19'),
(660, 65, NULL, 2, 1, '2014-03-27 15:58:32'),
(661, 65, NULL, 0, 1, '2014-03-27 15:58:47'),
(662, 29, NULL, 0, 1, '2014-03-27 15:59:23'),
(663, 0, NULL, 0, 10, '2014-03-27 16:00:38'),
(664, 0, NULL, 0, 10, '2014-03-27 16:00:57'),
(665, 29, NULL, 0, 1, '2014-03-27 16:02:34'),
(666, 29, NULL, 0, 6, '2014-03-27 16:04:58'),
(667, 29, NULL, 0, 1, '2014-03-27 16:05:53'),
(668, 29, NULL, 0, 1, '2014-03-27 16:08:33'),
(669, 29, NULL, 0, 1, '2014-03-27 16:10:08'),
(670, 0, NULL, 0, 10, '2014-03-27 16:12:32'),
(671, 66, NULL, 0, 3, '2014-03-27 16:14:53'),
(672, 66, NULL, 0, 1, '2014-03-27 16:15:07'),
(673, 0, NULL, 0, 10, '2014-03-27 16:23:08'),
(674, 29, NULL, 0, 1, '2014-03-27 16:27:40'),
(675, 29, NULL, 0, 1, '2014-03-27 16:45:02'),
(676, 29, NULL, 0, 1, '2014-03-27 17:15:23'),
(677, 10, NULL, 0, 1, '2014-03-27 17:15:56'),
(678, 0, NULL, 3, 1, '2014-03-27 17:26:27'),
(679, 29, NULL, 0, 1, '2014-03-27 19:21:00'),
(680, 29, NULL, 0, 1, '2014-03-27 20:04:50'),
(681, 29, NULL, 2, 1, '2014-03-27 20:06:45'),
(682, 29, NULL, 0, 1, '2014-03-27 20:06:53'),
(683, 29, NULL, 0, 1, '2014-03-27 20:08:57'),
(684, 29, NULL, 0, 1, '2014-03-27 20:12:26'),
(685, 29, NULL, 0, 1, '2014-03-27 20:13:06'),
(686, 29, NULL, 0, 1, '2014-03-27 20:15:02'),
(687, 29, NULL, 0, 1, '2014-03-27 20:19:44'),
(688, 29, NULL, 0, 1, '2014-03-27 20:28:34'),
(689, 29, NULL, 0, 1, '2014-03-27 20:33:23'),
(690, 29, NULL, 0, 1, '2014-03-27 20:34:56'),
(691, 0, NULL, 0, 10, '2014-03-27 21:03:54'),
(692, 67, NULL, 8, 6, '2014-03-27 21:24:25'),
(693, 67, NULL, 21, 6, '2014-03-27 21:24:54'),
(694, 67, NULL, 21, 6, '2014-03-27 21:25:52'),
(695, 67, NULL, 0, 6, '2014-03-27 21:27:40'),
(696, 67, NULL, 0, 6, '2014-03-27 21:29:08'),
(697, 67, NULL, 0, 6, '2014-03-27 21:37:52'),
(698, 67, NULL, 0, 6, '2014-03-27 21:40:11'),
(699, 67, NULL, 0, 6, '2014-03-27 21:40:43'),
(700, 67, NULL, 0, 6, '2014-03-27 21:47:03'),
(701, 29, NULL, 0, 1, '2014-03-27 21:50:05'),
(702, 67, NULL, 0, 6, '2014-03-27 21:50:09'),
(703, 29, NULL, 0, 6, '2014-03-27 21:50:19'),
(704, 29, NULL, 0, 6, '2014-03-27 21:50:25'),
(705, 29, NULL, 0, 6, '2014-03-27 21:50:41'),
(706, 67, NULL, 0, 6, '2014-03-27 21:52:17'),
(707, 67, NULL, 0, 6, '2014-03-27 21:52:48'),
(708, 29, NULL, 0, 1, '2014-03-27 21:54:27'),
(709, 67, NULL, 2, 1, '2014-03-27 21:55:34'),
(710, 67, NULL, 2, 1, '2014-03-27 21:55:48'),
(711, 67, NULL, 2, 1, '2014-03-27 21:58:07'),
(712, 67, NULL, 2, 1, '2014-03-27 21:59:05'),
(713, 67, NULL, 2, 1, '2014-03-27 22:00:25'),
(714, 67, NULL, 2, 1, '2014-03-27 22:00:35'),
(715, 10, NULL, 0, 1, '2014-03-27 22:01:11'),
(716, 67, NULL, 0, 6, '2014-03-27 22:01:23'),
(717, 29, NULL, 0, 1, '2014-03-27 22:01:36'),
(718, 67, NULL, 0, 6, '2014-03-27 22:01:55'),
(719, 67, NULL, 2, 1, '2014-03-27 22:02:19'),
(720, 29, NULL, 0, 1, '2014-03-27 22:03:36'),
(721, 10, NULL, 0, 1, '2014-03-27 22:04:17'),
(722, 10, NULL, 9, 6, '2014-03-27 22:04:25'),
(723, 10, NULL, 9, 6, '2014-03-27 22:04:42'),
(724, 10, NULL, 0, 1, '2014-03-27 22:06:34'),
(725, 10, NULL, 9, 6, '2014-03-27 22:06:54'),
(726, 67, NULL, 21, 6, '2014-03-27 22:09:44'),
(727, 10, NULL, 0, 1, '2014-03-27 22:10:39'),
(728, 10, NULL, 9, 6, '2014-03-27 22:10:48'),
(729, 10, NULL, 0, 6, '2014-03-27 22:12:16'),
(730, 10, NULL, 0, 1, '2014-03-27 22:12:47'),
(731, 10, NULL, 9, 6, '2014-03-27 22:12:56'),
(732, 10, NULL, 0, 1, '2014-03-27 22:14:40'),
(733, 10, NULL, 11, 6, '2014-03-27 22:14:47'),
(734, 10, NULL, 11, 6, '2014-03-27 22:15:10'),
(735, 10, NULL, 0, 1, '2014-03-27 22:16:10'),
(736, 10, NULL, 0, 6, '2014-03-27 22:16:16'),
(737, 10, NULL, 0, 6, '2014-03-27 22:20:21'),
(738, 10, NULL, 0, 6, '2014-03-27 22:20:52'),
(739, 10, NULL, 0, 6, '2014-03-27 22:21:10'),
(740, 10, NULL, 0, 6, '2014-03-27 22:21:58'),
(741, 10, NULL, 0, 6, '2014-03-27 22:21:58'),
(742, 10, NULL, 0, 6, '2014-03-27 22:21:59'),
(743, 10, NULL, 0, 6, '2014-03-27 22:22:01'),
(744, 10, NULL, 0, 6, '2014-03-27 22:22:01'),
(745, 10, NULL, 0, 6, '2014-03-27 22:22:02'),
(746, 10, NULL, 0, 6, '2014-03-27 22:22:03'),
(747, 10, NULL, 0, 6, '2014-03-27 22:22:04'),
(748, 10, NULL, 0, 6, '2014-03-27 22:27:15'),
(749, 10, NULL, 0, 6, '2014-03-27 22:27:16'),
(750, 10, NULL, 0, 6, '2014-03-27 22:27:18'),
(751, 10, NULL, 0, 6, '2014-03-27 22:27:20'),
(752, 29, NULL, 0, 1, '2014-03-27 22:27:54'),
(753, 10, NULL, 0, 6, '2014-03-27 22:27:56'),
(754, 29, NULL, 0, 1, '2014-03-27 22:28:49'),
(755, 10, NULL, 0, 6, '2014-03-27 22:29:26'),
(756, 29, NULL, 0, 1, '2014-03-27 22:29:38'),
(757, 10, NULL, 0, 6, '2014-03-27 22:29:50'),
(758, 10, NULL, 0, 6, '2014-03-27 22:30:05'),
(759, 29, NULL, 0, 1, '2014-03-27 22:31:13'),
(760, 10, NULL, 0, 1, '2014-03-27 22:32:19'),
(761, 10, NULL, 8, 6, '2014-03-27 22:32:36'),
(762, 10, NULL, 8, 6, '2014-03-27 22:32:38'),
(763, 29, NULL, 0, 1, '2014-03-27 22:33:02'),
(764, 10, NULL, 0, 6, '2014-03-27 22:33:27'),
(765, 10, NULL, 0, 6, '2014-03-27 22:33:31'),
(766, 29, NULL, 0, 1, '2014-03-27 22:33:38'),
(767, 10, NULL, 0, 1, '2014-03-27 22:33:39'),
(768, 10, NULL, 9, 6, '2014-03-27 22:33:47'),
(769, 29, NULL, 0, 1, '2014-03-27 22:34:42'),
(770, 10, NULL, 0, 6, '2014-03-27 22:35:02'),
(771, 10, NULL, 0, 6, '2014-03-27 22:35:10'),
(772, 10, NULL, 9, 6, '2014-03-27 22:35:33'),
(773, 10, NULL, 0, 1, '2014-03-27 22:37:50'),
(774, 10, NULL, 9, 6, '2014-03-27 22:41:06'),
(775, 10, NULL, 0, 6, '2014-03-27 22:48:58'),
(776, 10, NULL, 0, 6, '2014-03-27 22:49:01'),
(777, 10, NULL, 0, 6, '2014-03-27 22:49:04'),
(778, 10, NULL, 0, 6, '2014-03-27 22:49:11'),
(779, 10, NULL, 0, 6, '2014-03-27 22:49:14'),
(780, 10, NULL, 0, 6, '2014-03-27 22:49:17'),
(781, 10, NULL, 0, 6, '2014-03-27 22:50:17'),
(782, 10, NULL, 0, 6, '2014-03-27 22:50:21'),
(783, 10, NULL, 0, 6, '2014-03-27 22:50:26'),
(784, 10, NULL, 0, 6, '2014-03-27 22:50:29'),
(785, 10, NULL, 0, 6, '2014-03-27 22:50:32'),
(786, 10, NULL, 0, 6, '2014-03-27 22:50:35'),
(787, 10, NULL, 0, 6, '2014-03-27 22:50:38'),
(788, 10, NULL, 0, 6, '2014-03-27 22:50:42'),
(789, 10, NULL, 0, 1, '2014-03-27 22:50:53'),
(790, 10, NULL, 0, 6, '2014-03-27 22:52:07'),
(791, 10, NULL, 0, 6, '2014-03-27 22:52:11'),
(792, 10, NULL, 0, 6, '2014-03-27 22:52:14'),
(793, 29, NULL, 0, 1, '2014-03-27 22:52:15'),
(794, 10, NULL, 0, 6, '2014-03-27 22:52:19'),
(795, 10, NULL, 0, 6, '2014-03-27 22:52:32'),
(796, 10, NULL, 0, 6, '2014-03-27 22:52:36'),
(797, 10, NULL, 0, 6, '2014-03-27 22:53:03'),
(798, 10, NULL, 0, 6, '2014-03-27 22:53:10'),
(799, 10, NULL, 0, 6, '2014-03-27 22:53:13'),
(800, 10, NULL, 0, 6, '2014-03-27 22:55:49'),
(801, 10, NULL, 0, 6, '2014-03-27 22:57:13'),
(802, 29, NULL, 0, 1, '2014-03-27 22:57:24'),
(803, 10, NULL, 0, 1, '2014-03-27 22:57:59'),
(804, 10, NULL, 0, 6, '2014-03-27 22:58:06'),
(805, 29, NULL, 0, 1, '2014-03-27 22:58:55'),
(806, 29, NULL, 0, 1, '2014-03-27 22:59:37'),
(807, 10, NULL, 0, 1, '2014-03-27 22:59:42'),
(808, 10, NULL, 0, 6, '2014-03-27 22:59:50'),
(809, 29, NULL, 0, 1, '2014-03-27 23:04:30'),
(810, 29, NULL, 0, 1, '2014-03-27 23:05:53'),
(811, 10, NULL, 0, 6, '2014-03-27 23:06:48'),
(812, 10, NULL, 0, 6, '2014-03-27 23:07:14'),
(813, 10, NULL, 0, 6, '2014-03-27 23:07:26'),
(814, 29, NULL, 0, 1, '2014-03-27 23:09:32'),
(815, 29, NULL, 0, 1, '2014-03-27 23:10:24'),
(816, 10, NULL, 0, 6, '2014-03-27 23:10:36'),
(817, 10, NULL, 0, 1, '2014-03-27 23:10:52'),
(818, 29, NULL, 0, 1, '2014-03-27 23:11:01'),
(819, 10, NULL, 0, 6, '2014-03-27 23:11:02'),
(820, 10, NULL, 0, 6, '2014-03-27 23:11:25'),
(821, 29, NULL, 0, 1, '2014-03-27 23:12:34'),
(822, 29, NULL, 0, 1, '2014-03-27 23:12:46'),
(823, 10, NULL, 0, 6, '2014-03-27 23:13:15'),
(824, 10, NULL, 0, 6, '2014-03-27 23:13:45'),
(825, 10, NULL, 0, 6, '2014-03-27 23:13:48'),
(826, 10, NULL, 0, 6, '2014-03-27 23:14:24'),
(827, 10, NULL, 0, 6, '2014-03-27 23:14:29'),
(828, 10, NULL, 0, 6, '2014-03-27 23:15:10'),
(829, 29, NULL, 0, 1, '2014-03-27 23:18:45'),
(830, 29, NULL, 0, 1, '2014-03-27 23:19:02'),
(831, 29, NULL, 0, 1, '2014-03-27 23:19:13'),
(832, 29, NULL, 0, 1, '2014-03-27 23:20:25'),
(833, 29, NULL, 0, 1, '2014-03-27 23:21:12'),
(834, 0, NULL, 0, 10, '2014-03-27 23:22:06'),
(835, 10, NULL, 0, 1, '2014-03-27 23:22:53'),
(836, 10, NULL, 0, 6, '2014-03-27 23:22:54'),
(837, 10, NULL, 0, 6, '2014-03-27 23:23:36'),
(838, 10, NULL, 0, 6, '2014-03-27 23:23:36'),
(839, 10, NULL, 0, 6, '2014-03-27 23:23:37'),
(840, 10, NULL, 0, 6, '2014-03-27 23:23:37'),
(841, 10, NULL, 0, 6, '2014-03-27 23:23:37'),
(842, 10, NULL, 0, 6, '2014-03-27 23:23:37'),
(843, 10, NULL, 0, 6, '2014-03-27 23:23:38'),
(844, 10, NULL, 0, 6, '2014-03-27 23:23:38'),
(845, 10, NULL, 0, 6, '2014-03-27 23:23:39'),
(846, 10, NULL, 0, 6, '2014-03-27 23:23:39'),
(847, 10, NULL, 0, 6, '2014-03-27 23:23:39'),
(848, 10, NULL, 0, 6, '2014-03-27 23:23:39'),
(849, 10, NULL, 0, 6, '2014-03-27 23:23:40'),
(850, 10, NULL, 0, 6, '2014-03-27 23:23:40'),
(851, 10, NULL, 0, 6, '2014-03-27 23:23:40'),
(852, 10, NULL, 0, 6, '2014-03-27 23:23:40'),
(853, 10, NULL, 0, 6, '2014-03-27 23:23:40'),
(854, 10, NULL, 0, 6, '2014-03-27 23:23:41'),
(855, 10, NULL, 0, 6, '2014-03-27 23:23:41'),
(856, 10, NULL, 0, 6, '2014-03-27 23:23:43'),
(857, 10, NULL, 0, 6, '2014-03-27 23:24:00'),
(858, 10, NULL, 0, 6, '2014-03-27 23:24:00'),
(859, 10, NULL, 0, 6, '2014-03-27 23:24:00'),
(860, 10, NULL, 0, 6, '2014-03-27 23:24:01'),
(861, 10, NULL, 0, 6, '2014-03-27 23:24:01'),
(862, 10, NULL, 0, 6, '2014-03-27 23:24:01'),
(863, 10, NULL, 0, 6, '2014-03-27 23:24:01'),
(864, 10, NULL, 0, 6, '2014-03-27 23:24:01'),
(865, 10, NULL, 0, 6, '2014-03-27 23:24:01'),
(866, 10, NULL, 0, 6, '2014-03-27 23:24:01'),
(867, 10, NULL, 0, 6, '2014-03-27 23:24:01'),
(868, 10, NULL, 0, 6, '2014-03-27 23:24:01'),
(869, 10, NULL, 0, 6, '2014-03-27 23:24:01'),
(870, 10, NULL, 0, 6, '2014-03-27 23:24:02'),
(871, 10, NULL, 0, 6, '2014-03-27 23:24:02'),
(872, 10, NULL, 0, 6, '2014-03-27 23:24:02'),
(873, 10, NULL, 0, 6, '2014-03-27 23:24:02'),
(874, 10, NULL, 0, 6, '2014-03-27 23:24:02'),
(875, 10, NULL, 0, 6, '2014-03-27 23:24:02'),
(876, 10, NULL, 0, 6, '2014-03-27 23:24:02'),
(877, 10, NULL, 0, 6, '2014-03-27 23:24:02'),
(878, 10, NULL, 0, 6, '2014-03-27 23:24:03'),
(879, 10, NULL, 0, 6, '2014-03-27 23:24:03'),
(880, 10, NULL, 0, 6, '2014-03-27 23:24:03'),
(881, 10, NULL, 0, 6, '2014-03-27 23:24:03'),
(882, 10, NULL, 0, 6, '2014-03-27 23:24:04'),
(883, 10, NULL, 0, 6, '2014-03-27 23:24:04'),
(884, 10, NULL, 0, 6, '2014-03-27 23:24:04'),
(885, 10, NULL, 0, 6, '2014-03-27 23:24:04'),
(886, 10, NULL, 0, 6, '2014-03-27 23:24:04'),
(887, 10, NULL, 0, 6, '2014-03-27 23:24:04'),
(888, 10, NULL, 0, 6, '2014-03-27 23:24:04'),
(889, 10, NULL, 0, 6, '2014-03-27 23:24:05'),
(890, 10, NULL, 0, 6, '2014-03-27 23:24:05'),
(891, 10, NULL, 0, 6, '2014-03-27 23:24:05'),
(892, 10, NULL, 0, 6, '2014-03-27 23:24:05'),
(893, 10, NULL, 0, 6, '2014-03-27 23:24:05'),
(894, 10, NULL, 0, 6, '2014-03-27 23:24:06'),
(895, 10, NULL, 0, 6, '2014-03-27 23:24:06'),
(896, 10, NULL, 0, 6, '2014-03-27 23:24:06'),
(897, 10, NULL, 0, 6, '2014-03-27 23:24:07'),
(898, 10, NULL, 0, 6, '2014-03-27 23:24:07'),
(899, 10, NULL, 0, 6, '2014-03-27 23:24:07'),
(900, 10, NULL, 0, 6, '2014-03-27 23:24:08'),
(901, 10, NULL, 0, 6, '2014-03-27 23:24:08'),
(902, 10, NULL, 0, 6, '2014-03-27 23:24:09'),
(903, 10, NULL, 0, 1, '2014-03-27 23:24:09'),
(904, 10, NULL, 0, 6, '2014-03-27 23:24:11'),
(905, 10, NULL, 0, 1, '2014-03-27 23:24:27'),
(906, 10, NULL, 0, 6, '2014-03-27 23:24:28'),
(907, 10, NULL, 0, 1, '2014-03-27 23:24:33'),
(908, 10, NULL, 0, 6, '2014-03-27 23:24:35'),
(909, 29, NULL, 0, 1, '2014-03-27 23:24:52'),
(910, 0, NULL, 0, 10, '2014-03-27 23:26:01'),
(911, 0, NULL, 0, 10, '2014-03-27 23:26:06'),
(912, 0, NULL, 0, 10, '2014-03-27 23:26:19'),
(913, 10, NULL, 0, 1, '2014-03-27 23:26:28'),
(914, 10, NULL, 0, 6, '2014-03-27 23:26:29'),
(915, 0, NULL, 0, 10, '2014-03-27 23:26:34'),
(916, 29, NULL, 0, 1, '2014-03-27 23:28:48'),
(917, 29, NULL, 0, 1, '2014-03-27 23:37:43'),
(918, 10, NULL, 0, 1, '2014-03-27 23:39:21'),
(919, 10, NULL, 8, 6, '2014-03-27 23:39:31'),
(920, 10, NULL, 4, 6, '2014-03-27 23:40:38'),
(921, 10, NULL, 0, 6, '2014-03-27 23:41:10'),
(922, 10, NULL, 0, 6, '2014-03-27 23:41:19'),
(923, 10, NULL, 0, 1, '2014-03-27 23:41:21'),
(924, 10, NULL, 8, 6, '2014-03-27 23:41:30'),
(925, 10, NULL, 8, 6, '2014-03-27 23:41:33'),
(926, 10, NULL, 0, 1, '2014-03-27 23:42:03'),
(927, 10, NULL, 0, 6, '2014-03-27 23:42:11'),
(928, 10, NULL, 0, 6, '2014-03-27 23:42:15'),
(929, 10, NULL, 0, 6, '2014-03-27 23:42:26'),
(930, 10, NULL, 0, 6, '2014-03-27 23:42:30'),
(931, 10, NULL, 0, 1, '2014-03-27 23:44:15'),
(932, 67, NULL, 0, 1, '2014-03-27 23:44:45'),
(933, 67, NULL, 2, 1, '2014-03-27 23:45:19'),
(934, 67, NULL, 2, 1, '2014-03-27 23:46:20'),
(935, 67, NULL, 0, 1, '2014-03-27 23:47:13'),
(936, 67, NULL, 0, 1, '2014-03-27 23:48:51'),
(937, 67, NULL, 0, 1, '2014-03-27 23:48:51'),
(938, 67, NULL, 2, 1, '2014-03-27 23:48:57'),
(939, 67, NULL, 0, 6, '2014-03-27 23:49:07'),
(940, 67, NULL, 0, 6, '2014-03-27 23:49:09'),
(941, 67, NULL, 0, 6, '2014-03-27 23:49:10'),
(942, 29, NULL, 0, 1, '2014-03-27 23:51:39'),
(943, 29, NULL, 0, 1, '2014-03-27 23:53:47'),
(944, 67, NULL, 2, 1, '2014-03-27 23:53:55'),
(945, 67, NULL, 2, 1, '2014-03-27 23:55:52'),
(946, 29, NULL, 0, 1, '2014-03-27 23:56:34'),
(947, 10, NULL, 0, 1, '2014-03-28 00:14:26'),
(948, 10, NULL, 0, 6, '2014-03-28 00:14:41'),
(949, 10, NULL, 0, 6, '2014-03-28 00:14:43'),
(950, 0, NULL, 3, 1, '2014-03-28 00:23:18'),
(951, 29, NULL, 0, 1, '2014-03-28 00:23:30'),
(952, 10, NULL, 0, 1, '2014-03-28 00:41:08'),
(953, 29, NULL, 0, 1, '2014-03-28 00:43:27'),
(954, 0, NULL, 3, 1, '2014-03-28 00:43:56'),
(955, 29, NULL, 2, 1, '2014-03-28 00:44:11'),
(956, 29, NULL, 0, 1, '2014-03-28 00:44:18'),
(957, 10, NULL, 0, 1, '2014-03-28 00:47:07'),
(958, 29, NULL, 0, 1, '2014-03-28 00:48:47'),
(959, 10, NULL, 0, 1, '2014-03-28 01:00:11'),
(960, 10, NULL, 0, 1, '2014-03-28 01:18:24'),
(961, 10, NULL, 0, 1, '2014-03-28 01:20:03'),
(962, 0, NULL, 3, 1, '2014-03-28 01:22:13'),
(963, 29, NULL, 0, 1, '2014-03-28 01:22:23'),
(964, 10, NULL, 0, 1, '2014-03-28 01:23:04'),
(965, 0, NULL, 3, 1, '2014-03-28 02:39:44'),
(966, 29, NULL, 2, 1, '2014-03-28 02:39:54'),
(967, 29, NULL, 0, 1, '2014-03-28 02:40:01'),
(968, 0, NULL, 3, 1, '2014-03-28 02:41:32'),
(969, 29, NULL, 2, 1, '2014-03-28 02:41:55'),
(970, 29, NULL, 0, 1, '2014-03-28 02:42:18'),
(971, 29, NULL, 0, 1, '2014-03-28 02:43:44'),
(972, 29, NULL, 0, 1, '2014-03-28 02:45:54'),
(973, 29, NULL, 0, 1, '2014-03-28 02:46:43'),
(974, 29, NULL, 0, 1, '2014-03-28 02:52:10'),
(975, 29, NULL, 0, 1, '2014-03-28 02:55:45'),
(976, 29, NULL, 0, 1, '2014-03-28 02:58:08'),
(977, 29, NULL, 0, 1, '2014-03-28 03:00:07'),
(978, 29, NULL, 0, 1, '2014-03-28 03:17:28'),
(979, 29, NULL, 0, 1, '2014-03-28 03:18:29'),
(980, 29, NULL, 0, 1, '2014-03-28 03:19:41'),
(981, 29, NULL, 0, 1, '2014-03-28 03:21:06'),
(982, 10, NULL, 0, 1, '2014-03-28 09:08:52'),
(983, 10, NULL, 0, 6, '2014-03-28 09:09:03'),
(984, 10, NULL, 0, 6, '2014-03-28 09:09:07'),
(985, 10, NULL, 0, 6, '2014-03-28 09:09:19'),
(986, 10, NULL, 0, 1, '2014-03-28 09:16:59'),
(987, 10, NULL, 0, 6, '2014-03-28 09:17:34'),
(988, 10, NULL, 0, 1, '2014-03-28 09:18:57'),
(989, 10, NULL, 0, 6, '2014-03-28 09:19:06'),
(990, 10, NULL, 0, 6, '2014-03-28 09:19:08'),
(991, 10, NULL, 0, 1, '2014-03-28 09:20:19'),
(992, 10, NULL, 0, 1, '2014-03-28 09:26:15'),
(993, 10, NULL, 0, 6, '2014-03-28 10:52:40'),
(994, 10, NULL, 0, 1, '2014-03-28 10:53:52'),
(995, 67, NULL, 0, 6, '2014-03-28 10:54:22'),
(996, 10, NULL, 0, 6, '2014-03-28 10:54:26'),
(997, 10, NULL, 0, 6, '2014-03-28 10:56:13'),
(998, 60, NULL, 6, 3, '2014-03-28 12:15:33'),
(999, 68, NULL, 0, 3, '2014-03-28 12:15:56'),
(1000, 68, NULL, 0, 1, '2014-03-28 12:16:08'),
(1001, 10, NULL, 0, 1, '2014-03-28 12:16:47'),
(1002, 10, NULL, 0, 6, '2014-03-28 12:17:08'),
(1003, 10, NULL, 0, 6, '2014-03-28 12:17:10'),
(1004, 69, NULL, 0, 3, '2014-03-28 12:22:15'),
(1005, 69, NULL, 0, 1, '2014-03-28 12:22:30'),
(1006, 10, NULL, 0, 1, '2014-03-28 12:23:00'),
(1007, 10, NULL, 0, 6, '2014-03-28 12:23:19'),
(1008, 10, NULL, 0, 6, '2014-03-28 12:23:22'),
(1009, 1, NULL, 2, 1, '2014-03-28 15:02:51'),
(1010, 10, NULL, 0, 1, '2014-03-28 15:03:09'),
(1011, 10, NULL, 0, 6, '2014-03-28 15:03:27'),
(1012, 10, NULL, 0, 6, '2014-03-28 15:03:28'),
(1013, 29, NULL, 0, 1, '2014-03-28 15:06:06'),
(1014, 29, NULL, 21, 6, '2014-03-28 15:08:29'),
(1015, 29, NULL, 21, 6, '2014-03-28 15:08:45'),
(1016, 29, NULL, 21, 6, '2014-03-28 15:08:58'),
(1017, 29, NULL, 0, 1, '2014-03-28 15:13:11'),
(1018, 10, NULL, 0, 1, '2014-03-28 15:13:39'),
(1019, 65, NULL, 0, 1, '2014-03-28 16:25:24'),
(1020, 65, NULL, 0, 1, '2014-03-28 16:26:42'),
(1021, 65, NULL, 0, 1, '2014-03-28 16:35:29'),
(1022, 0, NULL, 0, 3, '2014-03-28 16:36:33'),
(1023, 65, NULL, 6, 3, '2014-03-28 16:37:46'),
(1024, 1, NULL, 2, 1, '2014-03-28 16:38:22'),
(1025, 1, NULL, 2, 1, '2014-03-28 16:38:33'),
(1026, 10, NULL, 0, 1, '2014-03-28 16:39:03'),
(1027, 10, NULL, 0, 1, '2014-03-28 16:39:35'),
(1028, 1, NULL, 2, 1, '2014-03-28 16:54:56'),
(1029, 10, NULL, 0, 1, '2014-03-28 20:30:55'),
(1030, 10, NULL, 0, 1, '2014-03-29 14:59:45'),
(1031, 10, NULL, 0, 6, '2014-03-29 15:00:05'),
(1032, 10, NULL, 0, 1, '2014-03-29 15:11:27'),
(1033, 10, NULL, 0, 6, '2014-03-29 15:11:49'),
(1034, 0, NULL, 3, 1, '2014-03-30 11:55:11'),
(1035, 10, NULL, 2, 1, '2014-03-30 11:55:22'),
(1036, 10, NULL, 0, 1, '2014-03-30 11:55:31'),
(1037, 10, NULL, 0, 1, '2014-03-30 12:02:42'),
(1038, 10, NULL, 0, 1, '2014-03-30 12:07:33'),
(1039, 10, NULL, 0, 1, '2014-03-31 06:49:22'),
(1040, 10, NULL, 0, 1, '2014-03-31 06:50:36'),
(1041, 10, NULL, 0, 1, '2014-03-31 07:15:58'),
(1042, 10, NULL, 0, 1, '2014-03-31 08:06:29'),
(1043, 10, NULL, 0, 1, '2014-03-31 08:08:45'),
(1044, 10, NULL, 0, 1, '2014-03-31 08:08:50'),
(1045, 10, NULL, 0, 1, '2014-03-31 08:08:52'),
(1046, 10, NULL, 0, 1, '2014-03-31 08:09:02'),
(1047, 10, NULL, 0, 1, '2014-03-31 08:09:19'),
(1048, 10, NULL, 0, 1, '2014-03-31 08:12:40'),
(1049, 10, NULL, 0, 1, '2014-03-31 08:12:44'),
(1050, 10, NULL, 0, 1, '2014-03-31 08:12:46'),
(1051, 10, NULL, 0, 1, '2014-03-31 08:12:53'),
(1052, 10, NULL, 0, 1, '2014-03-31 08:13:35'),
(1053, 10, NULL, 0, 1, '2014-03-31 08:13:39'),
(1054, 10, NULL, 0, 1, '2014-03-31 08:16:43'),
(1055, 10, NULL, 0, 1, '2014-03-31 08:16:45'),
(1056, 10, NULL, 0, 1, '2014-03-31 08:18:11'),
(1057, 10, NULL, 0, 1, '2014-03-31 08:18:16'),
(1058, 10, NULL, 0, 1, '2014-03-31 08:18:19'),
(1059, 10, NULL, 0, 1, '2014-03-31 08:18:24'),
(1060, 10, NULL, 0, 1, '2014-03-31 08:18:28'),
(1061, 10, NULL, 0, 1, '2014-03-31 08:18:51'),
(1062, 10, NULL, 0, 1, '2014-03-31 08:18:55'),
(1063, 10, NULL, 0, 1, '2014-03-31 08:24:43'),
(1064, 10, NULL, 0, 1, '2014-03-31 08:29:20'),
(1065, 10, NULL, 0, 1, '2014-03-31 08:31:19'),
(1066, 10, NULL, 0, 1, '2014-03-31 08:37:46'),
(1067, 10, NULL, 0, 1, '2014-03-31 08:40:24'),
(1068, 10, NULL, 0, 1, '2014-03-31 08:42:34'),
(1069, 10, NULL, 0, 1, '2014-03-31 08:45:16'),
(1070, 10, NULL, 0, 1, '2014-03-31 08:51:31'),
(1071, 10, NULL, 0, 1, '2014-03-31 08:57:09'),
(1072, 10, NULL, 0, 1, '2014-03-31 08:58:36'),
(1073, 10, NULL, 0, 1, '2014-03-31 08:58:59'),
(1074, 10, NULL, 0, 1, '2014-03-31 08:59:08'),
(1075, 10, NULL, 0, 1, '2014-03-31 08:59:30'),
(1076, 10, NULL, 0, 1, '2014-03-31 08:59:54'),
(1077, 10, NULL, 0, 1, '2014-03-31 09:04:20'),
(1078, 10, NULL, 0, 1, '2014-03-31 09:04:25'),
(1079, 10, NULL, 0, 1, '2014-03-31 09:05:18'),
(1080, 10, NULL, 0, 1, '2014-03-31 09:05:23'),
(1081, 10, NULL, 0, 1, '2014-03-31 09:05:29'),
(1082, 10, NULL, 0, 1, '2014-03-31 09:09:52'),
(1083, 10, NULL, 0, 1, '2014-03-31 09:10:13'),
(1084, 10, NULL, 0, 1, '2014-03-31 09:10:17'),
(1085, 10, NULL, 0, 1, '2014-03-31 09:10:21'),
(1086, 10, NULL, 0, 1, '2014-03-31 09:10:30'),
(1087, 10, NULL, 0, 1, '2014-03-31 09:12:37'),
(1088, 10, NULL, 0, 1, '2014-03-31 09:17:25'),
(1089, 10, NULL, 0, 1, '2014-03-31 09:17:46'),
(1090, 10, NULL, 0, 1, '2014-03-31 13:33:05'),
(1091, 10, NULL, 0, 1, '2014-03-31 14:06:21'),
(1092, 10, NULL, 0, 1, '2014-03-31 14:08:11'),
(1093, 10, NULL, 0, 1, '2014-03-31 14:09:37'),
(1094, 10, NULL, 0, 1, '2014-03-31 14:10:00'),
(1095, 10, NULL, 0, 1, '2014-03-31 14:10:04'),
(1096, 10, NULL, 0, 1, '2014-03-31 14:12:22'),
(1097, 10, NULL, 0, 1, '2014-03-31 14:14:28'),
(1098, 10, NULL, 0, 1, '2014-03-31 14:30:23'),
(1099, 10, NULL, 0, 1, '2014-03-31 14:31:03'),
(1100, 10, NULL, 0, 1, '2014-03-31 14:33:38'),
(1101, 10, NULL, 0, 6, '2014-03-31 14:33:56'),
(1102, 10, NULL, 0, 6, '2014-03-31 14:34:01'),
(1103, 10, NULL, 4, 6, '2014-03-31 14:34:04'),
(1104, 10, NULL, 4, 6, '2014-03-31 14:34:07'),
(1105, 10, NULL, 0, 6, '2014-03-31 14:34:14'),
(1106, 10, NULL, 0, 6, '2014-03-31 14:34:18'),
(1107, 10, NULL, 0, 6, '2014-03-31 14:34:21'),
(1108, 10, NULL, 0, 6, '2014-03-31 14:34:24'),
(1109, 10, NULL, 4, 6, '2014-03-31 14:34:30'),
(1110, 10, NULL, 4, 6, '2014-03-31 14:34:46'),
(1111, 10, NULL, 0, 6, '2014-03-31 14:34:59'),
(1112, 10, NULL, 0, 1, '2014-03-31 14:37:29'),
(1113, 10, NULL, 0, 1, '2014-03-31 14:38:27'),
(1114, 10, NULL, 0, 1, '2014-03-31 14:38:37'),
(1115, 10, NULL, 0, 1, '2014-03-31 14:38:40'),
(1116, 10, NULL, 0, 1, '2014-03-31 14:40:28'),
(1117, 10, NULL, 0, 1, '2014-03-31 14:40:46'),
(1118, 10, NULL, 0, 1, '2014-03-31 14:40:54'),
(1119, 10, NULL, 0, 1, '2014-03-31 14:46:55'),
(1120, 10, NULL, 0, 1, '2014-03-31 15:09:09'),
(1121, 10, NULL, 0, 6, '2014-03-31 15:09:16'),
(1122, 10, NULL, 0, 6, '2014-03-31 15:09:21'),
(1123, 10, NULL, 4, 6, '2014-03-31 15:09:31'),
(1124, 10, NULL, 4, 6, '2014-03-31 15:09:35'),
(1125, 10, NULL, 4, 6, '2014-03-31 15:09:40'),
(1126, 10, NULL, 0, 6, '2014-03-31 15:09:45'),
(1127, 10, NULL, 0, 6, '2014-03-31 15:09:48'),
(1128, 10, NULL, 0, 6, '2014-03-31 15:09:50'),
(1129, 10, NULL, 0, 6, '2014-03-31 15:09:53'),
(1130, 10, NULL, 0, 6, '2014-03-31 15:09:57'),
(1131, 10, NULL, 0, 1, '2014-03-31 15:23:40'),
(1132, 10, NULL, 0, 6, '2014-03-31 15:23:51'),
(1133, 10, NULL, 0, 6, '2014-03-31 15:23:57'),
(1134, 10, NULL, 0, 1, '2014-03-31 15:37:38'),
(1135, 10, NULL, 0, 1, '2014-03-31 15:37:43'),
(1136, 10, NULL, 0, 1, '2014-03-31 15:39:51'),
(1137, 10, NULL, 0, 1, '2014-03-31 15:42:00'),
(1138, 10, NULL, 0, 1, '2014-03-31 15:42:07'),
(1139, 10, NULL, 0, 1, '2014-03-31 15:42:11'),
(1140, 10, NULL, 0, 1, '2014-03-31 15:42:26'),
(1141, 10, NULL, 0, 1, '2014-03-31 20:45:59'),
(1142, 10, NULL, 0, 1, '2014-03-31 21:12:15'),
(1143, 10, NULL, 0, 1, '2014-03-31 21:12:20'),
(1144, 10, NULL, 0, 1, '2014-03-31 21:12:23'),
(1145, 10, NULL, 0, 1, '2014-03-31 21:12:28'),
(1146, 10, NULL, 0, 1, '2014-03-31 21:12:36'),
(1147, 10, NULL, 0, 1, '2014-03-31 21:12:39'),
(1148, 10, NULL, 0, 1, '2014-03-31 21:12:46'),
(1149, 10, NULL, 0, 1, '2014-03-31 21:14:00'),
(1150, 10, NULL, 0, 1, '2014-03-31 21:14:04'),
(1151, 10, NULL, 0, 1, '2014-03-31 21:16:47'),
(1152, 10, NULL, 0, 1, '2014-03-31 21:17:48'),
(1153, 10, NULL, 0, 1, '2014-03-31 21:20:11'),
(1154, 10, NULL, 0, 1, '2014-03-31 21:23:01'),
(1155, 10, NULL, 0, 1, '2014-03-31 21:23:08'),
(1156, 10, NULL, 0, 1, '2014-03-31 21:23:20'),
(1157, 10, NULL, 0, 1, '2014-03-31 21:26:40'),
(1158, 10, NULL, 0, 1, '2014-03-31 21:26:45'),
(1159, 10, NULL, 0, 1, '2014-03-31 21:29:16'),
(1160, 10, NULL, 0, 6, '2014-03-31 21:29:47'),
(1161, 10, NULL, 0, 1, '2014-03-31 21:29:59'),
(1162, 10, NULL, 0, 1, '2014-03-31 21:30:41'),
(1163, 10, NULL, 0, 1, '2014-03-31 21:31:41'),
(1164, 10, NULL, 0, 1, '2014-03-31 21:34:51'),
(1165, 10, NULL, 0, 1, '2014-03-31 21:37:41'),
(1166, 10, NULL, 0, 1, '2014-03-31 21:37:57'),
(1167, 10, NULL, 0, 1, '2014-03-31 21:40:40'),
(1168, 10, NULL, 0, 1, '2014-03-31 21:48:09'),
(1169, 10, NULL, 0, 1, '2014-03-31 21:49:13'),
(1170, 10, NULL, 0, 1, '2014-03-31 21:49:18'),
(1171, 10, NULL, 0, 1, '2014-03-31 21:50:58'),
(1172, 10, NULL, 0, 1, '2014-03-31 21:53:12'),
(1173, 10, NULL, 0, 1, '2014-03-31 21:54:30'),
(1174, 10, NULL, 0, 1, '2014-03-31 21:55:12'),
(1175, 10, NULL, 0, 1, '2014-03-31 21:55:13'),
(1176, 10, NULL, 0, 1, '2014-03-31 21:55:16'),
(1177, 10, NULL, 0, 1, '2014-03-31 21:56:01'),
(1178, 10, NULL, 0, 1, '2014-03-31 21:56:38'),
(1179, 10, NULL, 0, 1, '2014-03-31 21:56:44'),
(1180, 10, NULL, 0, 1, '2014-03-31 21:56:48'),
(1181, 10, NULL, 0, 1, '2014-03-31 21:56:54'),
(1182, 10, NULL, 0, 1, '2014-03-31 21:56:58'),
(1183, 10, NULL, 0, 1, '2014-03-31 21:57:06'),
(1184, 10, NULL, 0, 1, '2014-03-31 21:57:10'),
(1185, 10, NULL, 0, 1, '2014-03-31 21:57:12'),
(1186, 10, NULL, 0, 1, '2014-03-31 21:57:13'),
(1187, 10, NULL, 0, 1, '2014-03-31 22:02:57'),
(1188, 10, NULL, 0, 1, '2014-03-31 22:04:14'),
(1189, 10, NULL, 0, 1, '2014-03-31 22:04:27'),
(1190, 10, NULL, 0, 1, '2014-03-31 22:11:53'),
(1191, 10, NULL, 0, 1, '2014-03-31 23:03:02'),
(1192, 10, NULL, 0, 1, '2014-03-31 23:03:51'),
(1193, 10, NULL, 0, 1, '2014-03-31 23:11:27'),
(1194, 10, NULL, 0, 1, '2014-03-31 23:18:13'),
(1195, 10, NULL, 0, 1, '2014-03-31 23:24:00'),
(1196, 10, NULL, 0, 1, '2014-03-31 23:24:02'),
(1197, 10, NULL, 0, 1, '2014-03-31 23:24:11'),
(1198, 10, NULL, 0, 1, '2014-03-31 23:24:27'),
(1199, 10, NULL, 0, 1, '2014-03-31 23:37:27'),
(1200, 10, NULL, 0, 1, '2014-03-31 23:52:19'),
(1201, 10, NULL, 0, 1, '2014-04-01 00:03:01'),
(1202, 10, NULL, 0, 1, '2014-04-01 00:03:38'),
(1203, 10, NULL, 0, 1, '2014-04-01 09:40:22'),
(1204, 10, NULL, 0, 1, '2014-04-02 08:58:05'),
(1205, 10, NULL, 0, 1, '2014-04-02 10:35:23'),
(1206, 10, NULL, 0, 1, '2014-04-02 10:35:35'),
(1207, 10, NULL, 2, 1, '2014-04-02 10:35:43'),
(1208, 10, NULL, 0, 1, '2014-04-02 10:40:57'),
(1209, 10, NULL, 0, 1, '2014-04-02 10:53:38'),
(1210, 10, NULL, 0, 1, '2014-04-02 14:15:47'),
(1211, 10, NULL, 0, 1, '2014-04-02 14:25:28'),
(1212, 10, NULL, 0, 1, '2014-04-02 14:30:50'),
(1213, 10, NULL, 0, 1, '2014-04-02 14:32:59'),
(1214, 10, NULL, 0, 6, '2014-04-02 14:36:12'),
(1215, 10, NULL, 0, 6, '2014-04-02 14:36:14'),
(1216, 10, NULL, 0, 6, '2014-04-02 14:38:54'),
(1217, 10, NULL, 0, 1, '2014-04-02 14:45:17'),
(1218, 29, NULL, 0, 1, '2014-04-02 14:47:17'),
(1219, 0, NULL, 3, 1, '2014-04-02 14:47:38'),
(1220, 29, NULL, 0, 1, '2014-04-02 14:47:52'),
(1221, 0, NULL, 3, 1, '2014-04-02 14:48:02'),
(1222, 0, NULL, 3, 1, '2014-04-02 14:48:15'),
(1223, 2, NULL, 2, 1, '2014-04-02 14:48:52'),
(1224, 2, NULL, 2, 1, '2014-04-02 14:49:01'),
(1225, 2, NULL, 2, 1, '2014-04-02 14:49:14'),
(1226, 2, NULL, 0, 1, '2014-04-02 14:49:43'),
(1227, 2, NULL, 0, 1, '2014-04-02 14:50:17'),
(1228, 2, NULL, 0, 1, '2014-04-02 14:50:41'),
(1229, 29, NULL, 0, 1, '2014-04-02 14:51:59'),
(1230, 2, NULL, 0, 1, '2014-04-02 14:52:44'),
(1231, 2, NULL, 0, 1, '2014-04-02 15:00:29'),
(1232, 29, NULL, 0, 1, '2014-04-02 15:00:56'),
(1233, 2, NULL, 0, 1, '2014-04-02 15:01:26'),
(1234, 2, NULL, 0, 1, '2014-04-02 15:03:45'),
(1235, 10, NULL, 0, 1, '2014-04-02 15:05:50');
INSERT INTO `HISTORYACCESS` (`IDHISTORY`, `IDUSER`, `IDHOUSE`, `ERROR`, `FUNCT`, `DATESTAMP`) VALUES
(1236, 29, NULL, 0, 1, '2014-04-02 15:07:34'),
(1237, 10, NULL, 0, 1, '2014-04-02 15:14:59'),
(1238, 10, NULL, 0, 6, '2014-04-02 15:15:09'),
(1239, 10, NULL, 0, 6, '2014-04-02 15:15:10'),
(1240, 10, NULL, 0, 6, '2014-04-02 15:15:12'),
(1241, 10, NULL, 0, 1, '2014-04-02 15:17:33'),
(1242, 10, NULL, 0, 1, '2014-04-02 15:21:30'),
(1243, 10, NULL, 0, 6, '2014-04-02 15:21:40'),
(1244, 10, NULL, 0, 1, '2014-04-02 15:24:30'),
(1245, 10, NULL, 0, 6, '2014-04-02 15:24:38'),
(1246, 10, NULL, 0, 1, '2014-04-02 15:27:21'),
(1247, 10, NULL, 0, 1, '2014-04-02 15:31:29'),
(1248, 10, NULL, 0, 1, '2014-04-02 15:33:49'),
(1249, 10, NULL, 0, 6, '2014-04-02 15:34:11'),
(1250, 10, NULL, 0, 6, '2014-04-02 15:35:24'),
(1251, 10, NULL, 0, 1, '2014-04-02 15:40:09'),
(1252, 10, NULL, 0, 1, '2014-04-02 15:41:20'),
(1253, 10, NULL, 0, 1, '2014-04-02 15:42:55'),
(1254, 10, NULL, 0, 1, '2014-04-02 15:46:59'),
(1255, 10, NULL, 0, 1, '2014-04-02 15:48:57'),
(1256, 10, NULL, 0, 1, '2014-04-02 16:17:42'),
(1257, 10, NULL, 0, 1, '2014-04-02 16:19:36'),
(1258, 0, NULL, 3, 1, '2014-04-02 16:22:07'),
(1259, 0, NULL, 3, 1, '2014-04-02 16:22:11'),
(1260, 10, NULL, 0, 1, '2014-04-02 16:34:51'),
(1261, 10, NULL, 0, 1, '2014-04-03 09:28:42'),
(1262, 29, NULL, 0, 1, '2014-04-03 09:29:27'),
(1263, 29, NULL, 21, 6, '2014-04-03 09:29:46'),
(1264, 29, NULL, 21, 6, '2014-04-03 09:29:50'),
(1265, 29, NULL, 21, 6, '2014-04-03 09:29:55'),
(1266, 10, NULL, 0, 1, '2014-04-03 09:30:08'),
(1267, 10, NULL, 0, 1, '2014-04-03 09:47:55'),
(1268, 10, NULL, 0, 1, '2014-04-03 09:51:48'),
(1269, 10, NULL, 0, 1, '2014-04-03 09:52:40'),
(1270, 10, NULL, 0, 1, '2014-04-03 09:53:24'),
(1271, 10, NULL, 0, 1, '2014-04-03 09:54:28'),
(1272, 10, NULL, 0, 1, '2014-04-03 09:57:45'),
(1273, 10, NULL, 0, 1, '2014-04-03 09:58:55'),
(1274, 10, NULL, 0, 6, '2014-04-03 09:59:16'),
(1275, 10, NULL, 0, 6, '2014-04-03 09:59:18'),
(1276, 10, NULL, 0, 6, '2014-04-03 10:03:10'),
(1277, 10, NULL, 0, 6, '2014-04-03 10:03:11'),
(1278, 10, NULL, 0, 1, '2014-04-03 10:04:29'),
(1279, 10, NULL, 0, 1, '2014-04-03 10:11:58'),
(1280, 10, NULL, 0, 1, '2014-04-03 10:19:04'),
(1281, 10, NULL, 0, 1, '2014-04-03 10:20:10'),
(1282, 29, NULL, 0, 1, '2014-04-03 10:20:42'),
(1283, 10, NULL, 0, 1, '2014-04-03 10:22:13'),
(1284, 10, NULL, 0, 1, '2014-04-03 10:23:07'),
(1285, 29, NULL, 0, 1, '2014-04-03 10:23:37'),
(1286, 10, NULL, 0, 1, '2014-04-03 11:04:16'),
(1287, 10, NULL, 0, 1, '2014-04-03 11:05:03'),
(1288, 10, NULL, 0, 1, '2014-04-03 11:17:57'),
(1289, 10, NULL, 0, 1, '2014-04-03 11:33:06'),
(1290, 10, NULL, 0, 1, '2014-04-03 11:34:10'),
(1291, 10, NULL, 0, 1, '2014-04-03 11:35:06'),
(1292, 10, NULL, 0, 1, '2014-04-03 11:36:19'),
(1293, 10, NULL, 0, 1, '2014-04-03 11:38:31'),
(1294, 10, NULL, 0, 1, '2014-04-03 11:39:53'),
(1295, 10, NULL, 0, 1, '2014-04-03 11:49:50'),
(1296, 10, NULL, 0, 1, '2014-04-03 11:55:29'),
(1297, 10, NULL, 0, 1, '2014-04-03 11:57:02'),
(1298, 10, NULL, 0, 1, '2014-04-03 11:59:00'),
(1299, 29, NULL, 0, 1, '2014-04-03 11:59:29'),
(1300, 10, NULL, 0, 1, '2014-04-03 12:04:09'),
(1301, 29, NULL, 2, 1, '2014-04-03 12:04:25'),
(1302, 29, NULL, 0, 1, '2014-04-03 12:04:39'),
(1303, 10, NULL, 0, 1, '2014-04-03 13:18:14'),
(1304, 10, NULL, 0, 6, '2014-04-03 13:18:27'),
(1305, 10, NULL, 0, 6, '2014-04-03 13:18:27'),
(1306, 10, NULL, 0, 6, '2014-04-03 13:18:27'),
(1307, 10, NULL, 0, 6, '2014-04-03 13:18:30'),
(1308, 10, NULL, 0, 6, '2014-04-03 13:18:32'),
(1309, 0, NULL, 0, 8, '2014-04-03 14:17:48'),
(1310, 10, NULL, 2, 1, '2014-04-03 14:18:03'),
(1311, 29, NULL, 2, 1, '2014-04-03 14:18:26'),
(1312, 29, NULL, 0, 1, '2014-04-03 14:19:09'),
(1313, 29, NULL, 0, 1, '2014-04-03 14:21:03'),
(1314, 29, NULL, 0, 1, '2014-04-03 14:23:58'),
(1315, 29, NULL, 0, 1, '2014-04-03 14:31:22'),
(1316, 29, NULL, 0, 1, '2014-04-03 14:32:34'),
(1317, 29, NULL, 21, 6, '2014-04-03 14:33:27'),
(1318, 29, NULL, 21, 6, '2014-04-03 14:33:29'),
(1319, 29, NULL, 0, 1, '2014-04-03 14:49:05'),
(1320, 29, NULL, 0, 1, '2014-04-03 14:55:03'),
(1321, 29, NULL, 0, 1, '2014-04-03 14:56:35'),
(1322, 0, NULL, 3, 1, '2014-04-03 14:56:47'),
(1323, 29, NULL, 0, 1, '2014-04-03 15:33:03'),
(1324, 2, NULL, 0, 1, '2014-04-03 15:33:39'),
(1325, 10, NULL, 0, 1, '2014-04-03 15:33:56'),
(1326, 29, NULL, 0, 1, '2014-04-03 15:36:01'),
(1327, 29, NULL, 0, 1, '2014-04-03 15:40:37'),
(1328, 29, NULL, 0, 1, '2014-04-03 15:42:58'),
(1329, 29, NULL, 0, 1, '2014-04-03 15:45:36'),
(1330, 29, NULL, 0, 1, '2014-04-03 15:46:32'),
(1331, 29, NULL, 0, 1, '2014-04-03 16:14:12'),
(1332, 29, NULL, 0, 6, '2014-04-03 16:15:03'),
(1333, 29, NULL, 21, 6, '2014-04-03 16:15:10'),
(1334, 29, NULL, 0, 1, '2014-04-03 19:23:30'),
(1335, 29, NULL, 21, 6, '2014-04-03 19:23:50'),
(1336, 29, NULL, 0, 1, '2014-04-03 20:05:17'),
(1337, 29, NULL, 0, 1, '2014-04-03 20:10:08'),
(1338, 29, NULL, 0, 1, '2014-04-03 20:11:15'),
(1339, 10, NULL, 0, 1, '2014-04-03 20:16:06'),
(1340, 29, NULL, 0, 1, '2014-04-03 20:16:31'),
(1341, 29, NULL, 0, 1, '2014-04-03 20:19:35'),
(1342, 29, NULL, 0, 1, '2014-04-03 20:20:42'),
(1343, 29, NULL, 0, 1, '2014-04-03 20:22:11'),
(1344, 29, NULL, 0, 1, '2014-04-03 20:23:57'),
(1345, 0, NULL, 3, 1, '2014-04-03 21:33:09'),
(1346, 29, NULL, 0, 1, '2014-04-03 21:34:36'),
(1347, 10, NULL, 2, 1, '2014-04-03 21:39:57'),
(1348, 10, NULL, 0, 1, '2014-04-03 21:40:05'),
(1349, 10, NULL, 0, 1, '2014-04-03 21:47:31'),
(1350, 10, NULL, 0, 1, '2014-04-03 21:48:37'),
(1351, 10, NULL, 0, 1, '2014-04-03 21:56:55'),
(1352, 29, NULL, 0, 1, '2014-04-03 21:57:26'),
(1353, 29, NULL, 0, 1, '2014-04-03 21:58:46'),
(1354, 10, NULL, 0, 1, '2014-04-03 21:58:49'),
(1355, 29, NULL, 0, 1, '2014-04-03 22:00:15'),
(1356, 10, NULL, 0, 1, '2014-04-03 22:03:03'),
(1357, 10, NULL, 0, 1, '2014-04-03 22:05:37'),
(1358, 29, NULL, 0, 1, '2014-04-03 22:12:39'),
(1359, 10, NULL, 0, 1, '2014-04-03 22:17:32'),
(1360, 29, NULL, 0, 1, '2014-04-03 22:27:57'),
(1361, 29, NULL, 0, 1, '2014-04-03 22:29:53'),
(1362, 10, NULL, 0, 1, '2014-04-03 22:36:40'),
(1363, 10, NULL, 0, 1, '2014-04-03 22:37:57'),
(1364, 10, NULL, 0, 1, '2014-04-03 22:42:38'),
(1365, 10, NULL, 0, 1, '2014-04-03 22:44:25'),
(1366, 10, NULL, 0, 1, '2014-04-03 22:45:25'),
(1367, 10, NULL, 0, 1, '2014-04-03 22:50:23'),
(1368, 29, NULL, 0, 1, '2014-04-03 22:58:38'),
(1369, 29, NULL, 0, 1, '2014-04-03 23:05:10'),
(1370, 10, NULL, 0, 1, '2014-04-03 23:07:43'),
(1371, 29, NULL, 0, 1, '2014-04-04 06:26:46'),
(1372, 10, NULL, 0, 1, '2014-04-04 08:00:46'),
(1373, 10, NULL, 0, 6, '2014-04-04 08:01:38'),
(1374, 10, NULL, 0, 6, '2014-04-04 08:01:42'),
(1375, 29, NULL, 0, 1, '2014-04-04 08:01:58'),
(1376, 29, NULL, 0, 1, '2014-04-04 13:48:33'),
(1377, 29, NULL, 0, 1, '2014-04-04 13:51:24'),
(1378, 29, NULL, 0, 1, '2014-04-04 13:51:42'),
(1379, 29, NULL, 0, 1, '2014-04-04 13:53:04'),
(1380, 10, NULL, 0, 1, '2014-04-04 13:57:59'),
(1381, 29, NULL, 0, 1, '2014-04-04 13:59:04'),
(1382, 29, NULL, 0, 1, '2014-04-04 14:17:05'),
(1383, 0, NULL, 0, 10, '2014-04-04 14:22:12'),
(1384, 0, NULL, 0, 10, '2014-04-04 14:22:31'),
(1385, 0, NULL, 0, 10, '2014-04-04 14:22:43'),
(1386, 0, NULL, 0, 10, '2014-04-04 14:22:57'),
(1387, 0, NULL, 0, 10, '2014-04-04 14:23:03'),
(1388, 29, NULL, 0, 1, '2014-04-04 14:24:40'),
(1389, 29, NULL, 0, 1, '2014-04-04 14:36:35'),
(1390, 29, NULL, 0, 1, '2014-04-04 14:37:19'),
(1391, 29, NULL, 0, 1, '2014-04-04 14:45:30'),
(1392, 29, NULL, 0, 1, '2014-04-04 14:46:08'),
(1393, 29, NULL, 0, 1, '2014-04-04 14:46:58'),
(1394, 29, NULL, 0, 1, '2014-04-04 14:48:59'),
(1395, 29, NULL, 0, 1, '2014-04-04 14:50:20'),
(1396, 29, NULL, 0, 1, '2014-04-04 14:51:28'),
(1397, 29, NULL, 0, 1, '2014-04-04 14:52:16'),
(1398, 29, NULL, 0, 1, '2014-04-04 14:52:54'),
(1399, 29, NULL, 0, 1, '2014-04-04 14:55:03'),
(1400, 29, NULL, 0, 1, '2014-04-04 14:56:28'),
(1401, 29, NULL, 0, 1, '2014-04-04 14:57:00'),
(1402, 29, NULL, 0, 1, '2014-04-04 14:58:56'),
(1403, 29, NULL, 0, 1, '2014-04-04 15:02:31'),
(1404, 29, NULL, 0, 1, '2014-04-04 15:05:09'),
(1405, 29, NULL, 0, 1, '2014-04-04 15:05:44'),
(1406, 29, NULL, 0, 1, '2014-04-04 15:07:21'),
(1407, 29, NULL, 0, 1, '2014-04-04 15:15:15'),
(1408, 29, NULL, 0, 1, '2014-04-04 15:18:56'),
(1409, 29, NULL, 0, 1, '2014-04-04 15:19:08'),
(1410, 29, NULL, 0, 1, '2014-04-04 15:21:22'),
(1411, 29, NULL, 0, 1, '2014-04-04 15:21:28'),
(1412, 29, NULL, 0, 1, '2014-04-04 15:23:36'),
(1413, 29, NULL, 0, 1, '2014-04-04 15:25:46'),
(1414, 29, NULL, 0, 1, '2014-04-04 15:30:15'),
(1415, 29, NULL, 0, 1, '2014-04-04 15:31:09'),
(1416, 29, NULL, 0, 1, '2014-04-04 15:33:17'),
(1417, 29, NULL, 0, 1, '2014-04-04 15:50:12'),
(1418, 29, NULL, 0, 1, '2014-04-04 15:52:20'),
(1419, 0, NULL, 3, 1, '2014-04-04 17:20:28'),
(1420, 29, NULL, 0, 1, '2014-04-04 17:20:39'),
(1421, 29, NULL, 0, 1, '2014-04-04 17:32:39'),
(1422, 29, NULL, 0, 1, '2014-04-04 17:35:38'),
(1423, 29, NULL, 0, 1, '2014-04-04 17:36:51'),
(1424, 29, NULL, 0, 1, '2014-04-04 17:47:19'),
(1425, 29, NULL, 0, 1, '2014-04-04 17:54:43'),
(1426, 29, NULL, 0, 1, '2014-04-04 18:04:56'),
(1427, 29, NULL, 0, 1, '2014-04-04 18:52:45'),
(1428, 29, NULL, 0, 6, '2014-04-04 18:55:04'),
(1429, 29, NULL, 0, 6, '2014-04-04 18:55:06'),
(1430, 29, NULL, 0, 6, '2014-04-04 18:55:08'),
(1431, 29, NULL, 0, 6, '2014-04-04 18:55:08'),
(1432, 29, NULL, 0, 6, '2014-04-04 18:55:08'),
(1433, 29, NULL, 0, 6, '2014-04-04 18:55:10'),
(1434, 29, NULL, 0, 6, '2014-04-04 18:55:11'),
(1435, 29, NULL, 0, 6, '2014-04-04 18:55:13'),
(1436, 29, NULL, 21, 6, '2014-04-04 18:55:17'),
(1437, 29, NULL, 21, 6, '2014-04-04 18:55:18'),
(1438, 29, NULL, 0, 1, '2014-04-04 20:00:42'),
(1439, 29, NULL, 0, 1, '2014-04-04 20:01:03'),
(1440, 29, NULL, 2, 1, '2014-04-04 20:01:12'),
(1441, 29, NULL, 0, 1, '2014-04-04 20:01:23'),
(1442, 29, NULL, 0, 1, '2014-04-04 20:02:49'),
(1443, 29, NULL, 0, 1, '2014-04-04 20:02:52'),
(1444, 0, NULL, 3, 1, '2014-04-04 20:02:57'),
(1445, 29, NULL, 0, 1, '2014-04-04 20:03:06'),
(1446, 29, NULL, 0, 1, '2014-04-04 20:03:41'),
(1447, 29, NULL, 0, 1, '2014-04-04 20:03:45'),
(1448, 29, NULL, 0, 1, '2014-04-04 20:04:18'),
(1449, 29, NULL, 0, 1, '2014-04-04 20:04:21'),
(1450, 29, NULL, 0, 1, '2014-04-04 20:04:59'),
(1451, 29, NULL, 0, 1, '2014-04-04 20:05:34'),
(1452, 29, NULL, 0, 1, '2014-04-04 20:06:34'),
(1453, 29, NULL, 0, 1, '2014-04-04 20:07:18'),
(1454, 29, NULL, 0, 1, '2014-04-04 20:07:59'),
(1455, 29, NULL, 0, 1, '2014-04-04 20:08:34'),
(1456, 29, NULL, 0, 1, '2014-04-04 20:08:40'),
(1457, 29, NULL, 0, 1, '2014-04-04 20:09:06'),
(1458, 29, NULL, 0, 1, '2014-04-04 20:10:46'),
(1459, 29, NULL, 0, 1, '2014-04-04 20:16:06'),
(1460, 29, NULL, 0, 1, '2014-04-04 20:19:05'),
(1461, 29, NULL, 0, 1, '2014-04-04 20:24:41'),
(1462, 29, NULL, 0, 1, '2014-04-04 20:26:28'),
(1463, 29, NULL, 0, 1, '2014-04-04 20:27:27'),
(1464, 29, NULL, 0, 1, '2014-04-04 20:28:35'),
(1465, 29, NULL, 0, 1, '2014-04-04 20:33:00'),
(1466, 29, NULL, 0, 1, '2014-04-04 21:10:08'),
(1467, 29, NULL, 0, 1, '2014-04-05 09:44:45'),
(1468, 29, NULL, 0, 1, '2014-04-05 09:46:22'),
(1469, 10, NULL, 2, 1, '2014-04-05 09:46:36'),
(1470, 29, NULL, 0, 1, '2014-04-05 09:46:44'),
(1471, 29, NULL, 0, 1, '2014-04-05 09:48:08'),
(1472, 29, NULL, 0, 1, '2014-04-05 09:49:46'),
(1473, 29, NULL, 0, 1, '2014-04-05 09:50:37'),
(1474, 29, NULL, 0, 1, '2014-04-05 09:50:56'),
(1475, 29, NULL, 0, 1, '2014-04-05 09:51:17'),
(1476, 29, NULL, 0, 1, '2014-04-05 09:51:34'),
(1477, 29, NULL, 0, 1, '2014-04-05 09:52:01'),
(1478, 29, NULL, 0, 1, '2014-04-05 09:52:58'),
(1479, 29, NULL, 0, 1, '2014-04-05 09:54:18'),
(1480, 29, NULL, 0, 1, '2014-04-05 10:08:23'),
(1481, 29, NULL, 0, 1, '2014-04-05 10:09:47'),
(1482, 29, NULL, 0, 1, '2014-04-05 10:11:03'),
(1483, 29, NULL, 0, 1, '2014-04-05 10:13:12'),
(1484, 29, NULL, 0, 1, '2014-04-05 10:14:43'),
(1485, 29, NULL, 0, 1, '2014-04-05 10:16:59'),
(1486, 29, NULL, 0, 1, '2014-04-05 10:18:10'),
(1487, 29, NULL, 0, 1, '2014-04-05 10:19:24'),
(1488, 29, NULL, 0, 1, '2014-04-05 10:20:13'),
(1489, 29, NULL, 0, 1, '2014-04-05 10:45:22'),
(1490, 29, NULL, 0, 1, '2014-04-05 11:00:52'),
(1491, 29, NULL, 0, 1, '2014-04-05 11:01:32'),
(1492, 29, NULL, 0, 1, '2014-04-05 11:08:32'),
(1493, 29, NULL, 0, 1, '2014-04-05 11:10:55'),
(1494, 29, NULL, 0, 1, '2014-04-05 11:14:41'),
(1495, 29, NULL, 0, 1, '2014-04-05 12:43:26'),
(1496, 29, NULL, 0, 1, '2014-04-05 12:45:18'),
(1497, 29, NULL, 0, 1, '2014-04-05 12:46:50'),
(1498, 29, NULL, 0, 1, '2014-04-05 12:47:48'),
(1499, 29, NULL, 0, 1, '2014-04-05 12:48:13'),
(1500, 29, NULL, 0, 1, '2014-04-05 12:49:45'),
(1501, 29, NULL, 0, 1, '2014-04-05 12:51:51'),
(1502, 29, NULL, 0, 1, '2014-04-05 12:52:31'),
(1503, 29, NULL, 0, 1, '2014-04-05 12:53:05'),
(1504, 0, NULL, 3, 1, '2014-04-05 12:53:21'),
(1505, 0, NULL, 3, 1, '2014-04-05 12:54:00'),
(1506, 29, NULL, 0, 1, '2014-04-05 12:54:07'),
(1507, 29, NULL, 0, 1, '2014-04-05 12:55:13'),
(1508, 29, NULL, 0, 1, '2014-04-05 12:57:59'),
(1509, 29, NULL, 0, 1, '2014-04-05 12:58:52'),
(1510, 29, NULL, 0, 1, '2014-04-05 12:59:44'),
(1511, 29, NULL, 0, 1, '2014-04-05 13:00:43'),
(1512, 29, NULL, 0, 1, '2014-04-05 13:00:53'),
(1513, 29, NULL, 0, 1, '2014-04-05 13:00:59'),
(1514, 29, NULL, 0, 1, '2014-04-05 13:02:40'),
(1515, 29, NULL, 0, 1, '2014-04-05 13:05:17'),
(1516, 29, NULL, 0, 1, '2014-04-05 13:05:32'),
(1517, 29, NULL, 0, 1, '2014-04-05 14:03:53'),
(1518, 10, NULL, 2, 1, '2014-04-05 14:04:26'),
(1519, 10, NULL, 2, 1, '2014-04-05 14:06:40'),
(1520, 10, NULL, 2, 1, '2014-04-05 14:17:51'),
(1521, 29, NULL, 0, 1, '2014-04-05 14:18:15'),
(1522, 29, NULL, 0, 1, '2014-04-05 14:21:02'),
(1523, 29, NULL, 0, 1, '2014-04-05 14:22:12'),
(1524, 10, NULL, 2, 1, '2014-04-05 14:53:15'),
(1525, 29, NULL, 0, 1, '2014-04-05 16:00:56'),
(1526, 29, NULL, 2, 1, '2014-04-07 16:55:03'),
(1527, 29, NULL, 2, 1, '2014-04-07 16:55:21'),
(1528, 29, NULL, 0, 1, '2014-04-07 16:55:41'),
(1529, 29, NULL, 0, 1, '2014-04-07 16:55:49'),
(1530, 29, NULL, 0, 1, '2014-04-07 19:25:24'),
(1531, 29, NULL, 0, 1, '2014-04-08 08:40:50'),
(1532, 29, NULL, 0, 1, '2014-04-08 08:45:38'),
(1533, 29, NULL, 6, 3, '2014-04-08 09:10:38'),
(1534, 0, NULL, 13, 3, '2014-04-08 09:10:58'),
(1535, 0, NULL, 2, 4, '2014-04-08 09:24:02'),
(1536, 0, NULL, 2, 4, '2014-04-08 09:24:14'),
(1537, 0, NULL, 2, 4, '2014-04-08 09:24:50'),
(1538, 0, NULL, 2, 4, '2014-04-08 09:25:08'),
(1539, 0, NULL, 2, 4, '2014-04-08 09:25:55'),
(1540, 0, NULL, 2, 4, '2014-04-08 09:30:57'),
(1541, 0, NULL, 2, 4, '2014-04-08 09:32:03'),
(1542, 0, NULL, 2, 4, '2014-04-08 09:32:43'),
(1543, 0, NULL, 2, 4, '2014-04-08 09:34:11'),
(1544, 0, NULL, 2, 4, '2014-04-08 09:41:36'),
(1545, 0, NULL, 2, 4, '2014-04-08 09:42:36'),
(1546, 72, NULL, 14, 4, '2014-04-08 09:43:48'),
(1547, 0, NULL, 3, 4, '2014-04-08 09:45:28'),
(1548, 0, NULL, 13, 3, '2014-04-08 09:47:15'),
(1549, 73, NULL, 6, 3, '2014-04-08 09:47:37'),
(1550, 0, NULL, 7, 3, '2014-04-08 09:47:50'),
(1551, 0, NULL, 7, 3, '2014-04-08 09:49:14'),
(1552, 73, NULL, 6, 3, '2014-04-08 09:49:21'),
(1553, 0, NULL, 13, 3, '2014-04-08 09:49:46'),
(1554, 74, NULL, 2, 4, '2014-04-08 09:50:18'),
(1555, 73, NULL, 14, 4, '2014-04-08 09:50:43'),
(1556, 0, NULL, 3, 4, '2014-04-08 09:50:59'),
(1557, 74, NULL, 2, 4, '2014-04-08 09:51:12'),
(1558, 74, NULL, 14, 4, '2014-04-08 09:51:23'),
(1559, 0, NULL, 3, 5, '2014-04-08 09:58:55'),
(1560, 0, NULL, 13, 3, '2014-04-08 09:59:21'),
(1561, 75, NULL, 15, 5, '2014-04-08 10:02:08'),
(1562, 0, NULL, 3, 5, '2014-04-08 10:02:50'),
(1563, 75, NULL, 7, 5, '2014-04-08 10:03:12'),
(1564, 75, NULL, 15, 5, '2014-04-08 10:04:00'),
(1565, 29, NULL, 0, 1, '2014-04-08 10:05:22'),
(1566, 29, NULL, 0, 1, '2014-04-08 10:10:01'),
(1567, 29, NULL, 0, 1, '2014-04-08 10:10:06'),
(1568, 29, NULL, 6, 3, '2014-04-08 10:10:17'),
(1569, 0, NULL, 0, 3, '2014-04-08 10:10:27'),
(1570, 75, NULL, 6, 3, '2014-04-08 10:17:46'),
(1571, 0, NULL, 7, 3, '2014-04-08 10:18:11'),
(1572, 0, NULL, 13, 3, '2014-04-08 10:18:30'),
(1573, 77, NULL, 6, 3, '2014-04-08 10:31:18'),
(1574, 77, NULL, 6, 3, '2014-04-08 10:31:27'),
(1575, 77, NULL, 6, 3, '2014-04-08 10:32:57'),
(1576, 77, NULL, 7, 5, '2014-04-08 10:33:08'),
(1577, 77, NULL, 7, 5, '2014-04-08 10:33:44'),
(1578, 77, NULL, 7, 5, '2014-04-08 10:34:17'),
(1579, 77, NULL, 15, 5, '2014-04-08 10:34:30'),
(1580, 29, NULL, 0, 1, '2014-04-08 10:35:27'),
(1581, 29, NULL, 2, 1, '2014-04-08 10:35:37'),
(1582, 29, NULL, 0, 1, '2014-04-08 10:35:52'),
(1583, 10, NULL, 0, 1, '2014-04-08 13:55:45'),
(1584, 29, NULL, 0, 1, '2014-04-08 13:56:19'),
(1585, 10, NULL, 0, 1, '2014-04-08 13:57:50'),
(1586, 10, NULL, 0, 1, '2014-04-08 14:00:11'),
(1587, 10, NULL, 0, 1, '2014-04-08 14:05:36'),
(1588, 60, NULL, 6, 3, '2014-04-08 14:09:10'),
(1589, 60, NULL, 6, 3, '2014-04-08 14:12:47'),
(1590, 29, NULL, 2, 1, '2014-04-08 18:34:32'),
(1591, 29, NULL, 2, 1, '2014-04-08 18:35:01'),
(1592, 29, NULL, 0, 1, '2014-04-08 18:35:45'),
(1593, 0, NULL, 3, 1, '2014-04-08 20:23:47'),
(1594, 0, NULL, 3, 1, '2014-04-08 23:31:53'),
(1595, 29, NULL, 0, 1, '2014-04-09 07:53:49'),
(1596, 29, NULL, 0, 1, '2014-04-09 07:55:18'),
(1597, 29, NULL, 0, 1, '2014-04-09 07:58:29'),
(1598, 29, NULL, 0, 1, '2014-04-09 07:59:27'),
(1599, 29, NULL, 0, 1, '2014-04-09 08:02:18'),
(1600, 29, NULL, 2, 1, '2014-04-09 08:02:25'),
(1601, 29, NULL, 2, 1, '2014-04-09 08:04:34'),
(1602, 29, NULL, 0, 1, '2014-04-09 08:04:42'),
(1603, 29, NULL, 0, 1, '2014-04-09 08:06:47'),
(1604, 29, NULL, 0, 1, '2014-04-09 08:06:53'),
(1605, 29, NULL, 0, 1, '2014-04-09 08:08:41'),
(1606, 29, NULL, 2, 1, '2014-04-09 08:08:51'),
(1607, 29, NULL, 0, 1, '2014-04-09 08:09:02'),
(1608, 29, NULL, 0, 1, '2014-04-09 08:10:30'),
(1609, 29, NULL, 0, 1, '2014-04-09 08:11:19'),
(1610, 29, NULL, 0, 1, '2014-04-09 08:13:51'),
(1611, 29, NULL, 2, 1, '2014-04-09 08:14:58'),
(1612, 29, NULL, 0, 1, '2014-04-09 08:15:34'),
(1613, 29, NULL, 6, 3, '2014-04-09 08:17:03'),
(1614, 29, NULL, 6, 3, '2014-04-09 08:18:52'),
(1615, 0, NULL, 7, 3, '2014-04-09 08:19:07'),
(1616, 0, NULL, 7, 3, '2014-04-09 08:19:36'),
(1617, 29, NULL, 0, 1, '2014-04-09 08:19:45'),
(1618, 0, NULL, 0, 3, '2014-04-09 08:19:54'),
(1619, 78, NULL, 6, 3, '2014-04-09 08:22:10'),
(1620, 78, NULL, 6, 3, '2014-04-09 08:25:40'),
(1621, 29, NULL, 6, 3, '2014-04-09 08:26:04'),
(1622, 0, NULL, 7, 3, '2014-04-09 08:26:14'),
(1623, 78, NULL, 7, 3, '2014-04-09 08:29:23'),
(1624, 0, NULL, 3, 4, '2014-04-09 08:44:22'),
(1625, 75, NULL, 2, 4, '2014-04-09 08:44:39'),
(1626, 75, NULL, 2, 4, '2014-04-09 08:46:25'),
(1627, 75, NULL, 2, 4, '2014-04-09 08:46:30'),
(1628, 78, NULL, 0, 4, '2014-04-09 08:47:03'),
(1629, 0, NULL, 3, 5, '2014-04-09 08:54:05'),
(1630, 79, NULL, 0, 3, '2014-04-09 08:54:21'),
(1631, 79, NULL, 0, 5, '2014-04-09 08:55:52'),
(1632, 0, NULL, 3, 5, '2014-04-09 08:56:00'),
(1633, 79, NULL, 0, 5, '2014-04-09 08:56:10'),
(1634, 79, NULL, 0, 5, '2014-04-09 08:56:13'),
(1635, 79, NULL, 0, 5, '2014-04-09 08:56:18'),
(1636, 79, NULL, 0, 5, '2014-04-09 08:56:23'),
(1637, 79, NULL, 0, 5, '2014-04-09 08:59:12'),
(1638, 79, NULL, 0, 5, '2014-04-09 08:59:18'),
(1639, 79, NULL, 0, 5, '2014-04-09 08:59:23'),
(1640, 79, NULL, 0, 5, '2014-04-09 08:59:30'),
(1641, 79, NULL, 2, 5, '2014-04-09 09:01:55'),
(1642, 79, NULL, 2, 5, '2014-04-09 09:02:02'),
(1643, 79, NULL, 2, 5, '2014-04-09 09:02:08'),
(1644, 79, NULL, 0, 5, '2014-04-09 09:03:11'),
(1645, 79, NULL, 0, 5, '2014-04-09 09:03:19'),
(1646, 79, NULL, 0, 5, '2014-04-09 09:04:38'),
(1647, 79, NULL, 0, 5, '2014-04-09 09:04:42'),
(1648, 75, NULL, 7, 5, '2014-04-09 09:06:01'),
(1649, 79, NULL, 2, 5, '2014-04-09 09:08:14'),
(1650, 79, NULL, 0, 5, '2014-04-09 09:08:20'),
(1651, 79, NULL, 7, 5, '2014-04-09 09:08:36'),
(1652, 79, NULL, 7, 5, '2014-04-09 09:08:42'),
(1653, 79, NULL, 0, 5, '2014-04-09 09:08:46'),
(1654, 80, NULL, 0, 3, '2014-04-09 09:09:05'),
(1655, 80, NULL, 6, 3, '2014-04-09 09:09:09'),
(1656, 80, NULL, 6, 3, '2014-04-09 09:12:12'),
(1657, 80, NULL, 6, 3, '2014-04-09 09:12:18'),
(1658, 80, NULL, 6, 3, '2014-04-09 09:12:25'),
(1659, 80, NULL, 6, 3, '2014-04-09 09:12:51'),
(1660, 80, NULL, 0, 5, '2014-04-09 09:14:58'),
(1661, 0, NULL, 3, 5, '2014-04-09 09:15:04'),
(1662, 80, NULL, 6, 5, '2014-04-09 09:15:30'),
(1663, 80, NULL, 0, 5, '2014-04-09 09:15:36'),
(1664, 29, NULL, 0, 1, '2014-04-09 10:18:54'),
(1665, 29, NULL, 0, 1, '2014-04-09 10:19:13'),
(1666, 29, NULL, 0, 1, '2014-04-09 10:20:12'),
(1667, 29, NULL, 0, 1, '2014-04-09 10:20:48'),
(1668, 29, NULL, 0, 1, '2014-04-09 10:22:58'),
(1669, 29, NULL, 0, 1, '2014-04-09 10:24:11'),
(1670, 29, NULL, 0, 1, '2014-04-09 10:29:31'),
(1671, 60, NULL, 6, 3, '2014-04-09 10:30:06'),
(1672, 60, NULL, 7, 3, '2014-04-09 10:30:16'),
(1673, 81, NULL, 0, 3, '2014-04-09 10:30:26'),
(1674, 29, NULL, 0, 1, '2014-04-09 10:30:37'),
(1675, 81, NULL, 0, 1, '2014-04-09 10:32:27'),
(1676, 0, NULL, 2, 1, '2014-04-09 10:37:04'),
(1677, 81, NULL, 0, 1, '2014-04-09 10:37:11'),
(1678, 81, NULL, 0, 1, '2014-04-09 10:39:17'),
(1679, 81, NULL, 0, 1, '2014-04-09 10:43:24'),
(1680, 81, NULL, 0, 1, '2014-04-09 10:46:04'),
(1681, 81, NULL, 6, 5, '2014-04-09 10:46:12'),
(1682, 81, NULL, 0, 5, '2014-04-09 10:46:18'),
(1683, 0, NULL, 3, 5, '2014-04-09 10:46:38'),
(1684, 0, NULL, 3, 5, '2014-04-09 10:46:45'),
(1686, 29, 9, 0, 14, '2014-04-09 10:50:25'),
(1687, 29, 9, 0, 14, '2014-04-09 10:50:31'),
(1688, 0, 9, 3, 14, '2014-04-09 10:51:08'),
(1689, 0, 0, 21, 14, '2014-04-09 10:51:25'),
(1690, 81, NULL, 0, 1, '2014-04-09 10:51:56'),
(1691, 81, NULL, 0, 5, '2014-04-09 10:52:07'),
(1692, 0, NULL, 3, 1, '2014-04-09 10:52:08'),
(1693, 0, NULL, 3, 5, '2014-04-09 10:52:34'),
(1694, 81, NULL, 0, 1, '2014-04-09 10:54:10'),
(1695, 81, NULL, 6, 5, '2014-04-09 10:54:25'),
(1696, 81, NULL, 0, 5, '2014-04-09 10:54:32'),
(1697, 0, NULL, 3, 1, '2014-04-09 10:54:33'),
(1698, 0, NULL, 3, 5, '2014-04-09 10:55:23'),
(1699, 29, 9, 0, 14, '2014-04-09 10:57:11'),
(1700, 81, NULL, 0, 1, '2014-04-09 11:00:18'),
(1701, 81, NULL, 0, 5, '2014-04-09 11:00:28'),
(1702, 0, NULL, 3, 1, '2014-04-09 11:00:28'),
(1703, 0, NULL, 3, 5, '2014-04-09 11:00:53'),
(1704, 81, NULL, 0, 1, '2014-04-09 11:05:54'),
(1705, 81, NULL, 0, 5, '2014-04-09 11:06:02'),
(1706, 0, NULL, 3, 5, '2014-04-09 11:06:09'),
(1707, 81, NULL, 0, 1, '2014-04-09 11:07:32'),
(1708, 81, NULL, 0, 5, '2014-04-09 11:07:43'),
(1709, 0, NULL, 3, 5, '2014-04-09 11:08:30'),
(1710, 81, NULL, 0, 1, '2014-04-09 11:12:15'),
(1711, 81, NULL, 6, 5, '2014-04-09 11:12:28'),
(1712, 81, NULL, 0, 5, '2014-04-09 11:12:38'),
(1713, 0, NULL, 3, 5, '2014-04-09 11:12:38'),
(1714, 0, NULL, 3, 5, '2014-04-09 11:12:45'),
(1715, 29, NULL, 2, 1, '2014-04-09 12:35:17'),
(1716, 29, NULL, 0, 1, '2014-04-09 12:35:30'),
(1717, 29, NULL, 0, 1, '2014-04-09 12:37:04'),
(1718, 29, NULL, 2, 1, '2014-04-09 12:37:49'),
(1719, 29, NULL, 2, 1, '2014-04-09 12:38:11'),
(1720, 0, NULL, 3, 1, '2014-04-09 12:38:13'),
(1721, 81, NULL, 0, 1, '2014-04-09 12:38:34'),
(1722, 81, NULL, 0, 5, '2014-04-09 12:38:47'),
(1723, 0, NULL, 3, 5, '2014-04-09 12:38:47'),
(1724, 29, NULL, 0, 1, '2014-04-09 12:39:11'),
(1725, 29, NULL, 0, 1, '2014-04-09 12:40:15'),
(1726, 29, NULL, 0, 1, '2014-04-09 12:41:11'),
(1727, 81, NULL, 2, 1, '2014-04-09 12:41:43'),
(1728, 81, NULL, 2, 1, '2014-04-09 12:41:51'),
(1729, 81, NULL, 0, 1, '2014-04-09 12:41:57'),
(1730, 81, NULL, 0, 1, '2014-04-09 12:42:46'),
(1731, 81, NULL, 0, 1, '2014-04-09 12:43:30'),
(1732, 81, NULL, 0, 1, '2014-04-09 12:44:25'),
(1733, 81, NULL, 0, 5, '2014-04-09 12:44:29'),
(1734, 0, NULL, 3, 5, '2014-04-09 12:44:30'),
(1735, 29, NULL, 0, 1, '2014-04-09 12:47:41'),
(1736, 29, NULL, 0, 1, '2014-04-09 12:48:28'),
(1737, 29, NULL, 0, 1, '2014-04-09 12:49:13'),
(1738, 29, NULL, 0, 1, '2014-04-09 12:52:23'),
(1739, 29, NULL, 0, 1, '2014-04-09 12:53:02'),
(1740, 81, NULL, 0, 1, '2014-04-09 12:54:28'),
(1741, 81, NULL, 0, 5, '2014-04-09 12:54:39'),
(1742, 81, NULL, 0, 1, '2014-04-09 12:54:39'),
(1743, 81, NULL, 0, 1, '2014-04-09 12:54:39'),
(1744, 0, NULL, 3, 1, '2014-04-09 12:56:06'),
(1745, 81, NULL, 0, 1, '2014-04-09 12:56:26'),
(1746, 68, NULL, 0, 1, '2014-04-09 12:56:39'),
(1747, 81, NULL, 6, 5, '2014-04-09 12:56:39'),
(1748, 68, NULL, 0, 1, '2014-04-09 12:56:39'),
(1749, 81, NULL, 0, 1, '2014-04-09 12:56:49'),
(1750, 81, NULL, 0, 1, '2014-04-09 12:56:49'),
(1751, 0, NULL, 3, 1, '2014-04-09 12:56:58'),
(1752, 81, NULL, 0, 5, '2014-04-09 12:56:58'),
(1753, 81, NULL, 0, 1, '2014-04-09 12:56:58'),
(1754, 81, NULL, 0, 1, '2014-04-09 12:57:05'),
(1755, 0, NULL, 3, 5, '2014-04-09 12:57:05'),
(1756, 81, NULL, 0, 1, '2014-04-09 12:57:05'),
(1757, 81, NULL, 0, 1, '2014-04-09 12:58:08'),
(1758, 0, NULL, 3, 5, '2014-04-09 12:58:08'),
(1759, 81, NULL, 0, 1, '2014-04-09 12:58:09'),
(1760, 29, NULL, 0, 1, '2014-04-09 12:59:29'),
(1761, 29, NULL, 2, 1, '2014-04-09 12:59:44'),
(1762, 0, NULL, 0, 1, '2014-04-09 12:59:54'),
(1763, 81, NULL, 0, 1, '2014-04-09 13:03:30'),
(1764, 81, NULL, 0, 1, '2014-04-09 13:03:45'),
(1765, 81, NULL, 0, 5, '2014-04-09 13:03:45'),
(1766, 81, NULL, 0, 1, '2014-04-09 13:03:45'),
(1767, 81, NULL, 0, 1, '2014-04-09 13:04:28'),
(1768, 0, NULL, 3, 5, '2014-04-09 13:04:28'),
(1769, 81, NULL, 0, 1, '2014-04-09 13:04:28'),
(1770, 0, NULL, 0, 1, '2014-04-09 13:05:19'),
(1771, 0, NULL, 0, 1, '2014-04-09 13:06:57'),
(1772, 81, NULL, 0, 1, '2014-04-09 13:07:13'),
(1773, 0, NULL, 3, 5, '2014-04-09 13:07:13'),
(1774, 81, NULL, 0, 1, '2014-04-09 13:09:26'),
(1775, 81, NULL, 0, 1, '2014-04-09 13:09:34'),
(1776, 81, NULL, 0, 1, '2014-04-09 13:09:57'),
(1777, 10, NULL, 0, 1, '2014-04-09 13:10:17'),
(1778, 81, NULL, 0, 1, '2014-04-09 13:11:04'),
(1779, 0, NULL, 0, 1, '2014-04-09 13:11:39'),
(1780, 0, NULL, 0, 1, '2014-04-09 13:15:03'),
(1781, 0, NULL, 3, 1, '2014-04-09 13:15:12'),
(1782, 29, NULL, 0, 1, '2014-04-09 13:15:22'),
(1783, 29, NULL, 0, 1, '2014-04-09 13:18:28'),
(1784, 81, NULL, 0, 1, '2014-04-09 13:21:20'),
(1785, 68, NULL, 0, 1, '2014-04-09 13:21:34'),
(1786, 81, NULL, 6, 5, '2014-04-09 13:21:34'),
(1787, 68, NULL, 0, 1, '2014-04-09 13:21:39'),
(1788, 81, NULL, 6, 5, '2014-04-09 13:21:57'),
(1789, 68, NULL, 0, 1, '2014-04-09 13:21:57'),
(1790, 68, NULL, 0, 1, '2014-04-09 13:21:58'),
(1791, 29, NULL, 0, 1, '2014-04-09 13:22:23'),
(1792, 0, NULL, 3, 1, '2014-04-09 13:22:25'),
(1793, 81, NULL, 0, 5, '2014-04-09 13:22:25'),
(1794, 81, NULL, 0, 1, '2014-04-09 13:22:26'),
(1795, 81, NULL, 0, 1, '2014-04-09 13:22:51'),
(1796, 0, NULL, 3, 5, '2014-04-09 13:22:51'),
(1797, 81, NULL, 0, 1, '2014-04-09 13:22:53'),
(1798, 82, NULL, 0, 3, '2014-04-09 13:22:58'),
(1799, 82, NULL, 0, 1, '2014-04-09 13:23:13'),
(1800, 81, NULL, 0, 1, '2014-04-09 13:24:39'),
(1801, 0, NULL, 3, 1, '2014-04-09 13:24:50'),
(1802, 81, NULL, 0, 5, '2014-04-09 13:24:50'),
(1803, 81, NULL, 0, 1, '2014-04-09 13:24:50'),
(1804, 81, NULL, 0, 1, '2014-04-09 13:25:12'),
(1805, 0, NULL, 3, 5, '2014-04-09 13:25:12'),
(1806, 81, NULL, 0, 1, '2014-04-09 13:25:13'),
(1807, 81, NULL, 0, 1, '2014-04-09 13:27:00'),
(1808, 81, NULL, 0, 1, '2014-04-09 13:27:06'),
(1809, 81, NULL, 0, 1, '2014-04-09 13:27:07'),
(1810, 81, NULL, 0, 1, '2014-04-09 13:27:10'),
(1811, 81, NULL, 0, 1, '2014-04-09 13:27:10'),
(1812, 82, NULL, 0, 1, '2014-04-09 13:27:37'),
(1813, 82, NULL, 0, 1, '2014-04-09 13:27:53'),
(1814, 81, NULL, 0, 1, '2014-04-09 13:28:15'),
(1815, 81, NULL, 0, 1, '2014-04-09 13:28:23'),
(1816, 81, NULL, 0, 5, '2014-04-09 13:28:24'),
(1817, 81, NULL, 0, 1, '2014-04-09 13:28:24'),
(1818, 81, NULL, 0, 1, '2014-04-09 13:28:37'),
(1819, 0, NULL, 3, 5, '2014-04-09 13:28:37'),
(1820, 81, NULL, 0, 1, '2014-04-09 13:28:38'),
(1821, 81, NULL, 0, 1, '2014-04-09 13:28:42'),
(1822, 0, NULL, 3, 5, '2014-04-09 13:28:42'),
(1823, 81, NULL, 0, 1, '2014-04-09 13:28:43'),
(1824, 82, NULL, 0, 1, '2014-04-09 13:29:02'),
(1825, 82, NULL, 2, 1, '2014-04-09 13:29:13'),
(1826, 82, NULL, 2, 1, '2014-04-09 13:30:18'),
(1827, 82, NULL, 2, 1, '2014-04-09 13:31:01'),
(1828, 83, NULL, 0, 3, '2014-04-09 13:33:28'),
(1829, 83, NULL, 6, 3, '2014-04-09 13:33:31'),
(1830, 83, NULL, 2, 1, '2014-04-09 13:33:40'),
(1831, 83, NULL, 2, 1, '2014-04-09 13:33:47'),
(1832, 83, NULL, 0, 1, '2014-04-09 13:33:56'),
(1833, 82, NULL, 2, 1, '2014-04-09 13:34:08'),
(1834, 0, NULL, 3, 1, '2014-04-09 13:34:09'),
(1835, 83, NULL, 0, 5, '2014-04-09 13:34:09'),
(1836, 83, NULL, 0, 1, '2014-04-09 13:34:10'),
(1837, 82, NULL, 0, 1, '2014-04-09 13:34:14'),
(1838, 0, NULL, 3, 5, '2014-04-09 13:34:47'),
(1839, 83, NULL, 0, 1, '2014-04-09 13:34:47'),
(1840, 83, NULL, 0, 1, '2014-04-09 13:34:47'),
(1841, 29, NULL, 0, 1, '2014-04-09 13:34:56'),
(1842, 83, NULL, 0, 1, '2014-04-09 13:39:30'),
(1843, 0, NULL, 3, 1, '2014-04-09 13:39:44'),
(1844, 83, NULL, 0, 5, '2014-04-09 13:39:44'),
(1845, 83, NULL, 0, 1, '2014-04-09 13:39:44'),
(1846, 83, NULL, 0, 1, '2014-04-09 13:40:27'),
(1847, 0, NULL, 3, 5, '2014-04-09 13:40:27'),
(1848, 83, NULL, 0, 1, '2014-04-09 13:40:27'),
(1849, 29, 9, 0, 14, '2014-04-09 13:43:37'),
(1850, 29, 9, 0, 14, '2014-04-09 13:43:54'),
(1851, 0, 9, 21, 14, '2014-04-09 13:45:54'),
(1852, 29, 9, 0, 14, '2014-04-09 13:46:03'),
(1853, 83, NULL, 0, 1, '2014-04-09 13:47:28'),
(1854, 83, NULL, 0, 5, '2014-04-09 13:47:39'),
(1855, 83, NULL, 0, 1, '2014-04-09 13:52:22'),
(1856, 83, NULL, 0, 5, '2014-04-09 13:52:28'),
(1857, 83, NULL, 0, 1, '2014-04-09 13:52:28'),
(1858, 83, NULL, 0, 1, '2014-04-09 13:52:28'),
(1859, 83, NULL, 0, 1, '2014-04-09 13:52:29'),
(1860, 83, NULL, 0, 1, '2014-04-09 13:52:29'),
(1861, 83, NULL, 0, 1, '2014-04-09 13:52:29'),
(1862, 83, NULL, 0, 1, '2014-04-09 13:52:29'),
(1863, 83, NULL, 0, 1, '2014-04-09 13:52:29'),
(1864, 83, NULL, 0, 1, '2014-04-09 13:52:30'),
(1865, 83, NULL, 0, 1, '2014-04-09 13:52:30'),
(1866, 83, NULL, 0, 1, '2014-04-09 13:52:30'),
(1867, 83, NULL, 0, 1, '2014-04-09 13:52:30'),
(1868, 83, NULL, 0, 1, '2014-04-09 13:52:31'),
(1869, 83, NULL, 0, 1, '2014-04-09 13:52:31'),
(1870, 83, NULL, 0, 1, '2014-04-09 13:52:31'),
(1871, 83, NULL, 0, 1, '2014-04-09 13:52:31'),
(1872, 83, NULL, 0, 1, '2014-04-09 13:52:31'),
(1873, 83, NULL, 0, 1, '2014-04-09 13:52:33'),
(1874, 83, NULL, 0, 1, '2014-04-09 13:52:33'),
(1875, 83, NULL, 0, 1, '2014-04-09 13:52:33'),
(1876, 83, NULL, 0, 1, '2014-04-09 13:52:33'),
(1877, 83, NULL, 0, 1, '2014-04-09 13:52:33'),
(1878, 83, NULL, 0, 1, '2014-04-09 13:52:34'),
(1879, 83, NULL, 0, 1, '2014-04-09 13:52:34'),
(1880, 83, NULL, 0, 1, '2014-04-09 13:52:35'),
(1881, 83, NULL, 0, 1, '2014-04-09 13:52:35'),
(1882, 83, NULL, 0, 1, '2014-04-09 13:52:35'),
(1883, 83, NULL, 0, 1, '2014-04-09 13:52:36'),
(1884, 83, NULL, 0, 1, '2014-04-09 13:52:36'),
(1885, 83, NULL, 0, 1, '2014-04-09 13:52:36'),
(1886, 83, NULL, 0, 1, '2014-04-09 13:52:36'),
(1887, 83, NULL, 0, 1, '2014-04-09 13:52:36'),
(1888, 83, NULL, 0, 1, '2014-04-09 13:52:37'),
(1889, 83, NULL, 0, 1, '2014-04-09 13:52:37'),
(1890, 83, NULL, 0, 1, '2014-04-09 13:52:37'),
(1891, 83, NULL, 0, 1, '2014-04-09 13:52:37'),
(1892, 83, NULL, 0, 1, '2014-04-09 13:52:37'),
(1893, 83, NULL, 0, 1, '2014-04-09 13:52:38'),
(1894, 83, NULL, 0, 1, '2014-04-09 13:52:38'),
(1895, 83, NULL, 0, 1, '2014-04-09 13:52:38'),
(1896, 83, NULL, 0, 1, '2014-04-09 13:52:38'),
(1897, 83, NULL, 0, 1, '2014-04-09 13:52:38'),
(1898, 83, NULL, 0, 1, '2014-04-09 13:52:38'),
(1899, 83, NULL, 0, 1, '2014-04-09 13:52:39'),
(1900, 83, NULL, 0, 1, '2014-04-09 13:52:39'),
(1901, 83, NULL, 0, 1, '2014-04-09 13:52:39'),
(1902, 83, NULL, 0, 1, '2014-04-09 13:52:40'),
(1903, 83, NULL, 0, 1, '2014-04-09 13:52:40'),
(1904, 83, NULL, 0, 1, '2014-04-09 13:52:40'),
(1905, 83, NULL, 0, 1, '2014-04-09 13:52:40'),
(1906, 83, NULL, 0, 1, '2014-04-09 13:52:41'),
(1907, 83, NULL, 0, 1, '2014-04-09 13:52:41'),
(1908, 83, NULL, 0, 1, '2014-04-09 13:52:41'),
(1909, 83, NULL, 0, 1, '2014-04-09 13:52:41'),
(1910, 83, NULL, 0, 1, '2014-04-09 13:52:42'),
(1911, 83, NULL, 0, 1, '2014-04-09 13:52:42'),
(1912, 83, NULL, 0, 1, '2014-04-09 13:52:42'),
(1913, 83, NULL, 0, 1, '2014-04-09 13:52:42'),
(1914, 83, NULL, 0, 1, '2014-04-09 13:52:43'),
(1915, 83, NULL, 0, 1, '2014-04-09 13:52:43'),
(1916, 83, NULL, 0, 1, '2014-04-09 13:52:43'),
(1917, 83, NULL, 0, 1, '2014-04-09 13:52:44'),
(1918, 83, NULL, 0, 1, '2014-04-09 13:52:44'),
(1919, 83, NULL, 0, 1, '2014-04-09 13:52:44'),
(1920, 83, NULL, 0, 1, '2014-04-09 13:52:44'),
(1921, 83, NULL, 0, 1, '2014-04-09 13:52:45'),
(1922, 83, NULL, 0, 1, '2014-04-09 13:52:45'),
(1923, 83, NULL, 0, 1, '2014-04-09 13:52:45'),
(1924, 83, NULL, 0, 1, '2014-04-09 13:52:45'),
(1925, 83, NULL, 0, 1, '2014-04-09 13:52:45'),
(1926, 83, NULL, 0, 1, '2014-04-09 13:52:46'),
(1927, 83, NULL, 0, 1, '2014-04-09 13:52:46'),
(1928, 83, NULL, 0, 1, '2014-04-09 13:52:47'),
(1929, 83, NULL, 0, 1, '2014-04-09 13:52:47'),
(1930, 83, NULL, 0, 1, '2014-04-09 13:52:47'),
(1931, 83, NULL, 0, 1, '2014-04-09 13:52:47'),
(1932, 83, NULL, 0, 1, '2014-04-09 13:52:47'),
(1933, 83, NULL, 0, 1, '2014-04-09 13:52:47'),
(1934, 83, NULL, 0, 1, '2014-04-09 13:52:48'),
(1935, 83, NULL, 0, 1, '2014-04-09 13:52:48'),
(1936, 83, NULL, 0, 1, '2014-04-09 13:52:48'),
(1937, 83, NULL, 0, 1, '2014-04-09 13:52:48'),
(1938, 83, NULL, 0, 1, '2014-04-09 13:52:48'),
(1939, 83, NULL, 0, 1, '2014-04-09 13:52:48'),
(1940, 83, NULL, 0, 1, '2014-04-09 13:52:49'),
(1941, 83, NULL, 0, 1, '2014-04-09 13:52:49'),
(1942, 83, NULL, 0, 1, '2014-04-09 13:52:49'),
(1943, 83, NULL, 0, 1, '2014-04-09 13:52:50'),
(1944, 83, NULL, 0, 1, '2014-04-09 13:52:50'),
(1945, 83, NULL, 0, 1, '2014-04-09 13:52:50'),
(1946, 83, NULL, 0, 1, '2014-04-09 13:52:51'),
(1947, 83, NULL, 0, 1, '2014-04-09 13:52:51'),
(1948, 83, NULL, 0, 1, '2014-04-09 13:52:51'),
(1949, 83, NULL, 0, 1, '2014-04-09 13:52:51'),
(1950, 83, NULL, 0, 1, '2014-04-09 13:52:51'),
(1951, 83, NULL, 0, 1, '2014-04-09 13:52:52'),
(1952, 83, NULL, 0, 1, '2014-04-09 13:52:52'),
(1953, 83, NULL, 0, 1, '2014-04-09 13:52:52'),
(1954, 83, NULL, 0, 1, '2014-04-09 13:52:52'),
(1955, 83, NULL, 0, 1, '2014-04-09 13:52:52'),
(1956, 83, NULL, 0, 1, '2014-04-09 13:52:53'),
(1957, 83, NULL, 0, 1, '2014-04-09 13:52:53'),
(1958, 83, NULL, 0, 1, '2014-04-09 13:52:53'),
(1959, 83, NULL, 0, 1, '2014-04-09 13:52:53'),
(1960, 83, NULL, 0, 1, '2014-04-09 13:52:54'),
(1961, 83, NULL, 0, 1, '2014-04-09 13:52:54'),
(1962, 83, NULL, 0, 1, '2014-04-09 13:52:54'),
(1963, 83, NULL, 0, 1, '2014-04-09 13:52:54'),
(1964, 83, NULL, 0, 1, '2014-04-09 13:52:54'),
(1965, 83, NULL, 0, 1, '2014-04-09 13:52:55'),
(1966, 83, NULL, 0, 1, '2014-04-09 13:52:55'),
(1967, 83, NULL, 0, 1, '2014-04-09 13:52:55'),
(1968, 83, NULL, 0, 1, '2014-04-09 13:52:55'),
(1969, 83, NULL, 0, 1, '2014-04-09 13:52:55'),
(1970, 83, NULL, 0, 1, '2014-04-09 13:52:56'),
(1971, 83, NULL, 0, 1, '2014-04-09 13:52:56'),
(1972, 83, NULL, 0, 1, '2014-04-09 13:52:56'),
(1973, 83, NULL, 0, 1, '2014-04-09 13:52:56'),
(1974, 83, NULL, 0, 1, '2014-04-09 13:52:56'),
(1975, 83, NULL, 0, 1, '2014-04-09 13:52:57'),
(1976, 83, NULL, 0, 1, '2014-04-09 13:52:57'),
(1977, 83, NULL, 0, 1, '2014-04-09 13:52:57'),
(1978, 83, NULL, 0, 1, '2014-04-09 13:52:57'),
(1979, 83, NULL, 0, 1, '2014-04-09 13:52:57'),
(1980, 83, NULL, 0, 1, '2014-04-09 13:52:57'),
(1981, 83, NULL, 0, 1, '2014-04-09 13:52:58'),
(1982, 83, NULL, 0, 1, '2014-04-09 13:52:58'),
(1983, 83, NULL, 0, 1, '2014-04-09 13:52:58'),
(1984, 83, NULL, 0, 1, '2014-04-09 13:52:58'),
(1985, 83, NULL, 0, 1, '2014-04-09 13:52:58'),
(1986, 83, NULL, 0, 1, '2014-04-09 13:52:59'),
(1987, 83, NULL, 0, 1, '2014-04-09 13:53:00'),
(1988, 83, NULL, 0, 1, '2014-04-09 13:53:00'),
(1989, 83, NULL, 0, 1, '2014-04-09 13:53:00'),
(1990, 83, NULL, 0, 1, '2014-04-09 13:53:00'),
(1991, 83, NULL, 0, 1, '2014-04-09 13:53:01'),
(1992, 83, NULL, 0, 1, '2014-04-09 13:53:01'),
(1993, 83, NULL, 0, 1, '2014-04-09 13:53:01'),
(1994, 83, NULL, 0, 1, '2014-04-09 13:53:01'),
(1995, 83, NULL, 0, 1, '2014-04-09 13:53:01'),
(1996, 83, NULL, 0, 1, '2014-04-09 13:53:02'),
(1997, 83, NULL, 0, 1, '2014-04-09 13:53:02'),
(1998, 83, NULL, 0, 1, '2014-04-09 13:53:03'),
(1999, 83, NULL, 0, 1, '2014-04-09 13:53:03'),
(2000, 83, NULL, 0, 1, '2014-04-09 13:53:03'),
(2001, 83, NULL, 0, 1, '2014-04-09 13:53:03'),
(2002, 83, NULL, 0, 1, '2014-04-09 13:53:03'),
(2003, 83, NULL, 0, 1, '2014-04-09 13:53:04'),
(2004, 83, NULL, 0, 1, '2014-04-09 13:53:04'),
(2005, 83, NULL, 0, 1, '2014-04-09 13:53:04'),
(2006, 83, NULL, 0, 1, '2014-04-09 13:53:04'),
(2007, 83, NULL, 0, 1, '2014-04-09 13:53:05'),
(2008, 83, NULL, 0, 1, '2014-04-09 13:53:05'),
(2009, 83, NULL, 0, 1, '2014-04-09 13:53:05'),
(2010, 83, NULL, 0, 1, '2014-04-09 13:53:05'),
(2011, 83, NULL, 0, 1, '2014-04-09 13:53:05'),
(2012, 83, NULL, 0, 1, '2014-04-09 13:53:05'),
(2013, 83, NULL, 0, 1, '2014-04-09 13:53:06'),
(2014, 83, NULL, 0, 1, '2014-04-09 13:53:06'),
(2015, 83, NULL, 0, 1, '2014-04-09 13:53:07'),
(2016, 83, NULL, 0, 1, '2014-04-09 13:53:07'),
(2017, 83, NULL, 0, 1, '2014-04-09 13:53:07'),
(2018, 83, NULL, 0, 1, '2014-04-09 13:53:08'),
(2019, 83, NULL, 0, 1, '2014-04-09 13:53:08'),
(2020, 83, NULL, 0, 1, '2014-04-09 13:53:08'),
(2021, 83, NULL, 0, 1, '2014-04-09 13:53:08'),
(2022, 83, NULL, 0, 1, '2014-04-09 13:53:09'),
(2023, 83, NULL, 0, 1, '2014-04-09 13:53:09'),
(2024, 83, NULL, 0, 1, '2014-04-09 13:53:09'),
(2025, 83, NULL, 0, 1, '2014-04-09 13:53:09'),
(2026, 83, NULL, 0, 1, '2014-04-09 13:53:09'),
(2027, 83, NULL, 0, 1, '2014-04-09 13:53:09'),
(2028, 83, NULL, 0, 1, '2014-04-09 13:53:10'),
(2029, 83, NULL, 0, 1, '2014-04-09 13:53:10'),
(2030, 83, NULL, 0, 1, '2014-04-09 13:53:11'),
(2031, 83, NULL, 0, 1, '2014-04-09 13:53:11'),
(2032, 83, NULL, 0, 1, '2014-04-09 13:53:11'),
(2033, 83, NULL, 0, 1, '2014-04-09 13:53:11'),
(2034, 83, NULL, 0, 1, '2014-04-09 13:53:12'),
(2035, 83, NULL, 0, 1, '2014-04-09 13:53:12'),
(2036, 83, NULL, 0, 1, '2014-04-09 13:53:12'),
(2037, 83, NULL, 0, 1, '2014-04-09 13:53:12'),
(2038, 83, NULL, 0, 1, '2014-04-09 13:53:12'),
(2039, 83, NULL, 0, 1, '2014-04-09 13:53:13'),
(2040, 83, NULL, 0, 1, '2014-04-09 13:53:13'),
(2041, 83, NULL, 0, 1, '2014-04-09 13:53:13'),
(2042, 83, NULL, 0, 1, '2014-04-09 13:53:13'),
(2043, 83, NULL, 0, 1, '2014-04-09 13:53:13'),
(2044, 83, NULL, 0, 1, '2014-04-09 13:53:14'),
(2045, 83, NULL, 0, 1, '2014-04-09 13:53:14'),
(2046, 83, NULL, 0, 1, '2014-04-09 13:53:14'),
(2047, 83, NULL, 0, 1, '2014-04-09 13:53:14'),
(2048, 83, NULL, 0, 1, '2014-04-09 13:53:14'),
(2049, 83, NULL, 0, 1, '2014-04-09 13:53:15'),
(2050, 83, NULL, 0, 1, '2014-04-09 13:53:15'),
(2051, 83, NULL, 0, 1, '2014-04-09 13:53:15'),
(2052, 83, NULL, 0, 1, '2014-04-09 13:53:15'),
(2053, 83, NULL, 0, 1, '2014-04-09 13:53:16'),
(2054, 83, NULL, 0, 1, '2014-04-09 13:53:16'),
(2055, 83, NULL, 0, 1, '2014-04-09 13:53:17'),
(2056, 83, NULL, 0, 1, '2014-04-09 13:53:17'),
(2057, 83, NULL, 0, 1, '2014-04-09 13:53:17'),
(2058, 83, NULL, 0, 1, '2014-04-09 13:53:17'),
(2059, 83, NULL, 0, 1, '2014-04-09 13:53:17'),
(2060, 83, NULL, 0, 1, '2014-04-09 13:53:18'),
(2061, 83, NULL, 0, 1, '2014-04-09 13:53:18'),
(2062, 83, NULL, 0, 1, '2014-04-09 13:53:18'),
(2063, 83, NULL, 0, 1, '2014-04-09 13:53:18'),
(2064, 83, NULL, 0, 1, '2014-04-09 13:53:19'),
(2065, 83, NULL, 0, 1, '2014-04-09 13:53:19'),
(2066, 83, NULL, 0, 1, '2014-04-09 13:53:19'),
(2067, 83, NULL, 0, 1, '2014-04-09 13:53:19'),
(2068, 83, NULL, 0, 1, '2014-04-09 13:53:20'),
(2069, 83, NULL, 0, 1, '2014-04-09 13:53:20'),
(2070, 83, NULL, 0, 1, '2014-04-09 13:53:20'),
(2071, 83, NULL, 0, 1, '2014-04-09 13:53:20'),
(2072, 83, NULL, 0, 1, '2014-04-09 13:53:20'),
(2073, 83, NULL, 0, 1, '2014-04-09 13:53:21'),
(2074, 83, NULL, 0, 1, '2014-04-09 13:53:21'),
(2075, 83, NULL, 0, 1, '2014-04-09 13:53:21'),
(2076, 83, NULL, 0, 1, '2014-04-09 13:53:21'),
(2077, 83, NULL, 0, 1, '2014-04-09 13:53:21'),
(2078, 83, NULL, 0, 1, '2014-04-09 13:53:22'),
(2079, 83, NULL, 0, 1, '2014-04-09 13:53:22'),
(2080, 83, NULL, 0, 1, '2014-04-09 13:53:22'),
(2081, 83, NULL, 0, 1, '2014-04-09 13:53:22'),
(2082, 83, NULL, 0, 1, '2014-04-09 13:53:22'),
(2083, 83, NULL, 0, 1, '2014-04-09 13:53:23'),
(2084, 83, NULL, 0, 1, '2014-04-09 13:53:23'),
(2085, 83, NULL, 0, 1, '2014-04-09 13:53:23'),
(2086, 83, NULL, 0, 1, '2014-04-09 13:53:23'),
(2087, 83, NULL, 0, 1, '2014-04-09 13:53:23'),
(2088, 83, NULL, 0, 1, '2014-04-09 13:53:24'),
(2089, 83, NULL, 0, 1, '2014-04-09 13:53:24'),
(2090, 83, NULL, 0, 1, '2014-04-09 13:53:24'),
(2091, 83, NULL, 0, 1, '2014-04-09 13:53:25'),
(2092, 83, NULL, 0, 1, '2014-04-09 13:53:25'),
(2093, 83, NULL, 0, 1, '2014-04-09 13:53:25'),
(2094, 83, NULL, 0, 1, '2014-04-09 13:53:25'),
(2095, 83, NULL, 0, 1, '2014-04-09 13:53:25'),
(2096, 83, NULL, 0, 1, '2014-04-09 13:53:26'),
(2097, 83, NULL, 0, 1, '2014-04-09 13:53:26'),
(2098, 83, NULL, 0, 1, '2014-04-09 13:53:26'),
(2099, 83, NULL, 0, 1, '2014-04-09 13:53:26'),
(2100, 83, NULL, 0, 1, '2014-04-09 13:53:26'),
(2101, 83, NULL, 0, 1, '2014-04-09 13:53:27'),
(2102, 83, NULL, 0, 1, '2014-04-09 13:53:27'),
(2103, 83, NULL, 0, 1, '2014-04-09 13:53:27'),
(2104, 83, NULL, 0, 1, '2014-04-09 13:53:27'),
(2105, 83, NULL, 0, 1, '2014-04-09 13:53:28'),
(2106, 83, NULL, 0, 1, '2014-04-09 13:53:28'),
(2107, 83, NULL, 0, 1, '2014-04-09 13:53:28'),
(2108, 83, NULL, 0, 1, '2014-04-09 13:53:28'),
(2109, 83, NULL, 0, 1, '2014-04-09 13:53:29'),
(2110, 83, NULL, 0, 1, '2014-04-09 13:53:29'),
(2111, 83, NULL, 0, 1, '2014-04-09 13:53:29'),
(2112, 83, NULL, 0, 1, '2014-04-09 13:53:30'),
(2113, 83, NULL, 0, 1, '2014-04-09 13:53:31'),
(2114, 83, NULL, 0, 1, '2014-04-09 13:53:31'),
(2115, 83, NULL, 0, 1, '2014-04-09 13:53:32'),
(2116, 83, NULL, 0, 1, '2014-04-09 13:53:32'),
(2117, 83, NULL, 0, 1, '2014-04-09 13:53:32'),
(2118, 83, NULL, 0, 1, '2014-04-09 13:53:32'),
(2119, 83, NULL, 0, 1, '2014-04-09 13:53:32'),
(2120, 83, NULL, 0, 1, '2014-04-09 13:53:33'),
(2121, 83, NULL, 0, 1, '2014-04-09 13:53:33'),
(2122, 83, NULL, 0, 1, '2014-04-09 13:53:33'),
(2123, 83, NULL, 0, 1, '2014-04-09 13:53:34'),
(2124, 83, NULL, 0, 1, '2014-04-09 13:53:34'),
(2125, 83, NULL, 0, 1, '2014-04-09 13:53:34'),
(2126, 83, NULL, 0, 1, '2014-04-09 13:53:34'),
(2127, 83, NULL, 0, 1, '2014-04-09 13:53:36'),
(2128, 83, NULL, 0, 1, '2014-04-09 13:53:36'),
(2129, 83, NULL, 0, 1, '2014-04-09 13:53:36'),
(2130, 83, NULL, 0, 1, '2014-04-09 13:53:36'),
(2131, 83, NULL, 0, 1, '2014-04-09 13:53:36'),
(2132, 83, NULL, 0, 1, '2014-04-09 13:53:37'),
(2133, 83, NULL, 0, 1, '2014-04-09 13:53:37'),
(2134, 83, NULL, 0, 1, '2014-04-09 13:53:37'),
(2135, 83, NULL, 0, 1, '2014-04-09 13:53:38'),
(2136, 83, NULL, 0, 1, '2014-04-09 13:53:38'),
(2137, 83, NULL, 0, 1, '2014-04-09 13:53:39'),
(2138, 83, NULL, 0, 1, '2014-04-09 13:53:41'),
(2139, 83, NULL, 0, 1, '2014-04-09 13:53:41'),
(2140, 83, NULL, 0, 1, '2014-04-09 13:53:42'),
(2141, 83, NULL, 0, 1, '2014-04-09 13:53:42'),
(2142, 83, NULL, 0, 1, '2014-04-09 13:53:43'),
(2143, 83, NULL, 0, 1, '2014-04-09 13:53:43'),
(2144, 83, NULL, 0, 1, '2014-04-09 13:53:43'),
(2145, 83, NULL, 0, 1, '2014-04-09 13:53:43'),
(2146, 83, NULL, 0, 1, '2014-04-09 13:53:44'),
(2147, 83, NULL, 0, 1, '2014-04-09 13:53:45'),
(2148, 83, NULL, 0, 1, '2014-04-09 13:53:45'),
(2149, 83, NULL, 0, 1, '2014-04-09 13:53:45'),
(2150, 83, NULL, 0, 1, '2014-04-09 13:53:45'),
(2151, 83, NULL, 0, 1, '2014-04-09 13:53:45'),
(2152, 83, NULL, 0, 1, '2014-04-09 13:53:46'),
(2153, 83, NULL, 0, 1, '2014-04-09 13:53:46'),
(2154, 83, NULL, 0, 1, '2014-04-09 13:53:46'),
(2155, 83, NULL, 0, 1, '2014-04-09 13:53:46'),
(2156, 83, NULL, 0, 1, '2014-04-09 13:53:46'),
(2157, 83, NULL, 0, 1, '2014-04-09 13:53:46'),
(2158, 83, NULL, 0, 1, '2014-04-09 13:53:47'),
(2159, 83, NULL, 0, 1, '2014-04-09 13:53:47'),
(2160, 83, NULL, 0, 1, '2014-04-09 13:53:47'),
(2161, 83, NULL, 0, 1, '2014-04-09 13:53:47'),
(2162, 83, NULL, 0, 1, '2014-04-09 13:53:48'),
(2163, 83, NULL, 0, 1, '2014-04-09 13:53:48'),
(2164, 83, NULL, 0, 1, '2014-04-09 13:53:48'),
(2165, 83, NULL, 0, 1, '2014-04-09 13:53:48'),
(2166, 83, NULL, 0, 1, '2014-04-09 13:53:48'),
(2167, 83, NULL, 0, 1, '2014-04-09 13:53:48'),
(2168, 83, NULL, 0, 1, '2014-04-09 13:53:49'),
(2169, 83, NULL, 0, 1, '2014-04-09 13:53:49'),
(2170, 83, NULL, 0, 1, '2014-04-09 13:53:49'),
(2171, 83, NULL, 0, 1, '2014-04-09 13:53:50'),
(2172, 83, NULL, 0, 1, '2014-04-09 13:53:50'),
(2173, 83, NULL, 0, 1, '2014-04-09 13:53:50'),
(2174, 83, NULL, 0, 1, '2014-04-09 13:53:50'),
(2175, 83, NULL, 0, 1, '2014-04-09 13:53:50'),
(2176, 83, NULL, 0, 1, '2014-04-09 13:53:50'),
(2177, 83, NULL, 0, 1, '2014-04-09 13:53:51'),
(2178, 83, NULL, 0, 1, '2014-04-09 13:53:51'),
(2179, 83, NULL, 0, 1, '2014-04-09 13:53:51'),
(2180, 83, NULL, 0, 1, '2014-04-09 13:53:51'),
(2181, 83, NULL, 0, 1, '2014-04-09 13:53:51'),
(2182, 83, NULL, 0, 1, '2014-04-09 13:53:52'),
(2183, 83, NULL, 0, 1, '2014-04-09 13:53:52'),
(2184, 83, NULL, 0, 1, '2014-04-09 13:53:52'),
(2185, 83, NULL, 0, 1, '2014-04-09 13:53:52'),
(2186, 83, NULL, 0, 1, '2014-04-09 13:53:52'),
(2187, 83, NULL, 0, 1, '2014-04-09 13:53:53'),
(2188, 83, NULL, 0, 1, '2014-04-09 13:53:53'),
(2189, 83, NULL, 0, 1, '2014-04-09 13:53:53'),
(2190, 83, NULL, 0, 1, '2014-04-09 13:53:53'),
(2191, 83, NULL, 0, 1, '2014-04-09 13:53:53'),
(2192, 83, NULL, 0, 1, '2014-04-09 13:53:54'),
(2193, 83, NULL, 0, 1, '2014-04-09 13:53:54'),
(2194, 83, NULL, 0, 1, '2014-04-09 13:53:55'),
(2195, 83, NULL, 0, 1, '2014-04-09 13:53:55'),
(2196, 83, NULL, 0, 1, '2014-04-09 13:53:56'),
(2197, 83, NULL, 0, 1, '2014-04-09 13:53:57'),
(2198, 83, NULL, 0, 1, '2014-04-09 13:53:58'),
(2199, 83, NULL, 0, 1, '2014-04-09 13:53:58'),
(2200, 83, NULL, 0, 1, '2014-04-09 13:53:58'),
(2201, 83, NULL, 0, 1, '2014-04-09 13:53:58'),
(2202, 83, NULL, 0, 1, '2014-04-09 13:53:58'),
(2203, 83, NULL, 0, 1, '2014-04-09 13:53:58'),
(2204, 83, NULL, 0, 1, '2014-04-09 13:53:59'),
(2205, 83, NULL, 0, 1, '2014-04-09 13:53:59'),
(2206, 83, NULL, 0, 1, '2014-04-09 13:54:00'),
(2207, 83, NULL, 0, 1, '2014-04-09 13:54:00'),
(2208, 83, NULL, 0, 1, '2014-04-09 13:54:01'),
(2209, 83, NULL, 0, 1, '2014-04-09 13:54:01'),
(2210, 83, NULL, 0, 1, '2014-04-09 13:54:01'),
(2211, 83, NULL, 0, 1, '2014-04-09 13:54:02'),
(2212, 83, NULL, 0, 1, '2014-04-09 13:54:03'),
(2213, 83, NULL, 0, 1, '2014-04-09 13:54:03'),
(2214, 83, NULL, 0, 1, '2014-04-09 13:54:04'),
(2215, 83, NULL, 0, 1, '2014-04-09 13:54:05'),
(2216, 83, NULL, 0, 1, '2014-04-09 13:54:05'),
(2217, 83, NULL, 0, 1, '2014-04-09 13:54:05'),
(2218, 83, NULL, 0, 1, '2014-04-09 13:54:06'),
(2219, 83, NULL, 0, 1, '2014-04-09 13:54:06'),
(2220, 83, NULL, 0, 1, '2014-04-09 13:54:06'),
(2221, 83, NULL, 0, 1, '2014-04-09 13:54:06'),
(2222, 83, NULL, 0, 1, '2014-04-09 13:54:06'),
(2223, 83, NULL, 0, 1, '2014-04-09 13:54:06'),
(2224, 83, NULL, 0, 1, '2014-04-09 13:54:07'),
(2225, 83, NULL, 0, 1, '2014-04-09 13:54:07'),
(2226, 83, NULL, 0, 1, '2014-04-09 13:54:08'),
(2227, 83, NULL, 0, 1, '2014-04-09 13:54:08'),
(2228, 83, NULL, 0, 1, '2014-04-09 13:54:08'),
(2229, 83, NULL, 0, 1, '2014-04-09 13:54:08'),
(2230, 83, NULL, 0, 1, '2014-04-09 13:54:08'),
(2231, 83, NULL, 0, 1, '2014-04-09 13:54:09'),
(2232, 83, NULL, 0, 1, '2014-04-09 13:54:09'),
(2233, 83, NULL, 0, 1, '2014-04-09 13:54:10'),
(2234, 83, NULL, 0, 1, '2014-04-09 13:54:10'),
(2235, 83, NULL, 0, 1, '2014-04-09 13:54:10'),
(2236, 83, NULL, 0, 1, '2014-04-09 13:54:10'),
(2237, 83, NULL, 0, 1, '2014-04-09 13:54:10'),
(2238, 83, NULL, 0, 1, '2014-04-09 13:54:11'),
(2239, 83, NULL, 0, 1, '2014-04-09 13:54:11'),
(2240, 83, NULL, 0, 1, '2014-04-09 13:54:11'),
(2241, 83, NULL, 0, 1, '2014-04-09 13:54:11'),
(2242, 83, NULL, 0, 1, '2014-04-09 13:54:11'),
(2243, 83, NULL, 0, 1, '2014-04-09 13:54:11'),
(2244, 83, NULL, 0, 1, '2014-04-09 13:54:12'),
(2245, 83, NULL, 0, 1, '2014-04-09 13:54:12'),
(2246, 83, NULL, 0, 1, '2014-04-09 13:54:12'),
(2247, 83, NULL, 0, 1, '2014-04-09 13:54:12'),
(2248, 83, NULL, 0, 1, '2014-04-09 13:54:12'),
(2249, 83, NULL, 0, 1, '2014-04-09 13:54:13'),
(2250, 83, NULL, 0, 1, '2014-04-09 13:54:13'),
(2251, 83, NULL, 0, 1, '2014-04-09 13:54:13'),
(2252, 83, NULL, 0, 1, '2014-04-09 13:54:13'),
(2253, 83, NULL, 0, 1, '2014-04-09 13:54:14'),
(2254, 83, NULL, 0, 1, '2014-04-09 13:54:14'),
(2255, 83, NULL, 0, 1, '2014-04-09 13:54:14'),
(2256, 83, NULL, 0, 1, '2014-04-09 13:54:15'),
(2257, 83, NULL, 0, 1, '2014-04-09 13:54:15'),
(2258, 83, NULL, 0, 1, '2014-04-09 13:54:15'),
(2259, 83, NULL, 0, 1, '2014-04-09 13:54:15'),
(2260, 83, NULL, 0, 1, '2014-04-09 13:54:15'),
(2261, 83, NULL, 0, 1, '2014-04-09 13:54:16'),
(2262, 83, NULL, 0, 1, '2014-04-09 13:54:17'),
(2263, 83, NULL, 0, 1, '2014-04-09 13:54:17'),
(2264, 83, NULL, 0, 1, '2014-04-09 13:54:18'),
(2265, 83, NULL, 0, 1, '2014-04-09 13:54:18'),
(2266, 83, NULL, 0, 1, '2014-04-09 13:54:18'),
(2267, 83, NULL, 0, 1, '2014-04-09 13:54:18'),
(2268, 83, NULL, 0, 1, '2014-04-09 13:54:19'),
(2269, 83, NULL, 0, 1, '2014-04-09 13:54:19'),
(2270, 83, NULL, 0, 1, '2014-04-09 13:54:19'),
(2271, 83, NULL, 0, 1, '2014-04-09 13:54:19'),
(2272, 83, NULL, 0, 1, '2014-04-09 13:54:19'),
(2273, 83, NULL, 0, 1, '2014-04-09 13:54:20'),
(2274, 83, NULL, 0, 1, '2014-04-09 13:54:20'),
(2275, 83, NULL, 0, 1, '2014-04-09 13:54:20'),
(2276, 83, NULL, 0, 1, '2014-04-09 13:54:20'),
(2277, 83, NULL, 0, 1, '2014-04-09 13:54:20'),
(2278, 83, NULL, 0, 1, '2014-04-09 13:54:21'),
(2279, 83, NULL, 0, 1, '2014-04-09 13:54:21'),
(2280, 83, NULL, 0, 1, '2014-04-09 13:54:21'),
(2281, 83, NULL, 0, 1, '2014-04-09 13:54:21'),
(2282, 83, NULL, 0, 1, '2014-04-09 13:54:21'),
(2283, 83, NULL, 0, 1, '2014-04-09 13:54:22'),
(2284, 83, NULL, 0, 1, '2014-04-09 13:54:22'),
(2285, 83, NULL, 0, 1, '2014-04-09 13:54:22'),
(2286, 83, NULL, 0, 1, '2014-04-09 13:54:22'),
(2287, 83, NULL, 0, 1, '2014-04-09 13:54:22'),
(2288, 83, NULL, 0, 1, '2014-04-09 13:54:23'),
(2289, 83, NULL, 0, 1, '2014-04-09 13:54:23'),
(2290, 83, NULL, 0, 1, '2014-04-09 13:54:23'),
(2291, 83, NULL, 0, 1, '2014-04-09 13:54:23'),
(2292, 83, NULL, 0, 1, '2014-04-09 13:54:23'),
(2293, 83, NULL, 0, 1, '2014-04-09 13:54:24'),
(2294, 83, NULL, 0, 1, '2014-04-09 13:54:24'),
(2295, 83, NULL, 0, 1, '2014-04-09 13:54:24'),
(2296, 83, NULL, 0, 1, '2014-04-09 13:54:25'),
(2297, 83, NULL, 0, 1, '2014-04-09 13:54:25'),
(2298, 83, NULL, 0, 1, '2014-04-09 13:54:26'),
(2299, 83, NULL, 0, 1, '2014-04-09 13:54:41'),
(2300, 83, NULL, 0, 1, '2014-04-09 13:54:50'),
(2301, 83, NULL, 0, 5, '2014-04-09 13:54:50'),
(2302, 83, NULL, 0, 1, '2014-04-09 13:54:50'),
(2303, 29, NULL, 2, 1, '2014-04-09 13:57:37'),
(2304, 29, NULL, 0, 1, '2014-04-09 13:57:48'),
(2305, 83, NULL, 0, 1, '2014-04-09 13:58:45'),
(2306, 83, NULL, 0, 5, '2014-04-09 13:58:58'),
(2307, 83, NULL, 0, 1, '2014-04-09 13:58:58'),
(2308, 83, NULL, 0, 1, '2014-04-09 13:58:58'),
(2309, 0, 9, 21, 14, '2014-04-09 13:59:19'),
(2310, 29, 9, 0, 14, '2014-04-09 13:59:28'),
(2311, 29, 9, 0, 14, '2014-04-09 13:59:36'),
(2312, 29, 9, 0, 14, '2014-04-09 14:00:28'),
(2313, 29, 9, 0, 14, '2014-04-09 14:00:53'),
(2314, 29, 9, 0, 14, '2014-04-09 14:00:58'),
(2315, 0, 9, 21, 14, '2014-04-09 14:01:18'),
(2316, 0, 9, 0, 14, '2014-04-09 14:02:13'),
(2317, 60, 9, 0, 14, '2014-04-09 14:02:19'),
(2318, 0, 9, 3, 14, '2014-04-09 14:02:25'),
(2319, 83, NULL, 0, 1, '2014-04-09 14:02:29'),
(2320, 0, 9, 3, 14, '2014-04-09 14:02:35'),
(2321, 83, NULL, 0, 5, '2014-04-09 14:02:39'),
(2322, 83, NULL, 0, 1, '2014-04-09 14:02:39'),
(2323, 29, 9, 0, 14, '2014-04-09 14:02:45'),
(2324, 29, 9, 0, 14, '2014-04-09 14:03:25'),
(2325, 83, NULL, 0, 1, '2014-04-09 14:03:54'),
(2326, 83, NULL, 0, 5, '2014-04-09 14:03:59'),
(2327, 83, NULL, 0, 1, '2014-04-09 14:04:00'),
(2328, 83, NULL, 0, 5, '2014-04-09 14:04:07'),
(2329, 83, NULL, 0, 1, '2014-04-09 14:04:08'),
(2330, 83, NULL, 0, 5, '2014-04-09 14:04:19'),
(2331, 83, NULL, 0, 1, '2014-04-09 14:04:19'),
(2332, 83, NULL, 0, 5, '2014-04-09 14:04:44'),
(2333, 83, NULL, 2, 1, '2014-04-09 14:04:44'),
(2334, 0, NULL, 2, 1, '2014-04-09 14:04:48'),
(2335, 83, NULL, 2, 1, '2014-04-09 14:04:55'),
(2336, 83, NULL, 0, 1, '2014-04-09 14:05:02'),
(2337, 29, 9, 0, 14, '2014-04-09 14:05:24'),
(2338, 29, 9, 0, 14, '2014-04-09 14:05:35'),
(2339, 0, 9, 21, 14, '2014-04-09 14:05:41'),
(2340, 29, 9, 0, 14, '2014-04-09 14:06:05'),
(2341, 83, NULL, 6, 5, '2014-04-09 14:07:46'),
(2342, 29, 9, 0, 14, '2014-04-09 14:11:00'),
(2343, 29, 9, 0, 14, '2014-04-09 14:12:13'),
(2344, 29, 9, 0, 14, '2014-04-09 14:13:21'),
(2345, 29, 9, 0, 14, '2014-04-09 14:13:33'),
(2346, 29, 9, 0, 14, '2014-04-09 14:14:58'),
(2347, 29, 9, 0, 14, '2014-04-09 14:15:30');
INSERT INTO `HISTORYACCESS` (`IDHISTORY`, `IDUSER`, `IDHOUSE`, `ERROR`, `FUNCT`, `DATESTAMP`) VALUES
(2348, 29, 9, 0, 14, '2014-04-09 14:16:14'),
(2349, 29, 9, 0, 14, '2014-04-09 14:16:26'),
(2350, 29, NULL, 0, 1, '2014-04-09 14:16:56'),
(2351, 29, 9, 0, 14, '2014-04-09 14:21:26'),
(2352, 29, 9, 0, 14, '2014-04-09 14:22:39'),
(2353, 29, 9, 0, 14, '2014-04-09 14:24:40'),
(2354, 29, NULL, 0, 1, '2014-04-09 14:27:57'),
(2355, 29, NULL, 0, 1, '2014-04-09 14:31:41'),
(2356, 29, NULL, 0, 1, '2014-04-09 14:40:56'),
(2357, 29, NULL, 0, 1, '2014-04-09 14:49:06'),
(2358, 29, NULL, 0, 1, '2014-04-09 14:53:37'),
(2359, 29, NULL, 0, 1, '2014-04-09 14:57:49'),
(2360, 29, NULL, 0, 1, '2014-04-09 15:00:47'),
(2361, 29, 9, 10, 15, '2014-04-09 15:01:04'),
(2362, 0, 0, 11, 15, '2014-04-09 15:01:29'),
(2363, 29, 9, 0, 15, '2014-04-09 15:03:47'),
(2364, 29, NULL, 0, 1, '2014-04-09 15:05:21'),
(2365, 0, 0, 21, 15, '2014-04-09 15:14:40'),
(2366, 29, 9, 0, 15, '2014-04-09 15:15:26'),
(2367, 29, 9, 0, 15, '2014-04-09 15:15:32'),
(2368, 29, 9, 0, 15, '2014-04-09 15:15:44'),
(2369, 29, 9, 0, 15, '2014-04-09 15:15:50'),
(2370, 0, 0, 11, 15, '2014-04-09 15:16:05'),
(2371, 0, 0, 11, 15, '2014-04-09 15:16:11'),
(2372, 29, NULL, 0, 1, '2014-04-09 15:21:08'),
(2373, 29, NULL, 0, 1, '2014-04-09 15:22:10'),
(2374, 29, NULL, 0, 1, '2014-04-09 15:24:24'),
(2375, 29, NULL, 0, 1, '2014-04-09 15:38:27'),
(2376, 29, NULL, 0, 1, '2014-04-09 15:40:39'),
(2377, 29, NULL, 0, 1, '2014-04-09 15:41:44'),
(2378, 29, NULL, 0, 1, '2014-04-09 15:44:13'),
(2379, 29, NULL, 0, 1, '2014-04-09 15:45:34'),
(2380, 29, NULL, 0, 1, '2014-04-09 15:48:35'),
(2381, 29, NULL, 0, 1, '2014-04-09 17:36:34'),
(2382, 29, NULL, 0, 1, '2014-04-09 17:48:13'),
(2383, 29, NULL, 0, 1, '2014-04-09 17:50:39'),
(2384, 29, NULL, 0, 1, '2014-04-09 17:53:48'),
(2385, 29, NULL, 0, 1, '2014-04-09 17:55:32'),
(2386, 29, NULL, 0, 1, '2014-04-09 17:58:00'),
(2387, 29, NULL, 0, 1, '2014-04-09 18:03:26'),
(2388, 29, NULL, 0, 1, '2014-04-09 18:48:05'),
(2389, 29, NULL, 0, 1, '2014-04-09 18:54:26'),
(2390, 29, NULL, 0, 1, '2014-04-09 18:55:59'),
(2391, 29, NULL, 0, 1, '2014-04-09 18:58:26'),
(2392, 29, NULL, 0, 1, '2014-04-09 18:59:41'),
(2393, 29, NULL, 0, 1, '2014-04-09 19:03:13'),
(2394, 29, NULL, 0, 1, '2014-04-09 19:06:59'),
(2395, 29, NULL, 0, 1, '2014-04-09 19:08:22'),
(2396, 29, NULL, 0, 1, '2014-04-09 19:33:08'),
(2397, 29, NULL, 0, 1, '2014-04-09 19:36:13'),
(2398, 29, NULL, 0, 1, '2014-04-09 19:39:47'),
(2399, 29, NULL, 0, 1, '2014-04-09 19:41:57'),
(2400, 29, NULL, 0, 1, '2014-04-09 19:58:31'),
(2401, 29, NULL, 0, 1, '2014-04-09 20:00:33'),
(2402, 29, NULL, 0, 1, '2014-04-09 20:04:03'),
(2403, 29, NULL, 0, 1, '2014-04-09 20:10:44'),
(2404, 29, NULL, 0, 1, '2014-04-09 20:12:38'),
(2405, 29, NULL, 0, 1, '2014-04-09 20:19:42'),
(2406, 29, NULL, 0, 1, '2014-04-09 20:21:29'),
(2407, 29, NULL, 0, 1, '2014-04-09 20:23:08'),
(2408, 29, NULL, 0, 1, '2014-04-09 20:28:23'),
(2409, 29, NULL, 0, 1, '2014-04-09 20:29:58'),
(2410, 29, NULL, 0, 1, '2014-04-09 20:32:31'),
(2411, 29, NULL, 0, 11, '2014-04-09 20:32:39'),
(2412, 29, NULL, 24, 11, '2014-04-09 20:32:47'),
(2413, 0, NULL, 3, 11, '2014-04-09 20:32:58'),
(2414, 29, NULL, 0, 11, '2014-04-09 20:33:17'),
(2415, 29, NULL, 0, 1, '2014-04-10 06:41:39'),
(2416, 29, NULL, 0, 1, '2014-04-10 06:43:44'),
(2417, 29, NULL, 0, 1, '2014-04-10 06:44:40'),
(2418, 29, NULL, 0, 1, '2014-04-10 06:48:42'),
(2419, 29, NULL, 0, 1, '2014-04-10 06:51:53'),
(2420, 29, NULL, 0, 1, '2014-04-10 06:54:46'),
(2421, 29, NULL, 0, 1, '2014-04-10 07:02:39'),
(2422, 29, NULL, 0, 1, '2014-04-10 07:04:09'),
(2423, 29, NULL, 0, 1, '2014-04-10 07:20:54'),
(2424, 29, NULL, 0, 1, '2014-04-10 07:23:53'),
(2425, 29, NULL, 0, 1, '2014-04-10 07:24:40'),
(2426, 29, NULL, 0, 1, '2014-04-10 07:32:48'),
(2427, 29, NULL, 0, 1, '2014-04-10 07:35:51'),
(2428, 29, NULL, 0, 1, '2014-04-10 07:36:42'),
(2429, 29, NULL, 0, 1, '2014-04-10 07:37:38'),
(2430, 29, NULL, 0, 1, '2014-04-10 07:38:15'),
(2431, 29, NULL, 0, 1, '2014-04-10 07:38:37'),
(2432, 29, NULL, 0, 1, '2014-04-10 07:40:14'),
(2433, 29, NULL, 0, 1, '2014-04-10 07:40:37'),
(2434, 29, NULL, 0, 1, '2014-04-10 07:41:44'),
(2435, 29, NULL, 0, 1, '2014-04-10 07:42:23'),
(2436, 29, NULL, 0, 1, '2014-04-10 07:42:47'),
(2437, 29, NULL, 0, 1, '2014-04-10 07:43:21'),
(2438, 29, NULL, 0, 1, '2014-04-10 07:44:16'),
(2439, 29, NULL, 0, 1, '2014-04-10 07:44:46'),
(2440, 29, NULL, 0, 1, '2014-04-10 07:50:03'),
(2441, 29, NULL, 0, 1, '2014-04-10 07:51:57'),
(2442, 29, NULL, 0, 1, '2014-04-10 07:55:23'),
(2443, 29, NULL, 0, 1, '2014-04-10 08:11:26'),
(2444, 29, NULL, 0, 1, '2014-04-10 08:12:18'),
(2445, 29, NULL, 0, 1, '2014-04-10 08:29:24'),
(2446, 29, NULL, 0, 1, '2014-04-10 08:31:02'),
(2447, 29, NULL, 0, 1, '2014-04-10 08:39:25'),
(2448, 29, NULL, 0, 1, '2014-04-10 08:44:59'),
(2449, 29, NULL, 0, 1, '2014-04-10 08:50:17'),
(2450, 29, NULL, 0, 1, '2014-04-10 08:51:14'),
(2451, 29, NULL, 0, 1, '2014-04-10 08:54:55'),
(2452, 10, NULL, 0, 1, '2014-04-10 08:58:20'),
(2453, 10, NULL, 0, 1, '2014-04-10 08:59:04'),
(2454, 10, NULL, 0, 1, '2014-04-10 09:00:24'),
(2455, 29, NULL, 0, 1, '2014-04-10 09:01:03'),
(2456, 29, NULL, 0, 1, '2014-04-10 09:02:23'),
(2457, 10, NULL, 0, 11, '2014-04-10 09:10:47'),
(2458, 10, NULL, 24, 11, '2014-04-10 09:10:51'),
(2459, 0, NULL, 3, 11, '2014-04-10 09:10:59'),
(2460, 29, NULL, 0, 11, '2014-04-10 09:11:17'),
(2461, 29, NULL, 24, 11, '2014-04-10 09:14:00'),
(2462, 29, NULL, 0, 11, '2014-04-10 09:14:10'),
(2463, 29, NULL, 24, 11, '2014-04-10 09:15:16'),
(2464, 29, NULL, 0, 11, '2014-04-10 09:15:25'),
(2465, 29, NULL, 24, 11, '2014-04-10 09:16:34'),
(2466, 29, NULL, 0, 11, '2014-04-10 09:16:41'),
(2467, 29, NULL, 24, 11, '2014-04-10 09:17:05'),
(2468, 29, NULL, 0, 11, '2014-04-10 09:17:12'),
(2469, 29, NULL, 24, 11, '2014-04-10 09:18:47'),
(2470, 29, NULL, 0, 11, '2014-04-10 09:18:52'),
(2471, 29, NULL, 24, 11, '2014-04-10 09:19:28'),
(2472, 29, NULL, 0, 11, '2014-04-10 09:19:34'),
(2473, 29, NULL, 0, 11, '2014-04-10 09:20:14'),
(2474, 29, NULL, 24, 11, '2014-04-10 09:21:29'),
(2475, 29, NULL, 0, 12, '2014-04-10 09:22:49'),
(2476, 29, NULL, 31, 12, '2014-04-10 09:22:52'),
(2477, 29, NULL, 0, 12, '2014-04-10 09:23:23'),
(2478, 29, NULL, 0, 12, '2014-04-10 09:23:33'),
(2479, 75, NULL, 31, 12, '2014-04-10 09:23:40'),
(2480, 0, NULL, 3, 12, '2014-04-10 09:23:55'),
(2481, 29, NULL, 31, 12, '2014-04-10 09:24:02'),
(2482, 29, NULL, 0, 12, '2014-04-10 09:24:09'),
(2483, 10, NULL, 0, 12, '2014-04-10 09:24:31'),
(2484, 10, NULL, 31, 12, '2014-04-10 09:24:34'),
(2485, 29, 9, 0, 14, '2014-04-10 09:31:02'),
(2486, 29, 9, 0, 14, '2014-04-10 09:31:25'),
(2487, 29, NULL, 0, 1, '2014-04-10 09:31:31'),
(2488, 29, 9, 0, 14, '2014-04-10 09:31:55'),
(2489, 29, 9, 0, 14, '2014-04-10 09:32:10'),
(2490, 29, 9, 0, 14, '2014-04-10 09:34:01'),
(2491, 29, 9, 0, 14, '2014-04-10 09:34:11'),
(2492, 29, NULL, 0, 1, '2014-04-10 09:34:33'),
(2493, 29, NULL, 0, 1, '2014-04-10 09:36:38'),
(2494, 29, NULL, 0, 1, '2014-04-10 09:38:48'),
(2495, 29, NULL, 0, 1, '2014-04-10 09:40:32'),
(2496, 29, 9, 0, 21, '2014-04-10 09:43:22'),
(2497, 29, 9, 37, 21, '2014-04-10 09:44:15'),
(2498, 29, 9, 37, 21, '2014-04-10 09:44:24'),
(2499, 29, 9, 0, 21, '2014-04-10 09:44:46'),
(2500, 0, 0, 33, 21, '2014-04-10 09:44:55'),
(2501, 0, 0, 33, 21, '2014-04-10 09:45:20'),
(2502, 29, 9, 32, 21, '2014-04-10 09:45:30'),
(2503, 0, 0, 33, 21, '2014-04-10 09:45:46'),
(2504, 29, NULL, 0, 1, '2014-04-10 09:46:03'),
(2505, 29, 9, 0, 22, '2014-04-10 09:47:00'),
(2506, 29, 9, 36, 22, '2014-04-10 09:47:11'),
(2507, 29, 9, 32, 22, '2014-04-10 09:47:22'),
(2508, 0, 0, 33, 22, '2014-04-10 09:47:31'),
(2509, 29, NULL, 0, 1, '2014-04-10 09:50:24'),
(2510, 29, NULL, 0, 1, '2014-04-10 09:50:59'),
(2511, 0, NULL, 2, 1, '2014-04-10 09:55:21'),
(2512, 0, NULL, 2, 1, '2014-04-10 09:56:20'),
(2513, 0, NULL, 2, 1, '2014-04-10 09:56:32'),
(2514, 0, NULL, 2, 1, '2014-04-10 09:57:08'),
(2515, 0, NULL, 2, 1, '2014-04-10 09:57:29'),
(2516, 0, NULL, 2, 1, '2014-04-10 09:57:49'),
(2517, 0, NULL, 2, 1, '2014-04-10 09:57:55'),
(2518, 0, NULL, 2, 1, '2014-04-10 09:58:00'),
(2519, 0, NULL, 2, 1, '2014-04-10 09:58:45'),
(2520, 0, NULL, 2, 1, '2014-04-10 09:58:56'),
(2521, 0, NULL, 2, 1, '2014-04-10 09:59:17'),
(2522, 83, NULL, 2, 1, '2014-04-10 09:59:46'),
(2523, 83, NULL, 2, 1, '2014-04-10 09:59:54'),
(2524, 10, NULL, 0, 1, '2014-04-10 10:00:04'),
(2525, 71, NULL, 0, 1, '2014-04-10 10:00:23'),
(2526, 71, NULL, 0, 1, '2014-04-10 10:01:05'),
(2527, 71, NULL, 0, 1, '2014-04-10 10:01:56'),
(2528, 0, NULL, 2, 1, '2014-04-10 10:07:39'),
(2529, 29, NULL, 0, 1, '2014-04-10 10:07:59'),
(2530, 29, NULL, 0, 1, '2014-04-10 10:21:43'),
(2531, 29, NULL, 8, 6, '2014-04-10 10:22:35'),
(2532, 29, NULL, 8, 6, '2014-04-10 10:22:38'),
(2533, 0, 0, 21, 14, '2014-04-10 12:31:52'),
(2534, 10, 9, 0, 14, '2014-04-10 12:32:06'),
(2535, 0, 9, 11, 14, '2014-04-10 12:44:44'),
(2536, 29, 9, 0, 14, '2014-04-10 12:47:54'),
(2537, 29, 9, 0, 14, '2014-04-10 12:48:00'),
(2538, 29, 9, 10, 14, '2014-04-10 12:50:59'),
(2539, 29, 9, 10, 14, '2014-04-10 13:01:34'),
(2540, 29, NULL, 0, 1, '2014-04-10 13:55:59'),
(2541, 10, NULL, 0, 1, '2014-04-10 13:58:04'),
(2542, 29, NULL, 0, 1, '2014-04-10 14:14:11'),
(2543, 71, NULL, 0, 1, '2014-04-10 14:15:51'),
(2544, 29, NULL, 0, 1, '2014-04-10 14:17:52'),
(2545, 29, NULL, 0, 1, '2014-04-10 14:18:30'),
(2546, 29, NULL, 0, 1, '2014-04-10 14:20:48'),
(2547, 29, 9, 10, 14, '2014-04-10 14:36:15'),
(2548, 29, 9, 0, 14, '2014-04-10 14:36:44'),
(2549, 29, NULL, 0, 1, '2014-04-10 14:38:08'),
(2550, 29, NULL, 0, 1, '2014-04-10 14:47:43'),
(2551, 29, NULL, 0, 1, '2014-04-10 14:52:56'),
(2552, 29, NULL, 0, 1, '2014-04-10 15:07:46'),
(2553, 29, NULL, 0, 1, '2014-04-10 15:22:49'),
(2554, 29, 9, 0, 14, '2014-04-10 15:24:42'),
(2555, 0, NULL, 0, 10, '2014-04-10 15:24:52'),
(2556, 0, NULL, 0, 10, '2014-04-10 15:25:38'),
(2557, 29, NULL, 0, 1, '2014-04-10 15:34:34'),
(2558, 29, NULL, 0, 1, '2014-04-10 15:36:18'),
(2559, 0, NULL, 2, 1, '2014-04-10 15:38:46'),
(2560, 29, NULL, 0, 1, '2014-04-10 15:38:53'),
(2561, 29, NULL, 0, 1, '2014-04-10 15:47:29'),
(2562, 29, NULL, 0, 1, '2014-04-10 15:51:35'),
(2563, 29, NULL, 0, 1, '2014-04-10 15:54:12'),
(2564, 29, NULL, 0, 1, '2014-04-10 15:56:00'),
(2565, 29, NULL, 0, 1, '2014-04-10 15:57:48'),
(2566, 29, NULL, 0, 1, '2014-04-10 16:00:01'),
(2567, 29, NULL, 0, 1, '2014-04-10 16:11:39'),
(2568, 29, NULL, 0, 1, '2014-04-10 16:17:38'),
(2569, 29, NULL, 0, 1, '2014-04-10 16:21:57'),
(2570, 29, NULL, 0, 1, '2014-04-10 16:49:51'),
(2571, 0, 0, 33, 21, '2014-04-11 11:54:44'),
(2572, 10, NULL, 2, 1, '2014-04-11 11:55:00'),
(2573, 10, NULL, 2, 1, '2014-04-11 11:55:05'),
(2574, 29, NULL, 2, 1, '2014-04-11 11:55:18'),
(2575, 29, NULL, 0, 1, '2014-04-11 11:55:47'),
(2576, 29, NULL, 2, 1, '2014-04-11 20:27:44'),
(2577, 29, NULL, 0, 1, '2014-04-11 20:28:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HISTORYACTION`
--
-- Creación: 09-04-2014 a las 09:21:03
--

DROP TABLE IF EXISTS `HISTORYACTION`;
CREATE TABLE IF NOT EXISTS `HISTORYACTION` (
  `IDHISTORYACTION` int(11) NOT NULL AUTO_INCREMENT,
  `IDACTION` int(11) NOT NULL,
  `IDPROGRAM` int(11) DEFAULT NULL,
  `IDUSER` int(11) DEFAULT NULL,
  `RETURNCODE` varchar(20) NOT NULL,
  `DATESTAMP` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDHISTORYACTION`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=225 ;

--
-- RELACIONES PARA LA TABLA `HISTORYACTION`:
--   `IDACTION`
--       `ACTIONS` -> `IDACTION`
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

--
-- Volcado de datos para la tabla `HISTORYACTION`
--

INSERT INTO `HISTORYACTION` (`IDHISTORYACTION`, `IDACTION`, `IDPROGRAM`, `IDUSER`, `RETURNCODE`, `DATESTAMP`) VALUES
(5, 1, NULL, 67, '016748655', '2014-03-27 21:47:03'),
(6, 0, NULL, 67, '1', '2014-03-27 21:50:08'),
(7, 0, NULL, 29, '', '2014-03-27 21:50:18'),
(8, 0, NULL, 29, '', '2014-03-27 21:50:24'),
(9, 0, NULL, 29, '', '2014-03-27 21:50:40'),
(10, 0, NULL, 67, '01', '2014-03-27 21:52:17'),
(11, 0, NULL, 67, '03', '2014-03-27 21:52:48'),
(12, 1, NULL, 67, '167486552', '2014-03-27 22:01:23'),
(13, 1, NULL, 67, '167486552', '2014-03-27 22:01:55'),
(14, 1, NULL, 10, '167486552', '2014-03-27 22:12:15'),
(15, 0, NULL, 10, '03', '2014-03-27 22:16:16'),
(16, 0, NULL, 10, '03', '2014-03-27 22:20:21'),
(17, 0, NULL, 10, '03', '2014-03-27 22:20:46'),
(18, 0, NULL, 10, '03', '2014-03-27 22:21:09'),
(19, 0, NULL, 10, '03', '2014-03-27 22:21:57'),
(20, 0, NULL, 10, '03', '2014-03-27 22:21:58'),
(21, 0, NULL, 10, '03', '2014-03-27 22:21:59'),
(22, 0, NULL, 10, '03', '2014-03-27 22:22:01'),
(23, 0, NULL, 10, '03', '2014-03-27 22:22:01'),
(24, 0, NULL, 10, '03', '2014-03-27 22:22:02'),
(25, 0, NULL, 10, '03', '2014-03-27 22:22:03'),
(26, 0, NULL, 10, '03', '2014-03-27 22:22:04'),
(27, 1, NULL, 10, '167486552', '2014-03-27 22:27:15'),
(28, 0, NULL, 10, '03', '2014-03-27 22:27:16'),
(29, 1, NULL, 10, '167486552', '2014-03-27 22:27:18'),
(30, 1, NULL, 10, '167486552', '2014-03-27 22:27:20'),
(31, 1, NULL, 10, '167588552', '2014-03-27 22:27:56'),
(32, 1, NULL, 10, '167588552', '2014-03-27 22:29:26'),
(33, 0, NULL, 10, '03', '2014-03-27 22:29:50'),
(34, 1, NULL, 10, '167221352', '2014-03-27 22:30:04'),
(35, 1, NULL, 10, '167221352', '2014-03-27 22:33:27'),
(36, 1, NULL, 10, '167221352', '2014-03-27 22:33:31'),
(37, 0, NULL, 10, '03', '2014-03-27 22:35:01'),
(38, 0, NULL, 10, '03', '2014-03-27 22:35:10'),
(39, 0, NULL, 10, '03', '2014-03-27 22:48:58'),
(40, 0, NULL, 10, '03', '2014-03-27 22:49:01'),
(41, 0, NULL, 10, '03', '2014-03-27 22:49:04'),
(42, 1, NULL, 10, '0132167221352', '2014-03-27 22:49:11'),
(43, 1, NULL, 10, '0132167221352', '2014-03-27 22:49:14'),
(44, 1, NULL, 10, '0132167221352', '2014-03-27 22:49:17'),
(45, 0, NULL, 10, '03', '2014-03-27 22:50:17'),
(46, 0, NULL, 10, '03', '2014-03-27 22:50:21'),
(47, 0, NULL, 10, '03', '2014-03-27 22:50:26'),
(48, 0, NULL, 10, '03', '2014-03-27 22:50:29'),
(49, 0, NULL, 10, '03', '2014-03-27 22:50:32'),
(50, 0, NULL, 10, '03', '2014-03-27 22:50:35'),
(51, 0, NULL, 10, '03', '2014-03-27 22:50:38'),
(52, 0, NULL, 10, '03', '2014-03-27 22:50:41'),
(53, 0, NULL, 10, '03', '2014-03-27 22:52:07'),
(54, 0, NULL, 10, '03', '2014-03-27 22:52:11'),
(55, 0, NULL, 10, '03', '2014-03-27 22:52:14'),
(56, 0, NULL, 10, '03', '2014-03-27 22:52:19'),
(57, 0, NULL, 10, '03', '2014-03-27 22:52:32'),
(58, 0, NULL, 10, '03', '2014-03-27 22:52:36'),
(59, 1, NULL, 10, '0132167221352', '2014-03-27 22:53:03'),
(60, 1, NULL, 10, '0132167486552', '2014-03-27 22:53:10'),
(61, 1, NULL, 10, '0132167506952', '2014-03-27 22:53:13'),
(62, 0, NULL, 10, '03', '2014-03-27 22:55:49'),
(63, 0, NULL, 10, '03', '2014-03-27 22:57:13'),
(64, 0, NULL, 10, '03', '2014-03-27 22:58:06'),
(65, 0, NULL, 10, '03', '2014-03-27 22:59:49'),
(66, 0, NULL, 10, '03', '2014-03-27 23:06:48'),
(67, 0, NULL, 10, '03', '2014-03-27 23:07:14'),
(68, 0, NULL, 10, '03', '2014-03-27 23:07:26'),
(69, 0, NULL, 10, '03', '2014-03-27 23:10:35'),
(70, 0, NULL, 10, '03', '2014-03-27 23:11:02'),
(71, 0, NULL, 10, '03', '2014-03-27 23:11:24'),
(72, 0, NULL, 10, '03', '2014-03-27 23:13:15'),
(73, 0, NULL, 10, '03', '2014-03-27 23:13:45'),
(74, 0, NULL, 10, '03', '2014-03-27 23:13:48'),
(75, 0, NULL, 10, '03', '2014-03-27 23:14:24'),
(76, 0, NULL, 10, '03', '2014-03-27 23:14:29'),
(77, 1, NULL, 10, '0132167221352', '2014-03-27 23:15:10'),
(78, 1, NULL, 10, '0132167221352', '2014-03-27 23:22:54'),
(79, 0, NULL, 10, '03', '2014-03-27 23:23:36'),
(80, 0, NULL, 10, '03', '2014-03-27 23:23:36'),
(81, 0, NULL, 10, '03', '2014-03-27 23:23:37'),
(82, 0, NULL, 10, '03', '2014-03-27 23:23:37'),
(83, 0, NULL, 10, '03', '2014-03-27 23:23:37'),
(84, 0, NULL, 10, '03', '2014-03-27 23:23:37'),
(85, 0, NULL, 10, '03', '2014-03-27 23:23:38'),
(86, 0, NULL, 10, '03', '2014-03-27 23:23:38'),
(87, 0, NULL, 10, '03', '2014-03-27 23:23:39'),
(88, 0, NULL, 10, '03', '2014-03-27 23:23:39'),
(89, 0, NULL, 10, '03', '2014-03-27 23:23:39'),
(90, 0, NULL, 10, '03', '2014-03-27 23:23:39'),
(91, 0, NULL, 10, '03', '2014-03-27 23:23:40'),
(92, 0, NULL, 10, '03', '2014-03-27 23:23:40'),
(93, 0, NULL, 10, '03', '2014-03-27 23:23:40'),
(94, 0, NULL, 10, '03', '2014-03-27 23:23:40'),
(95, 0, NULL, 10, '03', '2014-03-27 23:23:40'),
(96, 0, NULL, 10, '03', '2014-03-27 23:23:41'),
(97, 0, NULL, 10, '03', '2014-03-27 23:23:41'),
(98, 0, NULL, 10, '03', '2014-03-27 23:23:43'),
(99, 0, NULL, 10, '03', '2014-03-27 23:24:00'),
(100, 0, NULL, 10, '03', '2014-03-27 23:24:00'),
(101, 0, NULL, 10, '03', '2014-03-27 23:24:00'),
(102, 0, NULL, 10, '03', '2014-03-27 23:24:01'),
(103, 0, NULL, 10, '03', '2014-03-27 23:24:01'),
(104, 0, NULL, 10, '03', '2014-03-27 23:24:01'),
(105, 0, NULL, 10, '03', '2014-03-27 23:24:01'),
(106, 0, NULL, 10, '03', '2014-03-27 23:24:01'),
(107, 0, NULL, 10, '03', '2014-03-27 23:24:01'),
(108, 0, NULL, 10, '03', '2014-03-27 23:24:01'),
(109, 0, NULL, 10, '03', '2014-03-27 23:24:01'),
(110, 0, NULL, 10, '03', '2014-03-27 23:24:01'),
(111, 0, NULL, 10, '03', '2014-03-27 23:24:01'),
(112, 0, NULL, 10, '03', '2014-03-27 23:24:02'),
(113, 0, NULL, 10, '03', '2014-03-27 23:24:02'),
(114, 0, NULL, 10, '03', '2014-03-27 23:24:02'),
(115, 0, NULL, 10, '03', '2014-03-27 23:24:02'),
(116, 0, NULL, 10, '03', '2014-03-27 23:24:02'),
(117, 0, NULL, 10, '03', '2014-03-27 23:24:02'),
(118, 0, NULL, 10, '03', '2014-03-27 23:24:02'),
(119, 0, NULL, 10, '03', '2014-03-27 23:24:02'),
(120, 0, NULL, 10, '03', '2014-03-27 23:24:03'),
(121, 0, NULL, 10, '03', '2014-03-27 23:24:03'),
(122, 0, NULL, 10, '03', '2014-03-27 23:24:03'),
(123, 0, NULL, 10, '03', '2014-03-27 23:24:03'),
(124, 0, NULL, 10, '03', '2014-03-27 23:24:04'),
(125, 0, NULL, 10, '03', '2014-03-27 23:24:04'),
(126, 0, NULL, 10, '03', '2014-03-27 23:24:04'),
(127, 0, NULL, 10, '03', '2014-03-27 23:24:04'),
(128, 0, NULL, 10, '03', '2014-03-27 23:24:04'),
(129, 0, NULL, 10, '03', '2014-03-27 23:24:04'),
(130, 0, NULL, 10, '03', '2014-03-27 23:24:04'),
(131, 0, NULL, 10, '03', '2014-03-27 23:24:05'),
(132, 0, NULL, 10, '03', '2014-03-27 23:24:05'),
(133, 0, NULL, 10, '03', '2014-03-27 23:24:05'),
(134, 0, NULL, 10, '03', '2014-03-27 23:24:05'),
(135, 0, NULL, 10, '03', '2014-03-27 23:24:05'),
(136, 0, NULL, 10, '03', '2014-03-27 23:24:06'),
(137, 0, NULL, 10, '03', '2014-03-27 23:24:06'),
(138, 0, NULL, 10, '03', '2014-03-27 23:24:06'),
(139, 0, NULL, 10, '03', '2014-03-27 23:24:07'),
(140, 0, NULL, 10, '03', '2014-03-27 23:24:07'),
(141, 0, NULL, 10, '03', '2014-03-27 23:24:07'),
(142, 0, NULL, 10, '03', '2014-03-27 23:24:08'),
(143, 0, NULL, 10, '03', '2014-03-27 23:24:08'),
(144, 0, NULL, 10, '03', '2014-03-27 23:24:09'),
(145, 1, NULL, 10, '0132167221352', '2014-03-27 23:24:11'),
(146, 1, NULL, 10, '0132167221352', '2014-03-27 23:24:28'),
(147, 1, NULL, 10, '0132167221352', '2014-03-27 23:24:35'),
(148, 1, NULL, 10, '0132167221352', '2014-03-27 23:26:29'),
(149, 1, NULL, 10, '0132167486552', '2014-03-27 23:41:07'),
(150, 1, NULL, 10, '0132167221352', '2014-03-27 23:41:19'),
(151, 0, NULL, 10, '03', '2014-03-27 23:42:11'),
(152, 0, NULL, 10, '03', '2014-03-27 23:42:14'),
(153, 0, NULL, 10, '03', '2014-03-27 23:42:26'),
(154, 0, NULL, 10, '03', '2014-03-27 23:42:29'),
(155, 0, NULL, 67, '01', '2014-03-27 23:49:07'),
(156, 0, NULL, 67, '01', '2014-03-27 23:49:09'),
(157, 0, NULL, 67, '01', '2014-03-27 23:49:10'),
(158, 0, NULL, 10, '03', '2014-03-28 00:14:41'),
(159, 0, NULL, 10, '03', '2014-03-28 00:14:43'),
(160, 0, NULL, 10, '03', '2014-03-28 09:09:02'),
(161, 0, NULL, 10, '03', '2014-03-28 09:09:06'),
(162, 0, NULL, 10, '03', '2014-03-28 09:09:19'),
(163, 0, NULL, 10, '03', '2014-03-28 09:17:34'),
(164, 0, NULL, 10, '03', '2014-03-28 09:19:06'),
(165, 0, NULL, 10, '03', '2014-03-28 09:19:08'),
(166, 1, NULL, 10, '0132167221352', '2014-03-28 10:52:40'),
(167, 1, NULL, 67, '0132167221352', '2014-03-28 10:54:21'),
(168, 0, NULL, 10, '03', '2014-03-28 10:54:26'),
(169, 1, NULL, 10, '0132167486552', '2014-03-28 10:56:13'),
(170, 0, NULL, 10, '03', '2014-03-28 12:17:07'),
(171, 0, NULL, 10, '03', '2014-03-28 12:17:10'),
(172, 0, NULL, 10, '03', '2014-03-28 12:23:19'),
(173, 0, NULL, 10, '03', '2014-03-28 12:23:22'),
(174, 0, NULL, 10, '03', '2014-03-28 15:03:27'),
(175, 0, NULL, 10, '03', '2014-03-28 15:03:28'),
(176, 0, NULL, 10, '03', '2014-03-29 15:00:03'),
(177, 0, NULL, 10, '03', '2014-03-29 15:11:48'),
(178, 1, NULL, 10, '0132167221352', '2014-03-31 14:33:56'),
(179, 1, NULL, 10, '0132167486552', '2014-03-31 14:34:01'),
(180, 1, NULL, 10, '0132167690552', '2014-03-31 14:34:14'),
(181, 1, NULL, 10, '0132167328452', '2014-03-31 14:34:18'),
(182, 1, NULL, 10, '0132167716052', '2014-03-31 14:34:20'),
(183, 1, NULL, 10, '0132167450852', '2014-03-31 14:34:24'),
(184, 1, NULL, 10, '0132167221352', '2014-03-31 14:34:59'),
(185, 1, NULL, 10, '0132167221352', '2014-03-31 15:09:15'),
(186, 1, NULL, 10, '0132167690552', '2014-03-31 15:09:21'),
(187, 1, NULL, 10, '0132167486552', '2014-03-31 15:09:45'),
(188, 1, NULL, 10, '0132167588552', '2014-03-31 15:09:48'),
(189, 1, NULL, 10, '0132167751752', '2014-03-31 15:09:50'),
(190, 1, NULL, 10, '0132167710952', '2014-03-31 15:09:53'),
(191, 1, NULL, 10, '0132167450852', '2014-03-31 15:09:57'),
(192, 0, NULL, 10, '03', '2014-03-31 15:23:51'),
(193, 0, NULL, 10, '03', '2014-03-31 15:23:57'),
(194, 0, NULL, 10, '03', '2014-03-31 21:29:47'),
(195, 0, NULL, 10, '03', '2014-04-02 14:36:12'),
(196, 0, NULL, 10, '03', '2014-04-02 14:36:14'),
(197, 0, NULL, 10, '03', '2014-04-02 14:38:54'),
(198, 1, NULL, 10, '013212', '2014-04-02 15:15:09'),
(199, 1, NULL, 10, '013202', '2014-04-02 15:15:10'),
(200, 0, NULL, 10, '03', '2014-04-02 15:15:12'),
(201, 1, NULL, 10, '0132167588552', '2014-04-02 15:21:37'),
(202, 1, NULL, 10, '0132167588552', '2014-04-02 15:24:38'),
(203, 1, NULL, 10, '0132167486552', '2014-04-02 15:34:11'),
(204, 0, NULL, 10, '03', '2014-04-02 15:35:24'),
(205, 0, NULL, 10, '03', '2014-04-03 09:59:16'),
(206, 0, NULL, 10, '03', '2014-04-03 09:59:18'),
(207, 0, NULL, 10, '03', '2014-04-03 10:03:10'),
(208, 0, NULL, 10, '03', '2014-04-03 10:03:11'),
(209, 1, NULL, 10, '0132167588552', '2014-04-03 13:18:26'),
(210, 1, NULL, 10, '0132167751752', '2014-04-03 13:18:26'),
(211, 1, NULL, 10, '0132167670152', '2014-04-03 13:18:26'),
(212, 0, NULL, 10, '03', '2014-04-03 13:18:30'),
(213, 0, NULL, 10, '03', '2014-04-03 13:18:32'),
(214, 1, NULL, 29, '013216746615132', '2014-04-03 16:15:03'),
(215, 0, NULL, 10, '03', '2014-04-04 08:01:33'),
(216, 0, NULL, 10, '03', '2014-04-04 08:01:34'),
(217, 1, NULL, 29, '013216750695132', '2014-04-04 18:55:03'),
(218, 1, NULL, 29, '013216754775132', '2014-04-04 18:55:06'),
(219, 1, NULL, 29, '013216750695132', '2014-04-04 18:55:07'),
(220, 1, NULL, 29, '013216750695132', '2014-04-04 18:55:08'),
(221, 1, NULL, 29, '013216750695132', '2014-04-04 18:55:08'),
(222, 1, NULL, 29, '013216771095132', '2014-04-04 18:55:10'),
(223, 1, NULL, 29, '013216771095132', '2014-04-04 18:55:11'),
(224, 1, NULL, 29, '013216722135132', '2014-04-04 18:55:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HOUSES`
--
-- Creación: 09-04-2014 a las 12:39:04
--

DROP TABLE IF EXISTS `HOUSES`;
CREATE TABLE IF NOT EXISTS `HOUSES` (
  `IDHOUSE` int(11) NOT NULL AUTO_INCREMENT,
  `IDUSER` int(11) NOT NULL,
  `HOUSENAME` varchar(15) CHARACTER SET utf8 NOT NULL,
  `GPS` varchar(10) DEFAULT NULL,
  `DATEBEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDHOUSE`),
  UNIQUE KEY `HOUSENAME` (`HOUSENAME`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- RELACIONES PARA LA TABLA `HOUSES`:
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

--
-- Volcado de datos para la tabla `HOUSES`
--

INSERT INTO `HOUSES` (`IDHOUSE`, `IDUSER`, `HOUSENAME`, `GPS`, `DATEBEGIN`) VALUES
(1, 1, 'mi casa', '37.6735925', '2014-03-04 05:00:00'),
(2, 11, 'otto', NULL, '2014-03-11 04:00:00'),
(3, 11, 'house', NULL, '2014-03-11 04:00:00'),
(4, 11, 'home', NULL, '2014-03-11 04:00:00'),
(5, 11, 'hause', NULL, '2014-03-11 04:00:00'),
(6, 11, 'shack', NULL, '2014-03-11 04:00:00'),
(8, 1, 'micasa', NULL, '2014-03-23 19:09:25'),
(9, 29, 'casaBertoldo', NULL, '2014-03-23 19:51:49'),
(10, 2, 'Mansión', NULL, '2014-03-25 21:39:22'),
(11, 0, 'demoHouse', NULL, '2014-03-27 14:48:48'),
(12, 0, 'basicHouse0', NULL, '2014-03-27 20:32:40'),
(13, 0, 'basicHouse1', NULL, '2014-03-27 20:32:51'),
(14, 0, 'basicHouse2', NULL, '2014-03-27 20:33:07'),
(15, 0, 'basicHouse3', NULL, '2014-03-27 20:33:21'),
(16, 71, 'Casa1', '125625625', '2014-04-02 09:30:09');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `IRCODES`
--
-- Creación: 27-03-2014 a las 09:29:44
--

DROP TABLE IF EXISTS `IRCODES`;
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
-- Estructura Stand-in para la vista `loginVIEW`
--
DROP VIEW IF EXISTS `loginVIEW`;
CREATE TABLE IF NOT EXISTS `loginVIEW` (
`IDUSER` int(11)
,`USERNAME` varchar(15)
,`IDHOUSE` int(11)
,`HOUSENAME` varchar(15)
,`IDROOM` int(11)
,`ROOMNAME` varchar(10)
,`IDSERVICE` int(11)
,`SERVICENAME` varchar(20)
,`IDACTION` int(11)
,`ACTIONNAME` varchar(10)
,`ACCESSNUMBER` int(11)
,`PERMISSIONNUMBER` int(11)
,`IDDEVICE` int(11)
,`IPADDRESS` varchar(20)
);
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PERMISSIONS`
--
-- Creación: 04-04-2014 a las 09:01:27
--

DROP TABLE IF EXISTS `PERMISSIONS`;
CREATE TABLE IF NOT EXISTS `PERMISSIONS` (
  `IDUSER` int(11) NOT NULL DEFAULT '0',
  `IDSERVICE` int(11) NOT NULL,
  `PERMISSIONNUMBER` int(11) NOT NULL,
  `DATEBEGIN` date DEFAULT NULL,
  PRIMARY KEY (`IDUSER`,`IDSERVICE`),
  KEY `IDSERVICE` (`IDSERVICE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELACIONES PARA LA TABLA `PERMISSIONS`:
--   `IDUSER`
--       `USERS` -> `IDUSER`
--   `IDSERVICE`
--       `SERVICES` -> `IDSERVICE`
--

--
-- Volcado de datos para la tabla `PERMISSIONS`
--

INSERT INTO `PERMISSIONS` (`IDUSER`, `IDSERVICE`, `PERMISSIONNUMBER`, `DATEBEGIN`) VALUES
(29, 13, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PROGRAMACTIONS`
--
-- Creación: 10-04-2014 a las 12:27:40
--

DROP TABLE IF EXISTS `PROGRAMACTIONS`;
CREATE TABLE IF NOT EXISTS `PROGRAMACTIONS` (
  `IDPROGRAM` int(11) NOT NULL AUTO_INCREMENT,
  `IDUSER` int(11) NOT NULL,
  `IDACTION` int(11) NOT NULL,
  `DATA` varchar(30) DEFAULT NULL,
  `STARTTIME` timestamp NULL DEFAULT NULL,
  `DATEBEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDPROGRAM`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=58 ;

--
-- RELACIONES PARA LA TABLA `PROGRAMACTIONS`:
--   `IDACTION`
--       `ACTIONS` -> `IDACTION`
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

--
-- Volcado de datos para la tabla `PROGRAMACTIONS`
--

INSERT INTO `PROGRAMACTIONS` (`IDPROGRAM`, `IDUSER`, `IDACTION`, `DATA`, `STARTTIME`, `DATEBEGIN`) VALUES
(1, 1, 3, NULL, NULL, '0000-00-00 00:00:00'),
(2, 1, 1, NULL, NULL, '0000-00-00 00:00:00'),
(3, 12, 4, NULL, NULL, '0000-00-00 00:00:00'),
(4, 12, 3, NULL, NULL, '0000-00-00 00:00:00'),
(5, 1, 0, NULL, NULL, '0000-00-00 00:00:00'),
(6, 12, 2, NULL, NULL, '0000-00-00 00:00:00'),
(7, 29, 3, NULL, NULL, '0000-00-00 00:00:00'),
(10, 10, 2, NULL, NULL, '0000-00-00 00:00:00'),
(11, 29, 2, NULL, NULL, '0000-00-00 00:00:00'),
(12, 1, 3, NULL, NULL, '0000-00-00 00:00:00'),
(13, 10, 4, NULL, NULL, '0000-00-00 00:00:00'),
(14, 11, 2, NULL, NULL, '0000-00-00 00:00:00'),
(15, 11, 2, NULL, NULL, '0000-00-00 00:00:00'),
(16, 10, 2, NULL, NULL, '0000-00-00 00:00:00'),
(17, 29, 52, NULL, '2014-04-09 10:47:29', '0000-00-00 00:00:00'),
(18, 29, 52, NULL, '2014-04-09 10:50:25', '0000-00-00 00:00:00'),
(19, 29, 52, NULL, '2014-04-09 10:50:30', '0000-00-00 00:00:00'),
(20, 29, 52, NULL, NULL, '2014-04-09 10:57:11'),
(21, 29, 52, NULL, '2014-04-09 13:43:36', '2014-04-09 13:43:36'),
(22, 29, 52, NULL, '2014-04-09 13:43:53', '2014-04-09 13:43:53'),
(23, 29, 52, NULL, '2014-04-09 13:46:03', '2014-04-09 13:46:03'),
(24, 29, 52, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(25, 29, 52, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(26, 29, 52, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(27, 29, 52, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(28, 29, 52, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(29, 0, 52, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(30, 60, 52, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(31, 29, 52, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(32, 29, 52, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(33, 29, 52, NULL, '2014-04-09 14:05:24', '0000-00-00 00:00:00'),
(34, 29, 52, NULL, '2014-04-09 14:05:35', '0000-00-00 00:00:00'),
(35, 29, 52, NULL, '2014-04-09 14:06:05', '0000-00-00 00:00:00'),
(36, 29, 52, NULL, '2014-04-09 14:11:00', '2014-04-09 14:11:00'),
(37, 29, 52, NULL, '2014-04-09 14:12:13', '2014-04-09 14:12:13'),
(38, 29, 52, NULL, NULL, '2014-04-09 14:13:21'),
(39, 29, 52, NULL, '0000-00-00 00:00:00', '2014-04-09 14:13:33'),
(40, 29, 52, NULL, '0000-00-00 00:00:00', '2014-04-09 14:14:58'),
(41, 29, 52, NULL, '0000-00-00 00:00:00', '2014-04-09 14:15:30'),
(42, 29, 52, NULL, '0000-00-00 00:00:00', '2014-04-09 14:16:14'),
(43, 29, 52, NULL, '0000-00-00 00:00:00', '2014-04-09 14:16:26'),
(44, 29, 52, NULL, '2014-04-09 13:43:36', '2014-04-09 14:21:26'),
(45, 29, 52, NULL, '2014-04-09 13:43:36', '2014-04-09 14:22:38'),
(46, 29, 52, NULL, '2014-04-09 13:43:36', '2014-04-09 14:24:40'),
(47, 29, 52, NULL, '0000-00-00 00:00:00', '2014-04-10 09:31:02'),
(48, 29, 52, NULL, '0000-00-00 00:00:00', '2014-04-10 09:31:25'),
(49, 29, 52, NULL, '0000-00-00 00:00:00', '2014-04-10 09:31:55'),
(50, 29, 52, NULL, '0000-00-00 00:00:00', '2014-04-10 09:32:10'),
(51, 29, 52, NULL, '1983-09-05 11:28:00', '2014-04-10 09:34:01'),
(52, 29, 52, NULL, '2009-02-01 23:02:02', '2014-04-10 09:34:11'),
(53, 10, 52, '19830905132800', '0000-00-00 00:00:00', '2014-04-10 12:32:06'),
(54, 29, 52, NULL, NULL, '2014-04-10 12:47:54'),
(55, 29, 52, '19830905132800', '0000-00-00 00:00:00', '2014-04-10 12:48:00'),
(56, 29, 52, '19830905132800', '2009-02-01 23:02:02', '2014-04-10 14:36:44'),
(57, 29, 52, '19830905132800', '2009-02-01 23:02:02', '2014-04-10 15:24:42');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `recuentoACCESOS`
--
DROP VIEW IF EXISTS `recuentoACCESOS`;
CREATE TABLE IF NOT EXISTS `recuentoACCESOS` (
`USERNAME` varchar(15)
,`FUNCTION` varchar(20)
,`TOTAL` bigint(21)
,`SUCCESS` decimal(23,0)
,`ERROR` decimal(23,0)
,`PASSWORD` decimal(23,0)
,`INTEGRITY` decimal(23,0)
);
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ROOMS`
--
-- Creación: 09-04-2014 a las 08:37:10
--

DROP TABLE IF EXISTS `ROOMS`;
CREATE TABLE IF NOT EXISTS `ROOMS` (
  `IDROOM` int(11) NOT NULL AUTO_INCREMENT,
  `IDHOUSE` int(11) DEFAULT NULL,
  `IDUSER` int(11) DEFAULT NULL,
  `ROOMNAME` varchar(10) NOT NULL,
  `DATEBEGIN` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDROOM`),
  UNIQUE KEY `ROOMNAME` (`ROOMNAME`,`IDHOUSE`),
  KEY `IDHOUSE` (`IDHOUSE`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;

--
-- RELACIONES PARA LA TABLA `ROOMS`:
--   `IDUSER`
--       `USERS` -> `IDUSER`
--   `IDHOUSE`
--       `HOUSES` -> `IDHOUSE`
--

--
-- Volcado de datos para la tabla `ROOMS`
--

INSERT INTO `ROOMS` (`IDROOM`, `IDHOUSE`, `IDUSER`, `ROOMNAME`, `DATEBEGIN`) VALUES
(1, 9, 29, 'cocina', '2014-03-23 20:00:53'),
(2, 9, 29, 'terraza', '2014-03-23 20:01:32'),
(7, 10, 2, 'Livingroom', '2014-03-25 21:40:27'),
(8, 10, 2, 'Garage', '2014-03-25 21:41:04'),
(9, 10, 2, 'Ktichen', '2014-03-25 21:41:17'),
(10, 10, 2, 'Garden', '2014-03-25 21:41:31'),
(11, 11, 0, 'Livingroom', '2014-03-25 21:40:27'),
(12, 11, 0, 'Ktichen', '2014-03-25 21:41:17'),
(13, 12, 0, 'Lab', '2014-03-27 20:34:35'),
(14, 13, 0, 'Lab', '2014-03-27 20:34:35'),
(15, 14, 0, 'Lab', '2014-03-27 20:34:35'),
(16, 15, 0, 'Lab', '2014-03-27 20:34:35'),
(17, 16, 71, 'Hab1', '2014-04-02 09:30:33');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `scheduleVIEW`
--
DROP VIEW IF EXISTS `scheduleVIEW`;
CREATE TABLE IF NOT EXISTS `scheduleVIEW` (
`IDTASK` int(11)
,`TASKNAME` varchar(15)
,`IDPROGRAM` int(11)
,`IDACTION` int(11)
,`IDHOUSE` int(11)
,`HOUSENAME` varchar(15)
,`IDROOM` int(11)
,`ROOMNAME` varchar(10)
,`IDSERVICE` int(11)
,`SERVICENAME` varchar(20)
);
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `SERVICES`
--
-- Creación: 09-04-2014 a las 07:56:47
--

DROP TABLE IF EXISTS `SERVICES`;
CREATE TABLE IF NOT EXISTS `SERVICES` (
  `IDSERVICE` int(11) NOT NULL AUTO_INCREMENT,
  `IDROOM` int(11) DEFAULT NULL,
  `IDDEVICE` int(11) DEFAULT NULL,
  `SERVICENAME` varchar(20) NOT NULL,
  `SERVICEINTERFACE` int(11) NOT NULL,
  `FCODE` int(11) DEFAULT NULL,
  `ENGLISH` varchar(50) DEFAULT NULL,
  `SPANISH` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IDSERVICE`),
  UNIQUE KEY `UNQ_IDROOM_IDDEVICE_SERVICENAME` (`IDROOM`,`IDDEVICE`,`SERVICENAME`),
  KEY `IDDEVICE` (`IDDEVICE`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=61 ;

--
-- RELACIONES PARA LA TABLA `SERVICES`:
--   `IDROOM`
--       `ROOMS` -> `IDROOM`
--   `IDDEVICE`
--       `DEVICES` -> `IDDEVICE`
--

--
-- Volcado de datos para la tabla `SERVICES`
--

INSERT INTO `SERVICES` (`IDSERVICE`, `IDROOM`, `IDDEVICE`, `SERVICENAME`, `SERVICEINTERFACE`, `FCODE`, `ENGLISH`, `SPANISH`) VALUES
(0, NULL, NULL, 'TV', 0, NULL, 'Universal remote for TV.', 'Mando universal para televición.'),
(1, NULL, NULL, 'IRRIGATION', 0, NULL, 'For plant drink.', 'Riego de plantas.'),
(2, NULL, NULL, 'INFRARED', 0, NULL, 'For control all infrared devices.', 'Control generico de dispositivos infrarrojos.'),
(3, NULL, NULL, 'LIGHTS', 0, NULL, 'Ligths control.', 'Control de las luces.'),
(4, NULL, NULL, 'SENSOR', 0, NULL, 'Control safety sensors.', 'Control de sensores de seguridad.'),
(5, NULL, NULL, 'BLINDS', 0, NULL, 'Control motorized blinds.', 'Control de persianas motorizadas.'),
(13, 1, 9, 'LIGHTS', 0, NULL, NULL, NULL),
(14, 2, 9, 'BLINDS', 0, NULL, NULL, NULL),
(15, 1, 9, 'TV', 0, 132, NULL, NULL),
(16, 2, 9, 'SENSOR', 0, NULL, NULL, NULL),
(17, 2, 9, 'LIGHTS', 0, NULL, NULL, NULL),
(29, 7, 10, 'TV', 0, NULL, NULL, NULL),
(30, 7, 10, 'DVD', 0, NULL, NULL, NULL),
(31, 7, 10, 'STEREO', 0, NULL, NULL, NULL),
(32, 7, 10, 'AIRCONDITIONING', 0, NULL, NULL, NULL),
(33, 7, 10, 'LIGHTS', 0, NULL, NULL, NULL),
(34, 7, 10, 'HEATING', 0, NULL, NULL, NULL),
(35, 8, 10, 'TV', 0, NULL, NULL, NULL),
(36, 8, 10, 'MICROWAVE', 0, NULL, NULL, NULL),
(37, 8, 10, 'STEREO', 0, NULL, NULL, NULL),
(38, 8, 10, 'AIRCONDITIONING', 0, NULL, NULL, NULL),
(39, 8, 10, 'HEATING', 0, NULL, NULL, NULL),
(40, 8, 10, 'LIGHTS', 0, NULL, NULL, NULL),
(41, 9, 10, 'STEREO', 0, NULL, NULL, NULL),
(42, 9, 10, 'DOOR', 0, NULL, NULL, NULL),
(43, 9, 10, 'LIGHTS', 0, NULL, NULL, NULL),
(44, 9, 10, 'HEATING', 0, NULL, NULL, NULL),
(45, 10, 10, 'LIGHTS', 0, NULL, NULL, NULL),
(46, 10, 10, 'VIDEO', 0, NULL, NULL, NULL),
(47, 11, 9, 'LIGHTS', 0, 0, NULL, NULL),
(48, 11, 9, 'TV', 0, 0, NULL, NULL),
(49, 12, 11, 'TV', 0, 1, 'Universal remote for TV.', 'Mando universal para televición.'),
(51, 12, 11, 'LIGHTS', 0, 1, 'Ligths control.', 'Control de las luces.'),
(52, 13, 11, 'TV', 0, 0, NULL, NULL),
(53, 13, 11, 'LIGHTS', 0, 1, NULL, NULL),
(54, 14, 12, 'TV', 0, 2, NULL, NULL),
(55, 15, 13, 'TV', 0, 4, NULL, NULL),
(56, 16, 14, 'TV', 0, 6, NULL, NULL),
(57, 14, 12, 'LIGHTS', 0, 3, NULL, NULL),
(58, 15, 13, 'LIGHTS', 0, 5, NULL, NULL),
(59, 16, 14, 'LIGHTS', 0, 7, NULL, NULL),
(60, 17, 15, 'LIGHTS', 0, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `SOFTWARE`
--
-- Creación: 23-03-2014 a las 15:23:12
--

DROP TABLE IF EXISTS `SOFTWARE`;
CREATE TABLE IF NOT EXISTS `SOFTWARE` (
  `DEVICE` int(11) NOT NULL,
  `VERSION` int(11) NOT NULL,
  `PACKAGE` varchar(1000) NOT NULL,
  UNIQUE KEY `DEVICE` (`DEVICE`,`VERSION`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `STADISTICS`
--
-- Creación: 05-04-2014 a las 17:48:55
--

DROP TABLE IF EXISTS `STADISTICS`;
CREATE TABLE IF NOT EXISTS `STADISTICS` (
  `Y` bigint(21) NOT NULL DEFAULT '0',
  `X` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `STADISTICS`
--

INSERT INTO `STADISTICS` (`Y`, `X`) VALUES
(4, '2014-04-01 00:00:00'),
(8, '2014-04-01 01:00:00'),
(2, '2014-04-01 01:30:00'),
(2, '2014-04-01 02:00:00'),
(1, '2014-04-01 11:30:00'),
(1, '2014-04-02 10:30:00'),
(5, '2014-04-02 12:30:00'),
(2, '2014-04-02 16:00:00'),
(19, '2014-04-02 16:30:00'),
(16, '2014-04-02 17:00:00'),
(9, '2014-04-02 17:30:00'),
(4, '2014-04-02 18:00:00'),
(1, '2014-04-02 18:30:00'),
(5, '2014-04-03 11:00:00'),
(10, '2014-04-03 11:30:00'),
(10, '2014-04-03 12:00:00'),
(3, '2014-04-03 13:00:00'),
(11, '2014-04-03 13:30:00'),
(3, '2014-04-03 14:00:00'),
(6, '2014-04-03 15:00:00'),
(6, '2014-04-03 16:00:00'),
(8, '2014-04-03 16:30:00'),
(8, '2014-04-03 17:30:00'),
(3, '2014-04-03 18:00:00'),
(2, '2014-04-03 21:00:00'),
(9, '2014-04-03 22:00:00'),
(10, '2014-04-03 23:30:00'),
(7, '2014-04-04 00:00:00'),
(7, '2014-04-04 00:30:00'),
(2, '2014-04-04 01:00:00'),
(1, '2014-04-04 08:00:00'),
(4, '2014-04-04 10:00:00'),
(6, '2014-04-04 15:30:00'),
(7, '2014-04-04 16:00:00'),
(14, '2014-04-04 16:30:00'),
(11, '2014-04-04 17:00:00'),
(5, '2014-04-04 17:30:00'),
(2, '2014-04-04 19:00:00'),
(5, '2014-04-04 19:30:00'),
(1, '2014-04-04 20:00:00'),
(11, '2014-04-04 20:30:00'),
(27, '2014-04-04 22:00:00'),
(1, '2014-04-04 22:30:00'),
(1, '2014-04-04 23:00:00'),
(13, '2014-04-05 11:30:00'),
(9, '2014-04-05 12:00:00'),
(1, '2014-04-05 12:30:00'),
(5, '2014-04-05 13:00:00'),
(16, '2014-04-05 14:30:00'),
(6, '2014-04-05 15:00:00'),
(7, '2014-04-05 16:00:00'),
(1, '2014-04-05 16:30:00'),
(1, '2014-04-05 18:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `TASKPROGRAM`
--
-- Creación: 09-04-2014 a las 12:30:29
--

DROP TABLE IF EXISTS `TASKPROGRAM`;
CREATE TABLE IF NOT EXISTS `TASKPROGRAM` (
  `IDTASK` int(11) NOT NULL,
  `IDPROGRAM` int(11) NOT NULL,
  UNIQUE KEY `1_ACTION_1_TASK` (`IDTASK`,`IDPROGRAM`),
  KEY `IDPROGRAM` (`IDPROGRAM`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELACIONES PARA LA TABLA `TASKPROGRAM`:
--   `IDTASK`
--       `TASKS` -> `IDTASK`
--   `IDPROGRAM`
--       `PROGRAMACTIONS` -> `IDPROGRAM`
--

--
-- Volcado de datos para la tabla `TASKPROGRAM`
--

INSERT INTO `TASKPROGRAM` (`IDTASK`, `IDPROGRAM`) VALUES
(5, 7),
(18, 50);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `TASKS`
--
-- Creación: 10-04-2014 a las 09:15:07
--

DROP TABLE IF EXISTS `TASKS`;
CREATE TABLE IF NOT EXISTS `TASKS` (
  `IDTASK` int(11) NOT NULL AUTO_INCREMENT,
  `TASKNAME` varchar(15) CHARACTER SET utf8 NOT NULL,
  `IDUSER` int(11) DEFAULT NULL,
  `DESCRIPTION` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  ` FREQUENCY` timestamp NULL DEFAULT NULL,
  `DATEBEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDTASK`),
  KEY `IDUSER` (`IDUSER`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=21 ;

--
-- RELACIONES PARA LA TABLA `TASKS`:
--   `IDUSER`
--       `USERS` -> `IDUSER`
--

--
-- Volcado de datos para la tabla `TASKS`
--

INSERT INTO `TASKS` (`IDTASK`, `TASKNAME`, `IDUSER`, `DESCRIPTION`, ` FREQUENCY`, `DATEBEGIN`) VALUES
(1, '', 1, NULL, NULL, '0000-00-00 00:00:00'),
(2, '', 29, NULL, NULL, '0000-00-00 00:00:00'),
(4, '', 1, NULL, NULL, '0000-00-00 00:00:00'),
(5, '', 1, NULL, NULL, '0000-00-00 00:00:00'),
(6, '', NULL, NULL, NULL, '0000-00-00 00:00:00'),
(9, 'er', 0, 'dess', '2014-04-09 20:32:05', '2014-04-09 20:32:05'),
(10, 'primer', 29, 'tarea nueva', '2014-04-09 20:32:39', '2014-04-09 20:32:39'),
(11, 'prier', 29, 'tarea nueva', '2014-04-09 20:33:17', '2014-04-09 20:33:17'),
(16, 'cuarta', 29, 'la primera', '2009-02-01 23:02:02', '2014-04-10 09:16:41'),
(17, 'quinta', 29, 'la primera', '0000-00-00 00:00:00', '2014-04-10 09:17:12'),
(18, 'sexta', 29, 'la primera', '1983-09-05 11:28:00', '2014-04-10 09:18:52'),
(19, 'septima', 29, 'la primera', '0000-00-00 00:00:00', '2014-04-10 09:19:34');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `USERS`
--
-- Creación: 09-04-2014 a las 13:27:15
--

DROP TABLE IF EXISTS `USERS`;
CREATE TABLE IF NOT EXISTS `USERS` (
  `IDUSER` int(11) NOT NULL AUTO_INCREMENT,
  `USERNAME` varchar(15) CHARACTER SET utf8 NOT NULL,
  `PASSWORD` varchar(40) CHARACTER SET utf8 NOT NULL,
  `EMAIL` varchar(40) CHARACTER SET utf8 NOT NULL,
  `HINT` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `DATEBEGIN` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDUSER`),
  UNIQUE KEY `USERNAME` (`USERNAME`),
  UNIQUE KEY `EMAIL` (`EMAIL`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=84 ;

--
-- Volcado de datos para la tabla `USERS`
--

INSERT INTO `USERS` (`IDUSER`, `USERNAME`, `PASSWORD`, `EMAIL`, `HINT`, `DATEBEGIN`) VALUES
(0, '', '', '', NULL, '2014-03-25 10:36:01'),
(1, 'alex', 'd41d8cd98f0b24e980998ecf8427e', 'a', 'hint', '2014-03-11 04:00:00'),
(2, 'Colin Tirado', '87e2763c408e3dc4adc3e4177566b3b2', 'ctiradocaa@gmail.com', 'Adivina adivinanza.', '2014-03-25 21:36:35'),
(10, 'luis', '502ff82f7f1f8218dd41201fe4353687', 'luis@gmail.com', 'what about me?', '2014-11-13 05:00:00'),
(11, 'alex2', '534b44a19bf18d20b71ecc4eb77c572f', 'alex@hotmail.co', 'what about me?', '2014-01-11 05:00:00'),
(12, 'alex3', '534b44a19bf18d20b71ecc4eb77c572f', 'alex@ehc.com', 'what about me?', '2014-03-01 05:00:00'),
(28, 'luis2', '502ff82f7f1f8218dd41201fe4353687', 'luis@hotmail.co', 'what about me?', '2014-03-03 05:00:00'),
(29, 'bertoldo', '6e1fd914c4532f9325e4107bd68e32c7', 'bertoldo@gmail.com', 'what about me?', '2014-03-23 04:00:01'),
(60, 'a', 'cc175b9c0f1b6a831c399e269772661', 'a@', NULL, '2014-03-25 22:08:01'),
(61, 'berto', '4124bca9335c27f86f24ba207a4912', 'hhhhh@gms.com', NULL, '2014-03-26 11:11:56'),
(62, 's', '3c7c0ace395d8182db7ae2c30f034', 's@d', NULL, '2014-03-27 14:35:35'),
(64, 'sobek', '69dafe8b5866478aea48f3df384820', 'Sergioprimo23@Gmail.com', NULL, '2014-03-27 15:17:28'),
(65, 'beaordepe', 'b32676f518207bc993997bf8b58adacc', 'beaordepe@gmail.com', NULL, '2014-03-27 15:58:12'),
(66, 'Ismael', 'e1adc3949ba59abbe56e057f2f883e', 'irequena@outlook.com', NULL, '2014-03-27 16:14:53'),
(67, 'example', '1a79a4d60de6718e8e5b326e338ae533', 'example@gmail.com', 'about me.', '2014-03-27 20:49:06'),
(68, 'asd', '7815696ecbf1c96e6894b779456d33e', 'asd@', '', '2014-03-28 12:15:55'),
(69, 'miguel', '9eb0c9605dc81a68731f61b3e0838937', 'miguel@gmail.com', '', '2014-03-28 12:22:15'),
(71, 'Sam', '332532dcfaa1cbf61e2a266bd723612c', 'sam@gmail.com', 'Remember me.', '2014-04-02 09:29:18'),
(75, 'd', 's', 'd', 'd', '2014-04-08 09:59:21'),
(77, 'beta', 'f', 'aasdf@asdf', 'hint', '2014-04-08 10:18:30'),
(80, 'dd', 'fgh', 'das', 'df', '2014-04-09 09:09:05'),
(82, 'ó', '', 'oóbn', 'oóoóo', '2014-04-09 13:22:58'),
(83, 'x', '7815696ecbf1c96e6894b779456d330e', 'z@f', ' ', '2014-04-09 13:33:28');

-- --------------------------------------------------------

--
-- Estructura para la vista `loginVIEW`
--
DROP TABLE IF EXISTS `loginVIEW`;

CREATE ALGORITHM=UNDEFINED DEFINER=`alex`@`localhost` SQL SECURITY DEFINER VIEW `loginVIEW` AS select `USERS`.`IDUSER` AS `IDUSER`,`USERS`.`USERNAME` AS `USERNAME`,`HOUSES`.`IDHOUSE` AS `IDHOUSE`,`HOUSES`.`HOUSENAME` AS `HOUSENAME`,`ROOMS`.`IDROOM` AS `IDROOM`,`ROOMS`.`ROOMNAME` AS `ROOMNAME`,`SERVICES`.`IDSERVICE` AS `IDSERVICE`,`SERVICES`.`SERVICENAME` AS `SERVICENAME`,`ACTIONS`.`IDACTION` AS `IDACTION`,`ACTIONS`.`ACTIONNAME` AS `ACTIONNAME`,`ACCESSHOUSE`.`ACCESSNUMBER` AS `ACCESSNUMBER`,`PERMISSIONS`.`PERMISSIONNUMBER` AS `PERMISSIONNUMBER`,`DEVICES`.`IDDEVICE` AS `IDDEVICE`,`DEVICES`.`IPADDRESS` AS `IPADDRESS` from (((((((`USERS` left join `ACCESSHOUSE` on((`USERS`.`IDUSER` = `ACCESSHOUSE`.`IDUSER`))) left join `HOUSES` on((`ACCESSHOUSE`.`IDHOUSE` = `HOUSES`.`IDHOUSE`))) left join `ROOMS` on((`ACCESSHOUSE`.`IDHOUSE` = `ROOMS`.`IDHOUSE`))) left join `SERVICES` on((`ROOMS`.`IDROOM` = `SERVICES`.`IDROOM`))) left join `DEVICES` on((`SERVICES`.`IDDEVICE` = `DEVICES`.`IDDEVICE`))) left join `ACTIONS` on((`SERVICES`.`IDSERVICE` = `ACTIONS`.`IDSERVICE`))) left join `PERMISSIONS` on(((`PERMISSIONS`.`IDUSER` = `USERS`.`IDUSER`) and (`PERMISSIONS`.`IDSERVICE` = `SERVICES`.`IDSERVICE`)))) where 1 order by `USERS`.`USERNAME`,`HOUSES`.`HOUSENAME`,`ROOMS`.`ROOMNAME`,`SERVICES`.`SERVICENAME`,`ACTIONS`.`ACTIONNAME` desc;

-- --------------------------------------------------------

--
-- Estructura para la vista `recuentoACCESOS`
--
DROP TABLE IF EXISTS `recuentoACCESOS`;

CREATE ALGORITHM=UNDEFINED DEFINER=`alex`@`localhost` SQL SECURITY DEFINER VIEW `recuentoACCESOS` AS select `USERS`.`USERNAME` AS `USERNAME`,`FUNCTIONS`.`FUNCTION` AS `FUNCTION`,count(0) AS `TOTAL`,sum(if((`HISTORYACCESS`.`ERROR` = 0),1,0)) AS `SUCCESS`,sum(if((`HISTORYACCESS`.`ERROR` <> 0),1,0)) AS `ERROR`,sum(if((`HISTORYACCESS`.`ERROR` = 2),1,0)) AS `PASSWORD`,sum(if((`HISTORYACCESS`.`ERROR` = 4),1,0)) AS `INTEGRITY` from (((`USERS` left join `HISTORYACCESS` on((`USERS`.`IDUSER` = `HISTORYACCESS`.`IDUSER`))) left join `FUNCTIONS` on((`HISTORYACCESS`.`FUNCT` = `FUNCTIONS`.`FUNCT`))) join `ERRORS` on((`ERRORS`.`ERRORCODE` = `HISTORYACCESS`.`ERROR`))) group by `USERS`.`USERNAME`,`FUNCTIONS`.`FUNCTION` order by count(0) desc;

-- --------------------------------------------------------

--
-- Estructura para la vista `scheduleVIEW`
--
DROP TABLE IF EXISTS `scheduleVIEW`;

CREATE ALGORITHM=UNDEFINED DEFINER=`alex`@`localhost` SQL SECURITY DEFINER VIEW `scheduleVIEW` AS select `TASKS`.`IDTASK` AS `IDTASK`,`TASKS`.`TASKNAME` AS `TASKNAME`,`PROGRAMACTIONS`.`IDPROGRAM` AS `IDPROGRAM`,`PROGRAMACTIONS`.`IDACTION` AS `IDACTION`,`HOUSES`.`IDHOUSE` AS `IDHOUSE`,`HOUSES`.`HOUSENAME` AS `HOUSENAME`,`ROOMS`.`IDROOM` AS `IDROOM`,`ROOMS`.`ROOMNAME` AS `ROOMNAME`,`SERVICES`.`IDSERVICE` AS `IDSERVICE`,`SERVICES`.`SERVICENAME` AS `SERVICENAME` from (`ACTIONS` join ((((`PROGRAMACTIONS` left join (`TASKPROGRAM` join `TASKS`) on(((`TASKPROGRAM`.`IDPROGRAM` = `PROGRAMACTIONS`.`IDPROGRAM`) and (`TASKPROGRAM`.`IDTASK` = `TASKS`.`IDTASK`)))) join `SERVICES`) join `ROOMS` on((`ROOMS`.`IDROOM` = `SERVICES`.`IDROOM`))) join `HOUSES` on((`HOUSES`.`IDHOUSE` = `ROOMS`.`IDHOUSE`)))) where ((`ACTIONS`.`IDACTION` = `PROGRAMACTIONS`.`IDACTION`) and (`SERVICES`.`IDSERVICE` = `ACTIONS`.`IDSERVICE`)) order by `TASKS`.`TASKNAME` desc,`PROGRAMACTIONS`.`IDPROGRAM`;

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
-- Filtros para la tabla `PERMISSIONS`
--
ALTER TABLE `PERMISSIONS`
  ADD CONSTRAINT `PERMISSIONS_ibfk_1` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`),
  ADD CONSTRAINT `PERMISSIONS_ibfk_2` FOREIGN KEY (`IDSERVICE`) REFERENCES `SERVICES` (`IDSERVICE`);

--
-- Filtros para la tabla `ROOMS`
--
ALTER TABLE `ROOMS`
  ADD CONSTRAINT `ROOMS_ibfk_1` FOREIGN KEY (`IDHOUSE`) REFERENCES `HOUSES` (`IDHOUSE`);

--
-- Filtros para la tabla `SERVICES`
--
ALTER TABLE `SERVICES`
  ADD CONSTRAINT `SERVICES_ibfk_1` FOREIGN KEY (`IDROOM`) REFERENCES `ROOMS` (`IDROOM`),
  ADD CONSTRAINT `SERVICES_ibfk_2` FOREIGN KEY (`IDDEVICE`) REFERENCES `DEVICES` (`IDDEVICE`);

--
-- Filtros para la tabla `TASKPROGRAM`
--
ALTER TABLE `TASKPROGRAM`
  ADD CONSTRAINT `TASKPROGRAM_ibfk_1` FOREIGN KEY (`IDTASK`) REFERENCES `TASKS` (`IDTASK`),
  ADD CONSTRAINT `TASKPROGRAM_ibfk_2` FOREIGN KEY (`IDPROGRAM`) REFERENCES `PROGRAMACTIONS` (`IDPROGRAM`);

--
-- Filtros para la tabla `TASKS`
--
ALTER TABLE `TASKS`
  ADD CONSTRAINT `TASKS_ibfk_1` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
