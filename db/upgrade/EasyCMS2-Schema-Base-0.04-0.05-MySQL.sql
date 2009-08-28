-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.04-MySQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.05-MySQL.sql':

-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sat Aug 26 12:00:33 2006
-- 
SET foreign_key_checks=0;

--
-- Table: mimetype
--
CREATE TABLE mimetype (
  id integer(11) NOT NULL auto_increment,
  type text NOT NULL,
  name text NOT NULL,
  icon text NOT NULL,
  PRIMARY KEY (id)
) Type=InnoDB;

--
-- Table: media
--
CREATE TABLE media (
  id integer(11) NOT NULL auto_increment,
  filename text NOT NULL,
  description text NOT NULL,
  type integer(11) NOT NULL,
  INDEX  (type),
  PRIMARY KEY (id),
  CONSTRAINT fk_type FOREIGN KEY (type) REFERENCES mimetype (id)
) Type=InnoDB;


ALTER TABLE template DROP FOREIGN KEY fk_parent;
ALTER TABLE category DROP FOREIGN KEY fk_parent;
ALTER TABLE category DROP FOREIGN KEY fk_template;
ALTER TABLE page DROP FOREIGN KEY fk_template;
ALTER TABLE page DROP FOREIGN KEY fk_category;
ALTER TABLE template ADD CONSTRAINT fk_parent FOREIGN KEY (parent) REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE category ADD CONSTRAINT fk_parent FOREIGN KEY (parent) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE category ADD CONSTRAINT fk_template FOREIGN KEY (template) REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE page ADD CONSTRAINT fk_template FOREIGN KEY (template) REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE page ADD CONSTRAINT fk_category FOREIGN KEY (category) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE;

