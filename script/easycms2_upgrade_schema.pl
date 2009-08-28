#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use EasyCMS2;
use EasyCMS2::Schema::Base;

my $cfg = EasyCMS2->config->{db};
my $upgrade = shift;

if (defined($upgrade) and $upgrade eq '--upgrade') {
    EasyCMS2->model('Base')->schema->upgrade;
} elsif (defined($upgrade) and $upgrade eq '--dryrun') {
    EasyCMS2->model('Base')->schema->upgrade(1);
} else {
    print <<END
please specify one of the following:
    --upgrade       To perform an upgrade from your current to the newest
    --dryrun        To dryrun an upgrade. Best used with DBIC_TRACE=1
END
}

package DBIx::Class::Storage::DBI;
sub backup {  
}
1;