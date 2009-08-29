package EasyCMS2::Controller::Javascript;

use strict;
use warnings;
use base 'Catalyst::Controller';
__PACKAGE__->config->{unsafe_bindlex_ok} = 1;

=head1 NAME

EasyCMS2::Controller::Javascript - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub setup : Local {
    my ( $self, $c ) = @_;

    # Hello World
    $c->response->content_type('text/javascript');
    my $body = 
        "var imgbase = '" . $c->uri_for('/static/images')->path_query . "';\n" . 
        "var urlbase = '" . $c->uri_for('/')->path_query . "';"
    ;
    
    $c->response->body($body);
    $c->log->abort(1);
}

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
