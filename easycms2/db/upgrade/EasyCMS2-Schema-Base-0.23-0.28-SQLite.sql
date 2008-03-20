-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema-Base-0.23-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema-Base-0.28-SQLite.sql':

BEGIN;

CREATE TABLE page_tag (
  page INTEGER NOT NULL,
  tag INTEGER NOT NULL,
  PRIMARY KEY (page, tag)
);


CREATE TABLE tag (
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(32) NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX unique_tag_name_tag_tag ON tag (name);

CREATE TEMPORARY TABLE author_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  login varchar(255) NOT NULL,
  email TEXT,
  password TEXT NOT NULL,
  name TEXT NOT NULL
);
INSERT INTO author_temp_alter SELECT id, login, email, password, name FROM author;
DROP TABLE author;
CREATE TABLE author (
  id INTEGER PRIMARY KEY NOT NULL,
  login varchar(255) NOT NULL,
  email TEXT,
  password TEXT NOT NULL,
  name TEXT NOT NULL
);
CREATE UNIQUE INDEX unique_login_author_author ON author (login);
INSERT INTO author SELECT id, login, email, password, name FROM author_temp_alter;
DROP TABLE author_temp_alter;

CREATE TEMPORARY TABLE category_temp_alter (
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
INSERT INTO category_temp_alter SELECT id, parent, template, type, index_page, allow_comments, css, js, name, url_name, config FROM category;
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
CREATE UNIQUE INDEX url_name_parent_category_ca00 ON category (url_name, parent);
INSERT INTO category SELECT id, parent, template, type, index_page, allow_comments, css, js, name, url_name, config FROM category_temp_alter;
DROP TABLE category_temp_alter;



CREATE TEMPORARY TABLE mimetype_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  type varchar(255) NOT NULL,
  name TEXT,
  extensions TEXT,
  icon TEXT
);
INSERT INTO mimetype_temp_alter SELECT id, type, name, extensions, icon FROM mimetype;
DROP TABLE mimetype;
CREATE TABLE mimetype (
  id INTEGER PRIMARY KEY NOT NULL,
  type varchar(255) NOT NULL,
  name TEXT,
  extensions TEXT,
  icon TEXT
);
CREATE UNIQUE INDEX unique_name_mimetype_mimetype ON mimetype (type);
INSERT INTO mimetype SELECT id, type, name, extensions, icon FROM mimetype_temp_alter;
DROP TABLE mimetype_temp_alter;

CREATE TEMPORARY TABLE page_temp_alter (
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
INSERT INTO page_temp_alter SELECT id, title, url_title, body, author, template, category, allow_comments, created, updated, extra, extra_search1, extra_search2, from_date, to_date FROM page;
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
CREATE UNIQUE INDEX unique_url_page_page ON page (category, url_title);
INSERT INTO page SELECT id, title, url_title, body, author, template, category, allow_comments, created, updated, extra, extra_search1, extra_search2, from_date, to_date FROM page_temp_alter;
DROP TABLE page_temp_alter;


CREATE TEMPORARY TABLE setting_temp_alter (
  key varchar(255) NOT NULL,
  value TEXT,
  PRIMARY KEY (key)
);
INSERT INTO setting_temp_alter SELECT key, value FROM setting;
DROP TABLE setting;
CREATE TABLE setting (
  key varchar(255) NOT NULL,
  value TEXT,
  PRIMARY KEY (key)
);
INSERT INTO setting SELECT key, value FROM setting_temp_alter;
DROP TABLE setting_temp_alter;



CREATE TEMPORARY TABLE template_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(255) NOT NULL,
  before TEXT NOT NULL,
  after TEXT NOT NULL,
  css TEXT,
  js TEXT,
  parent INTEGER
);
INSERT INTO template_temp_alter(id, name, before, after, parent) SELECT id, name, before, after, parent FROM template;
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
CREATE UNIQUE INDEX unique_name_template_template ON template (name);
INSERT INTO template SELECT id, name, before, after, css, js, parent FROM template_temp_alter;
DROP TABLE template_temp_alter;


COMMIT;
