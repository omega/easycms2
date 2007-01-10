use strict;
use warnings;
use Test::More tests => 8;

BEGIN {
    use_ok("EasyCMS2::CategoryType");
}

my $type = EasyCMS2::CategoryType->new({id => 'test'});

isa_ok($type, "EasyCMS2::CategoryType::Test");

is($type->id, 'test');

is($type->index->{test}, 'test-value');
is($type->catch_all, 0);


my $catchAll = EasyCMS2::CategoryType->new({id => 'test_catch_all'});

isa_ok($catchAll, "EasyCMS2::CategoryType::TestCatchAll");

is($catchAll->id, 'test_catch_all');
is($catchAll->catch_all, 1);