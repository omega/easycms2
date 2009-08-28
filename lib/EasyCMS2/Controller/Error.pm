package EasyCMS2::Controller::Error;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

EasyCMS2::Controller::Error - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    $c->log->error('Request->path: ' . $c->request->path);
    return 1;
}

sub no_category : Local {
    my ( $self, $c ) = @_;    
    $c->res->status('404');
    $c->stash->{template} = 'error/404.tt';    
}
sub no_page : Local {
    my ( $self, $c ) = @_;    
    $c->res->status('404');
    $c->stash->{template} = 'error/404.tt';    
}


=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
