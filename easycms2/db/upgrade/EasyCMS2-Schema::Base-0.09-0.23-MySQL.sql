-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.09-MySQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.23-MySQL.sql':

-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Mon Apr  9 19:57:17 2007
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


CREATE INDEX ON mimetype (id);
CREATE INDEX ON mimetype (type);
ALTER TABLE setting ;
CREATE INDEX ON setting (key);
ALTER TABLE template DROP FOREIGN KEY fk_parent;
CREATE INDEX ON template (id);
CREATE INDEX ON template (name);
ALTER TABLE page DROP FOREIGN KEY fk_template;
ALTER TABLE page DROP FOREIGN KEY fk_category;
ALTER TABLE page DROP FOREIGN KEY fk_author;
ALTER TABLE page ADD allow_comments int(11);
ALTER TABLE page ADD extra text;
ALTER TABLE page ADD extra_search1 text;
ALTER TABLE page ADD extra_search2 text;
ALTER TABLE page ADD from_date TIMESTAMP;
ALTER TABLE page ADD to_date TIMESTAMP;
CREATE INDEX ON page (id);
ALTER TABLE media DROP FOREIGN KEY fk_type;
ALTER TABLE media ADD category int(11);
CREATE INDEX ON media (id);
CREATE INDEX ON media (category);
ALTER TABLE category DROP FOREIGN KEY fk_parent;
ALTER TABLE category DROP FOREIGN KEY fk_template;
ALTER TABLE category ADD type text DEFAULT 'article' NOT NULL;
ALTER TABLE category ADD index_page text;
ALTER TABLE category ADD allow_comments int(11);
ALTER TABLE category ADD css text;
ALTER TABLE category ADD js text;
ALTER TABLE category ADD config text;
CREATE INDEX ON category (id);
CREATE INDEX ON category (url_name);
CREATE INDEX ON author (id);
CREATE INDEX ON author (login);
ALTER TABLE template ADD CONSTRAINT template_fk_parent FOREIGN KEY (parent) REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE page ADD CONSTRAINT page_fk_template FOREIGN KEY (template) REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE page ADD CONSTRAINT page_fk_category FOREIGN KEY (category) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE page ADD CONSTRAINT page_fk_author FOREIGN KEY (author) REFERENCES author (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE media ADD CONSTRAINT media_fk_category FOREIGN KEY (category) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE media ADD CONSTRAINT media_fk_type FOREIGN KEY (type) REFERENCES mimetype (id);
ALTER TABLE category ADD CONSTRAINT category_fk_parent FOREIGN KEY (parent) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE category ADD CONSTRAINT category_fk_template FOREIGN KEY (template) REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE;

