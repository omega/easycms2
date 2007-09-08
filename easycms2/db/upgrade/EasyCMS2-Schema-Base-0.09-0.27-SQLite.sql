-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.09-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.27-SQLite.sql':

-- Target database SQLite is untested/unsupported!!!
-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Sep  8 09:22:48 2007
-- 
BEGIN TRANSACTION;


--
-- Table: snippet
--
CREATE TABLE snippet (
  id INTEGER PRIMARY KEY NOT NULL,
  category INTEGER NOT NULL,
  text TEXT NOT NULL,
  name TEXT NOT NULL
);


--
-- Table: comment
--
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


COMMIT;

ALTER TABLE mimetype CHANGE type varchar(255) NOT NULL;
ALTER TABLE setting CHANGE key varchar(255) NOT NULL;
ALTER TABLE template ADD css TEXT;
ALTER TABLE template ADD js TEXT;
ALTER TABLE template CHANGE name varchar(255) NOT NULL;
ALTER TABLE page ADD allow_comments INTEGER;
ALTER TABLE page ADD extra TEXT;
ALTER TABLE page ADD extra_search1 TEXT;
ALTER TABLE page ADD extra_search2 TEXT;
ALTER TABLE page ADD from_date date;
ALTER TABLE page ADD to_date date;
ALTER TABLE page CHANGE url_title varchar(255) NOT NULL;
ALTER TABLE media ADD category INTEGER;
ALTER TABLE category ADD type varchar(64) DEFAULT 'article' NOT NULL;
ALTER TABLE category ADD index_page TEXT;
ALTER TABLE category ADD allow_comments INTEGER;
ALTER TABLE category ADD css TEXT;
ALTER TABLE category ADD js TEXT;
ALTER TABLE category ADD config TEXT;
ALTER TABLE category CHANGE url_name varchar(255) NOT NULL;
ALTER TABLE author CHANGE login varchar(255) NOT NULL;

