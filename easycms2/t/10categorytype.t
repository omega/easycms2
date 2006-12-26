use strict;
use warnings;
use Test::More tests => 4;

BEGIN {
    use_ok("EasyCMS2::CategoryType");
}

my $type = EasyCMS2::CategoryType->new({id => 'test'});

isa_ok($type, "EasyCMS2::CategoryType::Test");

is($type->id, 'test');

is($type->index->{test}, 'test-value');