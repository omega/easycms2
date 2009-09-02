package EasyCMS2::Schema::Base::MimeType;

use warnings;
use strict;

use base qw/DBIx::Class/;

use Imager;
use Data::Dumper::Simple;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('mimetype');

__PACKAGE__->add_columns(
    'id'            => { data_type => 'INTEGER', is_auto_increment => 1 },
    'type'      => { data_type => 'varchar', size => 255 },
    'name'   => { data_type => 'TEXT', is_nullable => 1 },
    'extensions' => { data_type => 'TEXT', is_nullable => 1},
    'icon'          => { data_type => 'TEXT', is_nullable => 1 },
    
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('unique_name' => ['type']);


sub check_imager {
    my $self = shift;
    
    my $type = $self->type;
    $type =~ s|image/||;
    
    return $Imager::formats{$type};
}
1;