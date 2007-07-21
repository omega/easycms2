-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.24-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.25-PostgreSQL.sql':

-- Target database PostgreSQL is untested/unsupported!!!
ALTER TABLE mimetype ALTER COLUMN type TYPE varchar(255) NOT NULL;
ALTER TABLE setting ALTER COLUMN key TYPE varchar NOT NULL;
ALTER TABLE template ALTER COLUMN name TYPE varchar(255) NOT NULL;
ALTER TABLE page ALTER COLUMN url_title TYPE varchar(255) NOT NULL;
ALTER TABLE category ALTER COLUMN url_nameTYPE varchar(255) NOT NULL;
ALTER TABLE author ALTER COLUMN login TYPE varchar(255) NOT NULL;

