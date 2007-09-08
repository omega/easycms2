-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.14-MySQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.16-MySQL.sql':

ALTER TABLE media ADD category int(11);
CREATE INDEX ON media (category);
ALTER TABLE media ADD CONSTRAINT fk_category FOREIGN KEY (category) REFERENCES category (id);

