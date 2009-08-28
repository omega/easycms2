-- Convert schema '/Users/andremar/Projects/EasyCMS2/db/upgrade/Base-0.03-SQLite.sql' to '/Users/andremar/Projects/EasyCMS2/db/upgrade/Base-0.04-SQLite.sql':

ALTER TABLE template CHANGE parent INTEGER;
ALTER TABLE category CHANGE parent INTEGER;
ALTER TABLE page CHANGE template INTEGER;

