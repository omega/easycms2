-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.16-MySQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.23-MySQL.sql':

-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Mon Apr  9 19:50:49 2007
-- 
SET foreign_key_checks=0;


--
-- Table: `snippet`
--
CREATE TABLE `snippet` (
  `id` integer(11) NOT NULL auto_increment,
  `category` integer(11) NOT NULL,
  `text` text NOT NULL,
  `name` text NOT NULL,
  INDEX  (`id`),
  INDEX  (`category`),
  PRIMARY KEY (`id`),
  CONSTRAINT `snippet_snippet_fk_category` FOREIGN KEY (`category`) REFERENCES `category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) Type=InnoDB;


--
-- Table: `comment`
--
CREATE TABLE `comment` (
  `id` integer(11) NOT NULL auto_increment,
  `title` text NOT NULL,
  `url_title` text NOT NULL,
  `body` text NOT NULL,
  `commenter` text NOT NULL,
  `page` integer(11) NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT 'now()',
  `updated` TIMESTAMP NOT NULL DEFAULT 'now()',
  INDEX  (`id`),
  INDEX  (`page`),
  PRIMARY KEY (`id`),
  CONSTRAINT `comment_comment_fk_page` FOREIGN KEY (`page`) REFERENCES `page` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) Type=InnoDB;


SET foreign_key_checks=1;


ALTER TABLE page ADD allow_comments int(11);
ALTER TABLE page ADD extra text;
ALTER TABLE page ADD extra_search1 text;
ALTER TABLE page ADD extra_search2 text;
ALTER TABLE page ADD from_date TIMESTAMP;
ALTER TABLE page ADD to_date TIMESTAMP;
ALTER TABLE category ADD allow_comments int(11);
ALTER TABLE category ADD css text;
ALTER TABLE category ADD js text;
ALTER TABLE category ADD config text;

