package EasyCMS2::CategoryType::Gallery;

use Moose;

extends 'EasyCMS2::CategoryType';

override  'index' => sub {
    my $self = shift;
    my $hashref = {};
    $hashref->{'pictures'} = $self->row->pictures({});
    return $hashref;
};

1;

__DATA__
{
    'template' => qq{
[% SET pictures = category.pictures %]
<div id="gallery">
<div class="picturestrip">
<ul class="picturestrip">
[% FOREACH pic  IN pictures %]
 <li><img src="[% pic.uri_for(c, "thumb") %]" onclick="showPicture('[% pic.uri_for(c, "gallery") %]')"/></li>
[% END %]
</ul>
</div>
<div id="bigPicture_box"><img id="bigPicture" src="[% pictures.first.uri_for(c, "gallery") %]" /></div>
</div>
    },
    'js' => qq{
function showPicture(newSrc) {
  var img = getElement('bigPicture');
  var newImg = IMG({'src': newSrc, 'id': 'bigPicture' });
  replaceChildNodes(img.parentNode, newImg);
}
    },
    'css' => qq{
div#gallery {
  width: 700px;
  border: 1px solid silver;
  background-color: black;
margin-left: auto;
margin-right: auto;
}

div.picturestrip {
  margin-left: auto;
margin-right: auto;
  width: 700px;
  overflow: auto;
  padding: 0px;
  height: 70px;
}
ul.picturestrip {
  padding: 5px;
  margin: 0px;
  height: 60px;
}
ul.picturestrip li {
  display: inline;
  float: left;
  margin: 0px;
padding: 0px;
}
ul.picturestrip li img {
 margin: 0px;
}
div#bigPicture_box {
 clear: both;
margin-left: auto;
margin-right: auto;
margin-bottom: 5px;
width: 640px;
text-align: center;
}
img#bigPicture {

}
    }
}
