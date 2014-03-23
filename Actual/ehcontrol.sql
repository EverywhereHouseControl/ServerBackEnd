-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 23-03-2014 a las 14:28:02
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
  PRIMARY KEY (`IDUSER`,`IDHOUSE`),
  KEY `IDHOUSE` (`IDHOUSE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `ACCESSHOUSE`
--

INSERT INTO `ACCESSHOUSE` (`IDUSER`, `IDHOUSE`, `ACCESSNUMBER`) VALUES
(1, 1, 3),
(10, 2, 1),
(10, 6, 6),
(12, 2, 4);

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `ACTIONMESSAGES`
--

INSERT INTO `ACTIONMESSAGES` (`IDMESSAGE`, `IDACTION`, `RETURNCODE`, `EXIT`, `ENGLISH`, `SPANISH`) VALUES
(1, 1, '0X000001', 0, 'SUCCESS', 'CORRECTO');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=24 ;

--
-- Volcado de datos para la tabla `ACTIONS`
--

INSERT INTO `ACTIONS` (`IDACTION`, `IDSERVICE`, `ACTIONNAME`, `ENGLISH`, `SPANISH`, `FCODE`) VALUES
(1, 1, 'ENCENDER', '', '', '0x0020301'),
(2, NULL, 'APAGAR', '', '', '0x002443'),
(3, NULL, 'RESET', '', '', '0x002221'),
(4, 1, 'RESET', '', '', '0x0025766'),
(6, 1, 'APAGAR', '', '', '0x002121'),
(7, 4, 'APAGAR', '', '', '0x00211'),
(8, 3, 'RESET', '', '', '0x002543'),
(9, 9, 'APAGAR', '', '', '0x00243'),
(10, NULL, 'ENCENDER', '', '', '0x002314'),
(11, NULL, 'ENVIAR', '', '', '0x002123'),
(12, NULL, 'RECIBIR', '', '', '0x002456'),
(13, NULL, 'CONFIGURAR', '', '', '0x002787'),
(14, 6, 'ENCENDER', '', '', '0x002223'),
(15, 3, 'CONFIGURAR', '', '', '0x0026556');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `DEVICES`
--

CREATE TABLE IF NOT EXISTS `DEVICES` (
  `IDDEVICE` int(11) NOT NULL AUTO_INCREMENT,
  `SERIAL` varchar(11) DEFAULT NULL,
  `NAME` varchar(10) DEFAULT NULL,
  `ENGLISH` varchar(50) DEFAULT NULL,
  `SPANISH` varchar(50) DEFAULT NULL,
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `VERSION` int(11) NOT NULL,
  PRIMARY KEY (`IDDEVICE`),
  UNIQUE KEY `SERIAL` (`SERIAL`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Volcado de datos para la tabla `DEVICES`
--

INSERT INTO `DEVICES` (`IDDEVICE`, `SERIAL`, `NAME`, `ENGLISH`, `SPANISH`, `DATE`, `VERSION`) VALUES
(1, '25.6.LR', 'JARDUINO', 'NOT EXISTING YET', NULL, '0000-00-00 00:00:00', 0),
(4, '25.2.LR', 'JARDUINO', 'NOT EXISTING YET', NULL, '0000-00-00 00:00:00', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ERRORS`
--

CREATE TABLE IF NOT EXISTS `ERRORS` (
  `ERRORCODE` int(11) NOT NULL AUTO_INCREMENT,
  `ENGLISH` varchar(50) NOT NULL,
  `SPANISH` varchar(50) NOT NULL,
  PRIMARY KEY (`ERRORCODE`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Volcado de datos para la tabla `ERRORS`
--

INSERT INTO `ERRORS` (`ERRORCODE`, `ENGLISH`, `SPANISH`) VALUES
(0, 'SUCCESS', 'CORRECTO'),
(1, 'Insert abort.', 'Inserción abortada.'),
(2, 'Incorrect password.', 'La contraseña es incorrecta.'),
(3, 'This user does not exist.', 'Este usuario no existe.'),
(4, 'Database integrity break.', 'Integridad de la base de datos rota.'),
(5, 'The action or service does not exist.', 'La acción o servicio no esiste.'),
(6, 'This user already exists.', 'Este usuario ya existe.'),
(7, 'This email already has an account associated.', 'Este email ya tiene una cuenta asociada.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HISTORYACCESS`
--

CREATE TABLE IF NOT EXISTS `HISTORYACCESS` (
  `IDHISTORY` int(11) NOT NULL AUTO_INCREMENT,
  `IDUSER` int(11) NOT NULL DEFAULT '0',
  `IDHOUSE` int(11) DEFAULT '0',
  `ACCESSRESULT` int(11) NOT NULL DEFAULT '0',
  `DATESTAMP` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDHISTORY`),
  KEY `IDUSER` (`IDUSER`),
  KEY `IDHOUSE` (`IDHOUSE`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcado de datos para la tabla `HISTORYACCESS`
--

INSERT INTO `HISTORYACCESS` (`IDHISTORY`, `IDUSER`, `IDHOUSE`, `ACCESSRESULT`, `DATESTAMP`) VALUES
(3, 1, NULL, 2, '2014-03-23 12:41:24');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HISTORYACTION`
--

CREATE TABLE IF NOT EXISTS `HISTORYACTION` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDACTION` int(11) NOT NULL,
  `IDPROGRAM` int(11) DEFAULT NULL,
  `IDUSER` int(11) NOT NULL,
  `RETURNCODE` varchar(20) NOT NULL,
  `DATESTAMP` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `IDPROGRAM` (`IDPROGRAM`),
  KEY `IDUSER` (`IDUSER`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `HISTORYACTION`
--

INSERT INTO `HISTORYACTION` (`ID`, `IDACTION`, `IDPROGRAM`, `IDUSER`, `RETURNCODE`, `DATESTAMP`) VALUES
(1, 3, NULL, 10, '0x077', '2014-03-23 15:49:10'),
(2, 2, NULL, 1, '0x0078', '2014-03-23 15:50:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `HOUSES`
--

CREATE TABLE IF NOT EXISTS `HOUSES` (
  `IDHOUSE` int(11) NOT NULL AUTO_INCREMENT,
  `IDUSER` int(11) NOT NULL,
  `HOUSENAME` varchar(10) NOT NULL,
  `IPADRESS` varchar(15) NOT NULL,
  `GPS` varchar(10) DEFAULT NULL,
  `DATEBEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IDHOUSE`),
  UNIQUE KEY `HOUSENAME` (`HOUSENAME`),
  KEY `IDUSER` (`IDUSER`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Volcado de datos para la tabla `HOUSES`
--

INSERT INTO `HOUSES` (`IDHOUSE`, `IDUSER`, `HOUSENAME`, `IPADRESS`, `GPS`, `DATEBEGIN`) VALUES
(1, 1, 'mi casa', '158.107.108.98', '37.6735925', '2014-03-04 05:00:00'),
(2, 11, 'otto', '255.255.255.255', NULL, '2014-03-11 04:00:00'),
(3, 11, 'house', '255.255.255.255', NULL, '2014-03-11 04:00:00'),
(4, 11, 'home', '255.255.255.255', NULL, '2014-03-11 04:00:00'),
(5, 11, 'hause', '255.255.255.255', NULL, '2014-03-11 04:00:00'),
(6, 11, 'shack', '255.255.255.255', NULL, '2014-03-11 04:00:00');

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

--
-- Volcado de datos para la tabla `PERMISSIONS`
--

INSERT INTO `PERMISSIONS` (`IDUSER`, `IDSERVICE`, `LEVELNUMBER`, `DATEBEGIN`) VALUES
(1, 3, 6, NULL),
(10, 1, 4, NULL);

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
  UNIQUE KEY `ROOMNAME` (`ROOMNAME`),
  KEY `IDHOUSE` (`IDHOUSE`),
  KEY `IDUSER` (`IDUSER`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcado de datos para la tabla `ROOMS`
--

INSERT INTO `ROOMS` (`IDROOM`, `IDHOUSE`, `IDUSER`, `ROOMNAME`, `DATEBEGIN`) VALUES
(1, 3, 11, 'SALOON', '2014-03-12 04:00:00'),
(2, 2, 10, 'WC', '2014-03-10 04:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `SERVICES`
--

CREATE TABLE IF NOT EXISTS `SERVICES` (
  `IDSERVICE` int(11) NOT NULL AUTO_INCREMENT,
  `IDROOM` int(11) DEFAULT NULL,
  `IDDEVICE` int(11) DEFAULT NULL,
  `SERVICENAME` varchar(20) NOT NULL,
  `ENGLISH` varchar(50) NOT NULL,
  `SPANISH` varchar(50) NOT NULL,
  PRIMARY KEY (`IDSERVICE`),
  UNIQUE KEY `UNQ_IDROOM_IDDEVICE_SERVICENAME` (`IDROOM`,`IDDEVICE`,`SERVICENAME`),
  KEY `IDDEVICE` (`IDDEVICE`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Volcado de datos para la tabla `SERVICES`
--

INSERT INTO `SERVICES` (`IDSERVICE`, `IDROOM`, `IDDEVICE`, `SERVICENAME`, `ENGLISH`, `SPANISH`) VALUES
(1, 1, 1, 'SALOON', 'DIVERSE', ''),
(2, NULL, NULL, 'TV', 'TV for soccer', ''),
(3, NULL, NULL, 'riego', 'For plant drink.', ''),
(4, NULL, NULL, 'infrarrojo', 'For control all infr', ''),
(5, 1, 4, 'infrarrojos', '', ''),
(6, 1, 1, 'infrarrojos', '', ''),
(9, 2, 4, 'infrarrojos', 'For plant drink.', ''),
(10, NULL, NULL, 'LUCES', 'Control de las luces.', '');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=37 ;

--
-- Volcado de datos para la tabla `USERS`
--

INSERT INTO `USERS` (`IDUSER`, `USERNAME`, `PASSWORD`, `EMAIL`, `HINT`, `JSON`, `DATEBEGIN`) VALUES
(1, 'alex', '534b44a19bf18d20b71ecc4eb77c572f', 'alex@gmail.com', 'what about me?', '{     "Rooms": {         "R1": {             "name": "Livingroom",             "items": [                 "TV",                 "DVD",                 "Stereo",                 "AirConditioning",                 "Lights",                 "Heating"             ]         },         "R2": {             "name": "Kitchen",             "items": [                 "TV",                 "Microhondas",                 "Stereo",                 "AirConditioning",                 "Heating",                 "Lights",                 "Heating"             ]         },         "R3": {             "name": "Garage",             "items": [                 "Stereo",                 "Door",                 "Lights",                 "Heating"             ]         },         "R4": {             "name": "Garden",             "items": [                 "Lights",                 "Video"             ]         }     },     "User": "Colin Tirado" }', '2014-03-11 04:00:00'),
(10, 'luis', '502ff82f7f1f8218dd41201fe4353687', 'luis@gmail.com', 'what about me?', '{\n    "Rooms": {\n        "R1": {\n            "name": "Livingroom",\n            "items": [\n                "TV",\n                "DVD",\n                "Stereo",\n                "AirConditioning",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R2": {\n            "name": "Kitchen",\n            "items": [\n                "TV",\n                "Microhondas",\n                "Stereo",\n                "AirConditioning",\n                "Heating",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R3": {\n            "name": "Garage",\n            "items": [\n                "Stereo",\n                "Door",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R4": {\n            "name": "Garden",\n            "items": [\n                "Lights",\n                "Video"\n            ]\n        }\n    },\n    "User": "Colin Tirado"\n}', '2014-11-13 05:00:00'),
(11, 'alex2', '534b44a19bf18d20b71ecc4eb77c572f', 'alex@hotmail.co', 'what about me?', '{\n    "Rooms": {\n        "R1": {\n            "name": "Livingroom",\n            "items": [\n                "TV",\n                "DVD",\n                "Stereo",\n                "AirConditioning",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R2": {\n            "name": "Kitchen",\n            "items": [\n                "TV",\n                "Microhondas",\n                "Stereo",\n                "AirConditioning",\n                "Heating",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R3": {\n            "name": "Garage",\n            "items": [\n                "Stereo",\n                "Door",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R4": {\n            "name": "Garden",\n            "items": [\n                "Lights",\n                "Video"\n            ]\n        }\n    },\n    "User": "Colin Tirado"\n}', '2014-01-11 05:00:00'),
(12, 'alex3', '534b44a19bf18d20b71ecc4eb77c572f', 'alex@ehc.com', 'what about me?', '{\n    "Rooms": {\n        "R1": {\n            "name": "Livingroom",\n            "items": [\n                "TV",\n                "DVD",\n                "Stereo",\n                "AirConditioning",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R2": {\n            "name": "Kitchen",\n            "items": [\n                "TV",\n                "Microhondas",\n                "Stereo",\n                "AirConditioning",\n                "Heating",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R3": {\n            "name": "Garage",\n            "items": [\n                "Stereo",\n                "Door",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R4": {\n            "name": "Garden",\n            "items": [\n                "Lights",\n                "Video"\n            ]\n        }\n    },\n    "User": "Colin Tirado"\n}', '2014-03-01 05:00:00'),
(28, 'luis2', '502ff82f7f1f8218dd41201fe4353687', 'luis@hotmail.co', 'what about me?', '{\n    "Rooms": {\n        "R1": {\n            "name": "Livingroom",\n            "items": [\n                "TV",\n                "DVD",\n                "Stereo",\n                "AirConditioning",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R2": {\n            "name": "Kitchen",\n            "items": [\n                "TV",\n                "Microhondas",\n                "Stereo",\n                "AirConditioning",\n                "Heating",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R3": {\n            "name": "Garage",\n            "items": [\n                "Stereo",\n                "Door",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R4": {\n            "name": "Garden",\n            "items": [\n                "Lights",\n                "Video"\n            ]\n        }\n    },\n    "User": "Colin Tirado"\n}', '2014-03-03 05:00:00'),
(29, 'bertoldoG', '6e1fd914c4532f9325e4107bd68e32c7', 'bertoldo@gmaiGl', 'thats not fun.G', '{\n    "Rooms": {\n        "R1": {\n            "name": "Livingroom",\n            "items": [\n                "TV",\n                "DVD",\n                "Stereo",\n                "AirConditioning",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R2": {\n            "name": "Kitchen",\n            "items": [\n                "TV",\n                "Microhondas",\n                "Stereo",\n                "AirConditioning",\n                "Heating",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R3": {\n            "name": "Garage",\n            "items": [\n                "Stereo",\n                "Door",\n                "Lights",\n                "Heating"\n            ]\n        },\n        "R4": {\n            "name": "Garden",\n            "items": [\n                "Lights",\n                "Video"\n            ]\n        }\n    },\n    "User": "Colin Tirado"\n}', '0000-00-00 00:00:00');

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ACCESSHOUSE`
--
ALTER TABLE `ACCESSHOUSE`
  ADD CONSTRAINT `ACCESSHOUSE_ibfk_2` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`),
  ADD CONSTRAINT `ACCESSHOUSE_ibfk_1` FOREIGN KEY (`IDHOUSE`) REFERENCES `HOUSES` (`IDHOUSE`);

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
  ADD CONSTRAINT `HISTORYACCESS_ibfk_1` FOREIGN KEY (`IDUSER`) REFERENCES `USERS` (`IDUSER`),
  ADD CONSTRAINT `HISTORYACCESS_ibfk_2` FOREIGN KEY (`IDHOUSE`) REFERENCES `HOUSES` (`IDHOUSE`);

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
