-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 12, 2025 at 05:23 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `space station`
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

--
-- Dumping data for table `astronaut`
--

INSERT INTO `astronaut` (`astronautID`, `name`, `healthStatus`, `nationality`, `missionID`, `role`) VALUES
(1, 'Alice Vega', 'Active', 'USA', 1, 'Commander'),
(2, 'Bao Zhang', 'Active', 'China', 2, 'Pilot'),
(3, 'Carlos Díaz', 'On Leave', 'Mexico', 3, 'Science Officer'),
(4, 'Daria Ivanova', 'Active', 'Russia', 4, 'Mission Specialist'),
(5, 'Elena Petrova', 'Inactive', 'Russia', 5, 'Flight Engineer'),
(6, 'Faisal Khan', 'Active', 'UAE', 6, 'Medical Officer'),
(7, 'Grace Kim', 'On Leave', 'South Korea', 7, 'Payload Specialist'),
(8, 'Hans Müller', 'Active', 'Germany', 8, 'Backup Crew'),
(9, 'Isabella Rossi', 'Active', 'Italy', 9, 'Navigation Officer'),
(10, 'James Carter', 'Active', 'Canada', 10, 'Communication Officer');

-- --------------------------------------------------------

--
-- Table structure for table `astronautspacecraft`
--

CREATE TABLE `astronautspacecraft` (
  `ID` int(11) NOT NULL,
  `spacecraftID` int(11) NOT NULL,
  `astronautID` int(11) NOT NULL
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
  `result` enum('success','failed','aborted','on going') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `experiment`
--

INSERT INTO `experiment` (`experimentID`, `name`, `description`, `assignedAstronaut`, `result`) VALUES
(1, 'Photosynthesis in Microgravity', 'Studying plant growth without gravity.', 1, 'success'),
(2, 'Bone Density Analysis', 'Tracking bone loss in zero-G.', 2, 'on going'),
(3, 'Radiation Exposure', 'Measuring radiation inside spacecraft.', 3, 'success'),
(4, 'Fluid Dynamics', 'Observing water movement in microgravity.', 4, 'failed'),
(5, 'Combustion Study', 'Testing fire behavior.', 5, 'on going'),
(6, 'Muscle Atrophy', 'Monitoring astronaut muscle health.', 6, 'aborted'),
(7, 'Bacteria Mutation', 'Examining bacteria resistance.', 7, 'on going'),
(8, 'Crop Growth', 'Testing lettuce in space farms.', 8, 'success'),
(9, 'Oxygen Recycling', 'Testing onboard O2 systems.', 9, 'on going'),
(10, 'VR in Isolation', 'Studying VR effects in space.', 10, 'success');

-- --------------------------------------------------------

--
-- Table structure for table `mission`
--

CREATE TABLE `mission` (
  `missionID` int(11) NOT NULL,
  `name` varchar(90) NOT NULL,
  `objective` varchar(120) DEFAULT NULL,
  `launchDate` date DEFAULT NULL,
  `status` enum('on going','completed','aborted','planned') NOT NULL,
  `endDate` date DEFAULT NULL,
  `duration` decimal(5,2) GENERATED ALWAYS AS ((to_days(`endDate`) - to_days(`launchDate`)) / 30) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mission`
--

INSERT INTO `mission` (`missionID`, `name`, `objective`, `launchDate`, `status`, `endDate`) VALUES
(1, 'Lunar Explorer', 'Study moon soil composition', '2025-01-15', 'completed', '2025-02-14'),
(2, 'Mars Pioneer', 'Establish Mars base', '2025-03-10', 'on going', NULL),
(3, 'Orbital Surveyor', 'Map asteroid belt', '2024-11-01', 'completed', '2024-12-10'),
(4, 'Deep Space Probe', 'Test long-range systems', '2025-04-01', 'planned', NULL),
(5, 'ISS Resupply', 'Deliver resources', '2025-02-20', 'completed', '2025-03-01'),
(6, 'Solar Study', 'Analyze solar flares', '2025-01-01', 'completed', '2025-01-25'),
(7, 'Gravity Test', 'Microgravity effects on bone', '2025-04-01', 'on going', NULL),
(8, 'Atmospheric Sampling', 'Sample upper atmosphere', '2025-03-05', 'aborted', '2025-03-06'),
(9, 'Space Farming', 'Grow crops in orbit', '2025-01-10', 'completed', '2025-03-10'),
(10, 'Moon Relay', 'Deploy communication satellites', '2025-02-10', 'completed', '2025-02-28');

-- --------------------------------------------------------

--
-- Table structure for table `missionexperiment`
--

CREATE TABLE `missionexperiment` (
  `missionExperimentID` int(11) NOT NULL,
  `experimentID` int(11) NOT NULL,
  `missionID` int(11) NOT NULL
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
(1, 'oxygen', '2025-04-01', 430.00, 'liters'),
(2, 'food', '2025-04-01', 165.00, 'kg'),
(3, 'power', '2025-04-01', 849.99, 'watt'),
(4, 'water', '2025-04-01', 680.00, 'liters');

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
  `oxygen` int(11) NOT NULL DEFAULT 0,
  `food` int(11) NOT NULL DEFAULT 0,
  `power` int(11) NOT NULL DEFAULT 0,
  `water` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `spacecraft`
--

INSERT INTO `spacecraft` (`spaceCraftID`, `name`, `arrivalDate`, `departureDate`, `status`, `oxygen`, `food`, `power`, `water`) VALUES
(1, 'Orion', '2025-03-01', '2025-03-15', 'Completed', 180, 145, 350, 270),
(2, 'Endeavour', '2025-03-10', '2025-03-20', 'Completed', 180, 140, 180, 130),
(3, 'Discovery', '2025-04-01', NULL, 'In Progress', 60, 50, 120, 110),
(4, 'Atlantis', '2025-04-05', NULL, 'In Progress', 70, 60, 140, 120),
(5, 'Challenger', '2025-04-10', '2025-04-25', 'Completed', 80, 65, 160, 140),
(6, 'Columbia', '2025-04-12', NULL, 'Scheduled', 0, 0, 0, 0),
(7, 'Starliner', '2025-04-15', NULL, 'Scheduled', 0, 0, 0, 0),
(8, 'Crew Dragon', '2025-04-18', NULL, 'Scheduled', 0, 0, 0, 0),
(9, 'New Shepard', '2025-04-20', NULL, 'Scheduled', 0, 0, 0, 0),
(10, 'Dream Chaser', '2025-04-22', NULL, 'Scheduled', 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `ID` int(11) NOT NULL,
  `resourceID` int(11) NOT NULL,
  `spacecraftID` int(11) NOT NULL,
  `date` timestamp NULL DEFAULT NULL,
  `type` enum('Delivered to Spacecraft','Returned to Storage') NOT NULL,
  `quantity` decimal(10,0) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`ID`, `resourceID`, `spacecraftID`, `date`, `type`, `quantity`) VALUES
(1, 1, 1, '2025-04-01 05:00:00', 'Delivered to Spacecraft', 100),
(2, 2, 1, '2025-04-01 05:05:00', 'Delivered to Spacecraft', 80),
(3, 3, 1, '2025-04-01 05:10:00', 'Delivered to Spacecraft', 200),
(4, 4, 1, '2025-04-01 05:15:00', 'Delivered to Spacecraft', 150),
(5, 1, 2, '2025-04-02 06:00:00', 'Delivered to Spacecraft', 90),
(6, 2, 2, '2025-04-02 06:05:00', 'Delivered to Spacecraft', 70),
(7, 1, 1, '2025-04-05 07:00:00', 'Returned to Storage', 20),
(8, 2, 1, '2025-04-05 07:05:00', 'Returned to Storage', 15),
(9, 3, 1, '2025-04-05 07:10:00', 'Returned to Storage', 50),
(10, 4, 1, '2025-04-05 07:15:00', 'Returned to Storage', 30);

--
-- Triggers `transaction`
--
DELIMITER $$
CREATE TRIGGER `automatic_transaction` AFTER INSERT ON `transaction` FOR EACH ROW BEGIN
  IF NEW.type = 'Delivered to Spacecraft' THEN
    IF NEW.resourceID = 1 THEN -- oxygen
        UPDATE resource SET quantity = quantity  - NEW.quantity WHERE resourceID = 1;
        UPDATE spacecraft SET oxygen = oxygen + NEW.quantity WHERE spaceCraftID = NEW.spaceCraftID;
   
   ELSEIF NEW.resourceID = 2 THEN -- food
        UPDATE resource SET quantity = quantity - NEW.quantity WHERE resourceID = 2;
        UPDATE spacecraft SET food = food + NEW.quantity WHERE spaceCraftID = NEW.spaceCraftID;
    
    ELSEIF NEW.resourceID = 3 THEN -- power
        UPDATE resource SET quantity = quantity - NEW.quantity WHERE resourceID = 3;
        UPDATE spacecraft SET power = power + NEW.quantity WHERE spaceCraftID = NEW.spaceCraftID;
   
   ELSEIF NEW.resourceID = 4 THEN -- water
        UPDATE resource SET quantity = quantity - NEW.quantity WHERE resourceID = 4;
        UPDATE spacecraft SET water = water + NEW.quantity WHERE spaceCraftID = NEW.spaceCraftID;
    END IF;
    
ELSEIF NEW.type = 'Returned to Storage' THEN
    IF NEW.resourceID = 1 THEN -- oxygen
        UPDATE resource SET quantity = quantity + NEW.quantity WHERE resourceID = 1;
        UPDATE spacecraft SET oxygen = oxygen - NEW.quantity WHERE spaceCraftID = NEW.spaceCraftID;
    ELSEIF NEW.resourceID = 2 THEN -- food
        UPDATE resource SET quantity = quantity + NEW.quantity WHERE resourceID = 2;
        UPDATE spacecraft SET food = food - NEW.quantity WHERE spaceCraftID = NEW.spaceCraftID;
    ELSEIF NEW.resourceID = 3 THEN -- power
        UPDATE resource SET quantity = quantity + NEW.quantity WHERE resourceID = 3;
        UPDATE spacecraft SET power = power - NEW.quantity WHERE spaceCraftID = NEW.spaceCraftID;
    ELSEIF NEW.resourceID = 4 THEN -- water
        UPDATE resource SET quantity = quantity + NEW.quantity WHERE resourceID = 4;
        UPDATE spacecraft SET water = water - NEW.quantity WHERE spaceCraftID = NEW.spaceCraftID;
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
  MODIFY `astronautID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `astronautspacecraft`
--
ALTER TABLE `astronautspacecraft`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `experiment`
--
ALTER TABLE `experiment`
  MODIFY `experimentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `mission`
--
ALTER TABLE `mission`
  MODIFY `missionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
  MODIFY `spaceCraftID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
