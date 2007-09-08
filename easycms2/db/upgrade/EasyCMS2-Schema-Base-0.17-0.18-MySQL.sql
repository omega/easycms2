-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.17-MySQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.18-MySQL.sql':

ALTER TABLE snippet ADD name text NOT NULL;
ALTER TABLE comment DROP FOREIGN KEY comment_fk_page;
ALTER TABLE comment ADD CONSTRAINT comment_fk_page FOREIGN KEY (page) REFERENCES page (id) ON DELETE CASCADE ON UPDATE CASCADE;

