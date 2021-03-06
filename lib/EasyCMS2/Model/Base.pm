package EasyCMS2::Model::Base;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

use EasyCMS2::Schema::Base;

__PACKAGE__->config(
    schema_class => 'EasyCMS2::Schema::Base',
);


=head1 NAME

EasyCMS2::Model::Base - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<EasyCMS2>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema
L<>

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
