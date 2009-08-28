-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.25-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.26-PostgreSQL.sql':

-- Target database PostgreSQL is untested/unsupported!!!
ALTER TABLE category CHANGE type varchar(64) NOT NULL DEFAULT 'article';

