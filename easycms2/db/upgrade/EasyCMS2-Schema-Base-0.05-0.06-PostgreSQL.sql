-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.05-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.06-PostgreSQL.sql':

ALTER TABLE mimetype ADD extensions text;
ALTER TABLE mimetype CHANGE name text;
ALTER TABLE mimetype CHANGE icon text;
ALTER TABLE media CHANGE description text;

