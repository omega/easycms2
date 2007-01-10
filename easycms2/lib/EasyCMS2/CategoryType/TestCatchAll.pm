package EasyCMS2::CategoryType::TestCatchAll;
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

override 'catch_all' => sub {
    return 1;
};

1;
