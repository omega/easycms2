package EasyCMS2::Schema::Base::Category;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core HTMLWidget/);
__PACKAGE__->table('category');

__PACKAGE__->add_columns(
    'id'    => { data_type => 'INTEGER', is_auto_increment => 1},
    
    'parent' => { data_type => 'INTEGER', is_nullable => 1},
    'template' => { data_type => 'INTEGER' },
    
    'name' => { data_type => 'TEXT' },
    'url_name' => { data_type => 'TEXT' },
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(template => EasyCMS2::Schema::Base::Template);
__PACKAGE__->belongs_to(parent => EasyCMS2::Schema::Base::Category);
__PACKAGE__->has_many('children' => 'EasyCMS2::Schema::Base::Category', 'parent', { order_by => 'name'});
__PACKAGE__->has_many('pages' => 'EasyCMS2::Schema::Base::Page', 'category', { order_by => 'title'});


# We only allow one category within a parent to have the same name.
__PACKAGE__->add_unique_constraint('url_name_parent' => ['url_name', 'parent']);


sub get_template {
    my $self = shift;
    return $self->template;
}

sub node {
    my $self = shift;
    my $ident = shift;
    
    my @categories;
    push @categories, { id => $self->id, name => ( $self->parent ? $ident : '' ) . $self->name };
    
    my $children = $self->children;
    while (my $child = $children->next) {
        push @categories, $child->node(( $self->parent ? $ident : '' ) . $ident);
    }
    return @categories;
}

sub can_remove {
    my $self = shift;
    
    return ($self->children->count == 0 and $self->pages->count == 0);
    
}
sub remove {
    my $self = shift;
    if ($self->can_remove) {
        $self->delete();
    }
}

1;
