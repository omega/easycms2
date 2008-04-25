package EasyCMS2::Controller::Admin::Author;

use strict;
use warnings;
use base qw(Catalyst::Controller::HTML::FormFu Catalyst::Controller::BindLex);

=head1 NAME

EasyCMS2::Controller::Admin::Author - Catalyst Controller

=head1 SYNOPSIS

See L<EasyCMS2>

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


sub index : Private {
    my ( $self, $c ) = @_;
    
    $c->forward('list');
    
}

sub list : Private {
    my ( $self, $c ) = @_;
    my $authors : Stashed = $c->model('Base::Author')->search({}, {order_by => 'name'});
}

sub load : Chained('/admin/admin') PathPart('author') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $object : Stashed = $c->model('Base::Author')->find($id);
    
}

sub create : Local : FormConfig {
    my ( $self, $c ) = @_;
    my $object : Stashed = $c->model('Base::Author')->new({ });
    
    $c->forward('doit');
}

sub edit : Chained('load') Args(0) : FormConfig {
    my ( $self, $c, $id) = @_;
    
    $c->forward('doit');
}

sub doit : Private {
    my ( $self, $c ) = @_;
    
    my $object : Stashed;
    die "no author" unless $object;

    my $form : Stashed;
    $form->model('DBIC')->default_values($object);
    
    if ($form->submitted_and_valid) {
        $form->model()->update($object);
    }
}

sub delete : Chained('load') Args(0) {
    my ( $self, $c) = @_;
    
    my $object : Stashed;
    
    die "no such author" unless $object;
    my $msg : Flashed = 'Author removed';
    
    if ($object->can_remove) {
        $object->remove;
    } else {
        $msg = 'Cannot remove author';
    }
    $c->res->redirect($c->uri_for(''));
}

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
