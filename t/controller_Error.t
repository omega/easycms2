use strict;
use warnings;
use Test::More tests => 4;

BEGIN { use_ok 'Catalyst::Test', 'EasyCMS2' }
BEGIN { use_ok 'EasyCMS2::Controller::Error' }

ok( request('/error/no_page')->is_error, 'Request should succeed' );
ok( request('/error/no_category')->is_error, 'Request should succeed' );


