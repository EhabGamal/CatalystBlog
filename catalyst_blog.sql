-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: catalyst_blog
-- ------------------------------------------------------
-- Server version	5.7.17-0ubuntu0.16.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `postid` int(11) unsigned NOT NULL,
  `userid` int(11) unsigned NOT NULL,
  `comment` text,
  `comment_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `postid` (`postid`),
  KEY `userid` (`userid`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`postid`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (26,33,2,'new comment','2017-03-20 10:55:00'),(27,34,11,'this is the first comment','2017-03-20 13:05:07');
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_tags`
--

DROP TABLE IF EXISTS `post_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_tags` (
  `postid` int(11) unsigned NOT NULL,
  `tagid` int(11) unsigned NOT NULL,
  KEY `postid` (`postid`),
  KEY `tagid` (`tagid`),
  CONSTRAINT `post_tags_ibfk_1` FOREIGN KEY (`postid`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `post_tags_ibfk_2` FOREIGN KEY (`tagid`) REFERENCES `tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_tags`
--

LOCK TABLES `post_tags` WRITE;
/*!40000 ALTER TABLE `post_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userid` int(11) unsigned NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` mediumtext,
  `publish` datetime DEFAULT NULL,
  `edit` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (3,3,'Title3','This is post number 3','2017-02-22 00:00:00','2017-02-22 00:00:00'),(4,2,'Title4','This is post number 4 but this content should be long enough to test the truncate formatting class','2017-02-22 00:00:00','2017-02-22 00:00:00'),(5,3,'this is a new post','this is the content of the new post','2017-02-26 00:00:00','2017-02-26 00:00:00'),(6,3,'this is the most recent post so far','this is the content of the most recent post so far','2017-02-26 00:00:00','2017-02-26 00:00:00'),(8,2,'this post from admin','this is the content of this post','2017-02-26 00:00:00','2017-02-26 00:00:00'),(9,2,'this post from admin','this is the content of this post','2017-02-26 00:00:00','2017-02-26 00:00:00'),(26,3,'test date','content date',NULL,NULL),(33,2,'new post','post content','2017-03-20 10:54:02','2017-03-20 10:54:02'),(34,11,'new post from admin','this is the content of the post','2017-03-20 13:04:56','2017-03-20 13:04:56');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(2) NOT NULL,
  `role` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'user'),(2,'admin');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tag` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_role` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (1,1),(1,2),(2,1),(3,1),(10,1),(10,2),(11,1),(11,2);
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `fname` varchar(30) DEFAULT NULL,
  `lname` varchar(30) DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `password` char(64) NOT NULL,
  `gender` char(1) DEFAULT NULL,
  `bio` varchar(300) DEFAULT NULL,
  `avatar` varchar(100) DEFAULT NULL,
  `regdate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'ehab','Ehab','Gamal','ehab.g.sh@gmail.com','{SSHA}FpGhpCJus+Ea9ne4ww8404HH+hJKW/fW+bAv1v6FuRUy2G7I2aoTRQ==','m','This is ehab, over!',NULL,NULL),(3,'user','John','Doe','example@email.com','{SSHA}ZyGlpiHls8qFBSbHr3r5t/iqcZE602XLMbkSVRRNl6rF8imv1abQVg==','m','this is a temp user for testing',NULL,'2017-02-27 00:00:00'),(7,'test','test','test','emaila@local.com','{SSHA}KMEzW8PrmcH8YUsMTuldi1TPzywhHCmYTKMtlebeoET5ZppzFErU4A==','m',NULL,NULL,'2017-03-19 00:18:49'),(9,'username','fname','lname','email@exam.com','{SSHA}O7LuNQa1ZD3LRTjRo4FdWplEkFA7/RbM7m6yeIuGp+eSf8fOyB1GSg==','m',NULL,NULL,'2017-03-19 22:43:58'),(10,'master','Admin','Admin','admin@host.com','{SSHA}vMbPtkNPbvTVRQlsPKfBEGkHaYue3vB+T0R0ymBgeUgfkx4FgbYSwA==','m',NULL,NULL,'2017-03-19 23:45:04'),(11,'admin','Ehab','Gamal','admin@localhost.com','{SSHA}+BHRUMLCzJf+7IGm957z/lXaUw5b0loGsU+4gpZOSowKBnGC12Ztbw==','m',NULL,NULL,'2017-03-20 13:04:30');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-03-20 13:06:26
