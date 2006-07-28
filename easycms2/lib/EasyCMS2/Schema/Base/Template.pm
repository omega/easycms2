package EasyCMS2::Schema::Base::Template;

use warnings;
use strict;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core HTMLWidget/);
__PACKAGE__->table('template');

__PACKAGE__->add_columns(
    'id'    => { data_type => 'INTEGER', is_auto_increment => 1},
    'name' => { data_type => 'TEXT' },
    
    'before' => { data_type => 'TEXT' },
    'after' => { data_type => 'TEXT' },    
    
    'parent' => { data_type => 'INTEGER', is_nullable => 1 },
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('parent' => 'EasyCMS2::Schema::Base::Template');
__PACKAGE__->has_many('children' => 'EasyCMS2::Schema::Base::Template', 'parent', { order_by => 'name'});

__PACKAGE__->has_many('categories' => 'EasyCMS2::Schema::Base::Category', 'template', { order_by => 'name'});
__PACKAGE__->has_many('pages' => 'EasyCMS2::Schema::Base::Page', 'template', { order_by => 'title'});

__PACKAGE__->add_unique_constraint('unique_name' => ['name']);


sub node {
    my $self = shift;
    my $ident = shift;
    
    my @templates;
    push @templates, { id => $self->id, name => ( $self->parent ? $ident : '' ) . $self->name };
    
    my $children = $self->children;
    while (my $child = $children->next) {
        push @templates, $child->node(( $self->parent ? $ident : '' ) . $ident);
    }
    return @templates;
}


sub get_header {
    my $self = shift;
    
    my $header = '';
    if ($self->parent) {
        $header = $self->parent->get_header();
    }
    return $header . $self->before;
}

sub get_footer {
    my $self = shift;
    
    my $footer = '' . $self->after;
    
    if ($self->parent) {
        $footer .= $self->parent->get_footer;
    }
    
    return $footer;
}

sub remove {
    my $self = shift;
    if ($self->can_remove) {
        $self->delete();
    }
}

sub can_remove {
    my $self = shift;
    return ($self->children->count == 0 and $self->categories->count == 0 and $self->pages->count == 0);
}
1;