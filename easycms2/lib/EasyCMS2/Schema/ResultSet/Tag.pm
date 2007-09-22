package EasyCMS2::Schema::ResultSet::Tag;

use base qw(DBIx::Class::ResultSet);

sub stringify {
    my $self = shift;
    
   
    return join(" ", map {
        warn $_->can('name') ? "can name" : "cannot name";
        $_ = ($_->can('name') ? $_->name : $_->tag->name);
        
        m/\s/ ? 
            '"'. $_ . '"' :
            $_ 
    } $self->all);
}
1;
