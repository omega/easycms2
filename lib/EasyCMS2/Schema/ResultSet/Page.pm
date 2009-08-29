package EasyCMS2::Schema::ResultSet::Page;

use base 'DBIx::Class::ResultSet';

sub links {
    my $self = shift;
    
    return $self->search({}, {order_by => 'title'});
}


1;