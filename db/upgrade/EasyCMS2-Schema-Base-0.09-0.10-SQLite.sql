-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.09-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.10-SQLite.sql':

ALTER TABLE page ADD type TEXT DEFAULT 'article' NOT NULL;

