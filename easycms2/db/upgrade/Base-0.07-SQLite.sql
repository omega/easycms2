-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Aug 26 12:51:13 2006
-- 
BEGIN TRANSACTION;

--
-- Table: mimetype
--
DROP TABLE mimetype;
CREATE TABLE mimetype (
  id INTEGER PRIMARY KEY NOT NULL,
  type TEXT NOT NULL,
  name TEXT,
  extensions TEXT,
  icon TEXT
);

--
-- Table: setting
--
DROP TABLE setting;
CREATE TABLE setting (
  key TEXT NOT NULL,
  value TEXT,
  PRIMARY KEY (key)
);

--
-- Table: template
--
DROP TABLE template;
CREATE TABLE template (
  id INTEGER PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  before TEXT NOT NULL,
  after TEXT NOT NULL,
  parent INTEGER
);

--
-- Table: category
--
DROP TABLE category;
CREATE TABLE category (
  id INTEGER PRIMARY KEY NOT NULL,
  parent INTEGER,
  template INTEGER NOT NULL,
  name TEXT NOT NULL,
  url_name TEXT NOT NULL
);

--
-- Table: author
--
DROP TABLE author;
CREATE TABLE author (
  id INTEGER PRIMARY KEY NOT NULL,
  login TEXT NOT NULL,
  email TEXT,
  password TEXT NOT NULL,
  name TEXT NOT NULL
);

--
-- Table: page
--
DROP TABLE page;
CREATE TABLE page (
  id INTEGER PRIMARY KEY NOT NULL,
  title TEXT NOT NULL,
  url_title TEXT NOT NULL,
  body TEXT NOT NULL,
  author INTEGER NOT NULL,
  template INTEGER,
  category INTEGER NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- Table: media
--
DROP TABLE media;
CREATE TABLE media (
  id INTEGER PRIMARY KEY NOT NULL,
  filename TEXT NOT NULL,
  description TEXT,
  type INTEGER NOT NULL
);

CREATE UNIQUE INDEX unique_name_mimetype on mimetype (type);
CREATE UNIQUE INDEX unique_name_template on template (name);
CREATE UNIQUE INDEX url_name_parent_category on category (url_name, parent);
CREATE UNIQUE INDEX unique_login_author on author (login);
CREATE UNIQUE INDEX unique_url_page on page (category, url_title);
COMMIT;
