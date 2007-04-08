#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../Other/dbic-current/lib";

use EasyCMS2;

use EasyCMS2::Schema::Base;

my $cfg = EasyCMS2->config->{db};

my $schema = EasyCMS2->model('Base')->schema;

my $pversion = shift;

if ($pversion) {
    warn "creating upgradefiles from $pversion to " . $schema->VERSION;
} else {
    warn "creating bare files";
    $pversion = undef;
}

$schema->create_ddl_dir([qw/PostgreSQL MySQL SQLite/], $schema->VERSION, $cfg->{upgrade}, $pversion);
