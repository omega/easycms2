#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use EasyCMS2;

my $cfg = EasyCMS2->config->{'Model::Base'};

my $schema = EasyCMS2->model('Base')->schema;

my $pversion = shift;

if ($pversion) {
    warn "creating upgradefiles from $pversion to " . $schema->VERSION;
} else {
    warn "creating bare files";
    $pversion = undef;
}

$schema->create_ddl_dir(
    [qw/PostgreSQL MySQL SQLite/], 
    $schema->schema_version, 
    $cfg->{upgrade_directory}, 
    $pversion
);
