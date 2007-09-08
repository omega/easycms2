-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema-Base-0.09-PostgreSQL.sql' 
-- to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema-Base-0.27-PostgreSQL.sql':

-- Target database PostgreSQL is untested/unsupported!!!
--
-- Table: snippet02
--
-- Comments: 
-- Table: snippet
-- DROP TABLE snippet CASCADE;
CREATE TABLE snippet (
  id serial NOT NULL,
  category integer NOT NULL,
  text text NOT NULL,
  name text NOT NULL,
  PRIMARY KEY (id)
);



--
-- Table: comment02
--
-- Comments: 
-- Table: comment
-- DROP TABLE comment CASCADE;
CREATE TABLE comment (
  id serial NOT NULL,
  title text NOT NULL,
  url_title text NOT NULL,
  body text NOT NULL,
  commenter text NOT NULL,
  page integer NOT NULL,
  created timestamp(0) DEFAULT now() NOT NULL,
  updated timestamp(0) DEFAULT now() NOT NULL,
  PRIMARY KEY (id)
);

--
-- Foreign Key Definitions
--

ALTER TABLE snippet ADD FOREIGN KEY (category)
  REFERENCES category (id) ON DELETE cascade ON UPDATE cascade;

ALTER TABLE comment ADD FOREIGN KEY (page)
  REFERENCES page (id) ON DELETE cascade ON UPDATE cascade;

--ALTER TABLE mimetype CHANGE type varchar(255) NOT NULL;
begin;
ALTER TABLE mimetype ADD COLUMN type_new varchar(255);
UPDATE mimetype SET type_new = CAST(type AS varchar);
ALTER TABLE mimetype ALTER COLUMN type_new SET NOT NULL;
ALTER TABLE mimetype DROP COLUMN type;
ALTER TABLE mimetype RENAME COLUMN type_new TO type;
commit;

--ALTER TABLE setting CHANGE key varchar(255) NOT NULL;
begin;
ALTER TABLE setting ADD COLUMN key_new varchar(255);
UPDATE setting SET key_new = CAST(key AS varchar);
ALTER TABLE setting ALTER COLUMN key_new SET NOT NULL;
ALTER TABLE setting DROP COLUMN key;
ALTER TABLE setting RENAME COLUMN key_new TO key;
commit;

ALTER TABLE template ADD css text;
ALTER TABLE template ADD js text;

--ALTER TABLE template CHANGE name varchar(255) NOT NULL;
begin;
ALTER TABLE template ADD COLUMN name_new varchar(255);
UPDATE template SET name_new = CAST(name AS varchar);
ALTER TABLE template ALTER COLUMN name_new SET NOT NULL;
ALTER TABLE template DROP COLUMN name;
ALTER TABLE template RENAME COLUMN name_new TO name;
commit;

--ALTER TABLE template CHANGE parent integer(10);
begin;
ALTER TABLE template ADD COLUMN parent_new integer(10);
UPDATE template SET parent_new = CAST(parent AS varchar);
ALTER TABLE template ALTER COLUMN parent_new SET NOT NULL;
ALTER TABLE template DROP COLUMN parent;
ALTER TABLE template RENAME COLUMN parent_new TO parent;
commit;

ALTER TABLE page ADD allow_comments integer(10);
ALTER TABLE page ADD extra text;
ALTER TABLE page ADD extra_search1 text;
ALTER TABLE page ADD extra_search2 text;
ALTER TABLE page ADD from_date date;
ALTER TABLE page ADD to_date date;


--ALTER TABLE page CHANGE url_title varchar(255) NOT NULL;
begin;
ALTER TABLE page ADD COLUMN url_title_new varchar(255);
UPDATE page SET url_title_new = CAST(url_title AS varchar);
ALTER TABLE page ALTER COLUMN url_title_new SET NOT NULL;
ALTER TABLE page DROP COLUMN url_title;
ALTER TABLE page RENAME COLUMN url_title_new TO url_title;
commit;

--ALTER TABLE page CHANGE author integer(10) NOT NULL;
begin;
ALTER TABLE page ADD COLUMN author_new integer(10);
UPDATE page SET author_new = CAST(author AS varchar);
ALTER TABLE page ALTER COLUMN author_new SET NOT NULL;
ALTER TABLE page DROP COLUMN author;
ALTER TABLE page RENAME COLUMN author_new TO author;
commit;

--ALTER TABLE page CHANGE template integer(10);
begin;
ALTER TABLE page ADD COLUMN template_new integer(10);
UPDATE page SET template_new = CAST(template AS varchar);
ALTER TABLE page ALTER COLUMN template_new SET NOT NULL;
ALTER TABLE page DROP COLUMN template;
ALTER TABLE page RENAME COLUMN template_new TO template;
commit;

--ALTER TABLE page CHANGE category integer(10) NOT NULL;
begin;
ALTER TABLE page ADD COLUMN category_new integer(10);
UPDATE page SET category_new = CAST(category AS varchar);
ALTER TABLE page ALTER COLUMN category_new SET NOT NULL;
ALTER TABLE page DROP COLUMN category;
ALTER TABLE page RENAME COLUMN category_new TO category;
commit;

ALTER TABLE media ADD category integer(10);
--ALTER TABLE media CHANGE type integer(10);
begin;
ALTER TABLE media ADD COLUMN type_new integer(10);
UPDATE media SET type_new = CAST(type AS varchar);
ALTER TABLE media ALTER COLUMN type_new SET NOT NULL;
ALTER TABLE media DROP COLUMN type;
ALTER TABLE media RENAME COLUMN type_new TO type;
commit;


ALTER TABLE category ADD type varchar(64) DEFAULT 'article' NOT NULL;
ALTER TABLE category ADD index_page text;
ALTER TABLE category ADD allow_comments integer(10);
ALTER TABLE category ADD css text;
ALTER TABLE category ADD js text;
ALTER TABLE category ADD config text;
--ALTER TABLE category CHANGE parent integer(10);
begin;
ALTER TABLE category ADD COLUMN parent_new integer(10);
UPDATE category SET parent_new = CAST(parent AS varchar);
ALTER TABLE category ALTER COLUMN parent_new SET NOT NULL;
ALTER TABLE category DROP COLUMN parent;
ALTER TABLE category RENAME COLUMN parent_new TO parent;
commit;

--ALTER TABLE category CHANGE template integer(10) NOT NULL;
begin;
ALTER TABLE category ADD COLUMN template_new integer(10);
UPDATE category SET template_new = CAST(template AS varchar);
ALTER TABLE category ALTER COLUMN template_new SET NOT NULL;
ALTER TABLE category DROP COLUMN template;
ALTER TABLE category RENAME COLUMN template_new TO template;
commit;

--ALTER TABLE category CHANGE url_name varchar(255) NOT NULL;
begin;
ALTER TABLE category ADD COLUMN url_name_new varchar(255);
UPDATE category SET url_name_new = CAST(url_name AS varchar);
ALTER TABLE category ALTER COLUMN url_name_new SET NOT NULL;
ALTER TABLE category DROP COLUMN url_name;
ALTER TABLE category RENAME COLUMN url_name_new TO url_name;
commit;


--ALTER TABLE author CHANGE login varchar(255) NOT NULL;
begin;
ALTER TABLE author ADD COLUMN login_new varchar(255);
UPDATE author SET login_new = CAST(login AS varchar);
ALTER TABLE author ALTER COLUMN login_new SET NOT NULL;
ALTER TABLE author DROP COLUMN login;
ALTER TABLE author RENAME COLUMN login_new TO login;
commit;

ALTER TABLE media ADD CONSTRAINT FOREIGN KEY (category) REFERENCES category (id) ON DELETE cascade ON UPDATE cascade;

