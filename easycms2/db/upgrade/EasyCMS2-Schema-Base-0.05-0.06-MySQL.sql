-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.05-MySQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.06-MySQL.sql':

ALTER TABLE mimetype ADD extensions text;
ALTER TABLE mimetype CHANGE name name text;
ALTER TABLE mimetype CHANGE icon icon text;
ALTER TABLE media CHANGE description description text;

