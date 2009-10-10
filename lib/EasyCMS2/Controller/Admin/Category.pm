package EasyCMS2::Controller::Admin::Category;

use strict;
use warnings;
use base qw(Catalyst::Controller::HTML::FormFu Catalyst::Controller::BindLex);
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

sub create : Local : FormConfig {
    my ($self, $c) = @_;
    my $parent = $c->req->param('parent');
        
    my $object : Stashed = $c->model('Base::Category')->new({
        parent => $parent || undef, 
        type => 'article' 
    });
    
    $c->forward('doit');
}

sub edit : Chained('load') Args(0) : FormConfig {
    my ($self, $c) = @_;
    
    $c->forward('doit');
}
sub doit : Private {
    my ($self, $c) = @_;
    my $object : Stashed;
    if ($object) {
        $c->log->debug('we have object: ' . $object->id) if $c->debug;
    }

    my $form : Stashed;
    {
        my $roots = $c->model('Base::Category')->search({
            parent => undef
        }, {
            order_by => 'name'
        });
        my @categories;
        push @categories, { id => undef, name => 'No parent'};
        while (my $root = $roots->next) {
            push @categories, $root->node('-- ');
        }
        $form->get_all_element({
            type => 'Select',
            name => 'parent',
        })->options(
            [map { [$_->{id} => $_->{name}] } @categories]
        );
    }
    
    {
        my $roots = $c->model('Base::Template')->search({
            parent => undef
        }, {
            order_by => 'name'
        });
    
        my @templates;
        while (my $root = $roots->next) {
            push @templates, $root->node('-- ');
        }
    
        $form->get_all_element({
            type => 'Select',
            name => 'template',
        })->options(
            [map { [$_->{id} => $_->{name}] } @templates]
        );
    }
    
    $form->get_all_element({
        type => 'Select',
        name => 'type'
    })->options(
        [
            map { [("EasyCMS2::CategoryType::" . $_)->ID => $_] } 
            EasyCMS2->category_types 
        ]
    );
    
    

    
    $form->get_all_element({
        type => 'Block',
        name => 'index_page_default',
    })->content($object->type->default_template());    
    
    if ($c->req->method eq 'POST' and $form->submitted_and_valid) {
        
        my $title = lc($form->param('name'));
        $title =~ s/[^a-z0-9_-]+/_/g;
        $form->add_valid(url_name => $title);
        $form->model->update($object);

        if ($c->req->param('save') ne 'Save') {
            $c->res->redirect($c->uri_for(''));
        } else {
            $c->res->redirect($c->uri_for($object->id , 'edit'));
        }
    } elsif (!$form->submitted) {
        $form->model->default_values( $object );
    }
    if (!$object->template and $object->parent and $object->parent->template) {
        $object->template($object->parent->template);
    }
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
    
    $msg = 'Error while setting category as homepage' 
    if ($c->setting('default-page') ne "c" . $object->id);
    
    $c->res->redirect($c->req->referer);
    
}

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
