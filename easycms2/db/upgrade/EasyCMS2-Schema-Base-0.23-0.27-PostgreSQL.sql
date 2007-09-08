-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema-Base-0.23-PostgreSQL.sql';
-- to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema-Base-0.27-PostgreSQL.sql':;

-- Target database PostgreSQL is untested/unsupported!!!;

begin;
ALTER TABLE mimetype ADD COLUMN type_new varchar(255);
UPDATE mimetype SET type_new = CAST(type AS varchar);
ALTER TABLE mimetype ALTER COLUMN type_new SET NOT NULL;
ALTER TABLE mimetype DROP COLUMN type;
ALTER TABLE mimetype RENAME COLUMN type_new TO type;

ALTER TABLE setting ADD COLUMN key_new varchar(255);
UPDATE setting SET key_new = CAST(key AS varchar);
ALTER TABLE setting ALTER COLUMN key_new SET NOT NULL;
ALTER TABLE setting DROP COLUMN key;
ALTER TABLE setting RENAME COLUMN key_new TO key;

ALTER TABLE template ADD css text;
ALTER TABLE template ADD js text;

ALTER TABLE template ADD COLUMN name_new varchar(255);
UPDATE template SET name_new = CAST(name AS varchar);
ALTER TABLE template ALTER COLUMN name_new SET NOT NULL;
ALTER TABLE template DROP COLUMN name;
ALTER TABLE template RENAME COLUMN name_new TO name;

ALTER TABLE page ADD COLUMN url_title_new varchar(255);
UPDATE page SET url_title_new = CAST(url_title AS varchar);
ALTER TABLE page ALTER COLUMN url_title_new SET NOT NULL;
ALTER TABLE page DROP COLUMN url_title;
ALTER TABLE page RENAME COLUMN url_title_new TO url_title;

ALTER TABLE page ADD COLUMN from_date_new date;
UPDATE page SET from_date_new = CAST(from_date AS date);
--ALTER TABLE page ALTER COLUMN from_date_new SET NOT NULL;
ALTER TABLE page DROP COLUMN from_date;
ALTER TABLE page RENAME COLUMN from_date_new TO from_date;

ALTER TABLE page ADD COLUMN to_date_new date;
UPDATE page SET to_date_new = CAST(to_date AS date);
--ALTER TABLE page ALTER COLUMN to_date_new SET NOT NULL;
ALTER TABLE page DROP COLUMN to_date;
ALTER TABLE page RENAME COLUMN to_date_new TO to_date;

-- ALTER TABLE category CHANGE type varchar(64) NOT NULL DEFAULT 'article';

ALTER TABLE category ADD COLUMN type_new varchar(64);
ALTER TABLE category ALTER COLUMN type_new SET DEFAULT 'article';
UPDATE category SET type_new = CAST(type AS varchar);
ALTER TABLE category ALTER COLUMN type_new SET NOT NULL;
ALTER TABLE category DROP COLUMN type;
ALTER TABLE category RENAME COLUMN type_new TO type;

-- ALTER TABLE category CHANGE url_name varchar(255) NOT NULL;

ALTER TABLE category ADD COLUMN url_name_new varchar(255);
UPDATE category SET url_name_new = CAST(url_name AS varchar);
ALTER TABLE category ALTER COLUMN url_name_new SET NOT NULL;
ALTER TABLE category DROP COLUMN url_name;
ALTER TABLE category RENAME COLUMN url_name_new TO url_name;

-- ALTER TABLE author CHANGE login varchar(255) NOT NULL;

ALTER TABLE author ADD COLUMN login_new varchar(255);
UPDATE author SET login_new = CAST(login AS varchar);
ALTER TABLE author ALTER COLUMN login_new SET NOT NULL;
ALTER TABLE author DROP COLUMN login;
ALTER TABLE author RENAME COLUMN login_new TO login;

commit;

