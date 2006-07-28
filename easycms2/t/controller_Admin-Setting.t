use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'EasyCMS2' }
BEGIN { use_ok 'EasyCMS2::Controller::Admin::Setting' }

ok( request('/admin/setting')->is_success, 'Request should succeed' );


