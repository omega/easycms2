package EasyCMS2::View::JSON;

use strict;
use base 'Catalyst::View::JSON';

__PACKAGE__->config(expose_stash => qr/^help_/);

=head1 NAME

EasyCMS2::View::JSON - Catalyst JSON View

=head1 SYNOPSIS

See L<EasyCMS2>

=head1 DESCRIPTION

Catalyst JSON View.

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
