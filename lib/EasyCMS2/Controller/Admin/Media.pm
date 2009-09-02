package EasyCMS2::Controller::Admin::Media;

use strict;
use warnings;
use base qw(Catalyst::Controller::HTML::FormFu Catalyst::Controller::BindLex);
__PACKAGE__->config->{unsafe_bindlex_ok} = 1;

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
    my $root : Stashed = $c->model('Base::Category')->search({parent => undef});
    my $medias : Stashed = $c->model('Base::Media')->search({}, {order_by => 'description'});
}

sub load : Chained('/admin/admin') PathPart('media') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    
    my $object : Stashed = $c->model('Base::Media')->find($id);

}

sub create : Local FormConfig {
    my ( $self, $c ) = @_;
    my $category = $c->req->param('category');  
    my $object : Stashed = $c->model('Base::Media')->new({ category => $category });
    
    my $form : Stashed;
    # Add the file selector
    
    my $file = $form->element({
        type => 'File',
        name => 'file',
        label_loc => 'file',
    });
    my $pos = $form->get_all_element( { type => 'Text', name => 'description'});
    $form->insert_after($file, $pos);
    
    $c->forward('doit');
}

sub edit : Chained('load') Args(0) formConfig {
    my ( $self, $c ) = @_;
    
    $c->forward('doit');
}
sub doit : Private {
    my ( $self, $c ) = @_;
    
    my $object : Stashed;
    
    die "no media" unless $object;
    
    my $form : Stashed;
    
    {
        my $roots = $c->model('Base::Category')->search({parent => undef}, {order_by => 'name'});
        my @categories;
        while (my $root = $roots->next) {
            push @categories, $root->node('-- ');
        }
        $form->get_all_element({
            type => 'Select', 
            name => 'category'
        })->options(
            [map { [$_->{id} => $_->{name}] } @categories]
        );
    }

    # Add media preview
    $form->get_all_element({ type => 'Block', name => 'media-preview'})
        ->content(HTML::Element->new('img', src => $object->uri_for($c) )) if $object->filename;

    # Add the file select element unless this is already an uploaded file
    
    if ($form->submitted_and_valid) {
        
        $form->model->update( $object );
        $c->log->debug("media object id: " . $object->id) if $c->debug;
        $object->file($c->req->upload('file')) if $c->req->upload('file');
        
        $object->update();
        $c->res->redirect($c->uri_for(''));
    } elsif (!$form->submitted) {
        $form->model->default_values( $object );
    }
    $c->log->debug('uri_for:' . $object->uri_for($c)) if $c->debug;
}

sub delete : Chained('load') Args(0) {
    my ( $self, $c ) = @_;
    
    my $object : Stashed;
    
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
