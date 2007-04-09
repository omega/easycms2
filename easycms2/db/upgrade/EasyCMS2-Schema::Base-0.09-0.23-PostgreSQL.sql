-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.09-PostgreSQL.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.23-PostgreSQL.sql':

-- Target database PostgreSQL is untested/unsupported!!!
--
-- Table: snippet02
--
-- Comments: 
-- Table: snippet
-- DROP TABLE snippet CASCADE;
CREATE TABLE "snippet" (
  "id" serial NOT NULL,
  "category" integer NOT NULL,
  "text" text NOT NULL,
  "name" text NOT NULL,
  PRIMARY KEY ("id")
);



--
-- Table: comment02
--
-- Comments: 
-- Table: comment
-- DROP TABLE comment CASCADE;
CREATE TABLE "comment" (
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

ALTER TABLE "snippet" ADD FOREIGN KEY ("category")
  REFERENCES "category" ("id") ON DELETE cascade ON UPDATE cascade;

ALTER TABLE "comment" ADD FOREIGN KEY ("page")
  REFERENCES "page" ("id") ON DELETE cascade ON UPDATE cascade;

ALTER TABLE template CHANGE parent integer(10);
ALTER TABLE page ADD allow_comments integer(10);
ALTER TABLE page ADD extra text;
ALTER TABLE page ADD extra_search1 text;
ALTER TABLE page ADD extra_search2 text;
ALTER TABLE page ADD from_date timestamp;
ALTER TABLE page ADD to_date timestamp;
ALTER TABLE page CHANGE author integer(10) NOT NULL;
ALTER TABLE page CHANGE template integer(10);
ALTER TABLE page CHANGE category integer(10) NOT NULL;
ALTER TABLE media ADD category integer(10);
ALTER TABLE media CHANGE type integer(10);
ALTER TABLE category ADD type text DEFAULT 'article' NOT NULL;
ALTER TABLE category ADD index_page text;
ALTER TABLE category ADD allow_comments integer(10);
ALTER TABLE category ADD css text;
ALTER TABLE category ADD js text;
ALTER TABLE category ADD config text;
ALTER TABLE category CHANGE parent integer(10);
ALTER TABLE category CHANGE template integer(10) NOT NULL;
ALTER TABLE media ADD CONSTRAINT FOREIGN KEY (category) REFERENCES category (id) ON DELETE cascade ON UPDATE cascade;
ALTER TABLE category ADD ;

