use strict;
use warnings;
use Test::More tests => 2;
use Data::Dumper::Simple;

BEGIN {
    use_ok("EasyCMS2");
}

is(EasyCMS2->get_snippet('/blog/asfsdf'), "APEJENS");
