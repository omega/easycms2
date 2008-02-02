package EasyCMS2::Controller::Admin::Author;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

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

sub create : Local {
    my ( $self, $c ) = @_;
    my $object : Stashed = $c->model('Base::Author')->new({ });
    
    $c->forward('edit');
}

sub edit : Local {
    my ( $self, $c, $id) = @_;
    my $object : Stashed;
    $object = $c->model('Base::Author')->find($id) unless $object;
    
    die "no author" unless $object;
    
    $c->widget('edit_author')->method('post')->action($c->uri_for($c->action->name(), $object->id ));
    $c->widget('edit_author')->indicator(sub { $c->req->method eq 'POST' } );
    $c->widget('edit_author')->element('Textfield','name')->label('Name');
    $c->widget('edit_author')->element('Textfield','login')->label('Login');
    $c->widget('edit_author')->element('Textfield','email')->label('Email');
    $c->widget('edit_author')->element('Password','password')->label('Password');
    $c->widget('edit_author')->element('Password','confirm_password')->label('Confirm password');

    $c->widget('edit_author')->element('Submit','save')->label('Save');

    $c->widget('edit_author')->constraint('AllOrNone','password', 'confirm_password');
    $c->widget('edit_author')->constraint('Equal','password', 'confirm_password');
    
    my $result : Stashed = $c->widget_result($c->widget('edit_author'));
    
    if (! $result->has_errors and $c->req->method() eq 'POST') {
        
        $object->populate_from_widget($result);
        $c->res->redirect($c->uri_for(''));
    }
    $object->fill_widget($c->widget('edit_author'));
    
    
}

sub delete : Local {
    my ( $self, $c, $id) = @_;
    
    my $object : Stashed = $c->model('Base::Author')->find($id) if $id;
    
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
