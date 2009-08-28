-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.19-MySQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.20-MySQL.sql':

ALTER TABLE page ADD extra text;
ALTER TABLE category ADD css text;
ALTER TABLE category ADD js text;

