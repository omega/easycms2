-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.04-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.05-SQLite.sql':

-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Aug 26 12:00:35 2006
-- 
BEGIN TRANSACTION;

--
-- Table: mimetype
--
CREATE TABLE mimetype (
  id INTEGER PRIMARY KEY NOT NULL,
  type TEXT NOT NULL,
  name TEXT NOT NULL,
  icon TEXT NOT NULL
);

--
-- Table: media
--
CREATE TABLE media (
  id INTEGER PRIMARY KEY NOT NULL,
  filename TEXT NOT NULL,
  description TEXT NOT NULL,
  type INTEGER NOT NULL
);

COMMIT;


