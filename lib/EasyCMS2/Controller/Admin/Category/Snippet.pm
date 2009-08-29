package EasyCMS2::Controller::Admin::Category::Snippet;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';
__PACKAGE__->config->{unsafe_bindlex_ok} = 1;

=head1 NAME

EasyCMS2::Controller::Admin::Category::Snippet - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub list : Chained('/admin/category/category') PathPart('snippets') Args(0) {
    my ($self, $c) = @_;
    my $object : Stashed;
    
    my $root : Stashed = $object->snippets;
}

sub chain : Chained('/admin/category/category') CaptureArgs(0) PathPart('snippets') {
    
}

sub chain_capture : Chained('/admin/category/category') CaptureArgs(1) PathPart('snippets') {
    my ($self, $c, $id) = @_;
    
    my $snippet : Stashed = $c->model('Base::Snippet')->find($id);    
}
sub create : Chained('chain') PathPart('create') Args(0) {
    my ($self, $c) = @_;
    my $object : Stashed;
    
    my $snippet : Stashed = $c->model('Base::Snippet')->new({ category => $object->id });
    
    $c->forward('edit');    
}

sub edit : Chained('chain_capture') PathPart('edit') Args(0) {
    my ($self, $c) = @_;
    
    my $snippet : Stashed;
    my $object : Stashed;
    
    $c->widget('edit_snippet')->method('post')->action($c->uri_for('/admin/category', $object->id, 
        'snippets', ($c->action->name =~ m/create/ ? 'create' : $snippet->id . '/edit')));
    $c->widget('edit_snippet')->indicator('name');
    
    $c->widget('edit_snippet')->element('Textfield','name')->label('Name');
    $c->widget('edit_snippet')->element('Textarea','text')->label('Text');
    
    $c->widget('edit_snippet')->element('Submit','save')->label('Save');
    $c->widget('edit_snippet')->element('Submit','save')->label('Save and close');
    
    my $result : Stashed = $c->widget_result($c->widget('edit_snippet'));
    
    if (! $result->has_errors and $c->req->method() eq 'POST') {
        
        $snippet->populate_from_widget($result);
        $snippet->update();
        if ($c->req->param('save') ne 'Save') {
            $c->res->redirect($c->uri_for('/admin/category', $object->id, 'snippets'));
        } else {
            $c->res->redirect($c->uri_for('/admin/category', $object->id, 'snippets', $snippet->id , 'edit'));
        }
    }
    $snippet->fill_widget($c->widget('edit_snippet'));
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
