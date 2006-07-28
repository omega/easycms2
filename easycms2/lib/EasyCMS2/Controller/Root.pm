package EasyCMS2::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

=head1 NAME

EasyCMS2::Controller::Root - Root Controller for this Catalyst based application

=head1 SYNOPSIS

See L<EasyCMS2>.

=head1 DESCRIPTION

Root Controller for this Catalyst based application.

=head1 METHODS

=cut

=head2 default

=cut

sub auto : Private {
    my ($self, $c) = @_;
    
    $c->stash->{submenu} = 'submenu.tt';
    return 1;
}
sub index : Private {
    my ( $self, $c ) = @_;
    my $page = $c->model('Base::Page')->find($c->setting('default-page'));
    $c->forward('page/render', [$page]);
    
}
sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;
    
}

sub default : Private {
    my ( $self, $c , @args) = @_;
    
    my $page = pop @args;
    
    my $parent_category;
    my $category;
    while (my $category_url_name = shift @args) {
        
        $category = $c->model('Base::Category')->search({url_name => $category_url_name, parent => ($parent_category ? $parent_category->id : undef)})->first;
        $parent_category = $category;
    }
    return $c->detach('/error/no_category') unless $category;
    
    $page = $c->model('Base::Page')->find({url_title => $page, category => $category->id});
    $c->forward('page/render', [$page]);
   
}

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
