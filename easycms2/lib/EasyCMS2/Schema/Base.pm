package EasyCMS2::Schema::Base;

use strict;
use warnings;

use base qw/DBIx::Class::Schema/;
__PACKAGE__->load_classes(qw/Page Template Author Category   Setting/);
__PACKAGE__->load_components(qw/+DBIx::Class::Schema::Versioned/);

our $VERSION = '0.04';
1;