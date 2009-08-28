-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.12-MySQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.13-MySQL.sql':

ALTER TABLE category ADD index_page text NOT NULL;
ALTER TABLE category DROP index;

