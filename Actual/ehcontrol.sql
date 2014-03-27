-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 27-03-2014 a las 17:16:00
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
(0, 11, 1, '2014-03-25 21:39:58'),
(0, 12, 1, '2014-03-23 19:56:06'),
(0, 13, 1, '2014-03-23 19:56:06'),
(0, 14, 1, '2014-03-23 19:56:06'),
(0, 15, 1, '2014-03-23 19:56:06'),
(2, 10, 1, '2014-03-25 21:39:58'),
(29, 9, 1, '2014-03-23 19:56:06'),
(67, 12, 1, '2014-03-23 19:56:06'),
(67, 13, 1, '2014-03-23 19:56:06'),
(67, 14, 1, '2014-03-23 19:56:06'),
(67, 15, 1, '2014-03-23 19:56:06');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=15 ;

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
(14, '12.45.34.123', '3', 'Arduino UNO', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '{"Microcontroller":"ATmega328",\n    "Operating Voltage":"5V",\n    "Input Voltage (recommended)":"7-12V",\n    "Input Voltage (limits)":"6-20V",\n    "Digital I/O Pins":"14 (of which 6 provide PWM output)",\n    "Analog Input Pins":"6",\n    "DC Current per I/O Pin":"40 mA",\n    "DC Current for 3.3V Pin":"50 mA",\n    "Flash Memory":"32 KB (ATmega328) of which 0.5 KB used by bootloader",\n    "SRAM":"2 KB (ATmega328)",\n    "EEPROM":"1 KB (ATmega328)",\n    "Clock Speed":"16 MHz"}', '2014-03-23 21:21:42', 1);

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=692 ;

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
(691, 0, NULL, 0, 10, '2014-03-27 21:03:54');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

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
(15, 0, 'basicHouse3', NULL, '2014-03-27 20:33:21');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Volcado de datos para la tabla `ROOMS`
--

INSERT INTO `ROOMS` (`IDROOM`, `IDHOUSE`, `IDUSER`, `ROOMNAME`, `DATEBEGIN`) VALUES
(1, 9, 29, 'cocina', '2014-03-23 20:00:53'),
(2, 9, 29, 'terraza', '2014-03-23 20:01:32'),
(7, 10, 2, 'Livingroom', '2014-03-25 21:40:27'),
(8, 10, 2, 'holo', '2014-03-25 21:41:04'),
(9, 10, 2, 'Ktichen', '2014-03-25 21:41:17'),
(10, 10, 2, 'Garden', '2014-03-25 21:41:31'),
(11, 11, 0, 'Livingroom', '2014-03-25 21:40:27'),
(12, 11, 0, 'Ktichen', '2014-03-25 21:41:17'),
(13, 12, 0, 'Lab', '2014-03-27 20:34:35'),
(14, 13, 0, 'Lab', '2014-03-27 20:34:35'),
(15, 14, 0, 'Lab', '2014-03-27 20:34:35'),
(16, 15, 0, 'Lab', '2014-03-27 20:34:35');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=60 ;

--
-- Volcado de datos para la tabla `SERVICES`
--

INSERT INTO `SERVICES` (`IDSERVICE`, `IDROOM`, `IDDEVICE`, `SERVICENAME`, `FCODE`, `ENGLISH`, `SPANISH`) VALUES
(0, NULL, NULL, 'TV', NULL, 'Universal remote for TV.', 'Mando universal para televición.'),
(1, NULL, NULL, 'IRRIGATION', NULL, 'For plant drink.', 'Riego de plantas.'),
(2, NULL, NULL, 'INFRARED', NULL, 'For control all infrared devices.', 'Control generico de dispositivos infrarrojos.'),
(3, NULL, NULL, 'LIGTHS', NULL, 'Ligths control.', 'Control de las luces.'),
(4, NULL, NULL, 'SENSOR', NULL, 'Control safety sensors.', 'Control de sensores de seguridad.'),
(5, NULL, NULL, 'BLINDS', NULL, 'Control motorized blinds.', 'Control de persianas motorizadas.'),
(13, 1, 9, 'LIGTHS', NULL, NULL, NULL),
(14, 2, 9, 'BLINDS', NULL, NULL, NULL),
(15, 1, 9, 'TV', NULL, NULL, NULL),
(16, 2, 9, 'SENSOR', NULL, NULL, NULL),
(17, 2, 9, 'LIGTHS', NULL, NULL, NULL),
(29, 7, 10, 'TV', NULL, NULL, NULL),
(30, 7, 10, 'DVD', NULL, NULL, NULL),
(31, 7, 10, 'Stereo', NULL, NULL, NULL),
(32, 7, 10, 'AirConditioning', NULL, NULL, NULL),
(33, 7, 10, 'Lights', NULL, NULL, NULL),
(34, 7, 10, 'Heating', NULL, NULL, NULL),
(35, 8, 10, 'TV', NULL, NULL, NULL),
(36, 8, 10, 'Microhondas', NULL, NULL, NULL),
(37, 8, 10, 'Stereo', NULL, NULL, NULL),
(38, 8, 10, 'AirConditioning', NULL, NULL, NULL),
(39, 8, 10, 'Heating', NULL, NULL, NULL),
(40, 8, 10, 'Lights', NULL, NULL, NULL),
(41, 9, 10, 'Stereo', NULL, NULL, NULL),
(42, 9, 10, 'Door', NULL, NULL, NULL),
(43, 9, 10, 'Lights', NULL, NULL, NULL),
(44, 9, 10, 'Heating', NULL, NULL, NULL),
(45, 10, 10, 'Lights', NULL, NULL, NULL),
(46, 10, 10, 'Video', NULL, NULL, NULL),
(47, 11, 9, 'LIGTHS', NULL, NULL, NULL),
(48, 11, 9, 'TV', NULL, NULL, NULL),
(49, 12, 11, 'TV', NULL, 'Universal remote for TV.', 'Mando universal para televición.'),
(51, 12, 11, 'LIGTHS', NULL, 'Ligths control.', 'Control de las luces.'),
(52, 13, 11, 'TV', 0, NULL, NULL),
(53, 13, 11, 'LIGHTS', 1, NULL, NULL),
(54, 14, 12, 'TV', 2, NULL, NULL),
(55, 15, 13, 'TV', 4, NULL, NULL),
(56, 16, 14, 'TV', 6, NULL, NULL),
(57, 14, 12, 'LIGHTS', 3, NULL, NULL),
(58, 15, 13, 'LIGHTS', 5, NULL, NULL),
(59, 16, 14, 'LIGHTS', 7, NULL, NULL);

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=68 ;

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
(29, 'bertoldo', '6e1fd914c4532f9325e4107bd68e32c7', 'bertoldo@gmail.', NULL, '2014-03-23 04:00:01'),
(60, 'a', 'cc175b9c0f1b6a831c399e269772661', 'a@', NULL, '2014-03-25 22:08:01'),
(61, 'berto', '4124bca9335c27f86f24ba207a4912', 'hhhhh@gms.com', NULL, '2014-03-26 11:11:56'),
(62, 's', '3c7c0ace395d8182db7ae2c30f034', 's@d', NULL, '2014-03-27 14:35:35'),
(64, 'sobek', '69dafe8b5866478aea48f3df384820', 'Sergioprimo23@Gmail.com', NULL, '2014-03-27 15:17:28'),
(65, 'beaordepe', 'b32676f518207bc993997bf8b58adacc', 'beaordepe@gmail.com', NULL, '2014-03-27 15:58:12'),
(66, 'Ismael', 'e1adc3949ba59abbe56e057f2f883e', 'irequena@outlook.com', NULL, '2014-03-27 16:14:53'),
(67, 'example', '1a79a4d60de6718e8e5b326e338ae533', 'example@gmail.com', 'about me.', '2014-03-27 20:49:06');

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
