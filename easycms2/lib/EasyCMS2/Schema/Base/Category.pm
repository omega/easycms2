package EasyCMS2::Schema::Base::Category;

use base qw/DBIx::Class/;

#use EasyCMS2::CategoryType;
use EasyCMS2::Extra;

__PACKAGE__->load_components(qw/PK::Auto Core HTMLWidget/);
__PACKAGE__->table('category');

__PACKAGE__->add_columns(
    'id'    => { data_type => 'INTEGER', is_auto_increment => 1},
    
    'parent' => { data_type => 'INTEGER', is_nullable => 1},
    'template' => { data_type => 'INTEGER' },
    
    # Type can be: article, blog, gallery
    'type' => { data_type => 'varchar', size => 64, default_value => 'article'},
    
    # holds the index-page text
    'index_page' => { data_type => 'TEXT', is_nullable => 1 },
    'allow_comments' => {data_type => 'INTEGER', is_nullable => 1},
    
    'css' => { data_type => 'TEXT', is_nullable => 1 },
    'js' => { data_type => 'TEXT', is_nullable => 1 },
    
    'name' => { data_type => 'TEXT' },
    'url_name' => { data_type => 'varchar', size => 255 },
    'config' => { data_type => 'TEXT', is_nullable => 1 },
    
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('template' => 'EasyCMS2::Schema::Base::Template');
__PACKAGE__->belongs_to('parent' => 'EasyCMS2::Schema::Base::Category');
__PACKAGE__->has_many('children' => 'EasyCMS2::Schema::Base::Category', 'parent', { order_by => 'name'});
__PACKAGE__->has_many('pages' => 'EasyCMS2::Schema::Base::Page', 'category', { order_by => 'title'});
__PACKAGE__->has_many('medias' => 'EasyCMS2::Schema::Base::Media', 'category', { order_by => 'description'} ); 

__PACKAGE__->has_many('pictures' => 'EasyCMS2::Schema::Base::Media', 'category', { order_by => 'description' });
# We only allow one category within a parent to have the same name.

__PACKAGE__->has_many('snippets' => 'EasyCMS2::Schema::Base::Snippet', 'category', { order_by => 'name' });

__PACKAGE__->add_unique_constraint('url_name_parent' => ['url_name', 'parent']);

# We dont want to handle the type stuff ourselfs, it would just be too much work!

__PACKAGE__->inflate_column('type' => {
    'inflate' => sub { return EasyCMS2::CategoryType->new({id => shift, row => shift}); },
    'deflate' => sub { return shift->toString(); } }

);

__PACKAGE__->inflate_column('config' => {
    'inflate' => sub { return EasyCMS2::Extra->new({'stored' => shift})},
    'deflate' => sub { return shift->store(); }
});

sub get_config {
    my $self = shift;
    my $config = shift;
    my $h = $self->config;
    
    return ($h ? $h->get($config) : undef);
}

sub set_config {
    my $self = shift;
    my $config = shift;
    my $value = shift;
    my $h = $self->config;
    
    $h->set($config => $value);
    $self->config($h);
    
    return $value;
}


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

sub uri_for {
    my $self = shift;
    my $c = shift;
    my @additions = @_;
    
    my @parents;
        
    my $cat = $self;
    while ($cat) {
        unshift @parents, $cat->url_name;
        $cat = $cat->parent || undef;
    }
   
    return ($c ? $c->uri_for('/', @parents, @additions)->path_query : join ('/', @parents, @additions));
}

sub can_remove {
    my $self = shift;
    
    return ($self->children->count == 0 and $self->pages->count == 0 and $self->pictures->count == 0);
    
}
sub remove {
    my $self = shift;
    if ($self->can_remove) {
        #$self->delete();
        return 1;
    } else {
        return 0;
    }
}

sub catch_all {
    my $self = shift;
    
    return $self->type->catch_all;
        
}

1;
