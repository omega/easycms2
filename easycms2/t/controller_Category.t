use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'EasyCMS2' }
BEGIN { use_ok 'EasyCMS2::Controller::Category' }

TODO: {
    local $TODO = "Not implemented";
    ok( request('/category/')->is_success, 'Request should succeed' );
}

