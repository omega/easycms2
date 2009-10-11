package EasyCMS2::CategoryType::Youtube;

use Moose;
extends 'EasyCMS2::CategoryType';

use XML::Atom::Feed;
use XML::Atom::Ext::Media;

use URI;

override 'catch_all' => sub {
    return 1;
};

override  'index' => sub {
    my $self = shift;
    my $c = shift;
    my $rest_path = shift;

    my $hashref = {};
    $hashref->{'pages'} = $self->row->pages({});

    if (defined($rest_path) and $rest_path ne '') {
        # We have a catch-all request, so it might be for some archive-path
    } else {
        # We should probably get the feed from extra and do something with it
        my $feed = XML::Atom::Feed->new(
            URI->new($self->row->get_config('youtube_feed_url'))
        );
        
        $hashref->{'feed'} = $feed;
        
        # we should also extract somewhat, so we can more easily
        # to stuff in the templates
    }
    return $hashref;
};

override 'extend_category_form' => sub {
    my $self = shift;
    my $form = shift;
    my $page = shift;
    
    $self->insert_elements(
        $form, $form->element({
            type => 'Text',
            name => 'youtube_feed_url',
            label_loc => 'youtube_feed_url',
        })->value( $page->get_config('youtube_feed_url'))
    );
};
override 'extend_category_save' => sub {
    my $self = shift;
    my $form = shift;
    my $page = shift;
    $page->set_config('youtube_feed_url', $form->param('youtube_feed_url'));
};

1;

__DATA__
{
    'template' => qq{
<div id="video_container">
[% SET youtube = category.feed, i = 4, first_video = 0%]
<ul id="videos">
[% FOREACH entry IN youtube.entries; LAST UNLESS i; SET i = i - 1; %]

   [% SET video = entry.media_groups; SET first_video = video UNLESS first_video %]
   <li data:yt_url="[% video.default_content.url %]" data:yt_type="[% video.default_content.type %]">
      <h2>[% video.title %]</h2>
      <img class="thumb" src="[% video.thumbnails.0.url %]" />
      <p class="description">[% video.description %]</p>
      <a class="watch">Watch movie</a>
   </li>
[% END %]
</ul>
[% IF first_video %]
<div id="yt_player">
  <p>You need Flash Player 8+ and JavaScript enabled to watch videos</p>
</div>
<script type="text/javascript">

    var params = { allowScriptAccess: "always" };
    var atts = { id: "yt_player" };
    swfobject.embedSWF("[% first_video.default_content.url %]&enablejsapi=1&playerapiid=ytplayer", 
                       "yt_player", "425", "356", "8", null, null, params, atts);
</script>

[% END %]
</div>
    },
    'js' => qq{
\$(function() {
  \$('#video_container a.watch').click(function(event) {
    if (typeof(ytplayer) == "undefined") {
       return false;
    }
    ytplayer.loadVideoByUrl(\$(this).parent().attr('data:yt_url'));
  });
});
var ytplayer;

function onYouTubePlayerReady(playerId) {
  ytplayer = document.getElementById("yt_player");
}

    },
    'css' => qq{
div#video_container {
  position: relative;
}

ul#videos {
  list-style: none;
  margin-right: 50%;
}

#yt_player {
  position: absolute;
  top: 15px;
  right: 15px;
}

img.thumb {
  float: left;
  margin-right: 10px;
  margin-bottom: 10px;
}
    },
    
}
