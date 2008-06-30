use strict;
use warnings;
use Test::More tests => 2;

BEGIN { use_ok 'Catalyst::Test', 'EasyCMS2' }
BEGIN { use_ok 'EasyCMS2::Controller::API::XMLRPC' }

#ok( request('/api/xmlrpc')->is_success, 'Request should succeed' );


