package EasyCMS2::Controller::API::XMLRPC;

use strict;
use warnings;
use base 'Catalyst::Controller';

use Data::Dump qw(dump);

=head1 NAME

EasyCMS2::Controller::API::MT - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub text_filters : XMLRPCPath('/mt/supportedTextFilters') {
    my ( $self, $c ) = @_;
    $c->stash->{xmlrpc} = [{
        label => 'unknown',
        key => '__default__',
    }];
}

sub blogs : XMLRPCPath('/blogger/getUsersBlogs') {
    my ( $self, $c ) = @_;
    
    my ($appkey, $user, $pass) = @{$c->req->xmlrpc->args};
#    $c->log->debug('app: ' . $appkey . ', user: ' . $user . ', pass: ' . $pass) if $c->debug;
    
    # Find the categories
    my $cats = $c->model('Base::Category')->search({
        type    => 'blog',
    });
    $c->log->debug($cats) if $c->debug;
    my @res;
    while (my $cat = $cats->next) {
        $c->log->debug('adding cat: ' . $cat->name) if $c->debug;
        push(@res, {
            url         => $c->req->base . $cat->uri_for($c),
            blogName    => $cat->name,
            blogid      => $cat->id,
        });
    }
    $c->log->debug(dump(@res)) if $c->debug;
    $c->stash->{xmlrpc} = \@res if scalar(@res);
    
}

sub simple_page_list : XMLRPCPath('/wp/getPageList') {
    my ( $self, $c ) = @_;
    my ($id, $user, $pass) = @{ $c->req->xmlrpc->args };
#    $c->log->debug('id: ' . $id . ', user: ' . $user . ', pass: ' . $pass) if $c->debug;
    
    my $pages = $c->model('Base::Page')->search({
        category => {'!=', $id}
    });
    my @res;
    while (my $page = $pages->next) {
        push(@res, {
            page_id     => $page->id,
            page_title  => $page->title,
            page_parent_id  => $page->category->id,
            datetime        => $page->created . '',
        });
    }
    $c->stash->{xmlrpc} = \@res if scalar(@res);
}

sub complex_page_list : XMLRPCPath('/wp/getPages') {
    my ( $self, $c ) = @_;
    
}
sub recent_posts : XMLRPCPath('/metaWeblog/getRecentPosts') {
    my ( $self, $c ) = @_;
    
    my ($id, $user, $pass, $number) = @{ $c->req->xmlrpc->args };
    
    $c->log->debug('id: ' . $id . ', user: ' 
        . $user . ', pass: ' . $pass . ", number: " . $number) if $c->debug;
    
    
    
}

sub category_list : XMLRPCPath('/mt/getCategoryList') {
    my ( $self, $c ) = @_;
    
}
sub end : Private {
    
}
=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
