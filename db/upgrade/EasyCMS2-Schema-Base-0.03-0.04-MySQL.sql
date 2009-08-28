-- Convert schema '/Users/andremar/Projects/EasyCMS2/db/upgrade/Base-0.03-MySQL.sql' to '/Users/andremar/Projects/EasyCMS2/db/upgrade/Base-0.04-MySQL.sql':

ALTER TABLE template CHANGE parent parent int(11);
ALTER TABLE category CHANGE parent parent int(11);
ALTER TABLE page CHANGE template template int(11);

