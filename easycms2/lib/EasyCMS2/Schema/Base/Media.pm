package EasyCMS2::Schema::Base::Media;

use warnings;
use strict;
use MIME::Types;
use Imager;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/ResultSetManager PK::Auto Core HTMLWidget/);
__PACKAGE__->table('media');

__PACKAGE__->add_columns(
    'id'            => { data_type => 'INTEGER', is_auto_increment => 1 },
    'filename'      => { data_type => 'TEXT', is_nullable => 1 },
    'description'   => { data_type => 'TEXT', is_nullable => 1 },
    'type'          => { data_type => 'INTEGER', is_nullable => 1 },
    
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('type' => 'EasyCMS2::Schema::Base::MimeType');

sub images : ResultSet {
    my $self = shift;
    
    return $self->search({'type.type' => [qw(image/png image/jpeg image/gif)]}, {join => 'type', prefetch => 'type'});
}

sub toHash {
    my $self = shift;
    
    my $hash = {
        'id' => $self->id,
        'filename' => $self->filename,
        'description' => $self->description,
        'type' => $self->type->type,
        'uri_basename' => $self->id . "_" . $self->filename,
    };
    $hash->{'uri_basename_thumb'} = $self->id ."_thumb_" . $self->filename 
    if ($self->type->type eq 'image/png' or $self->type->type eq 'image/jpeg');
    
    return $hash;
}

sub file {
    my $self = shift;
    my $file = shift;
    
    my $store = EasyCMS2->config()->{'file_store'};
    
    if ($self->id) {
        
        # We need an ID to store the file under.
        my $locname = $store . "/" . $self->id . "_" . $file->basename;
        
        my $types = MIME::Types->new();
        
        my $type = $types->mimeTypeOf($file->basename);
        
        $type = $type->type;
        my $type_RS = $self->result_source->related_source('type')->resultset;
        my $db_type = $type_RS->find({type => $type});
        if ($db_type) {
            warn "db_type: " . $db_type->type;
            
            if ($db_type->type eq 'image/png' or $db_type->type eq 'image/jpeg') {
                # create a thumb
                my $img = Imager->new();
                $img->read(file => $file->tempname);
                my $thumb = $img->scale(xpixels => 75);
                $thumb->write(file => $store ."/" . $self->id . "_thumb_" . $file->basename );
            }
            $file->copy_to($locname);
            $self->filename($file->basename);
            $self->type($db_type->id);
        } else {
            die "unknown mimetype: " . $type;
        }
        
    }
}

sub uri_for {
    my $self = shift;
    my $c = shift;
    
    
    my $store = EasyCMS2->config()->{'file_base'};
    
    if ($self->id) {
        return $c->uri_for($store, $self->id . "_" . $self->filename)->path_query;
    } else {
        return "";
    }
}

sub remove {
    my $self = shift;
    if ($self->can_remove) {
        $self->delete();
    }
}
    
sub can_remove {
    return 1;
}
1;