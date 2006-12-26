package EasyCMS2::Schema::Base::Page;

use base qw/DBIx::Class/;

use Text::Textile;

my $textile=Text::Textile->new();
$textile->charset('utf-8');



__PACKAGE__->load_components(qw/ResultSetManager PK::Auto Core HTMLWidget/);
__PACKAGE__->table('page');
__PACKAGE__->add_columns(
    'id'    => { data_type => 'INTEGER', is_auto_increment => 1 },
    
    'title' => { data_type => 'TEXT' },
    'url_title' => { data_type => 'TEXT' },
    
    'body'  => { data_type => 'TEXT' },
    
    'author' => { data_type => 'INTEGER' },
    'template' => { data_type => 'INTEGER', is_nullable => 1 },
    'category' => { data_type => 'INTEGER' },
        
    'created' => {data_type => 'TIMESTAMP', default_value => 'now()'},
    'updated' => {data_type => 'TIMESTAMP', default_value => 'now()'},
);
__PACKAGE__->set_primary_key('id');


__PACKAGE__->belongs_to(author => EasyCMS2::Schema::Base::Author);
__PACKAGE__->belongs_to(template => EasyCMS2::Schema::Base::Template);
__PACKAGE__->belongs_to(category => EasyCMS2::Schema::Base::Category);


__PACKAGE__->add_unique_constraint('unique_url' => ['category', 'url_title']);

__PACKAGE__->has_many('comments' => 'EasyCMS2::Schema::Base::Comment', 'page', {order_by => 'created'});

sub links : ResultSet {
    my $self = shift;
    
    return $self->search({}, {order_by => 'title'});
}

sub toHash {
    my $self = shift;
    
    my $hash = {
        'id' => $self->id,
        'title' => $self->title,
        'body' => $self->body,
        'uri_base' => $self->uri_for,
    };
    return $hash;
}

sub get_template {
    my $self = shift;
    
    if ($self->template) {
        return $self->template;
    } else {
        return $self->category->get_template;
    }
}

sub formated_body {    
    return $textile->process( shift->body );
}


sub uri_for {
    my $self = shift;
    my $c = shift;
    my @parents;
    
    return undef unless $self->category;
    
    my $cat = $self->category;
    while ($cat) {
        unshift @parents, $cat->url_name;
        $cat = $cat->parent || undef;
    }
    push @parents, $self->url_title;
    
    return ($c ? $c->uri_for('/', @parents)->path_query : join ('/', @parents));
}


1;