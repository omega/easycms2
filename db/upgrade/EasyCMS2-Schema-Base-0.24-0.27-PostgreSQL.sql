-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.24-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.27-PostgreSQL.sql':

-- Target database PostgreSQL is untested/unsupported!!!
ALTER TABLE mimetype ALTER COLUMN type TYPE varchar(255);
ALTER TABLE mimetype ALTER COLUMN type SET NOT NULL;
ALTER TABLE setting ALTER COLUMN key TYPE varchar(255);
ALTER TABLE setting ALTER COLUMN key SET NOT NULL;
ALTER TABLE template ALTER COLUMN name TYPE varchar(255);
ALTER TABLE template ALTER COLUMN name SET NOT NULL;
ALTER TABLE page ALTER COLUMN url_title TYPE varchar(255);
ALTER TABLE page ALTER COLUMN url_title SET NOT NULL;
ALTER TABLE page ALTER COLUMN from_date TYPE date;
ALTER TABLE page ALTER COLUMN to_date TYPE date;
ALTER TABLE category ALTER COLUMN type TYPE varchar(64);
ALTER TABLE category ALTER COLUMN type SET NOT NULL;
ALTER TABLE category ALTER COLUMN type SET DEFAULT 'article';
ALTER TABLE category ALTER COLUMN url_name TYPE varchar(255);
ALTER TABLE category ALTER COLUMN url_name SET NOT NULL;
ALTER TABLE author ALTER COLUMN login TYPE varchar(255);
ALTER TABLE author ALTER COLUMN login SET NOT NULL;

