-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.19-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.20-PostgreSQL.sql':

-- Target database PostgreSQL is untested/unsupported!!!
ALTER TABLE page ADD extra text;
ALTER TABLE category ADD css text;
ALTER TABLE category ADD js text;

