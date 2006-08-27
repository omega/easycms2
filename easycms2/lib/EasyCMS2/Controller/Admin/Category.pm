package EasyCMS2::Controller::Admin::Category;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

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
    $c->log->debug('roots: ' . $root->count);
    
}

sub create : Local {
    my ($self, $c) = @_;
    my $parent = $c->req->param('parent');
        
    my $object : Stashed = $c->model('Base::Category')->new({parent => $parent || undef });
    
    $c->forward('edit');
}

sub edit : Local {
    my ($self, $c, $id) = @_;
    
    my $object : Stashed;
    if ($object) {
        $c->log->debug('we have object: ' . $object->id);
    }
    
    $object = $c->model('Base::Category')->find($id) unless $object;
    die "no category" unless $object;
    
    $c->widget('edit_category')->method('post')->action($c->uri_for($c->action->name(), $object->id ));
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
            $c->res->redirect($c->uri_for('edit', $object->id));
        }
    }
    if (!$object->template and $object->parent and $object->parent->template) {
        $object->template($object->parent->template);
    }
    $object->fill_widget($c->widget('edit_category'));

}

sub delete : Local {
    my ( $self, $c, $id) = @_;
    
    my $object : Stashed = $c->model('Base::Category')->find($id) if $id;
    
    die "no such page" unless $object;
    my $msg : Flashed = 'Category removed';
    
    if ($object->can_remove()) {
        $object->remove;
    } else {
        $msg = 'Cannot remove non-empty category (has children or pages)';
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
