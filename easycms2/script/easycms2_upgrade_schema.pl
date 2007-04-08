#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../Other/dbic-current/lib";

use EasyCMS2;
use EasyCMS2::Schema::Base;

my $cfg = EasyCMS2->config->{db};
my $upgrade = shift;

if (defined($upgrade) and $upgrade eq '--upgrade') {
    my $schema = EasyCMS2->model('Base')->schema->upgrade;
} else {
    print "please specify --upgrade as commandline parameter to perform upgrade\n";    
}

package DBIx::Class::Storage::DBI;
sub backup {  
}
1;