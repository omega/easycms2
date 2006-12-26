-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.14-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.16-PostgreSQL.sql':

ALTER TABLE media ADD category integer(5);
ALTER TABLE media ADD CONSTRAINT FOREIGN KEY (category) REFERENCES category (id);

