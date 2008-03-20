-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Thu Mar 20 16:19:29 2008
-- 
BEGIN TRANSACTION;


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

CREATE UNIQUE INDEX unique_login_author ON author (login);

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

CREATE UNIQUE INDEX url_name_parent_category ON category (url_name, parent);

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

CREATE UNIQUE INDEX unique_name_mimetype ON mimetype (type);

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

CREATE UNIQUE INDEX unique_url_page ON page (category, url_title);

--
-- Table: page_tag
--
DROP TABLE page_tag;
CREATE TABLE page_tag (
  page INTEGER NOT NULL,
  tag INTEGER NOT NULL,
  PRIMARY KEY (page, tag)
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
-- Table: tag
--
DROP TABLE tag;
CREATE TABLE tag (
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(32) NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX unique_tag_name_tag ON tag (name);

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

CREATE UNIQUE INDEX unique_name_template ON template (name);

COMMIT;
