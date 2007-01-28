-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.16-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.17-PostgreSQL.sql':

-- Target database PostgreSQL is untested/unsupported!!!
--
-- Table: snippet02
--
-- Comments: 
-- Table: snippet
-- DROP TABLE snippet CASCADE;
--CREATE TABLE "snippet02" (
  "id" serial NOT NULL,
  "category" integer NOT NULL,
  "text" text NOT NULL,
  PRIMARY KEY ("id")
);



--
-- Table: comment02
--
-- Comments: 
-- Table: comment
-- DROP TABLE comment CASCADE;
--CREATE TABLE "comment02" (
  "id" serial NOT NULL,
  "title" text NOT NULL,
  "url_title" text NOT NULL,
  "body" text NOT NULL,
  "commenter" text NOT NULL,
  "page" integer NOT NULL,
  "created" timestamp(0) DEFAULT now() NOT NULL,
  "updated" timestamp(0) DEFAULT now() NOT NULL,
  PRIMARY KEY ("id")
);

--
-- Foreign Key Definitions
--

ALTER TABLE "snippet02" ADD FOREIGN KEY ("category")
  REFERENCES "category" ("id") ON DELETE cascade ON UPDATE cascade;

ALTER TABLE "comment02" ADD FOREIGN KEY ("page")
  REFERENCES "page" ("id");


