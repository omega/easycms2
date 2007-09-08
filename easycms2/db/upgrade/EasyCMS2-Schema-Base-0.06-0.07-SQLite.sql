-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.06-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.07-SQLite.sql':

ALTER TABLE mimetype ADD UNIQUE unique_name_mimetype (type);

