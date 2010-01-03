package EasyCMS2::CategoryType;

# so the default value population in FormFu works :p
use overload 
    '""' => sub { 
        my $self = shift;
        return $self->id;
}, fallback => 1;

use strict;
use warnings;

use Moose;

has 'id' => (is => 'rw', isa => 'Str');
has 'row' => (is => 'rw', isa => 'Ref');

sub textile_index {
    return 0;
}
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
    return $self->get_default('template');
}
sub get_default {
    my $self = shift;
    my $what = shift;
    my $defs = $self->get_defaults() || {};
    
    return $defs->{$what};
}
sub get_defaults {
    my $self = shift;
    
    $self->read_defaults() unless $default_cache->{ref($self)};
    
    return $default_cache->{ref($self)};    
}
sub read_defaults {
    my $self = shift;
    local $/;
    my $defaults = eval "package " . ref($self) . "; <DATA>";
    $default_cache->{ref($self)} = eval $defaults if $defaults;    
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
sub order_by {
    return "title";
}
sub extend_category_form {
    my $self = shift;
    my $form = shift;
    my $page = shift;
    
}
sub extend_category_save {
    my $self = shift;
    my $form = shift;
    my $page = shift;
    
}

sub extend_page_form {
    my $self = shift;
    my $form = shift;
    my $page = shift;
}

sub extend_page_save {
    my $self = shift;
    my $form = shift;
    my $page = shift;
}

sub insert_elements {
    my $self = shift;
    my $form = shift;
    
    my $position = $form->get_all_element({ type => 'Submit' });
    while (my $elem = shift) {
        $form->insert_before($elem, $position);
    }
}
1;