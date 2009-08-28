-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sat May 27 20:40:35 2006
-- 
SET foreign_key_checks=0;

--
-- Table: setting
--
DROP TABLE IF EXISTS setting;
CREATE TABLE setting (
  key text NOT NULL,
  value text NOT NULL,
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
  parent INTEGER NOT NULL,
  INDEX (parent),
  PRIMARY KEY (id),
  UNIQUE unique_name (name),
  CONSTRAINT fk_parent FOREIGN KEY (parent) REFERENCES template (id)
) Type=InnoDB;

--
-- Table: category
--
DROP TABLE IF EXISTS category;
CREATE TABLE category (
  id INTEGER NOT NULL auto_increment,
  parent INTEGER NOT NULL,
  template INTEGER NOT NULL,
  name text NOT NULL,
  url_name text NOT NULL,
  INDEX (parent),
  INDEX (template),
  PRIMARY KEY (id),
  UNIQUE url_name_parent (url_name, parent),
  CONSTRAINT fk_parent FOREIGN KEY (parent) REFERENCES category (id),
  CONSTRAINT fk_template FOREIGN KEY (template) REFERENCES template (id)
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
  template INTEGER NOT NULL,
  category INTEGER NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT 'now()',
  updated TIMESTAMP NOT NULL DEFAULT 'now()',
  INDEX (template),
  INDEX (author),
  INDEX (category),
  PRIMARY KEY (id),
  UNIQUE unique_url (category, url_title),
  CONSTRAINT fk_template FOREIGN KEY (template) REFERENCES template (id),
  CONSTRAINT fk_author FOREIGN KEY (author) REFERENCES author (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_category FOREIGN KEY (category) REFERENCES category (id)
) Type=InnoDB;

--
-- Table: author
--
DROP TABLE IF EXISTS author;
CREATE TABLE author (
  id INTEGER NOT NULL auto_increment,
  login text NOT NULL,
  email text NOT NULL,
  password text NOT NULL,
  name text NOT NULL,
  PRIMARY KEY (id),
  UNIQUE unique_login (login)
) Type=InnoDB;

