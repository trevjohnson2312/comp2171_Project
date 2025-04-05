-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 29, 2025 at 03:40 PM
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
  `grade` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `name`, `grade`) VALUES
(5001, 'James Bennet', '5th Form'),
(5002, 'Michael Carter', '5th Form'),
(5003, 'William Brooks', '5th Form'),
(5004, 'Alexander Hayes', '5th Form'),
(5005, 'Daniel Reed', '5th Form'),
(5006, 'Matthew Cooper', '5th Form'),
(5007, 'Ethan Sullivan', '5th Form'),
(5008, 'Noah Fisher', '5th Form'),
(5009, 'Joshua Adams', '5th Form'),
(5010, 'Christopher Parker', '5th Form'),
(5011, 'Benjamin Howard', '5th Form'),
(5012, 'Nathaniel Wright', '5th Form'),
(5013, 'Andrew Morgan', '5th Form'),
(5014, 'Samuel Collins', '5th Form'),
(5015, 'Ryan Mitchell', '5th Form');

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
(5001, 'present', '2025-03-01'),
(5001, 'present', '2025-03-02'),
(5001, 'present', '2025-03-03'),
(5001, 'present', '2025-03-04'),
(5001, 'present', '2025-03-05'),
(5001, 'present', '2025-03-06'),
(5001, 'present', '2025-03-07'),
(5001, 'present', '2025-03-08'),
(5001, 'present', '2025-03-09'),
(5001, 'present', '2025-03-10'),
(5001, 'present', '2025-03-11'),
(5001, 'present', '2025-03-12'),
(5001, 'present', '2025-03-13'),
(5001, 'present', '2025-03-14'),
(5001, 'present', '2025-03-15'),
(5001, 'present', '2025-03-16'),
(5001, 'present', '2025-03-17'),
(5001, 'present', '2025-03-18'),
(5001, 'present', '2025-03-19'),
(5001, 'present', '2025-03-20'),
(5001, 'present', '2025-03-21'),
(5001, 'present', '2025-03-22'),
(5001, 'present', '2025-03-23'),
(5001, 'present', '2025-03-24'),
(5001, 'present', '2025-03-25'),
(5001, 'present', '2025-03-26'),
(5001, 'present', '2025-03-27'),
(5001, 'present', '2025-03-28'),
(5001, 'present', '2025-03-29'),
(5001, 'present', '2025-03-30'),
(5001, 'present', '2025-03-31'),
(5001, 'present', '2025-04-01'),
(5001, 'present', '2025-04-02'),
(5001, 'present', '2025-04-03'),
(5001, 'present', '2025-04-04'),
(5001, 'present', '2025-04-05'),
(5002, 'present', '2025-03-01'),
(5002, 'present', '2025-03-02'),
(5002, 'present', '2025-03-03'),
(5002, 'present', '2025-03-04'),
(5002, 'present', '2025-03-05'),
(5002, 'present', '2025-03-06'),
(5002, 'present', '2025-03-07'),
(5002, 'present', '2025-03-08'),
(5002, 'present', '2025-03-09'),
(5002, 'present', '2025-03-10'),
(5002, 'present', '2025-03-11'),
(5002, 'present', '2025-03-12'),
(5002, 'present', '2025-03-13'),
(5002, 'present', '2025-03-14'),
(5002, 'present', '2025-03-15'),
(5002, 'present', '2025-03-16'),
(5002, 'present', '2025-03-17'),
(5002, 'present', '2025-03-18'),
(5002, 'present', '2025-03-19'),
(5002, 'present', '2025-03-20'),
(5002, 'present', '2025-03-21'),
(5002, 'present', '2025-03-22'),
(5002, 'present', '2025-03-23'),
(5002, 'present', '2025-03-24'),
(5002, 'present', '2025-03-25'),
(5002, 'present', '2025-03-26'),
(5002, 'present', '2025-03-27'),
(5002, 'present', '2025-03-28'),
(5002, 'present', '2025-03-29'),
(5002, 'present', '2025-03-30'),
(5002, 'present', '2025-03-31'),
(5002, 'present', '2025-04-01'),
(5002, 'present', '2025-04-02'),
(5002, 'present', '2025-04-03'),
(5002, 'present', '2025-04-04'),
(5002, 'present', '2025-04-05'),
(5003, 'present', '2025-03-01'),
(5003, 'present', '2025-03-02'),
(5003, 'present', '2025-03-03'),
(5003, 'present', '2025-03-04'),
(5003, 'present', '2025-03-05'),
(5003, 'present', '2025-03-06'),
(5003, 'present', '2025-03-07'),
(5003, 'present', '2025-03-08'),
(5003, 'present', '2025-03-09'),
(5003, 'present', '2025-03-10'),
(5003, 'present', '2025-03-11'),
(5003, 'present', '2025-03-12'),
(5003, 'present', '2025-03-13'),
(5003, 'present', '2025-03-14'),
(5003, 'present', '2025-03-15'),
(5003, 'present', '2025-03-16'),
(5003, 'present', '2025-03-17'),
(5003, 'present', '2025-03-18'),
(5003, 'present', '2025-03-19'),
(5003, 'present', '2025-03-20'),
(5003, 'present', '2025-03-21'),
(5003, 'present', '2025-03-22'),
(5003, 'present', '2025-03-23'),
(5003, 'present', '2025-03-24'),
(5003, 'present', '2025-03-25'),
(5003, 'present', '2025-03-26'),
(5003, 'present', '2025-03-27'),
(5003, 'present', '2025-03-28'),
(5003, 'present', '2025-03-29'),
(5003, 'present', '2025-03-30'),
(5003, 'present', '2025-03-31'),
(5003, 'present', '2025-04-01'),
(5003, 'present', '2025-04-02'),
(5003, 'present', '2025-04-03'),
(5003, 'present', '2025-04-04'),
(5003, 'present', '2025-04-05'),
(5004, 'present', '2025-03-01'),
(5004, 'present', '2025-03-02'),
(5004, 'present', '2025-03-03'),
(5004, 'present', '2025-03-04'),
(5004, 'present', '2025-03-05'),
(5004, 'present', '2025-03-06'),
(5004, 'present', '2025-03-07'),
(5004, 'present', '2025-03-08'),
(5004, 'present', '2025-03-09'),
(5004, 'present', '2025-03-10'),
(5004, 'present', '2025-03-11'),
(5004, 'present', '2025-03-12'),
(5004, 'present', '2025-03-13'),
(5004, 'present', '2025-03-14'),
(5004, 'present', '2025-03-15'),
(5004, 'present', '2025-03-16'),
(5004, 'present', '2025-03-17'),
(5004, 'present', '2025-03-18'),
(5004, 'absent', '2025-03-19'),
(5004, 'present', '2025-03-20'),
(5004, 'present', '2025-03-21'),
(5004, 'present', '2025-03-22'),
(5004, 'present', '2025-03-23'),
(5004, 'absent', '2025-03-24'),
(5004, 'present', '2025-03-25'),
(5004, 'present', '2025-03-26'),
(5004, 'present', '2025-03-27'),
(5004, 'present', '2025-03-28'),
(5004, 'present', '2025-03-29'),
(5004, 'present', '2025-03-30'),
(5004, 'present', '2025-03-31'),
(5004, 'present', '2025-04-01'),
(5004, 'present', '2025-04-02'),
(5004, 'present', '2025-04-03'),
(5004, 'present', '2025-04-04'),
(5004, 'late', '2025-04-05'),
(5005, 'present', '2025-03-01'),
(5005, 'absent', '2025-03-02'),
(5005, 'present', '2025-03-03'),
(5005, 'present', '2025-03-04'),
(5005, 'present', '2025-03-05'),
(5005, 'present', '2025-03-06'),
(5005, 'present', '2025-03-07'),
(5005, 'present', '2025-03-08'),
(5005, 'present', '2025-03-09'),
(5005, 'present', '2025-03-10'),
(5005, 'present', '2025-03-11'),
(5005, 'present', '2025-03-12'),
(5005, 'present', '2025-03-13'),
(5005, 'present', '2025-03-14'),
(5005, 'present', '2025-03-15'),
(5005, 'present', '2025-03-16'),
(5005, 'present', '2025-03-17'),
(5005, 'absent', '2025-03-18'),
(5005, 'present', '2025-03-19'),
(5005, 'present', '2025-03-20'),
(5005, 'present', '2025-03-21'),
(5005, 'absent', '2025-03-22'),
(5005, 'present', '2025-03-23'),
(5005, 'present', '2025-03-24'),
(5005, 'present', '2025-03-25'),
(5005, 'present', '2025-03-26'),
(5005, 'absent', '2025-03-27'),
(5005, 'present', '2025-03-28'),
(5005, 'present', '2025-03-29'),
(5005, 'present', '2025-03-30'),
(5005, 'absent', '2025-03-31'),
(5005, 'present', '2025-04-01'),
(5005, 'absent', '2025-04-02'),
(5005, 'present', '2025-04-03'),
(5005, 'present', '2025-04-04'),
(5005, 'late', '2025-04-05'),
(5006, 'present', '2025-03-01'),
(5006, 'present', '2025-03-02'),
(5006, 'present', '2025-03-03'),
(5006, 'present', '2025-03-04'),
(5006, 'absent', '2025-03-05'),
(5006, 'present', '2025-03-06'),
(5006, 'present', '2025-03-07'),
(5006, 'present', '2025-03-08'),
(5006, 'present', '2025-03-09'),
(5006, 'present', '2025-03-10'),
(5006, 'present', '2025-03-11'),
(5006, 'absent', '2025-03-12'),
(5006, 'present', '2025-03-13'),
(5006, 'present', '2025-03-14'),
(5006, 'present', '2025-03-15'),
(5006, 'present', '2025-03-16'),
(5006, 'absent', '2025-03-17'),
(5006, 'present', '2025-03-18'),
(5006, 'present', '2025-03-19'),
(5006, 'present', '2025-03-20'),
(5006, 'absent', '2025-03-21'),
(5006, 'present', '2025-03-22'),
(5006, 'present', '2025-03-23'),
(5006, 'present', '2025-03-24'),
(5006, 'absent', '2025-03-25'),
(5006, 'present', '2025-03-26'),
(5006, 'present', '2025-03-27'),
(5006, 'present', '2025-03-28'),
(5006, 'present', '2025-03-29'),
(5006, 'present', '2025-03-30'),
(5006, 'present', '2025-03-31'),
(5006, 'present', '2025-04-01'),
(5006, 'present', '2025-04-02'),
(5006, 'present', '2025-04-03'),
(5006, 'present', '2025-04-04'),
(5006, 'absent', '2025-04-05'),
(5007, 'present', '2025-03-01'),
(5007, 'absent', '2025-03-02'),
(5007, 'present', '2025-03-03'),
(5007, 'present', '2025-03-04'),
(5007, 'present', '2025-03-05'),
(5007, 'absent', '2025-03-06'),
(5007, 'present', '2025-03-07'),
(5007, 'present', '2025-03-08'),
(5007, 'present', '2025-03-09'),
(5007, 'present', '2025-03-10'),
(5007, 'present', '2025-03-11'),
(5007, 'absent', '2025-03-12'),
(5007, 'present', '2025-03-13'),
(5007, 'present', '2025-03-14'),
(5007, 'present', '2025-03-15'),
(5007, 'present', '2025-03-16'),
(5007, 'present', '2025-03-17'),
(5007, 'absent', '2025-03-18'),
(5007, 'present', '2025-03-19'),
(5007, 'present', '2025-03-20'),
(5007, 'present', '2025-03-21'),
(5007, 'present', '2025-03-22'),
(5007, 'present', '2025-03-23'),
(5007, 'present', '2025-03-24'),
(5007, 'present', '2025-03-25'),
(5007, 'absent', '2025-03-26'),
(5007, 'present', '2025-03-27'),
(5007, 'present', '2025-03-28'),
(5007, 'present', '2025-03-29'),
(5007, 'present', '2025-03-30'),
(5007, 'present', '2025-03-31'),
(5007, 'present', '2025-04-01'),
(5007, 'absent', '2025-04-02'),
(5007, 'present', '2025-04-03'),
(5007, 'present', '2025-04-04'),
(5007, 'present', '2025-04-05'),
(5008, 'present', '2025-03-01'),
(5008, 'present', '2025-03-02'),
(5008, 'present', '2025-03-03'),
(5008, 'present', '2025-03-04'),
(5008, 'present', '2025-03-05'),
(5008, 'present', '2025-03-06'),
(5008, 'absent', '2025-03-07'),
(5008, 'present', '2025-03-08'),
(5008, 'present', '2025-03-09'),
(5008, 'present', '2025-03-10'),
(5008, 'absent', '2025-03-11'),
(5008, 'present', '2025-03-12'),
(5008, 'present', '2025-03-13'),
(5008, 'absent', '2025-03-14'),
(5008, 'present', '2025-03-15'),
(5008, 'present', '2025-03-16'),
(5008, 'absent', '2025-03-17'),
(5008, 'present', '2025-03-18'),
(5008, 'absent', '2025-03-19'),
(5008, 'present', '2025-03-20'),
(5008, 'present', '2025-03-21'),
(5008, 'present', '2025-03-22'),
(5008, 'present', '2025-03-23'),
(5008, 'present', '2025-03-24'),
(5008, 'present', '2025-03-25'),
(5008, 'present', '2025-03-26'),
(5008, 'present', '2025-03-27'),
(5008, 'present', '2025-03-28'),
(5008, 'present', '2025-03-29'),
(5008, 'present', '2025-03-30'),
(5008, 'present', '2025-03-31'),
(5008, 'present', '2025-04-01'),
(5008, 'present', '2025-04-02'),
(5008, 'present', '2025-04-03'),
(5008, 'present', '2025-04-04'),
(5008, 'present', '2025-04-05'),
(5009, 'present', '2025-03-01'),
(5009, 'present', '2025-03-02'),
(5009, 'present', '2025-03-03'),
(5009, 'present', '2025-03-04'),
(5009, 'present', '2025-03-05'),
(5009, 'present', '2025-03-06'),
(5009, 'present', '2025-03-07'),
(5009, 'present', '2025-03-08'),
(5009, 'present', '2025-03-09'),
(5009, 'present', '2025-03-10'),
(5009, 'present', '2025-03-11'),
(5009, 'present', '2025-03-12'),
(5009, 'present', '2025-03-13'),
(5009, 'present', '2025-03-14'),
(5009, 'present', '2025-03-15'),
(5009, 'present', '2025-03-16'),
(5009, 'present', '2025-03-17'),
(5009, 'present', '2025-03-18'),
(5009, 'present', '2025-03-19'),
(5009, 'present', '2025-03-20'),
(5009, 'present', '2025-03-21'),
(5009, 'present', '2025-03-22'),
(5009, 'present', '2025-03-23'),
(5009, 'present', '2025-03-24'),
(5009, 'present', '2025-03-25'),
(5009, 'present', '2025-03-26'),
(5009, 'present', '2025-03-27'),
(5009, 'present', '2025-03-28'),
(5009, 'present', '2025-03-29'),
(5009, 'present', '2025-03-30'),
(5009, 'present', '2025-03-31'),
(5009, 'present', '2025-04-01'),
(5009, 'present', '2025-04-02'),
(5009, 'present', '2025-04-03'),
(5009, 'present', '2025-04-04'),
(5009, 'present', '2025-04-05'),
(5010, 'present', '2025-03-01'),
(5010, 'present', '2025-03-02'),
(5010, 'present', '2025-03-03'),
(5010, 'present', '2025-03-04'),
(5010, 'present', '2025-03-05'),
(5010, 'present', '2025-03-06'),
(5010, 'present', '2025-03-07'),
(5010, 'present', '2025-03-08'),
(5010, 'present', '2025-03-09'),
(5010, 'present', '2025-03-10'),
(5010, 'present', '2025-03-11'),
(5010, 'present', '2025-03-12'),
(5010, 'present', '2025-03-13'),
(5010, 'present', '2025-03-14'),
(5010, 'present', '2025-03-15'),
(5010, 'present', '2025-03-16'),
(5010, 'present', '2025-03-17'),
(5010, 'present', '2025-03-18'),
(5010, 'present', '2025-03-19'),
(5010, 'present', '2025-03-20'),
(5010, 'present', '2025-03-21'),
(5010, 'present', '2025-03-22'),
(5010, 'present', '2025-03-23'),
(5010, 'present', '2025-03-24'),
(5010, 'present', '2025-03-25'),
(5010, 'present', '2025-03-26'),
(5010, 'present', '2025-03-27'),
(5010, 'present', '2025-03-28'),
(5010, 'present', '2025-03-29'),
(5010, 'present', '2025-03-30'),
(5010, 'present', '2025-03-31'),
(5010, 'present', '2025-04-01'),
(5010, 'present', '2025-04-02'),
(5010, 'present', '2025-04-03'),
(5010, 'present', '2025-04-04'),
(5010, 'present', '2025-04-05'),
(5011, 'present', '2025-03-01'),
(5011, 'present', '2025-03-02'),
(5011, 'present', '2025-03-03'),
(5011, 'present', '2025-03-04'),
(5011, 'present', '2025-03-05'),
(5011, 'present', '2025-03-06'),
(5011, 'present', '2025-03-07'),
(5011, 'present', '2025-03-08'),
(5011, 'present', '2025-03-09'),
(5011, 'present', '2025-03-10'),
(5011, 'present', '2025-03-11'),
(5011, 'present', '2025-03-12'),
(5011, 'present', '2025-03-13'),
(5011, 'present', '2025-03-14'),
(5011, 'present', '2025-03-15'),
(5011, 'present', '2025-03-16'),
(5011, 'present', '2025-03-17'),
(5011, 'present', '2025-03-18'),
(5011, 'present', '2025-03-19'),
(5011, 'present', '2025-03-20'),
(5011, 'present', '2025-03-21'),
(5011, 'present', '2025-03-22'),
(5011, 'present', '2025-03-23'),
(5011, 'present', '2025-03-24'),
(5011, 'present', '2025-03-25'),
(5011, 'present', '2025-03-26'),
(5011, 'present', '2025-03-27'),
(5011, 'present', '2025-03-28'),
(5011, 'present', '2025-03-29'),
(5011, 'present', '2025-03-30'),
(5011, 'present', '2025-03-31'),
(5011, 'present', '2025-04-01'),
(5011, 'present', '2025-04-02'),
(5011, 'present', '2025-04-03'),
(5011, 'present', '2025-04-04'),
(5011, 'present', '2025-04-05'),
(5012, 'present', '2025-03-01'),
(5012, 'present', '2025-03-02'),
(5012, 'present', '2025-03-03'),
(5012, 'present', '2025-03-04'),
(5012, 'present', '2025-03-05'),
(5012, 'present', '2025-03-06'),
(5012, 'present', '2025-03-07'),
(5012, 'present', '2025-03-08'),
(5012, 'present', '2025-03-09'),
(5012, 'present', '2025-03-10'),
(5012, 'present', '2025-03-11'),
(5012, 'present', '2025-03-12'),
(5012, 'present', '2025-03-13'),
(5012, 'present', '2025-03-14'),
(5012, 'present', '2025-03-15'),
(5012, 'present', '2025-03-16'),
(5012, 'present', '2025-03-17'),
(5012, 'present', '2025-03-18'),
(5012, 'present', '2025-03-19'),
(5012, 'present', '2025-03-20'),
(5012, 'present', '2025-03-21'),
(5012, 'present', '2025-03-22'),
(5012, 'present', '2025-03-23'),
(5012, 'present', '2025-03-24'),
(5012, 'present', '2025-03-25'),
(5012, 'present', '2025-03-26'),
(5012, 'present', '2025-03-27'),
(5012, 'present', '2025-03-28'),
(5012, 'present', '2025-03-29'),
(5012, 'present', '2025-03-30'),
(5012, 'present', '2025-03-31'),
(5012, 'present', '2025-04-01'),
(5012, 'present', '2025-04-02'),
(5012, 'present', '2025-04-03'),
(5012, 'present', '2025-04-04'),
(5012, 'present', '2025-04-05'),
(5013, 'present', '2025-03-01'),
(5013, 'present', '2025-03-02'),
(5013, 'present', '2025-03-03'),
(5013, 'present', '2025-03-04'),
(5013, 'present', '2025-03-05'),
(5013, 'present', '2025-03-06'),
(5013, 'present', '2025-03-07'),
(5013, 'present', '2025-03-08'),
(5013, 'present', '2025-03-09'),
(5013, 'present', '2025-03-10'),
(5013, 'present', '2025-03-11'),
(5013, 'present', '2025-03-12'),
(5013, 'present', '2025-03-13'),
(5013, 'present', '2025-03-14'),
(5013, 'present', '2025-03-15'),
(5013, 'present', '2025-03-16'),
(5013, 'present', '2025-03-17'),
(5013, 'present', '2025-03-18'),
(5013, 'present', '2025-03-19'),
(5013, 'present', '2025-03-20'),
(5013, 'present', '2025-03-21'),
(5013, 'present', '2025-03-22'),
(5013, 'present', '2025-03-23'),
(5013, 'present', '2025-03-24'),
(5013, 'present', '2025-03-25'),
(5013, 'present', '2025-03-26'),
(5013, 'present', '2025-03-27'),
(5013, 'present', '2025-03-28'),
(5013, 'present', '2025-03-29'),
(5013, 'present', '2025-03-30'),
(5013, 'present', '2025-03-31'),
(5013, 'present', '2025-04-01'),
(5013, 'present', '2025-04-02'),
(5013, 'present', '2025-04-03'),
(5013, 'present', '2025-04-04'),
(5013, 'present', '2025-04-05'),
(5014, 'present', '2025-03-01'),
(5014, 'present', '2025-03-02'),
(5014, 'present', '2025-03-03'),
(5014, 'present', '2025-03-04'),
(5014, 'present', '2025-03-05'),
(5014, 'present', '2025-03-06'),
(5014, 'present', '2025-03-07'),
(5014, 'present', '2025-03-08'),
(5014, 'present', '2025-03-09'),
(5014, 'present', '2025-03-10'),
(5014, 'present', '2025-03-11'),
(5014, 'present', '2025-03-12'),
(5014, 'present', '2025-03-13'),
(5014, 'present', '2025-03-14'),
(5014, 'present', '2025-03-15'),
(5014, 'present', '2025-03-16'),
(5014, 'present', '2025-03-17'),
(5014, 'present', '2025-03-18'),
(5014, 'present', '2025-03-19'),
(5014, 'present', '2025-03-20'),
(5014, 'present', '2025-03-21'),
(5014, 'present', '2025-03-22'),
(5014, 'present', '2025-03-23'),
(5014, 'present', '2025-03-24'),
(5014, 'present', '2025-03-25'),
(5014, 'present', '2025-03-26'),
(5014, 'present', '2025-03-27'),
(5014, 'present', '2025-03-28'),
(5014, 'present', '2025-03-29'),
(5014, 'present', '2025-03-30'),
(5014, 'present', '2025-03-31'),
(5014, 'present', '2025-04-01'),
(5014, 'present', '2025-04-02'),
(5014, 'present', '2025-04-03'),
(5014, 'present', '2025-04-04'),
(5014, 'present', '2025-04-05'),
(5015, 'present', '2025-03-01'),
(5015, 'present', '2025-03-02'),
(5015, 'present', '2025-03-03'),
(5015, 'present', '2025-03-04'),
(5015, 'present', '2025-03-05'),
(5015, 'present', '2025-03-06'),
(5015, 'present', '2025-03-07'),
(5015, 'present', '2025-03-08'),
(5015, 'present', '2025-03-09'),
(5015, 'present', '2025-03-10'),
(5015, 'present', '2025-03-11'),
(5015, 'present', '2025-03-12'),
(5015, 'present', '2025-03-13'),
(5015, 'present', '2025-03-14'),
(5015, 'present', '2025-03-15'),
(5015, 'present', '2025-03-16'),
(5015, 'present', '2025-03-17'),
(5015, 'present', '2025-03-18'),
(5015, 'present', '2025-03-19'),
(5015, 'present', '2025-03-20'),
(5015, 'present', '2025-03-21'),
(5015, 'present', '2025-03-22'),
(5015, 'present', '2025-03-23'),
(5015, 'present', '2025-03-24'),
(5015, 'present', '2025-03-25'),
(5015, 'present', '2025-03-26'),
(5015, 'present', '2025-03-27'),
(5015, 'present', '2025-03-28'),
(5015, 'present', '2025-03-29'),
(5015, 'present', '2025-03-30'),
(5015, 'present', '2025-03-31'),
(5015, 'present', '2025-04-01'),
(5015, 'present', '2025-04-02'),
(5015, 'present', '2025-04-03'),
(5015, 'present', '2025-04-04'),
(5015, 'present', '2025-04-05');


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
(01, 'principal', 'principal123', 'Principal'),
(02, 'dean', 'dean123', 'Dean'),
(03, 'teacher1', 'teacher123', 'Teacher'),
(04, 'teacher2', 'teacher123', 'Teacher'),
(05, 'teacher3', 'teacher123', 'Teacher'),
(06, '123', '123', 'Prefect'),
(07, '1234', '1234', 'Security');

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
