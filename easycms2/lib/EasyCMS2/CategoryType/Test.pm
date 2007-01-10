package EasyCMS2::CategoryType::Test;
use strict;
use warnings;

use Moose;

extends 'EasyCMS2::CategoryType';

override  'index' => sub {
    my $self = shift;
    my $hashref = {};
    $hashref->{'test'} = 'test-value';
    return $hashref;
};

override 'public' => sub {
    return 0;
};
1;
