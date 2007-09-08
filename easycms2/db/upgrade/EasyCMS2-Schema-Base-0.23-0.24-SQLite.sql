-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.23-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.24-SQLite.sql':

-- Target database SQLite is untested/unsupported!!!
ALTER TABLE template ADD css TEXT;
ALTER TABLE template ADD js TEXT;

