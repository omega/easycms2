-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.05-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.06-SQLite.sql':

ALTER TABLE mimetype ADD extensions TEXT;
ALTER TABLE mimetype CHANGE name TEXT;
ALTER TABLE mimetype CHANGE icon TEXT;
ALTER TABLE media CHANGE description TEXT;

