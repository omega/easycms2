-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.16-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.17-SQLite.sql':

-- Target database SQLite is untested/unsupported!!!
-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Tue Jan 23 13:33:58 2007
-- 
BEGIN TRANSACTION;


--
-- Table: snippet
--
CREATE TABLE snippet (
  id INTEGER PRIMARY KEY NOT NULL,
  category INTEGER NOT NULL,
  text TEXT NOT NULL
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


