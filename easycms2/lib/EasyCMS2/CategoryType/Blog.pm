package EasyCMS2::CategoryType::Blog;
use strict;
use warnings;

use Moose;

extends 'EasyCMS2::CategoryType';

override  'index' => sub {
    my $self = shift;
    my $hashref = {};
    $hashref->{'latest_posts'} = $self->row->pages({}, {order_by => 'created desc', rows => 5});
    return $hashref;
};


1;

__DATA__
[% SET posts = category.latest_posts %]
[% WHILE (post = posts.next) %]
 <h2>[% post.title %]</h2>
<p>[% post.formated_body %]</p>
<p>Posted: [% post.created %]</p>
<hr />
[% END %]    
    
