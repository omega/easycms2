package EasyCMS2::Controller::Admin::Media;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

=head1 NAME

EasyCMS2::Controller::Admin::Media - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;
    
    $c->forward('list');
    
}

sub list : Private {
    my ( $self, $c ) = @_;
    my $medias : Stashed = $c->model('Base::Media')->search({}, {order_by => 'description'});
}

sub create : Local {
    my ( $self, $c ) = @_;
    
    my $object : Stashed = $c->model('Base::Media')->new({});
    
    $c->forward('edit');
}

sub edit : Local {
    my ( $self, $c, $id) = @_;
    my $object : Stashed;
    $object = $c->model('Base::Media')->find($id) unless $object;
    
    die "no media" unless $object;
    
    $c->widget('edit_media')->method('post')->action($c->uri_for($c->action->name(), $object->id ));
    $c->widget('edit_media')->indicator(sub { $c->req->method eq 'POST' } );

    $c->widget('edit_media')->element('Textfield','description')->label('Description');
    $c->widget('edit_media')->element('Upload','file')->label('File');
    $c->widget('edit_media')->element('Submit','save')->label('Save');
    my $result : Stashed = $c->widget_result($c->widget('edit_media'));
    
    if (! $result->has_errors and $c->req->method() eq 'POST') {
        
        $object->populate_from_widget($result);
        $c->log->debug("media object id: " . $object->id);
        $object->file($c->req->upload('file'));
        
        $object->update();
        $c->res->redirect($c->uri_for(''));
    }
    $object->fill_widget($c->widget('edit_page'));
    $c->log->debug('uri_for:' . $object->uri_for($c));
    
    
}

sub delete : Local {
    my ( $self, $c, $id) = @_;
    
    my $object : Stashed = $c->model('Base::Media')->find($id) if $id;
    
    die "no such media" unless $object;
    my $msg : Flashed = 'Media removed';
    
    if ($object->can_remove) {
        $object->remove;
    } else {
        $msg = 'Cannot remove media';
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
