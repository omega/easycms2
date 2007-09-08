-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Sep  8 09:40:38 2007
-- 
BEGIN TRANSACTION;


--
-- Table: mimetype
--
DROP TABLE mimetype;
CREATE TABLE mimetype (
  id INTEGER PRIMARY KEY NOT NULL,
  type varchar(255) NOT NULL,
  name TEXT,
  extensions TEXT,
  icon TEXT
);

CREATE UNIQUE INDEX unique_name_mimetype on mimetype (type);

--
-- Table: snippet
--
DROP TABLE snippet;
CREATE TABLE snippet (
  id INTEGER PRIMARY KEY NOT NULL,
  category INTEGER NOT NULL,
  text TEXT NOT NULL,
  name TEXT NOT NULL
);


--
-- Table: setting
--
DROP TABLE setting;
CREATE TABLE setting (
  key varchar(255) NOT NULL,
  value TEXT,
  PRIMARY KEY (key)
);


--
-- Table: comment
--
DROP TABLE comment;
CREATE TABLE comment (
  id INTEGER PRIMARY KEY NOT NULL,
  title TEXT NOT NULL,
  url_title TEXT NOT NULL,
  body TEXT NOT NULL,
  commenter TEXT NOT NULL,
  page INTEGER NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


--
-- Table: template
--
DROP TABLE template;
CREATE TABLE template (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(255) NOT NULL,
  before TEXT NOT NULL,
  after TEXT NOT NULL,
  css TEXT,
  js TEXT,
  parent INTEGER
);

CREATE UNIQUE INDEX unique_name_template on template (name);

--
-- Table: page
--
DROP TABLE page;
CREATE TABLE page (
  id INTEGER PRIMARY KEY NOT NULL,
  title TEXT NOT NULL,
  url_title varchar(255) NOT NULL,
  body TEXT NOT NULL,
  author INTEGER NOT NULL,
  template INTEGER,
  category INTEGER NOT NULL,
  allow_comments INTEGER,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  extra TEXT,
  extra_search1 TEXT,
  extra_search2 TEXT,
  from_date date,
  to_date date
);

CREATE UNIQUE INDEX unique_url_page on page (category, url_title);

--
-- Table: media
--
DROP TABLE media;
CREATE TABLE media (
  id INTEGER PRIMARY KEY NOT NULL,
  filename TEXT,
  description TEXT,
  type INTEGER,
  category INTEGER
);


--
-- Table: category
--
DROP TABLE category;
CREATE TABLE category (
  id INTEGER PRIMARY KEY NOT NULL,
  parent INTEGER,
  template INTEGER NOT NULL,
  type varchar(64) NOT NULL DEFAULT 'article',
  index_page TEXT,
  allow_comments INTEGER,
  css TEXT,
  js TEXT,
  name TEXT NOT NULL,
  url_name varchar(255) NOT NULL,
  config TEXT
);

CREATE UNIQUE INDEX url_name_parent_category on category (url_name, parent);

--
-- Table: author
--
DROP TABLE author;
CREATE TABLE author (
  id INTEGER PRIMARY KEY NOT NULL,
  login varchar(255) NOT NULL,
  email TEXT,
  password TEXT NOT NULL,
  name TEXT NOT NULL
);

CREATE UNIQUE INDEX unique_login_author on author (login);

COMMIT;
