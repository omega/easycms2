package EasyCMS2::Controller::Template;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';
__PACKAGE__->config->{unsafe_bindlex_ok} = 1;

=head1 NAME

EasyCMS2::Controller::Template - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub template : Chained('/') PathPart('template') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->log->abort(1) if $c->log->can('abort');
    
    my $template : Stashed = $c->model('Base::Template')->find($id); 
}

sub css : Chained('template') Args(0) {
    my ( $self, $c ) = @_;
    
    my $template : Stashed;
    my $css = $template->get_css;
    $c->log->debug($template->id) if $c->debug;
    if ($css and $css ne '') {
        $c->res->body($css);
        $c->res->status(200);
        $c->res->content_type('text/css');
    } else {
        $c->res->status(204);
        $c->res->content_type('text/css');
    }
}

sub js : Chained('template') Args(0) {
    my ( $self, $c ) = @_;
    $c->log->abort(1) if $c->log->can('abort');
    
    my $template : Stashed;

    my $js = $template->get_js;
    
    if ($js and $js ne '') {
        $c->res->body($js || ' ');
        $c->res->status(200);
        $c->res->content_type('text/javascript');
    } else {
        $c->res->status(204);
        $c->res->content_type('text/javascript');
    }
}


=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
