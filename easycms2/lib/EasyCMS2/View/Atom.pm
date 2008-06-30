package EasyCMS2::View::Atom;

use strict;
use warnings;
use base 'Catalyst::View';

__PACKAGE__->mk_accessors(qw(updated));

use XML::Atom::Feed;
use XML::Atom::Link;
use XML::Atom::Entry;
use XML::Atom::Content;
use XML::Atom::Person;

$XML::Atom::DefaultVersion = "1.0";

sub process {
    my ($self, $c) = @_;
    
    my $feed = XML::Atom::Feed->new();
    $feed->title($c->stash->{'cat'}->name);
    $feed->id($c->uri_for($c->stash->{'cat'}->uri_for($c)));
    
    my $link = XML::Atom::Link->new;
    $link->type('text/html');
    $link->rel('alternate');
    $link->href($c->uri_for($c->stash->{'cat'}->uri_for($c)));
    $feed->add_link($link);
    
    my $self_link = XML::Atom::Link->new;
    $self_link->type('application/atom+xml');
    $self_link->rel('self');
    $self_link->href($c->uri_for($c->req->path));
    
    $feed->add_link($self_link); 
    
    my $pages = $c->stash->{'category'}->{'posts'};
    my $updated = DateTime->from_epoch(epoch => 1);
    my @entries;
    unless ($pages) {
        # single page, show that item as atom
        $feed->title($c->stash->{'page'}->title);
        $feed->id($c->stash->{'page'}->uri_for($c));
        push @entries, $self->render_page($c, $c->stash->{'page'})
    } else {
        while (my $page = $pages->next) {
            push @entries, $self->render_page($c, $page);
        }
        
    }
    $feed->updated($self->updated . "Z");
    
    $feed->add_entry($_) foreach(@entries);
    my $b = $feed->as_xml;
#    my $pos = tell(DATA);
#    my $b = join("", <DATA>);
#    seek(DATA, $pos, 0);
    $c->res->body($b);
    $c->res->content_type('application/atom+xml; charset=utf8');
    
}

sub render_page {
    my ($self, $c, $page) = @_;
    $self->updated($page->updated) if ($page->updated > $self->updated);
    my $entry = XML::Atom::Entry->new();

    $entry->title($page->title);
    $entry->id($c->uri_for($page->uri_for($c)));
    $entry->updated($page->updated . "Z");
    my $link = XML::Atom::Link->new;
    $link->type('text/html');
    $link->rel('alternate');
    $link->href($c->uri_for($page->uri_for($c)));
    $entry->link($link);

    my $content = XML::Atom::Content->new(type => 'html');
    $content->body($page->formated_body);
    $entry->content($page->formated_body);
    my $author = XML::Atom::Person->new();
    $author->name($page->author->name);
    $author->email($page->author->email) if $page->author->email;
    $entry->author($author);
    
    return $entry;
}
=head1 NAME

EasyCMS2::View::Atom - Catalyst View

=head1 DESCRIPTION

Catalyst View.

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
__DATA__
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Blog</title>
  <id>http://localhost:3000//blog</id>
  <link type="text/html" rel="alternate" href="http://localhost:3000//blog"/>
  <link type="application/atom+xml" rel="self" href="http://localhost:3000/blog/.atom"/>
  <updated>2007-09-08T13:13:12Z</updated>
  <entry>
    <title>finaly!</title>
    <id>http://localhost:3000//blog/finaly_</id>
    <updated>2007-09-08T13:13:12Z</updated>
    <link type="text/html" rel="alternate" href="http://localhost:3000//blog/finaly_"/>
    <content type="text">
        <p>hopehope!</p>
    </content>
    <author>
      <name>Admin pwnz</name>
    </author>
  </entry>
</feed>
