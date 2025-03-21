-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 29, 2024 at 03:40 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12
DROP DATABASE IF EXISTS school_db;
CREATE DATABASE school_db;
USE school_db;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `school_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `parents_contact`
--

CREATE TABLE `parents_contact` (
  `student_id` int(11) UNSIGNED NOT NULL,
  `parent name` text NOT NULL,
  `email` varchar(50) NOT NULL,
  `telephone number` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parents_contact`
--

INSERT INTO `parents_contact` (`student_id`, `parent name`, `email`, `telephone number`) VALUES
(5001, 'Ashley Bennett', 'a.benett@gmail.com', '876-555-5001'),
(5002, 'Abigail Carter', 'a.carter@yahoo.com', '876-555-5002'),
(5003, 'Will Brooks', 'w.brooks@gmail.com', '876-555-5003'),
(5004, 'Alexander Hayes', 'a.hayes@yahoo.com', '876-555-5004'),
(5005, 'Dana Reed\r\n', 'd.reed@gmail.com', '876-555-5005'),
(5006, 'Marvin Cooper\r\n', 'm.cooper@yahoo.com', '876-555-5006'),
(5007, 'Elizabeth Sullivan\r\n', 'e.sullivan@gmail.com', '876-555-5007'),
(5008, 'Natasha Fisher', 'n.fisher@yahoo.com', '876-555-5008'),
(5009, 'Janet Adams\r\n', 'j.adams@yahoo.com', '876-555-5009'),
(5010, 'Karen Parker\r\n', 'k.parker@gmail.com', '876-555-5010'),
(5011, 'Ben Howard\r\n', 'b.howard@yahoo.com', '876-555-5011'),
(5012, 'Natalie Wright\r\n', 'n.wright@gmail.com', '876-555-5012'),
(5013, 'Andre Morgan\r\n', 'a.morgan@yahoo.com', '876-555-5013'),
(5014, 'Samantha Collins\r\n', 's.collins@gmail.com', '876-555-5014'),
(5015, 'Rick Mitchell', 'r.mitchell@yahoo.com', '876-555-5015');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` bigint(11) NOT NULL,
  `name` text NOT NULL,
  `grade` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `name`, `grade`) VALUES
(5001, 'James Bennet', 5),
(5002, 'Michael Carter', 5),
(5003, 'William Brooks', 5),
(5004, 'Alexander Hayes', 5),
(5005, 'Daniel Reed', 5),
(5006, 'Matthew Cooper', 5),
(5007, 'Ethan Sullivan', 5),
(5008, 'Noah Fisher', 5),
(5009, 'Joshua Adams', 5),
(5010, 'Christopher Parker', 5),
(5011, 'Benjamin Howard', 5),
(5012, 'Nathaniel Wright', 5),
(5013, 'Andrew Morgan', 5),
(5014, 'Samuel Collins', 5),
(5015, 'Ryan Mitchell', 5);

-- --------------------------------------------------------

--
-- Table structure for table `student_attendance`
--

CREATE TABLE `student_attendance` (
  `student_id` int(11) NOT NULL,
  `status` enum('present','absent','late') DEFAULT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_attendance`
--

INSERT INTO `student_attendance` (`student_id`, `status`, `date`) VALUES
(5001, 'present', '2024-11-26'),
(5001, 'late', '2024-11-27'),
(5001, 'present', '2024-11-28'),
(5001, 'present', '2024-11-29'),
(5001, 'absent', '2024-11-30'),
(5002, 'present', '2024-11-26'),
(5002, 'present', '2024-11-27'),
(5002, 'present', '2024-11-28'),
(5002, 'present', '2024-11-29'),
(5002, 'absent', '2024-11-30'),
(5003, 'present', '2024-11-26'),
(5003, 'late', '2024-11-27'),
(5003, 'late', '2024-11-28'),
(5003, 'present', '2024-11-29'),
(5003, 'present', '2024-11-30'),
(5004, 'present', '2024-11-26'),
(5004, 'present', '2024-11-27'),
(5004, 'present', '2024-11-28'),
(5004, 'present', '2024-11-29'),
(5004, 'present', '2024-11-30'),
(5005, 'present', '2024-11-26'),
(5005, 'present', '2024-11-27'),
(5005, 'present', '2024-11-28'),
(5005, 'present', '2024-11-29'),
(5005, 'present', '2024-11-30'),
(5006, 'present', '2024-11-26'),
(5006, 'present', '2024-11-27'),
(5006, 'present', '2024-11-28'),
(5006, 'present', '2024-11-29'),
(5006, 'present', '2024-11-30'),
(5007, 'present', '2024-11-26'),
(5007, 'present', '2024-11-27'),
(5007, 'present', '2024-11-28'),
(5007, 'absent', '2024-11-29'),
(5007, 'present', '2024-11-30'),
(5008, 'present', '2024-11-26'),
(5008, 'absent', '2024-11-27'),
(5008, 'absent', '2024-11-28'),
(5008, 'absent', '2024-11-29'),
(5008, 'present', '2024-11-30'),
(5009, 'present', '2024-11-26'),
(5009, 'absent', '2024-11-27'),
(5009, 'absent', '2024-11-28'),
(5009, 'absent', '2024-11-29'),
(5009, 'present', '2024-11-30'),
(5010, 'present', '2024-11-26'),
(5010, 'present', '2024-11-27'),
(5010, 'present', '2024-11-28'),
(5010, 'present', '2024-11-29'),
(5010, 'present', '2024-11-30'),
(5011, 'present', '2024-11-26'),
(5011, 'present', '2024-11-27'),
(5011, 'present', '2024-11-28'),
(5011, 'present', '2024-11-29'),
(5011, 'present', '2024-11-30'),
(5012, 'present', '2024-11-26'),
(5012, 'present', '2024-11-27'),
(5012, 'present', '2024-11-28'),
(5012, 'present', '2024-11-29'),
(5012, 'present', '2024-11-30'),
(5013, 'present', '2024-11-26'),
(5013, 'present', '2024-11-27'),
(5013, 'present', '2024-11-28'),
(5013, 'present', '2024-11-29'),
(5013, 'present', '2024-11-30'),
(5014, 'present', '2024-11-26'),
(5014, 'present', '2024-11-27'),
(5014, 'present', '2024-11-28'),
(5014, 'present', '2024-11-29'),
(5014, 'present', '2024-11-30'),
(5015, 'present', '2024-11-26'),
(5015, 'absent', '2024-11-27'),
(5015, 'absent', '2024-11-28'),
(5015, 'absent', '2024-11-29'),
(5015, 'present', '2024-11-30');

-- --------------------------------------------------------

--
-- Table structure for table `student_audit`
--

CREATE TABLE `student_audit` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `operation` varchar(20) NOT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `changed_by` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_audit`
--

INSERT INTO `student_audit` (`id`, `student_id`, `operation`, `changed_at`,`changed_by`) VALUES
(1, 5001, 'Updated', '2024-11-28 17:27:22','Dean'),
(2, 5002, 'Added', '2024-11-28 17:27:22','Principal'),
(3, 5003, 'Removed', '2024-11-28 17:27:22','Dean');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) UNSIGNED NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`) VALUES
(1, 'principal', 'principal123', 'Principal'),
(2, 'dean', 'dean123', 'Dean'),
(3, 'teacher', 'teacher123', 'Teacher'),
(4, '123', '123', 'Prefect'),
(5, '1234', '1234', 'Security');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `parents_contact`
--
ALTER TABLE `parents_contact`
  ADD PRIMARY KEY (`student_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `student_attendance`
--
ALTER TABLE `student_attendance`
  ADD PRIMARY KEY (`student_id`,`date`);

--
-- Indexes for table `student_audit`
--
ALTER TABLE `student_audit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `school_db_username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `parents_contact`
--
ALTER TABLE `parents_contact`
  MODIFY `student_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5016;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5016;

--
-- AUTO_INCREMENT for table `student_audit`
--
ALTER TABLE `student_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
