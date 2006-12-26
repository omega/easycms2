-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Tue Dec 26 15:35:52 2006
-- 
SET foreign_key_checks=0;

--
-- Table: mimetype
--
DROP TABLE IF EXISTS mimetype;
CREATE TABLE mimetype (
  id INTEGER NOT NULL auto_increment,
  type text NOT NULL,
  name text,
  extensions text,
  icon text,
  PRIMARY KEY (id),
  UNIQUE unique_name (type)
) Type=InnoDB;

--
-- Table: setting
--
DROP TABLE IF EXISTS setting;
CREATE TABLE setting (
  key text NOT NULL,
  value text,
  PRIMARY KEY (key)
) Type=InnoDB;

--
-- Table: template
--
DROP TABLE IF EXISTS template;
CREATE TABLE template (
  id INTEGER NOT NULL auto_increment,
  name text NOT NULL,
  before text NOT NULL,
  after text NOT NULL,
  parent INTEGER,
  INDEX (parent),
  PRIMARY KEY (id),
  UNIQUE unique_name (name),
  CONSTRAINT fk_parent FOREIGN KEY (parent) REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE
) Type=InnoDB;

--
-- Table: category
--
DROP TABLE IF EXISTS category;
CREATE TABLE category (
  id INTEGER NOT NULL auto_increment,
  parent INTEGER,
  template INTEGER NOT NULL,
  type text NOT NULL DEFAULT 'article',
  index_page text,
  name text NOT NULL,
  url_name text NOT NULL,
  INDEX (parent),
  INDEX (template),
  PRIMARY KEY (id),
  UNIQUE url_name_parent (url_name, parent),
  CONSTRAINT fk_parent FOREIGN KEY (parent) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_template FOREIGN KEY (template) REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE
) Type=InnoDB;

--
-- Table: author
--
DROP TABLE IF EXISTS author;
CREATE TABLE author (
  id INTEGER NOT NULL auto_increment,
  login text NOT NULL,
  email text,
  password text NOT NULL,
  name text NOT NULL,
  PRIMARY KEY (id),
  UNIQUE unique_login (login)
) Type=InnoDB;

--
-- Table: page
--
DROP TABLE IF EXISTS page;
CREATE TABLE page (
  id INTEGER NOT NULL auto_increment,
  title text NOT NULL,
  url_title text NOT NULL,
  body text NOT NULL,
  author INTEGER NOT NULL,
  template INTEGER,
  category INTEGER NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT 'now()',
  updated TIMESTAMP NOT NULL DEFAULT 'now()',
  INDEX (template),
  INDEX (category),
  INDEX (author),
  PRIMARY KEY (id),
  UNIQUE unique_url (category, url_title),
  CONSTRAINT fk_template FOREIGN KEY (template) REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_category FOREIGN KEY (category) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_author FOREIGN KEY (author) REFERENCES author (id) ON DELETE CASCADE ON UPDATE CASCADE
) Type=InnoDB;

--
-- Table: media
--
DROP TABLE IF EXISTS media;
CREATE TABLE media (
  id INTEGER NOT NULL auto_increment,
  filename text,
  description text,
  type INTEGER,
  category INTEGER,
  INDEX (type),
  INDEX (category),
  PRIMARY KEY (id),
  CONSTRAINT fk_type FOREIGN KEY (type) REFERENCES mimetype (id),
  CONSTRAINT fk_category FOREIGN KEY (category) REFERENCES category (id)
) Type=InnoDB;

