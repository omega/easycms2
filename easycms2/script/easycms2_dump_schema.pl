#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../Other/SQL-Translator-0.08_01/lib";
use lib "$FindBin::Bin/../../Other/dbic-versioning/lib";

use EasyCMS2::Schema::Base;
use EasyCMS2;

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
