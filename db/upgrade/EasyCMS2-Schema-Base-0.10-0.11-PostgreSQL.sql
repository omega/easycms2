-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.10-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.11-PostgreSQL.sql':

ALTER TABLE category ADD type text DEFAULT 'article' NOT NULL;
ALTER TABLE category ADD ;

