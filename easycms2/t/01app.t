use strict;
use warnings;
use Test::More tests => 2;
use Data::Dumper::Simple;

BEGIN { use_ok 'Catalyst::Test', 'EasyCMS2' }

ok( request('/')->is_success, 'Request should succeed' );

my $sizes = EasyCMS2->config()->{'media'};
foreach (@{$sizes->{resizes}}) {
    diag(Dumper($_));
}