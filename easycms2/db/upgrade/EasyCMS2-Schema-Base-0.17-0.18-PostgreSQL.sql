-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.17-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.18-PostgreSQL.sql':

-- Target database PostgreSQL is untested/unsupported!!!
ALTER TABLE snippet ADD name text NOT NULL;
ALTER TABLE snippet ADD ;
ALTER TABLE comment ADD CONSTRAINT FOREIGN KEY (page) REFERENCES page (id) ON DELETE cascade ON UPDATE cascade;

