package EasyCMS2::Controller::Category;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

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
    
    my $category : Stashed = $c->req->args->[0];
    
    my $stash_add = $category->prepare_index($c, $c->stash->{rest_path});
    foreach my $key (keys %$stash_add) {
        $c->log->debug('adding ' . $key . ' : ' . $stash_add->{$key});
        $c->stash->{category}->{$key} = $stash_add->{$key};
    }
    $c->log->debug('rendering category ' . $category->id);
    if ($category) {
        $c->stash->{templ} = $category->template;
        $c->stash->{template} = 'category/render.tt';    
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
