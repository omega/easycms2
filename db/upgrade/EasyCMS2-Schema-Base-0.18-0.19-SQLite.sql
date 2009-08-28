-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.18-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.19-SQLite.sql':

-- Target database SQLite is untested/unsupported!!!
ALTER TABLE page ADD allow_comments INTEGER;
ALTER TABLE category ADD allow_comments INTEGER;

