package EasyCMS2::Controller::Admin::Category;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';
__PACKAGE__->config->{unsafe_bindlex_ok} = 1;

=head1 NAME

EasyCMS2::Controller::Admin::Category - Catalyst Controller

=head1 SYNOPSIS

See L<EasyCMS2>

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub index : Private {
    my ($self, $c) = @_;
    
    $c->forward('list');
}

sub list : Private {
    my ($self, $c) = @_;
    
    my $root : Stashed = $c->model('Base::Category')->search({parent => undef});
    
}

sub load : Chained('/admin/admin') PathPart('category') CaptureArgs(1) {
    my ($self, $c, $cat_id) = @_;
    my $object : Stashed = $c->model('Base::Category')->find($cat_id);
}

sub create : Local {
    my ($self, $c) = @_;
    my $parent = $c->req->param('parent');
        
    my $object : Stashed = $c->model('Base::Category')->new({parent => $parent || undef, type => 'article' });
    
    $c->forward('edit');
}

sub edit : Chained('load') Args(0) {
    my ($self, $c) = @_;
    
    my $object : Stashed;
    if ($object) {
        $c->log->debug('we have object: ' . $object->id);
    }
        
    $c->widget('edit_category')->method('post')->action($c->uri_for($object->id, $c->action->name()));
    $c->widget('edit_category')->element('Textfield','name')->label('Name');
    $c->widget('edit_category')->indicator(sub { $c->req->method eq 'POST' } );
    
    {
        my $roots = $c->model('Base::Category')->search({parent => undef}, {order_by => 'name'});
        my @categories;
        push @categories, { id => 'undef', name => 'No parent'};
        while (my $root = $roots->next) {
            push @categories, $root->node('-- ');
        }
        my $category_select = $c->widget('edit_category')->element('Select','parent')->label('Parent')->options(
            map { $_->{id} => $_->{name} } @categories
        );
    }
    
    {
        my $roots = $c->model('Base::Template')->search({parent => undef}, {order_by => 'name'});
    
        my @templates;
        while (my $root = $roots->next) {
            push @templates, $root->node('-- ');
        }
    
        my $template_select = $c->widget('edit_category')->element('Select','template')->label('Template')->options(
            map { $_->{id} => $_->{name} } @templates
        );
    }
    
    $c->widget('edit_category')->element('Select','type')->label('Type')->options(
        map { ("EasyCMS2::CategoryType::" . $_)->ID => $_ } EasyCMS2->category_types  
    );
    $c->widget('edit_category')->element('Checkbox','allow_comments')->label('Allow comments');
    
    $c->widget('edit_category')->element('Textarea','index_page')->label('Index_page');
    $c->widget('edit_category')->element('Textarea','js')->label('Javascript');
    $c->widget('edit_category')->element('Textarea','css')->label('CSS');

    $c->widget('edit_category')->element('Button','insert_default')->label('Insert_default')
        ->attributes({ onclick => 'setDefault();', type => 'button'});
    
    $c->widget('edit_category')->element('Span', 'index_page_default')
        ->content($object->type->default_template())->class("hidden");
    
    $c->widget('edit_category')->element('Submit','save')->label('Save');
    $c->widget('edit_category')->element('Submit','save')->label('Save and Close');
    
    
    my $result : Stashed = $c->widget_result($c->widget('edit_category'));
    
    if (! $result->has_errors and $c->req->method() eq 'POST') {
        
        my $title = lc($result->param('name'));
        $title =~ s/[^a-z0-9_-]+/_/g;
        $object->url_name($title);
        
        $object->populate_from_widget($result);
        $object->update();
        if ($c->req->param('save') ne 'Save') {
            $c->res->redirect($c->uri_for(''));
        } else {
            $c->res->redirect($c->uri_for($object->id , 'edit'));
        }
    }
    if (!$object->template and $object->parent and $object->parent->template) {
        $object->template($object->parent->template);
    }
    $object->fill_widget($c->widget('edit_category'));

}

sub delete : Chained('load') Args(0) {
    my ( $self, $c) = @_;
    
    my $object : Stashed;
    
    die "no such category" unless $object;
    my $msg : Flashed = 'Category removed';
    
    $c->res->redirect($c->uri_for(''));
    if ($object->remove()) {
        $object->delete();
    } else {
        $msg = 'Cannot remove non-empty category (has children, pictures or pages)';
    }
    
}

sub homepage : Chained('load') Args(0) {
    my ( $self, $c ) = @_;
    
    my $object : Stashed;
    die "no such category" unless $object;
    
    $c->setting('default-page' => "c" . $object->id);
    
    my $msg : Flashed = 'Category successfully set as homepage';
    
    $msg = 'Error while setting category as homepage' if ($c->setting('default-page') ne "c" . $object->id);
    
    $c->res->redirect($c->req->referer);
    
}

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
