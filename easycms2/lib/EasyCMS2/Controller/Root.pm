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
    
    # each entry in @args is a part of the path. It should either point at a 
    # page or a category. In case of a category, we try to render the index 
    # method of that category.

    my $parent_category;
    my $page;
    my $category;
    while (my $path_part = shift @args) {
        $category = $c->model('Base::Category')->search({ url_name => $path_part,
            parent => ($parent_category ? $parent_category->id : undef ) })->first;
        if ($category) {
            # we found a category for this path_part, so we try the next
            $parent_category = $category;
            next;
        } else {
            # we found no category. We should try to find a page perhaps?
            $page = $c->model('Base::Page')->find({url_title => $path_part, category => $parent_category->id});
            last;
        }
    }
    
=pod
    my $page = pop @args;
    
    my $parent_category;
    my $category;
    while (my $category_url_name = shift @args) {
        
        $category = $c->model('Base::Category')->search({url_name => $category_url_name, 
            parent => ($parent_category ? $parent_category->id : undef)})->first;
        $parent_category = $category;
    }
    return $c->detach('/error/no_category') unless $category;
    
    $page = $c->model('Base::Page')->find({url_title => $page, category => $category->id});
=cut
    
    return $c->detach('/error/no_page') unless ($category || $page);
    if ($page) {
        $c->stash->{title} = $page->title;
        $c->forward('page/render', [$page]);
    } elsif ($category) {
        $c->stash->{title} = $category->name;
        $c->forward('category/render', [$category]);
    }
   
}

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
