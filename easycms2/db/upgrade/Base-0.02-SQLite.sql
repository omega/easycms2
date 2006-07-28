-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sun May 28 12:26:21 2006
-- 
BEGIN TRANSACTION;

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
  parent INTEGER NOT NULL
);

--
-- Table: category
--
DROP TABLE category;
CREATE TABLE category (
  id INTEGER PRIMARY KEY NOT NULL,
  parent INTEGER NOT NULL,
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
  email TEXT NOT NULL,
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
  template INTEGER NOT NULL,
  category INTEGER NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX unique_name_template on template (name);
CREATE UNIQUE INDEX url_name_parent_category on category (url_name, parent);
CREATE UNIQUE INDEX unique_login_author on author (login);
CREATE UNIQUE INDEX unique_url_page on page (category, url_title);
COMMIT;
