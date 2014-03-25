-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 25-03-2014 a las 13:50:15
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
(29, 9, 1, '2014-03-23 19:56:06');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=67 ;

--
-- Volcado de datos para la tabla `ACTIONS`
--

INSERT INTO `ACTIONS` (`IDACTION`, `IDSERVICE`, `ACTIONNAME`, `ENGLISH`, `SPANISH`, `FCODE`) VALUES
(0, NULL, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(1, NULL, 'RESETEAR', 'RESET', 'RESETEAR', '0x002221'),
(2, NULL, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(3, NULL, 'ENVIAR', 'SEND', 'ENVIAR', '0x002123'),
(4, NULL, 'RECIBIR', 'RECIVE', 'RECIBIR', '0x002456'),
(5, NULL, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002787'),
(24, 0, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(25, 0, 'RESETEAR', 'RESET', 'RESETEAR', '0x002221'),
(26, 0, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(27, 0, 'ENVIAR', 'SEND', 'ENVIAR', '0x002123'),
(28, 0, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002334'),
(29, 1, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(30, 1, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(31, 1, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002787'),
(32, 2, 'APAGAR', 'OFF', 'APAGAR', '0x118000'),
(33, 2, 'RESETEAR', 'RESET', 'RESETEAR', '0x180001'),
(34, 2, 'ENCENDER', 'ON', 'ENCENDER', '0x002300'),
(35, 2, 'ENVIAR', 'SEND', 'ENVIAR', '0x001010'),
(36, 2, 'RECIBIR', 'RECIVE', 'RECIBIR', '0x002456'),
(37, 2, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002787'),
(38, 3, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(39, 3, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(40, 4, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(41, 4, 'RESETEAR', 'RESET', 'RESETEAR', '0x002221'),
(42, 4, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(43, 4, 'ENVIAR', 'SEND', 'ENVIAR', '0x002123'),
(44, 4, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002787'),
(45, 4, 'RECIBIR', 'RECIVE', 'RECIBIR', '0x002456'),
(46, 5, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(49, 5, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(50, 5, 'ENVIAR', 'SEND', 'ENVIAR', '0x002123'),
(51, 13, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(52, 13, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(53, 14, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(54, 14, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(55, 14, 'ENVIAR', 'SEND', 'ENVIAR', '0x002123'),
(56, 15, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(57, 15, 'RESETEAR', 'RESET', 'RESETEAR', '0x002221'),
(58, 15, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(59, 15, 'ENVIAR', 'SEND', 'ENVIAR', '0x002123'),
(60, 15, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002334'),
(61, 16, 'APAGAR', 'OFF', 'APAGAR', '0x002443'),
(62, 16, 'RESETEAR', 'RESET', 'RESETEAR', '0x002221'),
(63, 16, 'ENCENDER', 'ON', 'ENCENDER', '0x002314'),
(64, 16, 'ENVIAR', 'SEND', 'ENVIAR', '0x002123'),
(65, 16, 'CONFIGURAR', 'CONFIGURE', 'CONFIGURAR', '0x002787'),
(66, 16, 'RECIBIR', 'RECIVE', 'RECIBIR', '0x002456');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

--
-- Volcado de datos para la tabla `DEVICES`
--

INSERT INTO `DEVICES` (`IDDEVICE`, `IPADDRESS`, `SERIAL`, `NAME`, `ENGLISH`, `SPANISH`, `DATE`, `VERSION`) VALUES
(0, NULL, NULL, 'Arduino UNO', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1),
(1, NULL, NULL, 'Arduino DUO', '{"Microcontroller":"AT91SAM3X8E","Operating Voltage":"3.3V","Input Voltage (recommended)":"7-12V","Input Voltage (limits)":"6-16V","Digital I/O Pins":"54 (of which 12 provide PWM output)","Analog Input Pins":"12","Analog Outputs Pins":"2 (DAC)","Total DC Output Current on all I/O lines":"130 mA","DC Current for 3.3V Pin":"800 mA","DC Current for 5V Pin":"800 mA","Flash Memory":"512 KB all available for the user applications","SRAM":"96 KB (two banks: 64KB and 32KB)","Clock Speed":"84 MHz"}', '{"Microcontroller":"AT91SAM3X8E","Operating Voltage":"3.3V","Input Voltage (recommended)":"7-12V","Input Voltage (limits)":"6-16V","Digital I/O Pins":"54 (of which 12 provide PWM output)","Analog Input Pins":"12","Analog Outputs Pins":"2 (DAC)","Total DC Output Current on all I/O lines":"130 mA","DC Current for 3.3V Pin":"800 mA","DC Current for 5V Pin":"800 mA","Flash Memory":"512 KB all available for the user applications","SRAM":"96 KB (two banks: 64KB and 32KB)","Clock Speed":"84 MHz"}', '2014-03-23 21:35:50', 1),
(9, '12.45.34.123', NULL, 'Arduino UNO', '{"Microcontroller":"ATmega328",\r\n    "Operating Voltage":"5V",\r\n    "Input Voltage (recommended)":"7-12V",\r\n    "Input Voltage (limits)":"6-20V",\r\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\r\n    "Analog Input Pins":"6",\r\n    "DC Current per I/O Pin":"40 mA",\r\n    "DC Current for 3.3V Pin":"50 mA",\r\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\r\n    "SRAM":"2 KB (ATmega328)",\r\n    "EEPROM":"1 KB (ATmega328)",\r\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\r\n    "Operating Voltage":"5V",\r\n    "Input Voltage (recommended)":"7-12V",\r\n    "Input Voltage (limits)":"6-20V",\r\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\r\n    "Analog Input Pins":"6",\r\n    "DC Current per I/O Pin":"40 mA",\r\n    "DC Current for 3.3V Pin":"50 mA",\r\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\r\n    "SRAM":"2 KB (ATmega328)",\r\n    "EEPROM":"1 KB (ATmega328)",\r\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ERRORS`
--

CREATE TABLE IF NOT EXISTS `ERRORS` (
  `ERRORCODE` int(11) NOT NULL AUTO_INCREMENT,
  `ENGLISH` varchar(50) NOT NULL,
  `SPANISH` varchar(50) NOT NULL,
  PRIMARY KEY (`ERRORCODE`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=20 ;

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
(9, 'This room does not exist.', 'Esta habitación no existe.'),
(10, 'Requires permission.', 'Necesita permisos.'),
(11, 'Requires access.', 'Necesita acceso.'),
(12, 'Email password recovery sent.', 'Correo de recuperacion de contraseña enviado.'),
(13, 'Create new user.', 'Nuevo usuario creado.'),
(14, 'Deleted user.', 'Usuario eliminado.'),
(15, 'User modified.', 'Usuario modificado.'),
(16, 'Action sent.', 'Acción enviada.'),
(17, 'Create new house.', 'Nueva casa creada.'),
(18, 'You have not access to this house.', 'No tiene acceso a la casa.'),
(19, 'House deleted.', 'Casa eliminada.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `FUNCTIONS`
--

CREATE TABLE IF NOT EXISTS `FUNCTIONS` (
  `FUNCT` int(11) NOT NULL AUTO_INCREMENT,
  `FUNCTION` varchar(20) NOT NULL,
  PRIMARY KEY (`FUNCT`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

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
(9, 'deletehouse');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=91 ;

--
-- Volcado de datos para la tabla `HISTORYACCESS`
--

INSERT INTO `HISTORYACCESS` (`IDHISTORY`, `IDUSER`, `IDHOUSE`, `ERROR`, `FUNCT`, `DATESTAMP`) VALUES
(56, 10, NULL, 0, 1, '2014-03-25 12:01:22'),
(57, 45, NULL, 6, 3, '2014-03-25 12:01:31'),
(58, 10, NULL, 0, 1, '2014-03-25 12:28:56'),
(59, 50, NULL, 0, 3, '2014-03-25 12:28:57'),
(60, 10, NULL, 0, 1, '2014-03-25 12:29:26'),
(61, 50, NULL, 6, 3, '2014-03-25 12:29:27'),
(62, 10, NULL, 0, 1, '2014-03-25 12:36:53'),
(63, 50, NULL, 6, 3, '2014-03-25 12:36:54'),
(64, 10, NULL, 0, 1, '2014-03-25 12:37:25'),
(65, 51, NULL, 0, 3, '2014-03-25 12:37:26'),
(66, 10, NULL, 0, 1, '2014-03-25 12:43:38'),
(67, 51, NULL, 6, 3, '2014-03-25 12:43:40'),
(68, 10, NULL, 0, 1, '2014-03-25 12:49:25'),
(69, 52, NULL, 0, 3, '2014-03-25 12:49:27'),
(70, 10, NULL, 0, 1, '2014-03-25 12:54:02'),
(71, 52, NULL, 6, 3, '2014-03-25 12:54:03'),
(72, 10, NULL, 0, 1, '2014-03-25 12:55:24'),
(73, 52, NULL, 6, 3, '2014-03-25 12:55:25'),
(74, 10, NULL, 0, 1, '2014-03-25 13:17:19'),
(75, 10, NULL, 0, 1, '2014-03-25 14:37:53'),
(76, 52, NULL, 6, 3, '2014-03-25 14:37:55'),
(77, 10, NULL, 0, 1, '2014-03-25 14:40:45'),
(78, 52, NULL, 6, 3, '2014-03-25 14:40:50'),
(79, 53, NULL, 0, 3, '2014-03-25 14:49:41'),
(80, 54, NULL, 0, 3, '2014-03-25 15:02:30'),
(81, 10, NULL, 0, 1, '2014-03-25 15:09:49'),
(82, 55, NULL, 0, 3, '2014-03-25 15:29:59'),
(83, 56, NULL, 0, 3, '2014-03-25 15:33:04'),
(84, 57, NULL, 0, 3, '2014-03-25 15:35:38'),
(85, 58, NULL, 0, 3, '2014-03-25 15:39:15'),
(86, 58, NULL, 6, 3, '2014-03-25 15:39:34'),
(87, 56, NULL, 6, 3, '2014-03-25 15:43:15'),
(88, 10, NULL, 0, 1, '2014-03-25 15:50:47'),
(89, 10, NULL, 0, 1, '2014-03-25 15:57:04'),
(90, 10, NULL, 0, 1, '2014-03-25 16:34:59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HISTORYACTION`
--

CREATE TABLE IF NOT EXISTS `HISTORYACTION` (
  `IDHISTORYACTION` int(11) NOT NULL AUTO_INCREMENT,
  `IDACTION` int(11) NOT NULL,
  `IDPROGRAM` int(11) DEFAULT NULL,
  `IDUSER` int(11) NOT NULL,
  `RETURNCODE` varchar(20) NOT NULL,
  `DATESTAMP` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDHISTORYACTION`),
  KEY `IDPROGRAM` (`IDPROGRAM`),
  KEY `IDUSER` (`IDUSER`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

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
(9, 29, 'casaBertoldo', NULL, '2014-03-23 19:51:49');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PERMISSIONS`
--

CREATE TABLE IF NOT EXISTS `PERMISSIONS` (
  `IDUSER` int(11) NOT NULL DEFAULT '0',
  `IDSERVICE` int(11) NOT NULL,
  `LEVELNUMBER` int(11) DEFAULT NULL,
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Volcado de datos para la tabla `ROOMS`
--

INSERT INTO `ROOMS` (`IDROOM`, `IDHOUSE`, `IDUSER`, `ROOMNAME`, `DATEBEGIN`) VALUES
(1, 9, 29, 'cocina', '2014-03-23 20:00:53'),
(2, 9, 29, 'terraza', '2014-03-23 20:01:32');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `SERVICES`
--

CREATE TABLE IF NOT EXISTS `SERVICES` (
  `IDSERVICE` int(11) NOT NULL AUTO_INCREMENT,
  `IDROOM` int(11) DEFAULT NULL,
  `IDDEVICE` int(11) DEFAULT NULL,
  `SERVICENAME` varchar(20) NOT NULL,
  `ENGLISH` varchar(50) DEFAULT NULL,
  `SPANISH` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IDSERVICE`),
  UNIQUE KEY `UNQ_IDROOM_IDDEVICE_SERVICENAME` (`IDROOM`,`IDDEVICE`,`SERVICENAME`),
  KEY `IDDEVICE` (`IDDEVICE`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;

--
-- Volcado de datos para la tabla `SERVICES`
--

INSERT INTO `SERVICES` (`IDSERVICE`, `IDROOM`, `IDDEVICE`, `SERVICENAME`, `ENGLISH`, `SPANISH`) VALUES
(0, NULL, NULL, 'TV', 'Universal remote for TV.', 'Mando universal para televición.'),
(1, NULL, NULL, 'IRRIGATION', 'For plant drink.', 'Riego de plantas.'),
(2, NULL, NULL, 'INFRARED', 'For control all infrared devices.', 'Control generico de dispositivos infrarrojos.'),
(3, NULL, NULL, 'LIGTHS', 'Ligths control.', 'Control de las luces.'),
(4, NULL, NULL, 'SENSOR', 'Control safety sensors.', 'Control de sensores de seguridad.'),
(5, NULL, NULL, 'BLINDS', 'Control motorized blinds.', 'Control de persianas motorizadas.'),
(13, 1, 9, 'LIGTHS', NULL, NULL),
(14, 2, 9, 'BLINDS', NULL, NULL),
(15, 1, 9, 'TV', NULL, NULL),
(16, 2, 9, 'SENSOR', NULL, NULL),
(17, 2, 9, 'LIGTHS', NULL, NULL);

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
  `PASSWORD` varchar(32) NOT NULL,
  `EMAIL` varchar(15) NOT NULL,
  `HINT` varchar(30) DEFAULT NULL,
  `JSON` varchar(1000) NOT NULL DEFAULT '{     "Rooms": {         "R1": {             "name": "Livingroom",             "items": [                 "TV",                 "DVD",                 "Stereo",                 "AirConditioning",                 "Lights",                 "Heating"             ]         },         "R2": {             "name": "Kitchen",             "items": [                 "TV",                 "Microhondas",                 "Stereo",                 "AirConditioning",                 "Heating",                 "Lights",                 "Heating"             ]         },         "R3": {             "name": "Garage",             "items": [                 "Stereo",                 "Door",                 "Lights",                 "Heating"             ]         },         "R4": {             "name": "Garden",             "items": [                 "Lights",                 "Video"             ]         }     },     "User": "Colin Tirado" }',
  `DATEBEGIN` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDUSER`),
  UNIQUE KEY `USERNAME` (`USERNAME`),
  UNIQUE KEY `EMAIL` (`EMAIL`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=59 ;

--
-- Volcado de datos para la tabla `USERS`
--

INSERT INTO `USERS` (`IDUSER`, `USERNAME`, `PASSWORD`, `EMAIL`, `HINT`, `JSON`, `DATEBEGIN`) VALUES
(0, 'administrator', '', '', NULL, '', '2014-03-25 10:36:01'),
(1, 'alex', '534b44a19bf18d20b71ecc4eb77c572f', 'alex@gmail.com', 'what about me?', '{     "Rooms": {         "R1": {             "name": "Livingroom",             "items": [                 "TV",                 "DVD",                 "Stereo",                 "AirConditioning",                 "Lights",                 "Heating"             ]         },         "R2": {             "name": "Kitchen",             "items": [                 "TV",                 "Microhondas",                 "Stereo",                 "AirConditioning",                 "Heating",                 "Lights",                 "Heating"             ]         },         "R3": {             "name": "Garage",             "items": [                 "Stereo",                 "Door",                 "Lights",                 "Heating"             ]         },         "R4": {             "name": "Garden",             "items": [                 "Lights",                 "Video"             ]         }     },     "User": "Colin Tirado" }', '2014-03-11 04:00:00'),
(10, 'luis', '502ff82f7f1f8218dd41201fe4353687', 'luis@gmail.com', 'what about me?', '{\n    "Rooms": {\n        "R1": {\n            "name": "Livingroom",\n            "items": [\n                "TV",\n                "DVD",\n                "Stereo",\n                "AirConditioning",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R2": {\n            "name": "Kitchen",\n            "items": [\n                "TV",\n                "Microhondas",\n                "Stereo",\n                "AirConditioning",\n                "Heating",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R3": {\n            "name": "Garage",\n            "items": [\n                "Stereo",\n                "Door",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R4": {\n            "name": "Garden",\n            "items": [\n                "Lights",\n                "Video"\n            ]\n        }\n    },\n    "User": "Colin Tirado"\n}', '2014-11-13 05:00:00'),
(11, 'alex2', '534b44a19bf18d20b71ecc4eb77c572f', 'alex@hotmail.co', 'what about me?', '{\n    "Rooms": {\n        "R1": {\n            "name": "Livingroom",\n            "items": [\n                "TV",\n                "DVD",\n                "Stereo",\n                "AirConditioning",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R2": {\n            "name": "Kitchen",\n            "items": [\n                "TV",\n                "Microhondas",\n                "Stereo",\n                "AirConditioning",\n                "Heating",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R3": {\n            "name": "Garage",\n            "items": [\n                "Stereo",\n                "Door",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R4": {\n            "name": "Garden",\n            "items": [\n                "Lights",\n                "Video"\n            ]\n        }\n    },\n    "User": "Colin Tirado"\n}', '2014-01-11 05:00:00'),
(12, 'alex3', '534b44a19bf18d20b71ecc4eb77c572f', 'alex@ehc.com', 'what about me?', '{\n    "Rooms": {\n        "R1": {\n            "name": "Livingroom",\n            "items": [\n                "TV",\n                "DVD",\n                "Stereo",\n                "AirConditioning",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R2": {\n            "name": "Kitchen",\n            "items": [\n                "TV",\n                "Microhondas",\n                "Stereo",\n                "AirConditioning",\n                "Heating",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R3": {\n            "name": "Garage",\n            "items": [\n                "Stereo",\n                "Door",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R4": {\n            "name": "Garden",\n            "items": [\n                "Lights",\n                "Video"\n            ]\n        }\n    },\n    "User": "Colin Tirado"\n}', '2014-03-01 05:00:00'),
(28, 'luis2', '502ff82f7f1f8218dd41201fe4353687', 'luis@hotmail.co', 'what about me?', '{\n    "Rooms": {\n        "R1": {\n            "name": "Livingroom",\n            "items": [\n                "TV",\n                "DVD",\n                "Stereo",\n                "AirConditioning",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R2": {\n            "name": "Kitchen",\n            "items": [\n                "TV",\n                "Microhondas",\n                "Stereo",\n                "AirConditioning",\n                "Heating",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R3": {\n            "name": "Garage",\n            "items": [\n                "Stereo",\n                "Door",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R4": {\n            "name": "Garden",\n            "items": [\n                "Lights",\n                "Video"\n            ]\n        }\n    },\n    "User": "Colin Tirado"\n}', '2014-03-03 05:00:00'),
(29, 'bertoldo', '6e1fd914c4532f9325e4107bd68e32c7', 'bertoldo@gmail.', 'thats not fun.', '{\n    "Rooms": {\n        "R1": {\n            "name": "Livingroom",\n            "items": [\n                "TV",\n                "DVD",\n                "Stereo",\n                "AirConditioning",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R2": {\n            "name": "Kitchen",\n            "items": [\n                "TV",\n                "Microhondas",\n                "Stereo",\n                "AirConditioning",\n                "Heating",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R3": {\n            "name": "Garage",\n            "items": [\n                "Stereo",\n                "Door",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R4": {\n            "name": "Garden",\n            "items": [\n                "Lights",\n                "Video"\n            ]\n        }\n    },\n    "User": "Colin Tirado"\n}', '2014-03-23 04:00:01'),
(52, 'a', 'cc175b9c0f1b6a831c399e269772661', 'a', 'caca', '', '2014-03-25 12:49:27'),
(53, 'q', '7694f4a66316e53c8cdd9d9954bd611d', 'q@h', 'caca', '', '2014-03-25 14:49:41'),
(54, 'j', '363b122c528f54df4a446b6bab05515', 'j@', 'caca', '', '2014-03-25 15:02:30'),
(55, 'x', '9dd4e461268c8034f5c8564e155c67a6', 'x@', 'caca', '', '2014-03-25 15:29:59'),
(56, 'z', 'fbade9e36a3f36d3d676c1b88451dd7', 'z@', 'caca', '', '2014-03-25 15:33:04'),
(57, 'n', '7b8b965ad4bca0e41ab51de7b31363a1', 'n@', 'caca', '', '2014-03-25 15:35:37'),
(58, 'm', '6f8f57715090da2632453988d9a1501b', 'm@', 'caca', '', '2014-03-25 15:39:15');

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
  ADD CONSTRAINT `HISTORYACTION_ibfk_1` FOREIGN KEY (`IDPROGRAM`) REFERENCES `PROGRAMACTIONS` (`IDPROGRAM`),
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
  ADD CONSTRAINT `PERMISSIONS_ibfk_2` FOREIGN KEY (`IDSERVICE`) REFERENCES `SERVICES` (`IDSERVICE`),
  ADD CONSTRAINT `PERMISSIONS_ibfk_1` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`);

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
