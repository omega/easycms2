-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sun Apr  8 22:29:50 2007
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS mimetype;
--
-- Table: mimetype
--
CREATE TABLE mimetype (
  id INTEGER NOT NULL auto_increment,
  type text NOT NULL,
  name text,
  extensions text,
  icon text,
  INDEX (id),
  INDEX (type),
  PRIMARY KEY (id),
  UNIQUE unique_name (type)
) Type=InnoDB;

DROP TABLE IF EXISTS snippet;
--
-- Table: snippet
--
CREATE TABLE snippet (
  id INTEGER NOT NULL auto_increment,
  category INTEGER NOT NULL,
  text text NOT NULL,
  name text NOT NULL,
  INDEX (id),
  INDEX (category),
  PRIMARY KEY (id),
  CONSTRAINT snippet_fk_category FOREIGN KEY (category) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE
) Type=InnoDB;

DROP TABLE IF EXISTS setting;
--
-- Table: setting
--
CREATE TABLE setting (
  key text NOT NULL,
  value text,
  INDEX (key),
  PRIMARY KEY (key)
);

DROP TABLE IF EXISTS comment;
--
-- Table: comment
--
CREATE TABLE comment (
  id INTEGER NOT NULL auto_increment,
  title text NOT NULL,
  url_title text NOT NULL,
  body text NOT NULL,
  commenter text NOT NULL,
  page INTEGER NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT 'now()',
  updated TIMESTAMP NOT NULL DEFAULT 'now()',
  INDEX (id),
  INDEX (page),
  PRIMARY KEY (id),
  CONSTRAINT comment_fk_page FOREIGN KEY (page) REFERENCES page (id) ON DELETE CASCADE ON UPDATE CASCADE
) Type=InnoDB;

DROP TABLE IF EXISTS template;
--
-- Table: template
--
CREATE TABLE template (
  id INTEGER NOT NULL auto_increment,
  name text NOT NULL,
  before text NOT NULL,
  after text NOT NULL,
  parent INTEGER,
  INDEX (id),
  INDEX (name),
  INDEX (parent),
  PRIMARY KEY (id),
  UNIQUE unique_name (name),
  CONSTRAINT template_fk_parent FOREIGN KEY (parent) REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE
) Type=InnoDB;

DROP TABLE IF EXISTS page;
--
-- Table: page
--
CREATE TABLE page (
  id INTEGER NOT NULL auto_increment,
  title text NOT NULL,
  url_title text NOT NULL,
  body text NOT NULL,
  author INTEGER NOT NULL,
  template INTEGER,
  category INTEGER NOT NULL,
  allow_comments INTEGER,
  created TIMESTAMP NOT NULL DEFAULT 'now()',
  updated TIMESTAMP NOT NULL DEFAULT 'now()',
  extra text,
  extra_search1 text,
  extra_search2 text,
  from_date TIMESTAMP,
  to_date TIMESTAMP,
  INDEX (id),
  INDEX (category),
  INDEX (template),
  INDEX (author),
  PRIMARY KEY (id),
  UNIQUE unique_url (category, url_title),
  CONSTRAINT page_fk_template FOREIGN KEY (template) REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT page_fk_category FOREIGN KEY (category) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT page_fk_author FOREIGN KEY (author) REFERENCES author (id) ON DELETE CASCADE ON UPDATE CASCADE
) Type=InnoDB;

DROP TABLE IF EXISTS media;
--
-- Table: media
--
CREATE TABLE media (
  id INTEGER NOT NULL auto_increment,
  filename text,
  description text,
  type INTEGER,
  category INTEGER,
  INDEX (id),
  INDEX (category),
  INDEX (type),
  PRIMARY KEY (id),
  CONSTRAINT media_fk_category FOREIGN KEY (category) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT media_fk_type FOREIGN KEY (type) REFERENCES mimetype (id)
) Type=InnoDB;

DROP TABLE IF EXISTS category;
--
-- Table: category
--
CREATE TABLE category (
  id INTEGER NOT NULL auto_increment,
  parent INTEGER,
  template INTEGER NOT NULL,
  type text NOT NULL DEFAULT 'article',
  index_page text,
  allow_comments INTEGER,
  css text,
  js text,
  name text NOT NULL,
  url_name text NOT NULL,
  config text,
  INDEX (id),
  INDEX (url_name),
  INDEX (parent),
  INDEX (template),
  PRIMARY KEY (id),
  UNIQUE url_name_parent (url_name, parent),
  CONSTRAINT category_fk_parent FOREIGN KEY (parent) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT category_fk_template FOREIGN KEY (template) REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE
) Type=InnoDB;

DROP TABLE IF EXISTS author;
--
-- Table: author
--
CREATE TABLE author (
  id INTEGER NOT NULL auto_increment,
  login text NOT NULL,
  email text,
  password text NOT NULL,
  name text NOT NULL,
  INDEX (id),
  INDEX (login),
  PRIMARY KEY (id),
  UNIQUE unique_login (login)
) Type=InnoDB;

SET foreign_key_checks=1;

