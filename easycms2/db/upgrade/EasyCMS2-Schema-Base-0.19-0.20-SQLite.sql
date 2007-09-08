-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.19-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.20-SQLite.sql':

-- Target database SQLite is untested/unsupported!!!
ALTER TABLE page ADD extra TEXT;
ALTER TABLE category ADD css TEXT;
ALTER TABLE category ADD js TEXT;

