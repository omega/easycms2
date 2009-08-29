package EasyCMS2::Schema::Base;

use strict;
use warnings;
use POSIX 'strftime';

use base qw/DBIx::Class::Schema/;

__PACKAGE__->load_classes();
__PACKAGE__->load_components(qw/Schema::Versioned/);

our $VERSION = '0.28';

sub urify {
    my ($self, $s) = @_;
    $s = lc($s);
    $s =~ s/[^a-z0-9_-]+/_/g;
    
    return $s;
}

1;