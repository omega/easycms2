use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'EasyCMS2' }
BEGIN { use_ok 'EasyCMS2::Controller::Auth' }

TODO: {
    local $TODO = "Not implemented";
    ok( request('/auth/login')->is_success, 'Request should succeed' );
}

