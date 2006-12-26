package EasyCMS2::CategoryType;

use strict;
use warnings;

use Moose;

has 'id' => (is => 'rw', isa => 'Str');
has 'row' => (is => 'rw', isa => 'Ref');

#has 'default_cache' => (is => 'rw', isa => 'HashRef', default => sub { {} });
our $default_cache = {};

require EasyCMS2::CategoryType::Article;
require EasyCMS2::CategoryType::Blog;
require EasyCMS2::CategoryType::Gallery;
require EasyCMS2::CategoryType::Test;


sub BUILD {
    my $self = shift;
    my $args = shift;
    
    
    my $new_class = "EasyCMS2::CategoryType::" . ucfirst(lc($args->{id}));
    
    $self = bless $self, $new_class;
    return $self;
};

sub toString {
    return shift->id;
}

sub index {
    
}

sub default_template {
    my $self = shift;
    return $default_cache->{ref($self)} if ($default_cache->{ref($self)});
    my $template;
    local $/;
    $template = eval "package " . ref($self) . "; <DATA>";
    $default_cache->{ref($self)} = $template;
    return $template;
    
}
1;