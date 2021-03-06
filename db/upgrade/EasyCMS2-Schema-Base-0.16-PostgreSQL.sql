--
-- Table: mimetype
--DROP TABLE mimetype CASCADE;
CREATE TABLE mimetype (
  id serial NOT NULL,
  type text NOT NULL,
  name text,
  extensions text,
  icon text,
  PRIMARY KEY (id),
  Constraint "unique_name" UNIQUE (type)
);



--
-- Table: setting
--DROP TABLE setting CASCADE;
CREATE TABLE setting (
  key text NOT NULL,
  value text,
  PRIMARY KEY (key)
);



--
-- Table: template
--DROP TABLE template CASCADE;
CREATE TABLE template (
  id serial NOT NULL,
  name text NOT NULL,
  before text NOT NULL,
  after text NOT NULL,
  parent integer,
  PRIMARY KEY (id),
  Constraint "unique_name3" UNIQUE (name)
);



--
-- Table: category
--DROP TABLE category CASCADE;
CREATE TABLE category (
  id serial NOT NULL,
  parent integer,
  template integer NOT NULL,
  type text DEFAULT 'article' NOT NULL,
  index_page text,
  name text NOT NULL,
  url_name text NOT NULL,
  PRIMARY KEY (id),
  Constraint "url_name_parent" UNIQUE (url_name, parent)
);



--
-- Table: author
--DROP TABLE author CASCADE;
CREATE TABLE author (
  id serial NOT NULL,
  login text NOT NULL,
  email text,
  password text NOT NULL,
  name text NOT NULL,
  PRIMARY KEY (id),
  Constraint "unique_login" UNIQUE (login)
);



--
-- Table: page
--DROP TABLE page CASCADE;
CREATE TABLE page (
  id serial NOT NULL,
  title text NOT NULL,
  url_title text NOT NULL,
  body text NOT NULL,
  author integer NOT NULL,
  template integer,
  category integer NOT NULL,
  created timestamp(0) DEFAULT now() NOT NULL,
  updated timestamp(0) DEFAULT now() NOT NULL,
  PRIMARY KEY (id),
  Constraint "unique_url" UNIQUE (category, url_title)
);



--
-- Table: media
--DROP TABLE media CASCADE;
CREATE TABLE media (
  id serial NOT NULL,
  filename text,
  description text,
  type integer,
  category integer,
  PRIMARY KEY (id)
);

--
-- Foreign Key Definitions
--

ALTER TABLE template ADD FOREIGN KEY (parent)
  REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE category ADD FOREIGN KEY (parent)
  REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE category ADD FOREIGN KEY (template)
  REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE page ADD FOREIGN KEY (template)
  REFERENCES template (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE page ADD FOREIGN KEY (category)
  REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE page ADD FOREIGN KEY (author)
  REFERENCES author (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE media ADD FOREIGN KEY (type)
  REFERENCES mimetype (id);

ALTER TABLE media ADD FOREIGN KEY (category)
  REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE;
