-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.26-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.27-PostgreSQL.sql':

-- Target database PostgreSQL is untested/unsupported!!!
ALTER TABLE page CHANGE from_date date;
ALTER TABLE page CHANGE to_date date;

