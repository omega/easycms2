use strict;
use warnings;
use Test::More tests => 1;

use Imager;

use Data::Dumper::Simple;

is(1, 1);

my $img = Imager->new();
diag(Dumper(%Imager::formats));
