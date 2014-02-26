-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 24-02-2014 a las 21:10:36
-- Versión del servidor: 5.5.35
-- Versión de PHP: 5.3.10-1ubuntu3.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `devPreview`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `items`
--

CREATE TABLE IF NOT EXISTS `items` (
  `idUser` int(11) NOT NULL,
  `idRoom` int(11) NOT NULL,
  `idItem` int(11) NOT NULL,
  `itemName` varchar(60) NOT NULL,
  KEY `FK_Rooms` (`idRoom`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `items`
--

INSERT INTO `items` (`idUser`, `idRoom`, `idItem`, `itemName`) VALUES
(1, 1, 1, 'TV'),
(1, 1, 2, 'Light');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jobs`
--

CREATE TABLE IF NOT EXISTS `jobs` (
  `idJob` int(11) NOT NULL AUTO_INCREMENT,
  `idUser` int(11) NOT NULL,
  `idRoom` int(11) NOT NULL,
  `idItem` int(11) NOT NULL,
  `job` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `dateOfJob` datetime NOT NULL,
  PRIMARY KEY (`idJob`),
  KEY `idJob` (`idJob`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=91 ;

--
-- Volcado de datos para la tabla `jobs`
--

INSERT INTO `jobs` (`idJob`, `idUser`, `idRoom`, `idItem`, `job`, `status`, `dateOfJob`) VALUES
(78, 1, 1, 1, 12, 1, '2013-12-18 12:47:23'),
(79, 1, 1, 1, 1, 1, '2013-12-20 14:13:15'),
(80, 1, 1, 2, 0, 1, '2014-01-19 19:12:57'),
(81, 1, 1, 2, 1, 1, '2014-01-19 19:13:00'),
(82, 1, 1, 2, 0, 1, '2014-01-20 09:51:15'),
(83, 1, 1, 2, 1, 1, '2014-01-20 09:51:16'),
(84, 1, 1, 2, 0, 1, '2014-01-20 10:02:50'),
(85, 1, 1, 2, 1, 1, '2014-01-20 10:02:55'),
(86, 1, 1, 2, 0, 1, '2014-01-22 11:38:14'),
(87, 1, 1, 2, 1, 1, '2014-01-22 11:38:14'),
(88, 1, 1, 1, 6, 1, '2014-01-22 11:38:35'),
(89, 1, 1, 1, 8, 1, '2014-01-22 11:38:35'),
(90, 1, 1, 1, 4, 1, '2014-01-22 11:38:43');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `login`
--

CREATE TABLE IF NOT EXISTS `login` (
  `IdUser` int(6) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` varchar(45) NOT NULL,
  `json` varchar(1000) CHARACTER SET utf8 COLLATE utf8_spanish2_ci NOT NULL,
  `ipArduino` varchar(20) NOT NULL,
  PRIMARY KEY (`IdUser`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=124 ;

--
-- Volcado de datos para la tabla `login`
--

INSERT INTO `login` (`IdUser`, `username`, `password`, `email`, `json`, `ipArduino`) VALUES
(1, 'luis', '502ff82f7f1f8218dd41201fe4353687', 'luis', '', ''),
(2, 'maxi', 'maxi', 'maxi', '{"numerosH":"6", "Habitaciones": {"H1":["Salon",{"items":["TV","DVD","Minicadena","Aire Acondicionad', ''),
(123, 'test', '502ff82f7f1f8218dd41201fe4353687', 'testmail', '{"numerosH":"6","Habitaciones":{"H1":["Salon",{"items":["TV","DVD","Minicadena","Aire Acondicionado","Luces","Calefaccion"]}], "H2":["Cocina",{"items":["TV","Microhondas","Minicadena","Luces","Calefaccion"]}],"H3":["Garage",{"items":["Minicadena","Puerta", "Luces","Calefaccion"]}],"H4":["Bano",{"items":["Luces","Calefaccion"]}],"H5":["Habitacion Kinki",{"items":["TV","Minicadena","Luces","Calefaccion"]}], "H6":["Jardin",{"items":["Luces","Video"]}]}}', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rooms`
--

CREATE TABLE IF NOT EXISTS `rooms` (
  `idUser` int(11) NOT NULL,
  `idRoom` int(11) NOT NULL,
  `roomName` varchar(60) NOT NULL,
  KEY `Rooms` (`idRoom`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `rooms`
--

INSERT INTO `rooms` (`idUser`, `idRoom`, `roomName`) VALUES
(1, 1, 'salon');

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `items_ibfk_1` FOREIGN KEY (`idRoom`) REFERENCES `rooms` (`idRoom`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
