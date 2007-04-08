-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.21-MySQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.22-MySQL.sql':

ALTER TABLE page ADD from_date TIMESTAMP;
ALTER TABLE page ADD to_date TIMESTAMP;

