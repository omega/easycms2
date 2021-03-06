package EasyCMS2::Controller::Page;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';
__PACKAGE__->config->{unsafe_bindlex_ok} = 1;

=head1 NAME

EasyCMS2::Controller::Page - Catalyst Controller

=head1 SYNOPSIS

See L<EasyCMS2>

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub render : Local {
    my ( $self, $c ) = @_;
    
    my $page : Stashed = $c->req->args->[0];
    
    if ($page) {
        $c->stash->{templ} = $page->template || $page->category->template;
        $c->log->debug('setting cat to ' . $page->category) if $c->debug;
        $c->stash->{cat} = $page->category;

        $c->stash->{template} = 'page/render.tt';    
    } else {
        return $c->detach('/error/no_page');
    }
    
}

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
