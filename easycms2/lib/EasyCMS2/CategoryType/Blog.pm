package EasyCMS2::CategoryType::Blog;
use strict;
use warnings;

use Moose;

extends 'EasyCMS2::CategoryType';

override  'index' => sub {
    my $self = shift;
    my $c = shift;
    my $rest_path = shift;
    
    my $tag = $c->stash->{'tag'};
    
    my $hashref = {};
    $hashref->{'resultset'} = $self->row;
    my ($func, $file, $line) = caller(2);
    if (defined($rest_path) and $rest_path ne '') {
        # We have a catch-all request, so it might be for some archive-path
        if ($rest_path =~ m|^(\d{4})/(\d{2})/(\d{2})$|) {
            my $datetime = DateTime->new(year => $1,
        				 month=> $2,
        				 day  => $3);

            $hashref->{'archive_start'} = $datetime;
            $hashref->{'archive_end'}   = $datetime->clone->add(days=>1);
            $hashref->{'archive_title'} = $datetime->day.'. '.$datetime->month_name.", ".$datetime->year;
            
        } elsif ($rest_path =~ m|^(\d{4})/(\d{2})$|) {
            my $datetime = DateTime->new(year => $1,
        				 month=> $2);

            $hashref->{'archive_start'} = $datetime;
            $hashref->{'archive_end'}   = $datetime->clone->add(months=>1);
            $hashref->{'archive_title'} = $datetime->month_name.", ".$datetime->year;
            
        } elsif ($rest_path =~ m|^(\d{4})$|) {
            my $datetime = DateTime->new(year => $1);

            $hashref->{'archive_start'} = $datetime;
            $hashref->{'archive_end'}   = $datetime->clone->add(years=>1);
            $hashref->{'archive_title'} = $datetime->year;
            
        } else {
            my $datetime = DateTime->now();

            $hashref->{'archive_end'}   = $datetime;
            $hashref->{'archive_start'} = $datetime->clone->subtract(months => 1);
            $hashref->{'archive_title'} = $datetime->year;
        }
        $c->log->debug("archive request");
        my $posts = $self->row->pages({ 
            created => { -between => [$hashref->{archive_start}, $hashref->{archive_end}]}
        }, {order_by => 'created desc'});
        $hashref->{'posts'} = $posts;
        
    } else {
        $hashref->{'posts'} = $self->row->pages({}, {order_by => 'created desc', rows => 5});
    }
    if ($tag) {
        $c->log->debug("constraining resultset posts to a given tag");
        $hashref->{'posts'} = $hashref->{'posts'}->search({
            'page_tags.tag' => $tag->id,
        }, {
            join => 'page_tags',
        });
    }
    $hashref->{'latest_posts'} = $self->row->pages({}, {order_by => 'created desc', rows => 5});
    return $hashref;
};

override 'catch_all' => sub {
    return 1;
};
override 'order_by' => sub {
    return "created DESC";
};
1;
__DATA__

{
    'template' => qq{
[% SET posts = category.posts %]
[% WHILE (post = posts.next) %]
 <h2>[% post.title %]</h2>
<p>[% post.formated_body %]</p>
<p>Posted: [% post.created %]</p>
<hr />
[% END %]        
    }
}
