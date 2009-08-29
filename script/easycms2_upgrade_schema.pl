#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use EasyCMS2;

my $cfg = EasyCMS2->config->{'Model::Base'};
my $upgrade = shift;

my $schema = EasyCMS2->model('Base')->schema;
if (defined($upgrade) and $upgrade eq '--upgrade') {
    
    if  (!$schema->get_db_version) {
        $schema->deploy();
    } else {
        $schema->upgrade;
    }
} else {
    print <<END
please specify one of the following:
    --upgrade       To perform an upgrade from your current to the newest
    --dryrun        To dryrun an upgrade. Best used with DBIC_TRACE=1
END
}

=pod
package DBIx::Class::Storage::DBI;
sub backup {  
}

=cut

1;