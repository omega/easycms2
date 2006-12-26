-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.10-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.11-SQLite.sql':

ALTER TABLE category ADD type TEXT DEFAULT 'article' NOT NULL;
ALTER TABLE page DROP type;

