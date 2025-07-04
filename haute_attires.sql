-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 04, 2025 at 05:31 PM
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
-- Database: `haute_attires`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins_table`
--

CREATE TABLE `admins_table` (
  `admin_id` int(11) NOT NULL,
  `admin_name` varchar(50) NOT NULL,
  `admin_email` varchar(50) NOT NULL,
  `admin_password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins_table`
--

INSERT INTO `admins_table` (`admin_id`, `admin_name`, `admin_email`, `admin_password`) VALUES
(1, 'Admin', 'admin@gmail.com', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `cancel_table`
--

CREATE TABLE `cancel_table` (
  `cancel_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `cancel_by` text NOT NULL,
  `reason` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart_table`
--

CREATE TABLE `cart_table` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `color` varchar(100) NOT NULL,
  `size` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `favorite_table`
--

CREATE TABLE `favorite_table` (
  `favorite_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `items_table`
--

CREATE TABLE `items_table` (
  `item_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `rating` double NOT NULL,
  `tags` varchar(100) NOT NULL,
  `price` double NOT NULL,
  `sizes` varchar(100) NOT NULL,
  `colors` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `image` text NOT NULL,
  `categories` text NOT NULL,
  `offer` double NOT NULL,
  `actualprice` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `items_table`
--

INSERT INTO `items_table` (`item_id`, `name`, `rating`, `tags`, `price`, `sizes`, `colors`, `description`, `image`, `categories`, `offer`, `actualprice`) VALUES
(82, 'Allen Solly Mens Regular Fit T-Shirt', 4, 'men, mens, tshirt, fit, printed', 535.33, 'S, M, L, XL, XXL', 'Yellow, Pink, Red, Black', 'Allen Solly an initiative of Madura Fashion & Lifestyle, a division of Aditya Birla Fashion and Lifestyle is Indias largest and fastest growing branded apparel companies and a premium lifestyle player in the retail sector.', 'image1.png', 'Man, T-shirt', 33, 799),
(83, 'BLECKZ SOMEAK Baby Boys Cotton and Spandex Printed Half Sleeves Applique Bow Solid Romper', 3.6, 'kids, dresses', 549.45, '0- 6M, 6M - 1Y, 2Y', 'Pink, White, Blue, Yellow', 'Crafted from 100% cotton for supreme softness and breathability. A bow to and some graphics to enhance your little boys look. Available in a variety of sizes', 'image2.png', 'Kids', 45, 999),
(84, 'TAGAS Mens Regular Jeans', 4.6, 'mens, jeans, denim, quality', 1079.28, '30, 32, 34, 36', 'Blue, Black', 'Jeans Made From Denim Fabric with Slant pocket Carrot jeans Suiatable for Daily Casual Wear as well as Travelling and All occasion.', 'image3.png', 'Man, Jeans', 28, 1499),
(85, 'SIRIL Womens Bandhani Printed & Embroidery Work In Lace Georgette Saree with Unstitched Blouse Piece', 3.7, 'women, saree, fashion, trend', 1966.77, 'Free Size', 'Cyan, Pink, Purple', 'Georgette Bandhani Printed Saree Collection. Product Dimensions: ‎ 35 x 32 x 3.5 cm; 610 g', 'image4.png', 'Women, Saree', 61, 5043),
(86, 'CB-COLEBROOK Mens Regular Fit Solid Soft Touch Cotton Casual Shirt with Pocket Design with Spread Collar & Full Sleeves', 3.9, 'Man, Men, FormalShirt, shirt, style', 1442.22, 'S, M, L, XL, XXL', 'Grey, Black, White', 'This shirt for men is one of the top selling product from premium quality casual shirts collection exclusively manufactured by CB-COLEBROOK brand.', 'image5.png', 'Man, Shirts', 22, 1849),
(87, 'Leather Retail Coffee-Colored Suede Jacket For Mens', 4.1, 'Mens, Jacket, jacket', 1432.25, 'XS, S, M, L, XL', 'Brown', 'A leather jacket is like a best friend: its always there for you when you need it. A leather jacket is the ultimate fashion statement.', 'image6.png', 'Man, Jackets', 15, 1685),
(88, 'KOTTY Men Denim Full Sleeve Regular Winter Jacket', 4.4, 'mens, Mens, jacket, Jacket', 2399.2, 'S, M, L, XL, XXL', 'Blue, Black', 'Give a trendy start to the winters with this Jacket from the house of KOTTY. This Jacket will give you warmth and comfort and Two side Pockets.', 'image7.png', 'Man, Jackets', 20, 2999),
(89, 'ARIEL Cotton Clothing Sets for Baby Boys & girls - Unisex Clothing sets Full Sleeve T-shirt & Pan', 4.5, 'kids', 486.75, '0-6 M, 6-18 M, 18-48 M', 'Red, Grey, Yellow', 'For Your Babys Comfort', 'image8.png', 'Kids', 25, 649),
(90, 'GRECIILOOKS Shirt for Women | Women Shirt | Long Shirt for Women | Shirt Tops for Women | Oversized Shirt for Women', 4.7, 'women, shirt', 1379.4, 'S, M, L, XL', 'Beige, Orange, White', 'Elevate your wardrobe with our Women Classic Cotton Shirt, a versatile and timeless piece perfect for any occasion.', 'image9.png', 'Women, Shirts', 40, 2299),
(91, 'ICW Women Korean Retro Style Vintage Floral Jacquard Lace-Up Off-The-shoulder Smock Puff Sleeve Ruffled Crop Blouse Corset Top Dn81', 4.8, 'women, tops', 780, 'XS, S, M, L', 'Grey, White, Black', 'The off-the-shoulder design adds a flirtatious touch, while the loose fit ensures ultimate comfort. Perfect for warm weather, this blouse is lightweight and airy, allowing your skin to breathe. Pair it with your favourite jeans or skirt for a chic and effortless look.', 'image10.png', 'Women, Tops', 22, 1000),
(92, 'madfrog Men Solid Round Neck Polyester Blend Waffle Knit Down Shoulder Oversized T-Shirt for Mens', 4.8, 'mens, tshirt', 649.35, 'M, L, XL, XXL', 'Beige, White, Olive', 'Oversized Fit: Designed with an oversized silhouette for a relaxed, contemporary look.', 'image11.png', 'Man, T-shirt', 35, 999),
(93, 'Kuchipoo Boys Full Sleeves Regular Fit Cotton T-Shirt', 4.9, 'kids', 1119.3, '2-3 Y, 3-5 Y, 5-7 Y', 'White, Red, Blue', 'Comfortable cotton tshirt for baby', 'image12.png', 'Kids', 30, 1599),
(94, 'Monjolika Fashion Womens Banarasi Silk Blend Woven Zari With Tussles Saree', 4.9, 'women, saree', 5599.2, 'Free Size', 'Magenta, Mustard, Red', 'Look stylish by wearing Our Sarees and revel in the comfort of the blended fabric. This Sarees will surely fetch you compliments for your rich sense of style.', 'image13.png', 'Women, Saree', 20, 6999),
(95, 'Ben Martin Jeans for Women || Bootcut Jeans for Women || Wide Leg Jeans Women || Bell Bottom Jeans for Women', 4.7, 'women, jeans', 1799.4, '28, 30, 32, 34', 'Blue, Black', 'Experience fashion redefined with Ben Martin Clothing. Make every outfit a statement!', 'image14.png', 'Women, Jeans', 40, 2999),
(96, 'Niren Enterprise Adorable Floral Girls Dress with Heart-Shaped Purse', 4.4, 'kids', 1099.45, '1-3 Y, 3-5 Y', 'Yellow, Maroon, Purple', 'The dress itself is crafted from a high-quality, breathable cotton blend, ensuring both comfort and long-lasting wear during all her summer adventures.', 'image15.png', 'Kids', 45, 1999),
(97, 'Pinkmint Popcorn Shirt for Men Soild Slim Fit Sleeve Spread Collar Trendy Men Shirt Summer Wear Goa Wear Olive', 4.8, 'men, shirt', 1199.4, 'S, M, L, XL', 'Mint Green, Aqua Blue, Beige, Black', 'Perfect for casual outings, movie nights, or hanging out with friends', 'image16.png', 'Man, Shirts', 40, 1999),
(98, 'BE SAVAGE Button up Black Versity Jacket for woman', 4.9, 'women, jacket', 899.1, 'S, M, L, XL', 'Black', 'This jackets is very stylish and quite suitable for casual and party wear.', 'image17.png', 'Women, Jackets', 10, 999),
(99, 'SGF11- Womens Kanjivaram Pure Soft Silk Handloom Saree Pure Golden Zar', 4.9, 'women, saree', 3599.4, 'Free Size', 'Blue, Light Green, Black', 'A Beautiful White Pashmina color saree is well crafted with premium quality kanjivaram pure soft silk fabric with Golden color Zari Border.', 'image18.png', 'Women, Saree', 40, 5999),
(100, 'Krishn Creations Kids Dress| Half Sleeve Printed Cotton Round Neck T Shirt and Short Combo Clothing Set for Baby', 4.3, 'kids', 799.2, '0-3 Y, 3-6 Y', 'White', 'Invest in soft and breathable baby clothing sets, ensuring gentle comfort and fuss-free wear for your little ones delicate skin.', 'image19.png', 'Kids', 20, 999),
(101, 'Elyraa Womens Western Style Printed Half Sleeve Top for Regular Wear and Girls | Trendy Design | Comfortable Fit', 4.8, 'women. tops', 879.2, 'XS, S, M, L, XL, XXL', 'White', 'Introducing the Elyraa Womens Western Style Printed Half Sleeve Top, perfect for regular wear and suited for girls seeking trendy fashion statements', 'image20.png', 'Women, Tops', 20, 1099),
(102, 'Enthone Womens Woven Banarasi Silk Saree', 4.6, 'women, saree', 3709.3, 'Free Size', 'Grey, Red', 'You can pair a saree with a clutch and a pair of fashion sandals or any casual footwear of your choice for a casual look when dressing up for a party.', 'image21.png', 'Women, Saree', 30, 5299),
(103, 'JC JUMMY COUTURE Best Women Summer Casual Warty Wear White Embroidered Cotton Top', 4.8, 'women, tops', 959.2, 'S, M, L, XL', 'White, Yellow, Green', 'Summer-friendly, layers with ease. Marries chikankari tradition with contemporary style. Adapts to trousers, skirts, jeans, or shorts flawlessly.', 'image22.png', 'Women, Tops', 20, 1199),
(104, 'HELLCAT Beige Trendy Printed Oversized T-Shirt for Women', 4.4, 'women, tops, tshirt', 1049.3, 'XS, S, M, L, XL', 'Beige, Cream, Black, Mint, ', 'Embrace effortless style with HELLCAT’s Trendy Women’s Oversized T-Shirts. Crafted for the modern woman, these tees blend comfort with chic, featuring a relaxed oversized fit that drapes beautifully over any silhouette', 'image23.png', 'Women, T-shirt, Tops', 30, 1499),
(105, 'Peter England Mens Regular Fit Shirt', 4.3, 'men, shirt', 909.3, '38, 40, 42, 44, 46, 48', 'Green, Pink', 'Peter England Formal Shirt', 'image24.png', 'Man, Shirts', 30, 1299),
(106, 'GRECIILOOKS Jeans for Women | Jeans Pant for Women | Baggy Jeans for Women | Women Jeans | Baggy Jeans for Women High Waist | Bell Bottom Jeans for Women', 4.6, 'women, jeans', 1305.83, '28, 30, 32, 34, 36', 'Sky, Blue, Black, Grey', 'These high waisted womens jeans have a light blue wash and feature a classic five pocket design.', 'image25.png', 'Women, Jeans', 33, 1949),
(107, 'Hopscotch Girls Knee Length Poly Cotton Full-Sleeve All-Over Print Party Dress in Navy Colo', 4.4, 'kids', 1985.83, '3-5 Y, 5-10 Y', 'Navyblue', 'We bring you what your kids will love and yet be comfortable in by scouring the world and hand-picking aww-some new styles every single day.', 'image26.png', 'Kids', 23, 2579),
(108, 'Thomas Scott Mens Classic Checkered Shacket with Zip Placket and Side Welt Pockets', 4.7, 'men, jacket, shirt', 1979.4, 'S, M, L, XL', 'Brown, Grey, Green, Yellow', 'Introducing the Thomas Scott Mens Classic Checkered Shacket with Zip Placket and Side Welt Pockets, a modern interpretation of timeless style and practical design', 'image27.png', 'Man, Shirts', 40, 3299),
(109, 'Leriya Fashion Women Tops | Tops for Women | Tops for Jeans for Women | Korean Tops for Women | Trendi Tops for Women | Western Tops for Women Stylish', 4.1, 'women, tops', 1239.38, 'S, M, L, XL', 'Blue, White', 'Leriya Fashion women sleeveless tops is used for Western Wear, birthday party wear, Office wear, casual wear, Beach Wear, Summer Wear, Hangouts, Picnic, Vacation Wear', 'image28.png', 'Women, Tops', 38, 1999),
(110, 'SQ Exports Couple Combo Half Sleeves Peach Goma', 4.9, 'women, men, tshirt', 909.3, 'L-S, L-M, L-L, L-XL, M-L, M-S, M-M', 'Black, Red', 'Perfect Gift for him and her, your loved ones, Couples, Love Birds, Girlfriends, boyfriends, Husband Wife. Anniversary Gifts.', 'image29.png', 'Man, Women, T-shirt', 30, 1299),
(111, 'Ben Martin Men Jeans || Wide leg jeans for men || Loose jeans for men || Baggy Jeans for Men', 4.8, 'men, jeans', 2099.3, '28, 30, 32, 34, 36', 'Grey, Balck, White', 'We have been crafting premium fashion pieces that resonate with your lifestyle. From trendy Mens Shirts to versatile Womens Jackets, and everything in between, we have covered your wardrobe essentials.', 'image30.png', 'Man, Jeans', 30, 2999),
(113, 'chmcs', 3.2, 'njkhj, kljl, hhkh', -9.899777777699999e34, 'lkhkj, kpupo, fghjg', 'gkhkj, jhj kjl, kjklj', 'ojiuiou', 'image12.png', 'Man, Women, Kids, T-shirt, Jeans, Saree, Shirts, Jackets, Tops', 9999.7777777, 1e33);

-- --------------------------------------------------------

--
-- Table structure for table `order_table`
--

CREATE TABLE `order_table` (
  `order_id` int(20) NOT NULL,
  `user_id` int(20) NOT NULL,
  `selectedItems` text NOT NULL,
  `deliverySystem` varchar(100) NOT NULL,
  `paymentSystem` varchar(100) NOT NULL,
  `note` text NOT NULL,
  `totalAmount` double NOT NULL,
  `status` varchar(100) NOT NULL,
  `dateTime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `shipmentAddress` text NOT NULL,
  `phoneNumber` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_table`
--

CREATE TABLE `users_table` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins_table`
--
ALTER TABLE `admins_table`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `cancel_table`
--
ALTER TABLE `cancel_table`
  ADD PRIMARY KEY (`cancel_id`);

--
-- Indexes for table `cart_table`
--
ALTER TABLE `cart_table`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `favorite_table`
--
ALTER TABLE `favorite_table`
  ADD PRIMARY KEY (`favorite_id`);

--
-- Indexes for table `items_table`
--
ALTER TABLE `items_table`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `order_table`
--
ALTER TABLE `order_table`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `users_table`
--
ALTER TABLE `users_table`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins_table`
--
ALTER TABLE `admins_table`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cancel_table`
--
ALTER TABLE `cancel_table`
  MODIFY `cancel_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `cart_table`
--
ALTER TABLE `cart_table`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `favorite_table`
--
ALTER TABLE `favorite_table`
  MODIFY `favorite_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `items_table`
--
ALTER TABLE `items_table`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT for table `order_table`
--
ALTER TABLE `order_table`
  MODIFY `order_id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `users_table`
--
ALTER TABLE `users_table`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
