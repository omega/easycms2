package EasyCMS2::CategoryType::Gallery;

use Moose;

extends 'EasyCMS2::CategoryType';

override  'index' => sub {
    my $self = shift;
    my $hashref = {};
    $hashref->{'pictures'} = $self->row->pictures({});
    return $hashref;
};

1;
