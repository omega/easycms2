package EasyCMS2::Schema::Base::Template;

use warnings;
use strict;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/UTF8Columns Core/);
__PACKAGE__->table('template');

__PACKAGE__->add_columns(
    'id'    => { data_type => 'INTEGER', is_auto_increment => 1},
    'name' => { data_type => 'varchar', size => 255 },
    
    'before' => { data_type => 'TEXT' },
    'after' => { data_type => 'TEXT' },
    
    'css' => { data_type => 'TEXT', is_nullable => 1 },
    'js' => { data_type => 'TEXT', is_nullable => 1 },
    
    'parent' => { data_type => 'INTEGER', is_nullable => 1 },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->utf8_columns(qw/name before after css js/);

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

sub get_css {
    my $self = shift;
    my $css = '';
    if ($self->parent) {
        $css = $self->parent->get_css();
    }
    return $css . ($self->css ? $self->css : '');
}

sub get_js {
    my $self = shift;
    my $js = '';
    if ($self->parent) {
        $js = $self->parent->get_js();
    }
    return $js . $self->js;
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