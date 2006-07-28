package EasyCMS2::Schema::Base::Author;

use base qw/DBIx::Class/;
use Digest::SHA1 qw/sha1_hex/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('author');

__PACKAGE__->add_columns(
    'id'    => { data_type => 'INTEGER', is_auto_increment => 1},
    
    'login' => { data_type => 'TEXT' },
    'email' => { data_type => 'TEXT', is_nullable => 1 },
    'password' => { data_type => 'TEXT' },
    
    'name' => { data_type => 'TEXT' },
    
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint('unique_login' => ['login']);
__PACKAGE__->has_many('pages' => EasyCMS2::Schema::Base::Page, 'author');

sub store_column {
	my ($self, $column, $value, @rest) = @_;
	
	if ($column eq 'password') {
		$value = sha1_hex($value);
	}
	
	return $self->next::method($column, $value, @rest);
}

1;