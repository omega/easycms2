-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.09-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.10-PostgreSQL.sql':

ALTER TABLE page ADD type text DEFAULT 'article' NOT NULL;
ALTER TABLE page ADD ;

