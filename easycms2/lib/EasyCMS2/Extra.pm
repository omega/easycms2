package EasyCMS2::Extra;

use strict;
use warnings;

use Moose;
use Storable qw(nfreeze thaw);

has 'data' => (is => 'rw', isa => 'Ref', default => sub { return {} });

sub BUILD {
    my $self = shift;
    my $args = shift;
    
    $self->data(thaw($args->{'stored'})) if $args->{'stored'};
}


sub set {
    my ( $self, $key, $value ) = @_;
    
    $self->data->{$key} = $value;
    
    return $self->data->{$key};
}

sub get {
    my ( $self, $key ) = @_;
    
    return $self->data->{$key};
}

sub store {
    my ( $self ) = @_;
    
    return nfreeze($self->data);
}

1;