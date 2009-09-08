package EasyCMS2::Schema::Base::Comment;

use base qw/DBIx::Class/;

use Text::Textile;

my $textile=Text::Textile->new();
$textile->charset('utf-8');



__PACKAGE__->load_components(qw/TimeStamp Core/);
__PACKAGE__->table('comment');
__PACKAGE__->add_columns(
    'id'    => { data_type => 'INTEGER', is_auto_increment => 1 },
    
    'title' => { data_type => 'TEXT' },
    'url_title' => { data_type => 'TEXT' },
    
    'body'  => { data_type => 'TEXT' },
    
    'commenter' => { data_type => 'TEXT' },
    'page' => {data_type => 'INTEGER' },
        
    'created' => {data_type => 'TIMESTAMP', set_on_create => 1,},
    'updated' => {data_type => 'TIMESTAMP', set_on_create => 1, set_on_update => 1,},
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('page' => 'EasyCMS2::Schema::Base::Page');

#__PACKAGE__->add_unique_constraint('unique_url' => ['category', 'url_title']);


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

sub formated_body {    
    return $textile->process( shift->body );
}


1;