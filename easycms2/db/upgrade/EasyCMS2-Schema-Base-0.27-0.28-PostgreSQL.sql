-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema-Base-0.27-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema-Base-0.28-PostgreSQL.sql':

-- Target database PostgreSQL is untested/unsupported!!!
--
-- Table: page_tag02
--
-- Comments: 
-- Table: page_tag
-- DROP TABLE page_tag CASCADE;

begin;

CREATE TABLE page_tag (
  page integer NOT NULL,
  tag integer NOT NULL,
  PRIMARY KEY (page, tag)
);



--
-- Table: tag02
--
-- Comments: 
-- Table: tag
-- DROP TABLE tag CASCADE;
CREATE TABLE tag (
  id serial NOT NULL,
  name varchar(32) NOT NULL,
  created timestamp(0) DEFAULT now() NOT NULL,
  PRIMARY KEY (id)
);

CREATE UNIQUE INDEX unique_tag_name on tag (name);

--
-- Foreign Key Definitions
--

ALTER TABLE page_tag ADD FOREIGN KEY (page)
  REFERENCES page (id) ON DELETE cascade ON UPDATE cascade;

ALTER TABLE page_tag ADD FOREIGN KEY (tag)
  REFERENCES tag (id) ON DELETE cascade ON UPDATE cascade;


commit;