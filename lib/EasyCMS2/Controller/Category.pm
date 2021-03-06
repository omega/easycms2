package EasyCMS2::Controller::Category;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';
__PACKAGE__->config->{unsafe_bindlex_ok} = 1;

=head1 NAME

EasyCMS2::Controller::Category - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub render : Local {
    my ( $self, $c ) = @_;
    
    my $cat : Stashed = $c->req->args->[0];
    my $tag : Stashed = $c->req->args->[1];
    my $stash_add = $cat->prepare_index($c, $c->stash->{rest_path});
    foreach my $key (keys %$stash_add) {
        $c->log->debug('adding ' . $key . ' : ' . $stash_add->{$key}) if $c->debug;
        $c->stash->{category}->{$key} = $stash_add->{$key};
    }
    $c->log->debug('rendering category ' . $cat->id) if $c->debug;
    if ($cat) {
        $c->stash->{templ} = $cat->template;
        $c->stash->{template} = 'category/render.tt';    
        $c->stash->{cat} = $cat;
        $c->stash->{title} = $cat->name;
    } else {
        return $c->detach('/error/no_page');
    }
    
}
sub cat : Chained('/') PathPart('category') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $cat : Stashed = $c->model('Base::Category')->find($id); 
}
sub css : Chained('cat') Args(0) {
    my ( $self, $c ) = @_;
    $c->log->abort(1) if $c->log->can('abort');
    
    my $cat : Stashed;

    my $css = ($cat and $cat->css ? $cat->css : ' ');
    
    $c->res->body($css);
    $c->res->status(200);
    $c->res->content_type('text/css');
}
sub js : Chained('cat') Args(0) {
    my ( $self, $c ) = @_;
    $c->log->abort(1) if $c->log->can('abort');
    
    my $cat : Stashed;

    my $js = ($cat and $cat->js ? $cat->js : ' ');
    
    $c->res->body($js);
    $c->res->status(200);
    $c->res->content_type('text/javascript');
}

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
