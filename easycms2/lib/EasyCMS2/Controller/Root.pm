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
    my $def = $c->setting('default-page');
    if ($def and $def =~ m/^c(\d+)/) {
        my $cat = $c->model('Base::Category')->find($1);
        $c->forward('category/render', [$cat]);
    } else {
        my $page = $c->model('Base::Page')->find($def);
        $c->forward('page/render', [$page]);        
    }
    
}
sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;
    
}

sub default : Private {
    my ( $self, $c , @args) = @_;
    
    # each entry in @args is a part of the path. It should either point at a 
    # page or a category. In case of a category, we try to render the index 
    # method of that category.
    # It can also be a tag, it then starts with !
    # alternate rendering formats are available as .<view>

    my ($tag);
    $c->log->debug("args: " . scalar(@args));
    foreach my $i (0 .. scalar(@args)) {
        $c->log->debug($args[$i]);
        if ($args[$i] && $args[$i] =~  m/!(.+)/) {
            my $t = $1;
            $t =~ s/\+/ /g;
            $c->log->debug("tag: $t");
            delete $args[$i];
            $tag = $c->model('Base::Tag')->find({ name => $t});
        }
        elsif ($args[$i] && $args[$i] =~ m/\.(.+)/) {
            $c->stash->{'current_view'} = $1;
            delete $args[$i];
        }
    }
    $c->log->debug("args: " . scalar(@args));
    
    return $c->detach('index') if scalar(@args) == 0;

    my $parent_category;
    my $page;
    my $category;
    my $catch_all;
    my @catch_all_args;
    while (my $path_part = shift @args) {
        $category = $c->model('Base::Category')->search({ url_name => $path_part,
            parent => ($parent_category ? $parent_category->id : undef ) })->first;
        if ($category) {
            # we found a category for this path_part, so we try the next
            $parent_category = $category;
            # The category has signaled that it wants to catch everything!
            if ($category->catch_all) {
                $catch_all = $category;
                @catch_all_args = @args;
            }
            next;
        } else {
            # we found no category. We should try to find a page perhaps?
            $page = $c->model('Base::Page')->find({url_title => $path_part, 
                category => ( $parent_category ? $parent_category->id : undef)});
            last;
        }
    }
    if ($catch_all) {
        $category = $catch_all;
        @args = @catch_all_args;
    }
    
    return $c->detach('/error/no_page') unless ($category || $page);
    if ($page) {
        $c->stash->{title} = $page->title;
        $c->forward('page/render', [$page]);
    } elsif ($category) {
        $c->stash->{rest_path} = join('/', grep { $_ && $_ ne ''} @args);
        $c->log->debug('restpath: ' . $c->stash->{rest_path});
        $c->forward('category/render', [$category, $tag]);
    }
   
}

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
