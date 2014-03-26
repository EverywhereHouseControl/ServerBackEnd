-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 26-03-2014 a las 08:29:42
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
(2, 10, 1, '2014-03-25 21:39:58'),
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=69 ;

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Volcado de datos para la tabla `DEVICES`
--

INSERT INTO `DEVICES` (`IDDEVICE`, `IPADDRESS`, `SERIAL`, `NAME`, `ENGLISH`, `SPANISH`, `DATE`, `VERSION`) VALUES
(0, NULL, NULL, 'Arduino UNO', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1),
(1, NULL, NULL, 'Arduino DUO', '{"Microcontroller":"AT91SAM3X8E","Operating Voltage":"3.3V","Input Voltage (recommended)":"7-12V","Input Voltage (limits)":"6-16V","Digital I/O Pins":"54 (of which 12 provide PWM output)","Analog Input Pins":"12","Analog Outputs Pins":"2 (DAC)","Total DC Output Current on all I/O lines":"130 mA","DC Current for 3.3V Pin":"800 mA","DC Current for 5V Pin":"800 mA","Flash Memory":"512 KB all available for the user applications","SRAM":"96 KB (two banks: 64KB and 32KB)","Clock Speed":"84 MHz"}', '{"Microcontroller":"AT91SAM3X8E","Operating Voltage":"3.3V","Input Voltage (recommended)":"7-12V","Input Voltage (limits)":"6-16V","Digital I/O Pins":"54 (of which 12 provide PWM output)","Analog Input Pins":"12","Analog Outputs Pins":"2 (DAC)","Total DC Output Current on all I/O lines":"130 mA","DC Current for 3.3V Pin":"800 mA","DC Current for 5V Pin":"800 mA","Flash Memory":"512 KB all available for the user applications","SRAM":"96 KB (two banks: 64KB and 32KB)","Clock Speed":"84 MHz"}', '2014-03-23 21:35:50', 1),
(9, '12.45.34.123', NULL, 'Arduino UNO', '{"Microcontroller":"ATmega328",\r\n    "Operating Voltage":"5V",\r\n    "Input Voltage (recommended)":"7-12V",\r\n    "Input Voltage (limits)":"6-20V",\r\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\r\n    "Analog Input Pins":"6",\r\n    "DC Current per I/O Pin":"40 mA",\r\n    "DC Current for 3.3V Pin":"50 mA",\r\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\r\n    "SRAM":"2 KB (ATmega328)",\r\n    "EEPROM":"1 KB (ATmega328)",\r\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\r\n    "Operating Voltage":"5V",\r\n    "Input Voltage (recommended)":"7-12V",\r\n    "Input Voltage (limits)":"6-20V",\r\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\r\n    "Analog Input Pins":"6",\r\n    "DC Current per I/O Pin":"40 mA",\r\n    "DC Current for 3.3V Pin":"50 mA",\r\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\r\n    "SRAM":"2 KB (ATmega328)",\r\n    "EEPROM":"1 KB (ATmega328)",\r\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1),
(10, '12.45.34.123', '52.33PL', 'Arduino UNO', '{"Microcontroller":"ATmega328",\r\n    "Operating Voltage":"5V",\r\n    "Input Voltage (recommended)":"7-12V",\r\n    "Input Voltage (limits)":"6-20V",\r\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\r\n    "Analog Input Pins":"6",\r\n    "DC Current per I/O Pin":"40 mA",\r\n    "DC Current for 3.3V Pin":"50 mA",\r\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\r\n    "SRAM":"2 KB (ATmega328)",\r\n    "EEPROM":"1 KB (ATmega328)",\r\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\r\n    "Operating Voltage":"5V",\r\n    "Input Voltage (recommended)":"7-12V",\r\n    "Input Voltage (limits)":"6-20V",\r\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\r\n    "Analog Input Pins":"6",\r\n    "DC Current per I/O Pin":"40 mA",\r\n    "DC Current for 3.3V Pin":"50 mA",\r\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\r\n    "SRAM":"2 KB (ATmega328)",\r\n    "EEPROM":"1 KB (ATmega328)",\r\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1);

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=254 ;

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
(253, 10, NULL, 0, 1, '2014-03-26 12:28:47');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

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
(10, 2, 'Mansión', NULL, '2014-03-25 21:39:22');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Volcado de datos para la tabla `ROOMS`
--

INSERT INTO `ROOMS` (`IDROOM`, `IDHOUSE`, `IDUSER`, `ROOMNAME`, `DATEBEGIN`) VALUES
(1, 9, 29, 'cocina', '2014-03-23 20:00:53'),
(2, 9, 29, 'terraza', '2014-03-23 20:01:32'),
(7, 10, 2, 'Livingroom', '2014-03-25 21:40:27'),
(8, 10, 2, 'holo', '2014-03-25 21:41:04'),
(9, 10, 2, 'Ktichen', '2014-03-25 21:41:17'),
(10, 10, 2, 'Garden', '2014-03-25 21:41:31');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=47 ;

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
(17, 2, 9, 'LIGTHS', NULL, NULL),
(29, 7, 10, 'TV', NULL, NULL),
(30, 7, 10, 'DVD', NULL, NULL),
(31, 7, 10, 'Stereo', NULL, NULL),
(32, 7, 10, 'AirConditioning', NULL, NULL),
(33, 7, 10, 'Lights', NULL, NULL),
(34, 7, 10, 'Heating', NULL, NULL),
(35, 8, 10, 'TV', NULL, NULL),
(36, 8, 10, 'Microhondas', NULL, NULL),
(37, 8, 10, 'Stereo', NULL, NULL),
(38, 8, 10, 'AirConditioning', NULL, NULL),
(39, 8, 10, 'Heating', NULL, NULL),
(40, 8, 10, 'Lights', NULL, NULL),
(41, 9, 10, 'Stereo', NULL, NULL),
(42, 9, 10, 'Door', NULL, NULL),
(43, 9, 10, 'Lights', NULL, NULL),
(44, 9, 10, 'Heating', NULL, NULL),
(45, 10, 10, 'Lights', NULL, NULL),
(46, 10, 10, 'Video', NULL, NULL);

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
  `EMAIL` varchar(40) NOT NULL,
  `HINT` varchar(30) DEFAULT NULL,
  `DATEBEGIN` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDUSER`),
  UNIQUE KEY `USERNAME` (`USERNAME`),
  UNIQUE KEY `EMAIL` (`EMAIL`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=62 ;

--
-- Volcado de datos para la tabla `USERS`
--

INSERT INTO `USERS` (`IDUSER`, `USERNAME`, `PASSWORD`, `EMAIL`, `HINT`, `DATEBEGIN`) VALUES
(0, 'administrator', '', '', NULL, '2014-03-25 10:36:01'),
(1, 'alex', 'd41d8cd98f0b24e980998ecf8427e', 'a', 'hint', '2014-03-11 04:00:00'),
(2, 'Colin Tirado', '291755357c76c19359d59bd1e756a8a9', 'ctiradocaa@gmail.com', 'Adivina adivinanza.', '2014-03-25 21:36:35'),
(10, 'luis', '502ff82f7f1f8218dd41201fe4353687', 'luis@gmail.com', 'what about me?', '2014-11-13 05:00:00'),
(11, 'alex2', '534b44a19bf18d20b71ecc4eb77c572f', 'alex@hotmail.co', 'what about me?', '2014-01-11 05:00:00'),
(12, 'alex3', '534b44a19bf18d20b71ecc4eb77c572f', 'alex@ehc.com', 'what about me?', '2014-03-01 05:00:00'),
(28, 'luis2', '502ff82f7f1f8218dd41201fe4353687', 'luis@hotmail.co', 'what about me?', '2014-03-03 05:00:00'),
(29, 'bertoldo', '6e1fd914c4532f9325e4107bd68e32c7', 'bertoldo@gmail.', 'thats not fun.', '2014-03-23 04:00:01'),
(60, 'a', 'cc175b9c0f1b6a831c399e269772661', 'a@', 'caca', '2014-03-25 22:08:01'),
(61, 'berto', '4124bca9335c27f86f24ba207a4912', 'hhhhh@gms.com', 'caca', '2014-03-26 11:11:56');

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
