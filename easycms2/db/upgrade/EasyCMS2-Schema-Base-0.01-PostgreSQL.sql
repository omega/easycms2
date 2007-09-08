-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sat May 27 20:40:35 2006
-- 
--
-- Table: setting
--

DROP TABLE setting;
CREATE TABLE setting (
  key text NOT NULL,
  value text NOT NULL,
  PRIMARY KEY (key)
);

--
-- Table: template
--

DROP TABLE template;
CREATE TABLE template (
  id serial NOT NULL,
  name text NOT NULL,
  before text NOT NULL,
  after text NOT NULL,
  parent smallint NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT "unique_name" UNIQUE (name)
);

--
-- Table: category
--

DROP TABLE category;
CREATE TABLE category (
  id serial NOT NULL,
  parent smallint NOT NULL,
  template smallint NOT NULL,
  name text NOT NULL,
  url_name text NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT "url_name_parent" UNIQUE (url_name, parent)
);

--
-- Table: page
--

DROP TABLE page;
CREATE TABLE page (
  id serial NOT NULL,
  title text NOT NULL,
  url_title text NOT NULL,
  body text NOT NULL,
  author smallint NOT NULL,
  template smallint NOT NULL,
  category smallint NOT NULL,
  created timestamp DEFAULT now() NOT NULL,
  updated timestamp DEFAULT now() NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT "unique_url" UNIQUE (category, url_title)
);

--
-- Table: author
--

DROP TABLE author;
CREATE TABLE author (
  id serial NOT NULL,
  login text NOT NULL,
  email text NOT NULL,
  password text NOT NULL,
  name text NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT "unique_login" UNIQUE (login)
);

--
-- Foreign Key Definitions
--

ALTER TABLE template ADD FOREIGN KEY (parent)
  REFERENCES template (id);

ALTER TABLE category ADD FOREIGN KEY (parent)
  REFERENCES category (id);

ALTER TABLE category ADD FOREIGN KEY (template)
  REFERENCES template (id);

ALTER TABLE page ADD FOREIGN KEY (template)
  REFERENCES template (id);

ALTER TABLE page ADD FOREIGN KEY (author)
  REFERENCES author (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE page ADD FOREIGN KEY (category)
  REFERENCES category (id);