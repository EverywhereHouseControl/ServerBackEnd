-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 09-04-2014 a las 11:22:47
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

CREATE DEFINER=`alex`@`localhost` PROCEDURE `loginJSON`( in u VARCHAR(15))
begin

SELECT *
	FROM  USERS
	LEFT JOIN ACCESSHOUSE USING (IDUSER)
	LEFT JOIN HOUSES USING ( IDHOUSE )
	LEFT JOIN ROOMS USING ( IDHOUSE )
	LEFT JOIN SERVICES USING ( IDROOM  )
	LEFT JOIN DEVICES USING (IDDEVICE)
	LEFT JOIN ACTIONS USING ( IDSERVICE  )
	LEFT JOIN PERMISSIONS ON (PERMISSIONS.IDUSER = USERS.IDUSER AND  PERMISSIONS.IDSERVICE=SERVICES.IDSERVICE)
	WHERE USERS.USERNAME = u 
	ORDER BY USERNAME, HOUSENAME, ROOMNAME, SERVICENAME, ACTIONNAME DESC;

end$$

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

CREATE DEFINER=`alex`@`localhost` PROCEDURE `ProG`()
begin 
SELECT * FROM USERS;
end$$

CREATE DEFINER=`alex`@`localhost` PROCEDURE `selectiduser`( in u VARCHAR(20), out id integer)
BEGIN
DECLARE idu INTEGER;
SELECT IDUSER into idu FROM USERS WHERE USERNAME=u;
set id = idu;
END$$

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
CREATE DEFINER=`alex`@`localhost` FUNCTION `ROUND_HOUR`(datestamp DATETIME) RETURNS datetime
    NO SQL
    DETERMINISTIC
    COMMENT 'returns nearest hour'
RETURN DATE_FORMAT(datestamp + INTERVAL 30 MINUTE, '%Y-%m-%d %H:00')$$

CREATE DEFINER=`alex`@`localhost` FUNCTION `TRUNC_N_HOURS`(datestamp DATETIME, n INT) RETURNS datetime
    NO SQL
    DETERMINISTIC
    COMMENT 'truncate to N hour boundary. For example,\n           TRUNCATE_N_HOURS(sometime, 12) gives the nearest\n           preceding half-day (noon, or midnight'
RETURN DATE(datestamp) +
                INTERVAL (HOUR(datestamp) -
                          HOUR(datestamp) MOD n) HOUR$$

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
(67, 12, 1, '2014-03-23 19:56:06'),
(67, 13, 1, '2014-03-23 19:56:06'),
(67, 14, 1, '2014-03-23 19:56:06'),
(67, 15, 1, '2014-03-23 19:56:06'),
(71, 16, 1, '2014-03-23 19:56:06');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1664 ;

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
  PRIMARY KEY (`IDHISTORYACTION`)
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
  UNIQUE KEY `HOUSENAME` (`HOUSENAME`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

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
(10, 2, 'Mansion', NULL, '2014-03-25 21:39:22'),
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
  KEY `IDHOUSE` (`IDHOUSE`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;

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
-- Estructura de tabla para la tabla `SERVICES`
--

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Volcado de datos para la tabla `TASKS`
--

INSERT INTO `TASKS` (`IDTASK`, `IDUSER`, `IDPROGRAM`, `DESCRIPTION`, `STARTTIME`, `PERIODICITY`) VALUES
(1, 1, 7, NULL, '2014-03-13 16:45:44', NULL),
(2, 29, 12, NULL, '2014-03-13 16:45:44', NULL),
(4, 1, 1, NULL, '2014-03-13 16:45:44', NULL),
(5, 1, 12, NULL, '2014-03-13 16:45:44', NULL),
(6, NULL, NULL, NULL, '2014-03-13 16:45:44', NULL);

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=81 ;

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
(71, 'Sam', 'ba0e0cde1bf72c28d435c89a66afc61a', 'sam@gmail.com', 'Remember me.', '2014-04-02 09:29:18'),
(75, 'd', 's', 'd', 'd', '2014-04-08 09:59:21'),
(77, 'beta', 'f', 'aasdf@asdf', 'hint', '2014-04-08 10:18:30'),
(80, 'dd', 'fgh', 'das', 'df', '2014-04-09 09:09:05');

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
-- Filtros para la tabla `PROGRAMACTIONS`
--
ALTER TABLE `PROGRAMACTIONS`
  ADD CONSTRAINT `PROGRAMACTIONS_ibfk_1` FOREIGN KEY (`NEXT`) REFERENCES `PROGRAMACTIONS` (`IDPROGRAM`);

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
-- Filtros para la tabla `TASKS`
--
ALTER TABLE `TASKS`
  ADD CONSTRAINT `TASKS_ibfk_1` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
