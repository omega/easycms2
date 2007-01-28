package EasyCMS2::Schema::Base::Snippet;

use strict;
use warnings;

use base qw/DBIx::Class/;

use EasyCMS2::Schema::ResultSet::Categorised;
__PACKAGE__->load_components(qw/ResultSetManager PK::Auto Core HTMLWidget/);
__PACKAGE__->table('snippet');

__PACKAGE__->add_columns(
    'id'    => { data_type => 'INTEGER', is_auto_increment => 1},
    
    'category' => { data_type => 'INTEGER' },
    
    'text' => { data_type => 'TEXT' },
    'name' => { data_type => 'TEXT' },
    
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('category' => 'EasyCMS2::Schema::Base::Category');

__PACKAGE__->resultset_class('EasyCMS2::Schema::ResultSet::Categorised');


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
    push @parents, $self->url_name;
    
    return ($c ? $c->uri_for('/', @parents)->path_query : join ('/', @parents));
    
}

sub path_part {
    return shift->url_name;
}
sub url_name {
    my $self = shift;
    my $name = lc($self->name);
    $name =~ s/[^a-z0-9]+/_/g;
    
    return $name;
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
