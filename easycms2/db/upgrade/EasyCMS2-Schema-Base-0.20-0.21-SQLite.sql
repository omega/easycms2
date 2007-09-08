-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.20-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.21-SQLite.sql':

-- Target database SQLite is untested/unsupported!!!
ALTER TABLE page ADD extra_search1 TEXT;
ALTER TABLE page ADD extra_search2 TEXT;

