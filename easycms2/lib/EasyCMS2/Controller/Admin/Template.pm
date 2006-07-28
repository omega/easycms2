package EasyCMS2::Controller::Admin::Template;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

use Data::Dumper::Simple;
=head1 NAME

EasyCMS2::Controller::Admin::Template - Catalyst Controller

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
    
    my $root : Stashed = $c->model('Base::Template')->search({parent => undef});
}

sub create : Local {
    my ($self, $c) = @_;
    my $parent = $c->req->param('parent');
    
    my $object : Stashed = $c->model('Base::Template')->new({parent => $parent || undef });
    
    $c->forward('edit');
}

sub edit : Local {
    my ($self, $c, $id) = @_;
    
    my $object : Stashed;
    $object = $c->model('Base::Template')->find($id) unless $object;
    
    die "no template" unless $object;
        
    $c->widget('edit_template')->method('post')->action($c->uri_for($c->action->name,  $object->id));
    
    $c->widget('edit_template')->element('Textfield','name')->label('Name');
    $c->widget('edit_template')->element('Textarea','before')->label('Before');
    $c->widget('edit_template')->element('Textarea','after')->label('After');
    
    $c->widget('edit_template')->indicator(sub { $c->req->method eq 'POST' } );
    
    my $roots = $c->model('Base::Template')->search({parent => undef}, {order_by => 'name'});
    
    my @templates;
    push @templates, { id => 'undef', name => 'No parent'};
    while (my $root = $roots->next) {
        push @templates, $root->node('-- ');
    }

    
    my $template_select = $c->widget('edit_template')->element('Select','parent')->label('Parent')->options(
        map { $_->{id} => $_->{name} } @templates
    );
    
    $c->widget('edit_template')->element('Submit','submit')->value('Store');
    
    my $result : Stashed = $c->widget_result($c->widget('edit_template'));
    

    if (! $result->has_errors and $c->req->method() eq 'POST') {
        $object->populate_from_widget($result);
        $object->update();
        $c->res->redirect($c->uri_for(''));
    }
    $object->fill_widget($c->widget('edit_template'));
    
    $template_select->value( ( $object->parent && $object->parent->can('id') ) ? $object->parent->id : undef);

}

sub delete : Local {
    my ( $self, $c, $id) = @_;
    
    my $object : Stashed = $c->model('Base::Template')->find($id) if $id;
    
    die "no such template" unless $object;
    my $msg : Flashed = 'Template removed';
    
    if ($object->can_remove()) {
        $object->remove;
    } else {
        $msg = 'Cannot remove non-empty template (has children, categories or pages)';
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
