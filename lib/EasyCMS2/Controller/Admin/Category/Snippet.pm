package EasyCMS2::Controller::Admin::Category::Snippet;

use strict;
use warnings;
use base qw(Catalyst::Controller::HTML::FormFu Catalyst::Controller::BindLex);
__PACKAGE__->config->{unsafe_bindlex_ok} = 1;

=head1 NAME

EasyCMS2::Controller::Admin::Category::Snippet - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub list : Chained('/admin/category/load') PathPart('snippets') Args(0) {
    my ($self, $c) = @_;
    my $object : Stashed;
    
    my $root : Stashed = $object->snippets;
}

sub chain : Chained('/admin/category/load') CaptureArgs(0) PathPart('snippets') {
    
}

sub chain_capture : Chained('/admin/category/load') CaptureArgs(1) PathPart('snippets') {
    my ($self, $c, $id) = @_;
    
    my $snippet : Stashed = $c->model('Base::Snippet')->find($id);    
}
sub create : Chained('chain') PathPart('create') Args(0) FormConfig {
    my ($self, $c) = @_;
    my $object : Stashed;
    
    my $snippet : Stashed = $c->model('Base::Snippet')->new({ category => $object->id });
    
    $c->forward('doit');    
}

sub edit : Chained('chain_capture') PathPart('edit') Args(0) FormConfig {
    my ($self, $c) = @_;
    
    $c->forward('doit');
}
sub doit : Private {
    my ( $self, $c ) = @_;
    
    my $snippet : Stashed;
    my $object : Stashed;
    my $form : Stashed;
    
    if ($c->req->method eq 'POST' and $form->submitted_and_valid) {
        
        $form->model->update($snippet);

        if ($c->req->param('save') ne 'Save') {
            $c->res->redirect($c->uri_for('/admin/category', $object->id, 'snippets'));
        } else {
            $c->res->redirect($c->uri_for('/admin/category', $object->id, 'snippets', $snippet->id , 'edit'));
        }
    } elsif (!$form->submitted) {
        $form->model->default_values( $snippet );
    }
}

sub delete : Chained('chain_capture') PathPart('delete') Args(0) {
    my ($self, $c) = @_;
    my $snippet : Stashed;
    
    $snippet->delete;
    
}



=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
