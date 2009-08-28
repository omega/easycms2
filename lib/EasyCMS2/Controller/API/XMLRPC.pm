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
    $c->forward('login', $user, $pass);
    
#    $c->log->debug('app: ' . $appkey . ', user: ' . $user . ', pass: ' . $pass) if $c->debug;
    
    # Find the categories
    my $cats = $c->model('Base::Category')->search({
        type    => 'blog',
    });

    my @res;
    while (my $cat = $cats->next) {
        push(@res, {
            url         => $c->req->base . $cat->uri_for($c),
            blogName    => $cat->name,
            blogid      => $cat->id,
        });
    }
    $c->stash->{xmlrpc} = \@res if scalar(@res);
    
}

sub simple_page_list : XMLRPCPath('/wp/getPageList') {
    my ( $self, $c ) = @_;
    my ($id, $user, $pass) = @{ $c->req->xmlrpc->args };
    $c->forward('login', $user, $pass);
    
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
    my ($id, $user, $pass) = @{ $c->req->xmlrpc->args };
    $c->forward('login', $user, $pass);
    
    my $pages = $c->model('Base::Page')->search({
        category => {'!=', $id}
    });
    my @res;
    while (my $page = $pages->next) {
        push(@res, {
            page_id         => $page->id,
            title           => $page->title,
            permaLink       => $c->req->base . $page->uri_for($c),
            description     => $page->body,
            dateCreated     => $page->created . '',
        });
    }
    $c->stash->{xmlrpc} = \@res if scalar(@res);
    
    
}
sub recent_posts : XMLRPCPath('/metaWeblog/getRecentPosts') {
    my ( $self, $c ) = @_;
    
    my ($id, $user, $pass, $number) = @{ $c->req->xmlrpc->args };
    $c->forward('login', $user, $pass);
    
    $c->log->debug('id: ' . $id . ', user: ' 
        . $user . ', pass: ' . $pass . ", number: " . $number) if $c->debug;
    
    my $cat = $c->model('Base::Category')->find({id => $id}) or return;
    
    
    my $pages = $cat->pages({}, {
        order_by    => 'created DESC',
        rows        => $number || 10,
    });
    my @res;
    while (my $page = $pages->next) {
        push(@res, {
            link                => $c->req->base . $page->uri_for($c),
            permaLink           => $c->req->base . $page->uri_for($c),
            userid              => $page->id,
            mt_allow_pings      => 0,
            mt_allow_comments   => $page->allow_comments,
            description         => $page->body,
            mt_convert_breaks   => 0,
            postid              => $page->id,
            mt_excerpt          => '',
            mt_keywords         => $page->get_tags,
            
            title               => $page->title,
            mt_text_more        => '',
            dateCreated         => $page->created . '',
            
        });
    }
    
    $c->stash->{xmlrpc} = \@res if scalar(@res);
    
}

sub category_list : XMLRPCPath('/mt/getCategoryList') {
    my ( $self, $c ) = @_;
    
    my ($id, $user, $pass) = @{ $c->req->xmlrpc->args };
    $c->forward('login', $user, $pass);
    
    my $cats = $c->model('Base::Category')->search({
    });
    my @res;
    while (my $cat = $cats->next) {
        push(@res, {
            categoryId      => $cat->id,
            categoryName    => $cat->name,
        });
    }
    $c->stash->{xmlrpc} = \@res if scalar(@res);
}


sub new_post : XMLRPCPath('/metaWeblog/newPost') {
    my ( $self, $c ) = @_;
    
    my ($id, $user, $pass, $content, $publish) = @{ $c->req->xmlrpc->args };
    $c->forward('login', $user, $pass);
    
    my $cat = $c->model('Base::Category')->find($id);
    # need to look for the page.
    my $page = $cat->pages->find_or_new({
        url_title => $c->model('Base')->schema->urify($content->{title}),
        author      => $c->user->id,
    });
    $page->title($content->{title});
    $page->body($content->{description});

    $page->insert_or_update;
    
    $page->set_tags($content->{mt_keywords}) if $content->{mt_keywords};
    
    
    $c->stash->{xmlrpc} = $page->id;
    
}

sub login : Private {
    my ( $self, $c, $user, $pass ) = @_;
    if ($c->authenticate( {
        username => $user,
        password => $pass
    }, "authors")) {
        # We could log in good..
    } else {
        die "Could not log you in";
    }
}


sub set_categories : XMLRPCPath('/mt/setPostCategories') {
    my ( $self, $c ) = @_;
    
}

sub publish_post : XMLRPCPath('/mt/publishPost') {
    my ( $self, $c ) = @_;
    
}

sub delete_post : XMLRPCPath('/blogger/deletePost') {
    my ( $self, $c ) = @_;
    
    my ($appkey, $id, $user, $pass) = @{$c->req->xmlrpc->args};
    
    my $page = $c->model('Base::Page')->find($id) || return;
    
    $page->remove;
    
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
