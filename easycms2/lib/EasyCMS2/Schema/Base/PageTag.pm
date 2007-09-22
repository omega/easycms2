package EasyCMS2::Schema::Base::PageTag;

use base qw/DBIx::Class/;

use Text::Textile;

my $textile=Text::Textile->new();
$textile->charset('utf-8');



__PACKAGE__->load_components(qw/ResultSetManager PK::Auto Core HTMLWidget/);
__PACKAGE__->table('page_tag');
__PACKAGE__->resultset_class('EasyCMS2::Schema::ResultSet::Tag');

__PACKAGE__->add_columns(
    'page'    => { data_type => 'INTEGER' },
    
    'tag' => { data_type => 'INTEGER' },
);
__PACKAGE__->set_primary_key(qw[page tag]);

__PACKAGE__->belongs_to('page' => 'EasyCMS2::Schema::Base::Page');
__PACKAGE__->belongs_to('tag' => 'EasyCMS2::Schema::Base::Tag');


1;