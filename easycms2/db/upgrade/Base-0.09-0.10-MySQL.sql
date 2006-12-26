-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.09-MySQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.10-MySQL.sql':

ALTER TABLE page ADD type text DEFAULT 'article' NOT NULL;

