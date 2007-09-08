-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.10-MySQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.11-MySQL.sql':

ALTER TABLE category ADD type text DEFAULT 'article' NOT NULL;
ALTER TABLE page DROP type;

