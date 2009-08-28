package EasyCMS2::Extra;

use strict;
use warnings;

use Moose;
use Storable qw(nfreeze thaw);
use JSON;

has 'data' => (is => 'rw', isa => 'Ref', default => sub { {} });
has 'serializer' => (is => 'ro', isa => 'Ref', default => sub { return JSON->new() });

sub BUILD {
    my $self = shift;
    my $args = shift;
    
    $self->data($self->serializer->jsonToObj($args->{'stored'})) if $args->{'stored'};
    $self->data({}) unless ref($self->data);
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
    
    return $self->serializer->objToJson($self->data);
}

1;