package EasyCMS2::Schema::Base::Media;

use warnings;
use strict;
use MIME::Types;
use Imager;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('media');

__PACKAGE__->add_columns(
    'id'            => { data_type => 'INTEGER', is_auto_increment => 1 },
    'filename'      => { data_type => 'TEXT', is_nullable => 1 },
    'description'   => { data_type => 'TEXT', is_nullable => 1 },
    'type'          => { data_type => 'INTEGER', is_nullable => 1 },
    'category'      => { data_type => 'INTEGER', is_nullable => 1 },
    
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('category' => 'EasyCMS2::Schema::Base::Category');
__PACKAGE__->belongs_to('type' => 'EasyCMS2::Schema::Base::MimeType');

__PACKAGE__->resultset_class('EasyCMS2::Schema::ResultSet::Media');

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
    if ($self->type->check_imager());
    
    return $hash;
}

{
    my $class = __PACKAGE__;
    no strict 'refs';
    my $sizes = EasyCMS2->config()->{'media'};
    foreach my $size (@{$sizes->{resizes}}) {
        my $filename = $size->{filename};
        my $accessor = sub {
            my $self = shift;
            if ($self->type && $self->type->can('check_imager') && $self->type->check_imager()) {
                return $self->id . "_" . $filename . "_" . $self->filename;
            } else {
                return "";
            }
        };
        
        my $accessorname = $filename . "_filename";
        unless (defined(&{"${class}::$accessorname"})) {
            *{ "${class}::$accessorname"} = $accessor;
        }
    }
}
sub file_name {
    my $self = shift;
    
    return $self->id . "_" . $self->filename;
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
            
            if ($db_type->check_imager()) {

                my $img = Imager->new();
                $img->read(file => $file->tempname);                

                my $sizes = EasyCMS2->config()->{'media'};
                foreach my $size (@{$sizes->{resizes}}) {
                    my $thumb;
                    if ($size->{scale} && $size->{crop}) {
                        $thumb = $img->scale(%{$size->{scale}})->crop(%{$size->{crop}});
                    } elsif ($size->{scale}) {
                        $thumb = $img->scale(%{$size->{scale}});
                    } elsif ($size->{crop}) {
                        $thumb = $img->crop(%{$size->{crop}});
                    } else {
                        die "No valid crop or scale given in format " . $size->{name};
                    }
                    
                    $thumb->write(file => $store . "/" . $self->id . "_" . $size->{filename} . "_" . $file->basename);
                    
                }
                # create a thumb
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
    my $size = shift;
    
    
    my $store = EasyCMS2->config()->{'file_base'};
    
    my $filename;
    if ($size) {
        my $met = $size . "_filename";
        if (UNIVERSAL::can($self, $met)) {
            $filename = $self->$met();
        } else {
            $filename = "";
        }
    } else {
        $filename = $self->file_name();
    }
    if ($self->id) {
        return $c->uri_for($store, $filename)->path_query;
    } else {
        return "";
    }
}

sub remove {
    my $self = shift;
    if ($self->can_remove) {
        my $sizes = EasyCMS2->config()->{'media'};
        my $store = EasyCMS2->config()->{'file_base'};
        foreach my $size (@{$sizes->{resizes}}) {
            
            my $file = $store . "/" . $self->id . "_" . $size->{filename} . "_" . $self->filename;
            unlink $file if (-f $file);
        }
        unlink $store . "/" . $self->id . "_" . $self->filename;
        $self->delete();
    }
}
    
sub can_remove {
    return 1;
}
1;