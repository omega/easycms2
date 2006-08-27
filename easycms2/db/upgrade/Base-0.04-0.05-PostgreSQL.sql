-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.04-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/Base-0.05-PostgreSQL.sql':

-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sat Aug 26 12:00:29 2006
-- 
--
-- Table: mimetype
--

-- Comments: 
-- Foreign Key Definitions
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sat Aug 26 12:00:24 2006
-- Table: mimetype
--

CREATE TABLE "mimetype" (
  "id" serial NOT NULL,
  "type" text NOT NULL,
  "name" text NOT NULL,
  "icon" text NOT NULL,
  PRIMARY KEY ("id")
);

--
-- Table: media
--

-- Comments: 
-- Table: media
--

CREATE TABLE "media" (
  "id" serial NOT NULL,
  "filename" text NOT NULL,
  "description" text NOT NULL,
  "type" integer NOT NULL,
  PRIMARY KEY ("id")
);

--
-- Foreign Key Definitions
--

ALTER TABLE media ADD FOREIGN KEY ("type")
  REFERENCES mimetype ("id");
ALTER TABLE template ADD CONSTRAINT FOREIGN KEY (parent) REFERENCES template (id) ON DELETE cascade ON UPDATE cascade;
ALTER TABLE category ADD CONSTRAINT FOREIGN KEY (parent) REFERENCES category (id) ON DELETE cascade ON UPDATE cascade;
ALTER TABLE category ADD CONSTRAINT FOREIGN KEY (template) REFERENCES template (id) ON DELETE cascade ON UPDATE cascade;
ALTER TABLE page ADD CONSTRAINT FOREIGN KEY (template) REFERENCES template (id) ON DELETE cascade ON UPDATE cascade;
ALTER TABLE page ADD CONSTRAINT FOREIGN KEY (category) REFERENCES category (id) ON DELETE cascade ON UPDATE cascade;

