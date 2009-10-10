package EasyCMS2::Schema::Base::Tag;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/UTF8Columns TimeStamp Core/);
__PACKAGE__->table('tag');
__PACKAGE__->resultset_class('EasyCMS2::Schema::ResultSet::Tag');

__PACKAGE__->add_columns(
    'id'    => { data_type => 'INTEGER', is_auto_increment => 1 },
    
    'name' => { data_type => 'VARCHAR', size => 32 },
    'created' => {data_type => 'TIMESTAMP', set_on_create => 1},
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->utf8_columns(qw/name/);

__PACKAGE__->add_unique_constraint('unique_tag_name' => ['name']);
__PACKAGE__->has_many('_page_tags' => 'EasyCMS2::Schema::Base::PageTag', 'tag');
__PACKAGE__->many_to_many('pages' => '_page_tags', 'page');


1;