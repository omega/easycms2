package EasyCMS2::CategoryType;

use strict;
use warnings;

use Moose;

has 'id' => (is => 'rw', isa => 'Str');
has 'row' => (is => 'rw', isa => 'Ref');

our $default_cache = {};

sub BUILD {
    my $self = shift;
    my $args = shift;
    
    
    my $new_class = "EasyCMS2::CategoryType::" . join("", map { ucfirst(lc($_)) } split("_", $args->{id}));
    
    $self = bless $self, $new_class;
    return $self;
};

sub toString {
    return shift->id;
}

sub index {
    
}
sub ID {
    my $self = shift;
    if (ref($self)) {
        return $self->id;
    }
    my @class = split("::", $self);
    my $class = $class[2];
    return join("_", map { lc($_) } split(/ [A-Z]/, $class) );
    
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
sub default_snippets {
    my $self = shift;
    
}
sub catch_all {
    return 0;
    
}
sub public {
    return 1;
}
1;