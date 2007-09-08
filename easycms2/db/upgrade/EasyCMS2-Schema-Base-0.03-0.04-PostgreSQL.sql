-- Convert schema '/Users/andremar/Projects/EasyCMS2/db/upgrade/Base-0.03-PostgreSQL.sql' to '/Users/andremar/Projects/EasyCMS2/db/upgrade/Base-0.04-PostgreSQL.sql':

ALTER TABLE template CHANGE parent integer(5);
ALTER TABLE category CHANGE parent integer(5);
ALTER TABLE page CHANGE template integer(5);

