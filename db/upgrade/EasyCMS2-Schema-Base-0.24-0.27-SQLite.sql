-- Convert schema '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.24-SQLite.sql' to '/Users/andremar/Projects/easycms2/db/upgrade/EasyCMS2-Schema::Base-0.27-SQLite.sql':

-- Target database SQLite is untested/unsupported!!!
ALTER TABLE mimetype CHANGE type varchar(255) NOT NULL;
ALTER TABLE setting CHANGE key varchar NOT NULL;
ALTER TABLE template CHANGE name varchar(255) NOT NULL;
ALTER TABLE page CHANGE url_title varchar(255) NOT NULL;
ALTER TABLE page CHANGE from_date date;
ALTER TABLE page CHANGE to_date date;
ALTER TABLE category CHANGE type varchar(64) NOT NULL DEFAULT 'article';
ALTER TABLE category CHANGE url_name varchar(255) NOT NULL;
ALTER TABLE author CHANGE login varchar(255) NOT NULL;

