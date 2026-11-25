
-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 31, 2025 at 03:49 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_library`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL,
  `adminUsername` varchar(255) DEFAULT NULL,
  `adminPassword` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `adminUsername`, `adminPassword`) VALUES
(1, 'admin', '12345');

-- --------------------------------------------------------

--
-- Stand-in structure for view `authorebook`
-- (See below for the actual view)
--
CREATE TABLE `authorebook` (
`ebook_id` int(11)
,`ebook_tittle` varchar(255)
,`ebook_description` text
,`eGenre` varchar(255)
,`author_id` int(11)
,`author_name` varchar(255)
,`published_date` date
,`ebook_filepath` varchar(255)
,`ebook_cover` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `authorsbook`
-- (See below for the actual view)
--
CREATE TABLE `authorsbook` (
`author_id` int(11)
,`author_name` varchar(255)
,`book_id` int(11)
,`book_name` varchar(255)
,`description` text
,`num_of_page` int(11)
,`genre` varchar(100)
,`quantity` int(11)
,`published_date` date
,`bookpic` varchar(255)
,`filepath` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `borrowedbooks`
-- (See below for the actual view)
--
CREATE TABLE `borrowedbooks` (
`borrowed_num` int(11)
,`student_id` varchar(10)
,`student_name` varchar(302)
,`book_id` int(11)
,`book_name` varchar(255)
,`date_borrowed` date
,`BookpiecesBorrwed` int(11)
,`expected_return_date` date
,`return_date` date
,`B_Status` varchar(10)
,`penalty` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `brwbks`
-- (See below for the actual view)
--
CREATE TABLE `brwbks` (
`borrowed_num` int(11)
,`student_id` varchar(10)
,`student_name` varchar(302)
,`book_id` int(11)
,`bookpic` varchar(255)
,`filepath` varchar(255)
,`book_name` varchar(255)
,`description` text
,`num_of_page` int(11)
,`genre` varchar(100)
,`date_borrowed` date
,`expected_return_date` date
,`BookpiecesBorrwed` int(11)
,`qtyReturned` int(11)
,`return_date` date
,`B_Status` varchar(10)
,`penalty` varchar(255)
);

-- --------------------------------------------------------
if request.method == 'POST':
        try:
            student_id = request.form['student_id']
            book_id = request.form['book_id']
            book_name = request.form['book_name']
            genre = request.form['genre']
            quantity = int(request.form['quantity'])
            quantity_borrowed = int(request.form['qbrw'])
            date_borrowed = request.form['date_borrowed']
            exp_return_date = request.form['Exp_return_date']

            if quantity_borrowed > quantity:
                flash('Cannot borrow more books than available!', 'error')
                return redirect(url_for('userbook'))

            new_quantity = quantity - quantity_borrowed

            cursor = mysql.connection.cursor()
            cursor.execute("""
                INSERT INTO tb_brwbook 
                (student_id, book_id, book_name, genre, quantity_borrowed, date_borrowed, expected_return_date)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (student_id, book_id, book_name, genre, quantity_borrowed, date_borrowed, exp_return_date))

            cursor.execute("UPDATE tb_books SET quantity = %s WHERE book_id = %s", (new_quantity, book_id))
            mysql.connection.commit()
            cursor.close()

            flash('Book borrowed successfully!', 'success')
            return redirect(url_for('userbook'))

        except Exception as e:
            mysql.connection.rollback()
            flash(f'Error borrowing book: {str(e)}', 'error')
            return redirect(url_for('userbook'))

    else:
        book_id = request.args.get('book_id')
        student_id = session.get('student_id')

        # If no book_id is provided, redirect to books.html
        if not book_id:
            return render_template('books.html')

        cursor = mysql.connection.cursor()
        cursor.execute("SELECT book_id, book_name, genre, quantity, bookpic FROM tb_books WHERE book_id = %s", (book_id,))
        book = cursor.fetchone()
        cursor.close()

        if book:
            return render_template('borrow.html',
                                   book_id=book[0],
                                   book_name=book[1],
                                   genre=book[2],
                                   quantity=book[3],
                                   image=book[4],
                                   student_id=student_id)
        else:
            flash("Book not found", 'error')
            return render_template('books.html')

--
-- Stand-in structure for view `brwbook`
-- (See below for the actual view)
--
CREATE TABLE `brwbook` (
`borrowed_num` int(11)
,`student_id` varchar(10)
,`book_id` int(11)
,`book_name` varchar(255)
,`description` text
,`num_of_page` int(11)
,`genre` varchar(100)
,`date_borrowed` date
,`expected_return_date` date
,`BookpiecesBorrwed` int(11)
,`B_Status` varchar(10)
);

-- --------------------------------------------------------

--
-- Table structure for table `lost_book`
--

CREATE TABLE `lost_book` (
  `id` int(11) NOT NULL,
  `book_id` int(11) DEFAULT NULL,
  `student_id` varchar(255) DEFAULT NULL,
  `qtylost` int(11) DEFAULT NULL,
  `lostpenalty` varchar(255) DEFAULT NULL,
  `penaltystats` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lost_book`
--

INSERT INTO `lost_book` (`id`, `book_id`, `student_id`, `qtylost`, `lostpenalty`, `penaltystats`) VALUES
(4, 78, '22-1464', 1, 'Buy new Book', 'DONE'),
(7, 78, '22-0612', 2, 'Buy new Book', 'DONE');

-- --------------------------------------------------------

--
-- Stand-in structure for view `reqstud`
-- (See below for the actual view)
--
CREATE TABLE `reqstud` (
`reqID` int(11)
,`student_id` varchar(255)
,`Name` varchar(302)
,`gender` varchar(6)
,`Course` varchar(100)
,`yearLvl` varchar(10)
,`access` varchar(20)
);

-- --------------------------------------------------------

--
-- Table structure for table `req_ebook`
--

CREATE TABLE `req_ebook` (
  `req_id` int(11) NOT NULL,
  `student_id` varchar(10) DEFAULT NULL,
  `ebook_id` int(11) DEFAULT NULL,
  `req_date` date DEFAULT NULL,
  `response_date` date DEFAULT NULL,
  `exp_date` date DEFAULT NULL,
  `req_status` enum('PENDING','APPROVED','REJECTED','EXPIRED') DEFAULT 'PENDING'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `studlostbk`
-- (See below for the actual view)
--
CREATE TABLE `studlostbk` (
`id` int(11)
,`student_id` varchar(255)
,`Name` varchar(302)
,`book_id` int(11)
,`book_name` varchar(255)
,`qtylost` int(11)
,`lostpenalty` varchar(255)
,`penaltystats` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `studpen`
-- (See below for the actual view)
--
CREATE TABLE `studpen` (
`return_num` int(11)
,`borrowed_num` int(11)
,`student_id` varchar(10)
,`date_borrowed` date
,`expected_return_date` date
,`return_date` date
,`book_id` int(11)
,`book_name` varchar(255)
,`name` varchar(302)
,`penalty` varchar(255)
,`penStats` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `tb_author`
--

CREATE TABLE `tb_author` (
  `author_id` int(11) NOT NULL,
  `author_name` varchar(255) DEFAULT NULL,
  `bday` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `pic` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_author`
--

INSERT INTO `tb_author` (`author_id`, `author_name`, `bday`, `gender`, `pic`) VALUES
(1, 'Mayie Figueroa', '2003-02-04', 'Male', '../uploadedimg/634436.jpg'),
(3, 'jahsna', '2024-12-06', 'Female', '../uploadedimg/55710822.jpg'),
(4, 'bakjhns', '2024-12-06', 'Female', '../uploadedimg/55710822.jpg'),
(5, 'ajbnsa', '2024-12-06', 'Male', '../uploadedimg/55710822.jpg'),
(7, 'Dourein Baricar Canillo', '2024-12-06', 'Male', '../uploadedimg/468751033_8997931086930624_1953127650406114847_n.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `tb_books`
--

CREATE TABLE `tb_books` (
  `book_id` int(11) NOT NULL,
  `book_name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `num_of_page` int(11) DEFAULT NULL,
  `genre` varchar(100) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `bookpic` varchar(255) NOT NULL,
  `filepath` varchar(255) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `published_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_books`
--

INSERT INTO `tb_books` (`book_id`, `book_name`, `description`, `num_of_page`, `genre`, `quantity`, `bookpic`, `filepath`, `author_id`, `published_date`) VALUES
(77, 'test', 'book for testing', 120, 'academic', 39, 'book_cover_test1.png', '../uploadedimg/book_cover_test1.png', 1, '2020-10-13'),
(78, 'test2', 'another book for testing', 110, 'academic', 0, 'DALL·E 2024-10-17 02.14.15 - A book cover titled \'Test 2\'. The design is modern and professional, with a background gradient of soft pastel colors transitioning from light pink to.webp', '../uploadedimg/DALL·E 2024-10-17 02.14.15 - A book cover titled \'Test 2\'. The design is modern and professional, with a background gradient of soft pastel colors transitioning from light pink to.webp', 1, '2017-10-11'),
(80, 'test3', 'testing purposes only', 103, 'academic', 0, 'DALL·E 2024-10-17 02.14.48 - A book cover titled \'Test 3\'. The design is modern with a dark, moody background— a gradient of deep purple fading into black. The title \'Test 3\' is p.webp', '../uploadedimg/DALL·E 2024-10-17 02.14.48 - A book cover titled \'Test 3\'. The design is modern with a dark, moody background— a gradient of deep purple fading into black. The title \'Test 3\' is p.webp', 1, '2016-12-12'),
(89, 'Supra note XX', 'everything about Toyata MK4 Supra', 100, 'Academic', 28, 'uwp4521447.png', '../uploadedimg/uwp4521447.png', 1, '2014-08-01'),
(93, 'Better Than the Movies', 'secret, basaha lang a', 45, 'Discovery', 50, '55710822.jpg', '../uploadedimg/55710822.jpg', 1, '2024-12-05'),
(94, 'test689', 'hoaraaaa', 1023, 'EWGF', 204, 'felynebae.jpg', '../uploadedimg/felynebae.jpg', 7, '2024-12-01'),
(95, 'zinogre lore', 'about zinogre', 1023, 'history', 102, 'zinogre.jpg', '../uploadedimg/zinogre.jpg', 5, '2024-12-06'),
(96, 'The Great Athos', 'the life and adventure of the great Athos', 120, 'Adventure', 97, 'athos.jpg', '../uploadedimg/athos.jpg', 1, '2016-12-13'),
(97, 'test69', 'ahhhhhwah', 1202, 'idk', 10, '469328630_122130657764481791_8646326665475882153_n.jpg', '../uploadedimg/469328630_122130657764481791_8646326665475882153_n.jpg', 1, '2024-12-01'),
(98, 'teostra', 'ah teostraa', 102, 'Discovery', 40, 'teoster.jpg', '../uploadedimg/teoster.jpg', 1, '2024-12-12');

-- --------------------------------------------------------

--
-- Table structure for table `tb_borrowed_books`
--

CREATE TABLE `tb_borrowed_books` (
  `borrowed_num` int(11) NOT NULL,
  `student_id` varchar(10) DEFAULT NULL,
  `book_id` int(11) DEFAULT NULL,
  `date_borrowed` date DEFAULT NULL,
  `expected_return_date` date DEFAULT NULL,
  `BookpiecesBorrwed` int(11) NOT NULL,
  `B_Status` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_borrowed_books`
--

INSERT INTO `tb_borrowed_books` (`borrowed_num`, `student_id`, `book_id`, `date_borrowed`, `expected_return_date`, `BookpiecesBorrwed`, `B_Status`) VALUES
(24, '22-1474', 80, '2024-10-01', '2024-11-06', 8, 'UNRETURN'),
(31, '22-0590', 78, '2024-10-17', '2024-10-24', 5, 'UNRETURN'),
(41, '22-1474', 89, '2024-11-05', '2024-11-10', 2, 'RETURNED'),
(46, '22-1464', 80, '2024-12-06', '2024-12-11', 2, 'RETURNED'),
(47, '22-0619', 77, '2024-12-06', '2024-11-11', 0, 'RETURNED'),
(48, '22-0619', 77, '2024-12-08', '2024-12-04', 0, 'RETURNED'),
(49, '22-0654', 89, '2024-12-09', '2024-12-09', 0, 'RETURNED'),
(53, '22-1474', 78, '2024-12-10', '2024-12-11', 1, 'UNRETURN'),
(55, '22-0612', 78, '2024-12-10', '2024-12-12', 50, 'UNRETURN'),
(56, '22-0612', 96, '2024-12-10', '2024-12-12', 1, 'UNRETURN');

-- --------------------------------------------------------

--
-- Table structure for table `tb_ebooks`
--

CREATE TABLE `tb_ebooks` (
  `ebook_id` int(11) NOT NULL,
  `ebook_tittle` varchar(255) DEFAULT NULL,
  `ebook_description` text DEFAULT NULL,
  `eGenre` varchar(255) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `published_date` date DEFAULT NULL,
  `ebook_filepath` varchar(255) NOT NULL,
  `ebook_cover` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_ebooks`
--

INSERT INTO `tb_ebooks` (`ebook_id`, `ebook_tittle`, `ebook_description`, `eGenre`, `author_id`, `published_date`, `ebook_filepath`, `ebook_cover`) VALUES
(8, 'test1', 'XDDDDD', 'comedy', 1, '2024-12-09', '../ebooks/CC-207_-Unit-6 (1).pdf', '../ebookphoto/6749b9ec8ca56.png'),
(9, 'test2', 'AH', 'Action', 1, NULL, '../ebooks/CC-207_-Unit-6.pdf', '../ebookphoto/6749ba2545828.png'),
(10, 'test3', 'test', 'SCI-FI', 1, NULL, '../ebooks/finalmayjean.drawio.pdf', '../ebookphoto/6749ba6c1776b.png');

-- --------------------------------------------------------

--
-- Table structure for table `tb_reqeb`
--

CREATE TABLE `tb_reqeb` (
  `reqID` int(11) NOT NULL,
  `student_id` varchar(255) DEFAULT NULL,
  `access` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_reqeb`
--

INSERT INTO `tb_reqeb` (`reqID`, `student_id`, `access`) VALUES
(2, '22-1474', 'GRANTED'),
(4, '22-0654', 'GRANTED'),
(5, '22-0612', 'GRANTED');

-- --------------------------------------------------------

--
-- Table structure for table `tb_return`
--

CREATE TABLE `tb_return` (
  `return_num` int(11) NOT NULL,
  `borrowed_num` int(11) DEFAULT NULL,
  `qtyReturned` int(11) NOT NULL,
  `return_date` date DEFAULT NULL,
  `penalty` varchar(255) DEFAULT NULL,
  `penStats` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_return`
--

INSERT INTO `tb_return` (`return_num`, `borrowed_num`, `qtyReturned`, `return_date`, `penalty`, `penStats`) VALUES
(19, 24, 3, '2024-12-10', '2 days community service', 'ONGOING'),
(21, 24, 0, '2024-12-10', '2 days community service', 'ONGOING'),
(22, 55, 3, '2024-12-31', '2 days community service', 'DONE'),
(23, 55, 0, '2024-12-31', '2 days community service', 'ONGOING'),
(24, 55, 0, '2024-12-31', '2 days community service', 'ONGOING'),
(25, 55, 4, '2024-12-11', 'NONE', 'NONE');

-- --------------------------------------------------------

--
-- Table structure for table `tb_student`
--

CREATE TABLE `tb_student` (
  `student_id` varchar(255) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `gender` varchar(6) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `Course` varchar(100) NOT NULL,
  `yearLvl` varchar(10) NOT NULL,
  `Section` varchar(100) NOT NULL,
  `stud_password` varchar(255) NOT NULL,
  `stats` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_student`
--

INSERT INTO `tb_student` (`student_id`, `first_name`, `middle_name`, `last_name`, `gender`, `email`, `Course`, `yearLvl`, `Section`, `stud_password`, `stats`) VALUES
('22-0567', 'melheart', 'gardose', 'lenantud', 'Female', 'melheartlenantud', 'BS Industrial Tech.', '3', 'ft', 'heart', 'DECLINED'),
('22-0590', 'franklin', 'leysa', 'mota', 'Female', 'franklin@gmail.com', 'BS Info. Tech.', '3', 'ST', '1234', 'DECLINED'),
('22-0597', 'Sean Eddric Daniel', 'Latorre', 'Goluyani', 'Male', 'seaneddric5@gmail.com', 'BS Criminology', '1', '3-B', 'Potangapassword123', 'APPROVED'),
('22-0608', 'joerin', 'H', 'Factolerin', 'Male', 'joerin@gmail.com', 'BS Info. Tech.', '1', 'ST', 'joerin', 'APPROVED'),
('22-0612', 'Noe', 'N', 'Sionillo', 'Male', 'noe@gmail.com', 'BS Info. Tech.', '1', 'ST', 'noe123', 'APPROVED'),
('22-0618', 'Jetze', 'S', 'rapista', 'famale', 'jet@gmail.com', 'BS Info. Tech.', '3', 'st', 'jetjet', 'APPROVED'),
('22-0619', 'joyce', 'jh', 'rapista', 'Female', 'jtr@gmail.com', 'BS Info. Tech.', '3', 'ST', 'jtr123', 'APPROVED'),
('22-0654', 'Mark', 'Ramjay', 'Maderse', 'Male', 'mark@gmail.com', 'BS Info. Tech.', '1', 'ST', '12345', 'APPROVED'),
('22-0661', 'Cheryl', 'Latorre', 'Mota', 'Female', 'cheryl@gmail.com', 'BS Info. Tech.', '3', '3-B', '54321', 'APPROVED'),
('22-0666', 'Gina', 'Pangantihon', 'Rapista', 'Female', 'gina@gmail.com', 'BS Info. Tech.', '3', 'ST', '456', 'APPROVED'),
('22-1255', 'Carl Joseph Francis', 'Biaton', 'Convacar', 'Male', 'carl@gmail.com', 'BS Industrial Tech.', '3', '3-FT', 'caloy1126', 'APPROVED'),
('22-1464', 'ML', 'Hebra', 'Patriarca', 'Female', 'MLhebra@gmail.com', 'BS Info. Tech.', '3', 'ST', 'ml123', 'APPROVED'),
('22-1472', 'Rosemarie ', 'Sollorin', 'Gragasin', 'Female', 'rosemariegragasin@gmail.com', 'BS Info. Tech.', '3', '3-NIS', 'Rosemarie', 'APPROVED'),
('22-1474', 'Dourein', 'Baricar', 'Canillo', 'Male', 'DoureinCanillo@gmail.com', 'BS Education', '3', 'ST', 'Dourein12345', 'APPROVED'),
('29-1394', 'testpcclient', 'testpcclient', 'testpcclient', 'Male', 'testpcclient@gmail.com', 'BS Info. Tech.', '1', '1', 'testcient', 'APPROVED'),
('29-1395', 'mayie ', 'buang', 'Gid', 'Male', 'testpcclient1@gmail.com', 'BS Info. Tech.', '1', '1', '123', 'APPROVED'),
('hhdnd', 'hdbs', 'bdbbs', 'bdbsb', 'Male', 'hhsh@gmail.com', 'BS Info. Tech.', '1', 'hdh', 'hdhshs', 'PENDING'),
('L0202477', 'Kashiel Rai', 'Aguaje', 'Pajaroja', 'Male', 'kashielraipajaroja@gmail.com', 'BS Criminology', '1', 'delta', '1234567', 'APPROVED');

-- --------------------------------------------------------

--
-- Structure for view `authorebook`
--
DROP TABLE IF EXISTS `authorebook`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `authorebook`  AS   (select `a`.`ebook_id` AS `ebook_id`,`a`.`ebook_tittle` AS `ebook_tittle`,`a`.`ebook_description` AS `ebook_description`,`a`.`eGenre` AS `eGenre`,`a`.`author_id` AS `author_id`,`b`.`author_name` AS `author_name`,`a`.`published_date` AS `published_date`,`a`.`ebook_filepath` AS `ebook_filepath`,`a`.`ebook_cover` AS `ebook_cover` from (`tb_ebooks` `a` left join `tb_author` `b` on(`a`.`author_id` = `b`.`author_id`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `authorsbook`
--
DROP TABLE IF EXISTS `authorsbook`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `authorsbook`  AS   (select `a`.`author_id` AS `author_id`,`a`.`author_name` AS `author_name`,`b`.`book_id` AS `book_id`,`b`.`book_name` AS `book_name`,`b`.`description` AS `description`,`b`.`num_of_page` AS `num_of_page`,`b`.`genre` AS `genre`,`b`.`quantity` AS `quantity`,`b`.`published_date` AS `published_date`,`b`.`bookpic` AS `bookpic`,`b`.`filepath` AS `filepath` from (`tb_author` `a` join `tb_books` `b` on(`a`.`author_id` = `b`.`author_id`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `borrowedbooks`
--
DROP TABLE IF EXISTS `borrowedbooks`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `borrowedbooks`  AS   (select `a`.`borrowed_num` AS `borrowed_num`,`a`.`student_id` AS `student_id`,concat(`b`.`first_name`,' ',`b`.`middle_name`,' ',`b`.`last_name`) AS `student_name`,`a`.`book_id` AS `book_id`,`c`.`book_name` AS `book_name`,`a`.`date_borrowed` AS `date_borrowed`,`a`.`BookpiecesBorrwed` AS `BookpiecesBorrwed`,`a`.`expected_return_date` AS `expected_return_date`,`d`.`return_date` AS `return_date`,`a`.`B_Status` AS `B_Status`,`d`.`penalty` AS `penalty` from (((`tb_borrowed_books` `a` left join `tb_student` `b` on(`a`.`student_id` = `b`.`student_id`)) left join `tb_books` `c` on(`c`.`book_id` = `a`.`book_id`)) left join `tb_return` `d` on(`d`.`borrowed_num` = `a`.`borrowed_num`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `brwbks`
--
DROP TABLE IF EXISTS `brwbks`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `brwbks`  AS   (select `a`.`borrowed_num` AS `borrowed_num`,`a`.`student_id` AS `student_id`,concat(`b`.`first_name`,' ',`b`.`middle_name`,' ',`b`.`last_name`) AS `student_name`,`a`.`book_id` AS `book_id`,`c`.`bookpic` AS `bookpic`,`c`.`filepath` AS `filepath`,`c`.`book_name` AS `book_name`,`c`.`description` AS `description`,`c`.`num_of_page` AS `num_of_page`,`c`.`genre` AS `genre`,`a`.`date_borrowed` AS `date_borrowed`,`a`.`expected_return_date` AS `expected_return_date`,`a`.`BookpiecesBorrwed` AS `BookpiecesBorrwed`,`d`.`qtyReturned` AS `qtyReturned`,`d`.`return_date` AS `return_date`,`a`.`B_Status` AS `B_Status`,`d`.`penalty` AS `penalty` from (((`tb_borrowed_books` `a` left join `tb_student` `b` on(`a`.`student_id` = `b`.`student_id`)) left join `tb_books` `c` on(`c`.`book_id` = `a`.`book_id`)) left join `tb_return` `d` on(`d`.`borrowed_num` = `a`.`borrowed_num`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `brwbook`
--
DROP TABLE IF EXISTS `brwbook`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `brwbook`  AS   (select `a`.`borrowed_num` AS `borrowed_num`,`a`.`student_id` AS `student_id`,`a`.`book_id` AS `book_id`,`b`.`book_name` AS `book_name`,`b`.`description` AS `description`,`b`.`num_of_page` AS `num_of_page`,`b`.`genre` AS `genre`,`a`.`date_borrowed` AS `date_borrowed`,`a`.`expected_return_date` AS `expected_return_date`,`a`.`BookpiecesBorrwed` AS `BookpiecesBorrwed`,`a`.`B_Status` AS `B_Status` from (`tb_borrowed_books` `a` left join `tb_books` `b` on(`a`.`book_id` = `b`.`book_id`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `reqstud`
--
DROP TABLE IF EXISTS `reqstud`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `reqstud`  AS   (select `a`.`reqID` AS `reqID`,`a`.`student_id` AS `student_id`,concat(`b`.`first_name`,' ',`b`.`middle_name`,' ',`b`.`last_name`) AS `Name`,`b`.`gender` AS `gender`,`b`.`Course` AS `Course`,`b`.`yearLvl` AS `yearLvl`,`a`.`access` AS `access` from (`tb_reqeb` `a` left join `tb_student` `b` on(`a`.`student_id` = `b`.`student_id`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `studlostbk`
--
DROP TABLE IF EXISTS `studlostbk`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `studlostbk`  AS   (select `a`.`id` AS `id`,`a`.`student_id` AS `student_id`,concat(`c`.`first_name`,' ',`c`.`middle_name`,' ',`c`.`last_name`) AS `Name`,`a`.`book_id` AS `book_id`,`b`.`book_name` AS `book_name`,`a`.`qtylost` AS `qtylost`,`a`.`lostpenalty` AS `lostpenalty`,`a`.`penaltystats` AS `penaltystats` from ((`lost_book` `a` left join `tb_books` `b` on(`b`.`book_id` = `a`.`book_id`)) left join `tb_student` `c` on(`a`.`student_id` = `c`.`student_id`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `studpen`
--
DROP TABLE IF EXISTS `studpen`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `studpen`  AS   (select `a`.`return_num` AS `return_num`,`a`.`borrowed_num` AS `borrowed_num`,`b`.`student_id` AS `student_id`,`b`.`date_borrowed` AS `date_borrowed`,`b`.`expected_return_date` AS `expected_return_date`,`a`.`return_date` AS `return_date`,`b`.`book_id` AS `book_id`,`d`.`book_name` AS `book_name`,concat(`c`.`first_name`,' ',`c`.`middle_name`,' ',`c`.`last_name`) AS `name`,`a`.`penalty` AS `penalty`,`a`.`penStats` AS `penStats` from (((`tb_return` `a` left join `tb_borrowed_books` `b` on(`a`.`borrowed_num` = `b`.`borrowed_num`)) left join `tb_student` `c` on(`c`.`student_id` = `b`.`student_id`)) left join `tb_books` `d` on(`d`.`book_id` = `b`.`book_id`)))  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `lost_book`
--
ALTER TABLE `lost_book`
  ADD PRIMARY KEY (`id`),
  ADD KEY `book_id` (`book_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `req_ebook`
--
ALTER TABLE `req_ebook`
  ADD PRIMARY KEY (`req_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `ebook_id` (`ebook_id`);

--
-- Indexes for table `tb_author`
--
ALTER TABLE `tb_author`
  ADD PRIMARY KEY (`author_id`);

--
-- Indexes for table `tb_books`
--
ALTER TABLE `tb_books`
  ADD PRIMARY KEY (`book_id`),
  ADD KEY `fk_author` (`author_id`);

--
-- Indexes for table `tb_borrowed_books`
--
ALTER TABLE `tb_borrowed_books`
  ADD PRIMARY KEY (`borrowed_num`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indexes for table `tb_ebooks`
--
ALTER TABLE `tb_ebooks`
  ADD PRIMARY KEY (`ebook_id`),
  ADD KEY `author_id` (`author_id`);

--
-- Indexes for table `tb_reqeb`
--
ALTER TABLE `tb_reqeb`
  ADD PRIMARY KEY (`reqID`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `tb_return`
--
ALTER TABLE `tb_return`
  ADD PRIMARY KEY (`return_num`),
  ADD KEY `borrowed_num` (`borrowed_num`);

--
-- Indexes for table `tb_student`
--
ALTER TABLE `tb_student`
  ADD PRIMARY KEY (`student_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `lost_book`
--
ALTER TABLE `lost_book`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `req_ebook`
--
ALTER TABLE `req_ebook`
  MODIFY `req_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_author`
--
ALTER TABLE `tb_author`
  MODIFY `author_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tb_books`
--
ALTER TABLE `tb_books`
  MODIFY `book_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT for table `tb_borrowed_books`
--
ALTER TABLE `tb_borrowed_books`
  MODIFY `borrowed_num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `tb_ebooks`
--
ALTER TABLE `tb_ebooks`
  MODIFY `ebook_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tb_reqeb`
--
ALTER TABLE `tb_reqeb`
  MODIFY `reqID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tb_return`
--
ALTER TABLE `tb_return`
  MODIFY `return_num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `lost_book`
--
ALTER TABLE `lost_book`
  ADD CONSTRAINT `lost_book_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `tb_books` (`book_id`),
  ADD CONSTRAINT `lost_book_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `tb_student` (`student_id`);

--
-- Constraints for table `req_ebook`
--
ALTER TABLE `req_ebook`
  ADD CONSTRAINT `req_ebook_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `tb_student` (`student_id`),
  ADD CONSTRAINT `req_ebook_ibfk_2` FOREIGN KEY (`ebook_id`) REFERENCES `tb_ebooks` (`ebook_id`);

--
-- Constraints for table `tb_books`
--
ALTER TABLE `tb_books`
  ADD CONSTRAINT `fk_author` FOREIGN KEY (`author_id`) REFERENCES `tb_author` (`author_id`);

--
-- Constraints for table `tb_borrowed_books`
--
ALTER TABLE `tb_borrowed_books`
  ADD CONSTRAINT `tb_borrowed_books_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `tb_student` (`student_id`),
  ADD CONSTRAINT `tb_borrowed_books_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `tb_books` (`book_id`);

--
-- Constraints for table `tb_ebooks`
--
ALTER TABLE `tb_ebooks`
  ADD CONSTRAINT `tb_ebooks_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `tb_author` (`author_id`);

--
-- Constraints for table `tb_reqeb`
--
ALTER TABLE `tb_reqeb`
  ADD CONSTRAINT `tb_reqeb_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `tb_student` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tb_return`
--
ALTER TABLE `tb_return`
  ADD CONSTRAINT `tb_return_ibfk_1` FOREIGN KEY (`borrowed_num`) REFERENCES `tb_borrowed_books` (`borrowed_num`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
