package EasyCMS2::CategoryType::Article;

use Moose;

extends 'EasyCMS2::CategoryType';

override  'index' => sub {
    my $self = shift;
    my $hashref = {};
    $hashref->{'pages'} = $self->row->pages({});
    return $hashref;
};


1;
