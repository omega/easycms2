package EasyCMS2::Schema::Base::Setting;

use base qw/DBIx::Class/;
__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('setting');
__PACKAGE__->add_columns(
    'key' => { data_type => 'TEXT' },
    'value' => { data_type => 'TEXT', is_nullable => 1 }
);

__PACKAGE__->add_unique_constraint('unique_key' => ['key']);

__PACKAGE__->set_primary_key('key');

1;

