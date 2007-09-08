-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.06-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.07-PostgreSQL.sql':

ALTER TABLE mimetype ADD UNIQUE  (type);

