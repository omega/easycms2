-- Convert schema '/Users/andremar/Projects/EasyCMS2/db/upgrade/Base-0.01-SQLite.sql' to '/Users/andremar/Projects/EasyCMS2/db/upgrade/Base-0.02-SQLite.sql':

ALTER TABLE setting CHANGE value TEXT;
ALTER TABLE template DROP INDEX unique_name_template02;
ALTER TABLE category DROP INDEX url_name_parent_category02;
ALTER TABLE author DROP INDEX unique_login_author02;
ALTER TABLE page DROP INDEX unique_url_page02;
ALTER TABLE template ADD UNIQUE unique_name_template (name);
ALTER TABLE category ADD UNIQUE url_name_parent_category (url_name, parent);
ALTER TABLE author ADD UNIQUE unique_login_author (login);
ALTER TABLE page ADD UNIQUE unique_url_page (category, url_title);

