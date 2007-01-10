package EasyCMS2::Schema::Base::Category;

use base qw/DBIx::Class/;

#use EasyCMS2::CategoryType;

__PACKAGE__->load_components(qw/PK::Auto Core HTMLWidget/);
__PACKAGE__->table('category');

__PACKAGE__->add_columns(
    'id'    => { data_type => 'INTEGER', is_auto_increment => 1},
    
    'parent' => { data_type => 'INTEGER', is_nullable => 1},
    'template' => { data_type => 'INTEGER' },
    
    # Type can be: article, blog, gallery
    'type' => { data_type => 'TEXT', default_value => 'article'},
    
    # holds the index-page text
    'index_page' => { data_type => 'TEXT', is_nullable => 1 },
    
    'name' => { data_type => 'TEXT' },
    'url_name' => { data_type => 'TEXT' },
    
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(template => EasyCMS2::Schema::Base::Template);
__PACKAGE__->belongs_to(parent => EasyCMS2::Schema::Base::Category);
__PACKAGE__->has_many('children' => 'EasyCMS2::Schema::Base::Category', 'parent', { order_by => 'name'});
__PACKAGE__->has_many('pages' => 'EasyCMS2::Schema::Base::Page', 'category', { order_by => 'title'});
__PACKAGE__->has_many('medias' => 'EasyCMS2::Schema::Base::Media', 'category', { order_by => 'description'} ); 

__PACKAGE__->has_many('pictures' => 'EasyCMS2::Schema::Base::Media', 'category', { order_by => 'description' });
# We only allow one category within a parent to have the same name.
__PACKAGE__->add_unique_constraint('url_name_parent' => ['url_name', 'parent']);

# We dont want to handle the type stuff ourselfs, it would just be too much work!

__PACKAGE__->inflate_column('type' => {
    'inflate' => sub { return EasyCMS2::CategoryType->new({id => shift, row => shift}); },
    'deflate' => sub { return shift->toString(); } }
);



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

# should return a hashref to include in the stash

sub prepare_index {
    return shift->type->index(@_);
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

sub catch_all {
    my $self = shift;
    
    return $self->type->catch_all;
        
}

1;
