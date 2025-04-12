-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 12, 2025 at 10:31 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `spacestation`
--

-- --------------------------------------------------------

--
-- Table structure for table `astronaut`
--

CREATE TABLE `astronaut` (
  `astronautID` int(11) NOT NULL,
  `name` varchar(90) NOT NULL,
  `healthStatus` enum('Active','Inactive','On Leave') NOT NULL,
  `nationality` varchar(90) NOT NULL,
  `missionID` int(11) DEFAULT NULL,
  `role` enum('Commander','Pilot','Mission Specialist','Flight Engineer','Payload Specialist','Science Officer','Medical Officer','Navigation Officer','Communication Officer','Backup Crew') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `astronautspacecraft`
--

CREATE TABLE `astronautspacecraft` (
  `ID` int(11) NOT NULL,
  `spacecraftID` int(11) DEFAULT NULL,
  `astronautID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `experiment`
--

CREATE TABLE `experiment` (
  `experimentID` int(11) NOT NULL,
  `name` varchar(90) NOT NULL,
  `description` varchar(300) DEFAULT NULL,
  `assignedAstronaut` int(11) DEFAULT NULL,
  `result` enum('success','failed','aborted','on going') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mission`
--

CREATE TABLE `mission` (
  `missionID` int(11) NOT NULL,
  `name` varchar(90) NOT NULL,
  `objective` varchar(120) DEFAULT NULL,
  `launchDate` date DEFAULT NULL,
  `status` enum('on going','completed','aborted','planned') DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `duration` decimal(5,2) GENERATED ALWAYS AS ((to_days(`endDate`) - to_days(`launchDate`)) / 30) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `missionexperiment`
--

CREATE TABLE `missionexperiment` (
  `missionExperimentID` int(11) NOT NULL,
  `experimentID` int(11) DEFAULT NULL,
  `missionID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `resource`
--

CREATE TABLE `resource` (
  `resourceID` int(11) NOT NULL,
  `type` varchar(90) NOT NULL,
  `lastRestockDate` date DEFAULT NULL,
  `quantity` decimal(5,2) NOT NULL,
  `unit` varchar(90) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `resource`
--

INSERT INTO `resource` (`resourceID`, `type`, `lastRestockDate`, `quantity`, `unit`) VALUES
(1, 'oxygen', '2025-04-01', 600.00, 'liters'),
(2, 'food', '2025-04-01', 300.00, 'kg'),
(3, 'power', '2025-04-01', 999.99, 'watt'),
(4, 'water', '2025-04-01', 800.00, 'liters');

-- --------------------------------------------------------

--
-- Table structure for table `spacecraft`
--

CREATE TABLE `spacecraft` (
  `spaceCraftID` int(11) NOT NULL,
  `name` varchar(90) NOT NULL,
  `arrivalDate` date DEFAULT NULL,
  `departureDate` date DEFAULT NULL,
  `status` enum('Completed','Scheduled','In Progress') DEFAULT NULL,
  `oxygen` int(11) NOT NULL,
  `food` int(11) NOT NULL,
  `power` int(11) NOT NULL,
  `water` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `ID` int(11) NOT NULL,
  `resourceID` int(11) DEFAULT NULL,
  `spacecraftID` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT NULL,
  `type` enum('Delivered to Spacecraft','Returned to Storage') DEFAULT NULL,
  `quantity` decimal(10,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `transaction`
--
DELIMITER $$
CREATE TRIGGER `automatic_transaction` AFTER INSERT ON `transaction` FOR EACH ROW BEGIN
  IF NEW.type = 'Delivered to Spacecraft' THEN
    IF NEW.resourceID = 1 THEN -- oxygen
        UPDATE storage SET oxygen = oxygen - NEW.quantity WHERE id = 1;
        UPDATE spacecraft SET oxygen = oxygen + NEW.quantity WHERE id = NEW.spaceCraftID;
    ELSEIF NEW.resourceID = 2 THEN -- food
        UPDATE storage SET food = food - NEW.quantity WHERE id = 1;
        UPDATE spacecraft SET food = food + NEW.quantity WHERE id = NEW.spaceCraftID;
    ELSEIF NEW.resourceID = 3 THEN -- power
        UPDATE storage SET power = power - NEW.quantity WHERE id = 1;
        UPDATE spacecraft SET power = power + NEW.quantity WHERE id = NEW.spaceCraftID;
    ELSEIF NEW.resourceID = 4 THEN -- water
        UPDATE storage SET water = water - NEW.quantity WHERE id = 1;
        UPDATE spacecraft SET water = water + NEW.quantity WHERE id = NEW.spaceCraftID;
    END IF;
    
ELSEIF NEW.type = 'Returned to Storage' THEN
    IF NEW.resourceID = 1 THEN -- oxygen
        UPDATE storage SET oxygen = oxygen + NEW.quantity WHERE id = 1;
        UPDATE spacecraft SET oxygen = oxygen - NEW.quantity WHERE id = NEW.spaceCraftID;
    ELSEIF NEW.resourceID = 2 THEN -- food
        UPDATE storage SET food = food + NEW.quantity WHERE id = 1;
        UPDATE spacecraft SET food = food - NEW.quantity WHERE id = NEW.spaceCraftID;
    ELSEIF NEW.resourceID = 3 THEN -- power
        UPDATE storage SET power = power + NEW.quantity WHERE id = 1;
        UPDATE spacecraft SET power = power - NEW.quantity WHERE id = NEW.spaceCraftID;
    ELSEIF NEW.resourceID = 4 THEN -- water
        UPDATE storage SET water = water + NEW.quantity WHERE id = 1;
        UPDATE spacecraft SET water = water - NEW.quantity WHERE id = NEW.spaceCraftID;
    END IF;
END IF;

END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `astronaut`
--
ALTER TABLE `astronaut`
  ADD PRIMARY KEY (`astronautID`),
  ADD KEY `missionID` (`missionID`);

--
-- Indexes for table `astronautspacecraft`
--
ALTER TABLE `astronautspacecraft`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `spacecraftID` (`spacecraftID`),
  ADD KEY `astronautID` (`astronautID`);

--
-- Indexes for table `experiment`
--
ALTER TABLE `experiment`
  ADD PRIMARY KEY (`experimentID`),
  ADD KEY `assignedAstronaut` (`assignedAstronaut`);

--
-- Indexes for table `mission`
--
ALTER TABLE `mission`
  ADD PRIMARY KEY (`missionID`);

--
-- Indexes for table `missionexperiment`
--
ALTER TABLE `missionexperiment`
  ADD PRIMARY KEY (`missionExperimentID`),
  ADD KEY `experimentID` (`experimentID`),
  ADD KEY `missionID` (`missionID`);

--
-- Indexes for table `resource`
--
ALTER TABLE `resource`
  ADD PRIMARY KEY (`resourceID`);

--
-- Indexes for table `spacecraft`
--
ALTER TABLE `spacecraft`
  ADD PRIMARY KEY (`spaceCraftID`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `astronaut`
--
ALTER TABLE `astronaut`
  MODIFY `astronautID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `astronautspacecraft`
--
ALTER TABLE `astronautspacecraft`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `experiment`
--
ALTER TABLE `experiment`
  MODIFY `experimentID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mission`
--
ALTER TABLE `mission`
  MODIFY `missionID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `missionexperiment`
--
ALTER TABLE `missionexperiment`
  MODIFY `missionExperimentID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `resource`
--
ALTER TABLE `resource`
  MODIFY `resourceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `spacecraft`
--
ALTER TABLE `spacecraft`
  MODIFY `spaceCraftID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `astronaut`
--
ALTER TABLE `astronaut`
  ADD CONSTRAINT `astronaut_ibfk_1` FOREIGN KEY (`missionID`) REFERENCES `mission` (`missionID`);

--
-- Constraints for table `astronautspacecraft`
--
ALTER TABLE `astronautspacecraft`
  ADD CONSTRAINT `astronautspacecraft_ibfk_1` FOREIGN KEY (`spacecraftID`) REFERENCES `spacecraft` (`spaceCraftID`),
  ADD CONSTRAINT `astronautspacecraft_ibfk_2` FOREIGN KEY (`astronautID`) REFERENCES `astronaut` (`astronautID`);

--
-- Constraints for table `experiment`
--
ALTER TABLE `experiment`
  ADD CONSTRAINT `experiment_ibfk_1` FOREIGN KEY (`assignedAstronaut`) REFERENCES `astronaut` (`astronautID`);

--
-- Constraints for table `missionexperiment`
--
ALTER TABLE `missionexperiment`
  ADD CONSTRAINT `missionexperiment_ibfk_1` FOREIGN KEY (`experimentID`) REFERENCES `experiment` (`experimentID`),
  ADD CONSTRAINT `missionexperiment_ibfk_2` FOREIGN KEY (`missionID`) REFERENCES `mission` (`missionID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
