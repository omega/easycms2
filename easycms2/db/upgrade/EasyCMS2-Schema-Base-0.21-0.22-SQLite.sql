-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.21-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.22-SQLite.sql':

-- Target database SQLite is untested/unsupported!!!
ALTER TABLE page ADD from_date TIMESTAMP;
ALTER TABLE page ADD to_date TIMESTAMP;

