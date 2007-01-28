-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.18-MySQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.19-MySQL.sql':

ALTER TABLE page ADD allow_comments int(11);
ALTER TABLE category ADD allow_comments int(11);

