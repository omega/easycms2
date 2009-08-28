-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.12-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.13-SQLite.sql':

ALTER TABLE category ADD index_page TEXT NOT NULL;
ALTER TABLE category DROP index;

