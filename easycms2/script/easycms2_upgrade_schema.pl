#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../Other/dbic-current/lib";

use EasyCMS2::Schema::Base;
use EasyCMS2;

my $cfg = EasyCMS2->config->{db};
my $upgrade = shift;

my $schema = EasyCMS2->model('Base')->schema->upgrade if (defined $upgrade && $upgrade eq "--upgrade");
print "please specify --upgrade as commandline parameter to perform upgrade" unless (defined $upgrade && $upgrade ne "--upgrade");
