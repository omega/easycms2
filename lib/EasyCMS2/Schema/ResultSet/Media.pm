package EasyCMS2::Schema::ResultSet::Media;

use base 'DBIx::Class::ResultSet';


sub images {
    my $self = shift;
    
    return $self->search({'type.type' => [qw(image/png image/jpeg image/gif)]}, {join => 'type', prefetch => 'type'});
}

1;
