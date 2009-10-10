package EasyCMS2::Controller::Admin::Page;

use strict;
use warnings;
use base qw(Catalyst::Controller::HTML::FormFu Catalyst::Controller::BindLex);
__PACKAGE__->config->{unsafe_bindlex_ok} = 1;

use Data::Dumper::Simple;

=head1 NAME

EasyCMS2::Controller::Admin::Page - Catalyst Controller

=head1 SYNOPSIS

See L<EasyCMS2>

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    
    return 1;
}


sub index : Private {
    my ($self, $c) = @_;
    
    $c->forward('list');
}


sub list : Private {
    my ($self, $c) = @_;
    my $root : Stashed = $c->model('Base::Category')->search({parent => undef});
}

sub load : Chained('/admin/admin') PathPart('page') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $object : Stashed = $c->model('Base::Page')->find($id);
}

sub create : Local : FormConfig {
    my ($self, $c) = @_;
    my $category = $c->req->param('category');
    
    my $object : Stashed = $c->model('Base::Page')->new({
        author => $c->user->id, 
        category => $category 
    });
    
    $c->forward('doit');
}

sub edit : Chained('load') Args(0) : FormConfig{
    my ( $self, $c ) = @_;
    
    $c->forward('doit');
}

sub doit : Private {
    my ( $self, $c ) = @_;
    
    my $onload : Stashed;

    if (ref($onload)) {
        push @$onload, 'page_onload()';
    } else {
        $onload = ['page_onload()'];
    }
    
    my $object : Stashed;
    die "no page" unless $object;

    my $form : Stashed;
    
    {
        # Populate the category dropdown
        my $roots = $c->model('Base::Category')->search({
            parent => undef
        }, {
            order_by => 'name'
        });
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


    {
        # Populate the template dropdown
        my $roots = $c->model('Base::Template')->search({
            parent => undef
        }, {
            order_by => 'name'
        });
    
        my @templates;
        push @templates, { id => 'undef', name => 'Inherit from category'};

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

  
    # Extend the damn form from the category type
    $object->category->type->extend_page_form($form, $object, 1) if $object->category;

    
    
    if ($c->req->method eq 'POST' and $form->submitted_and_valid) {

        
        my $title = lc($form->param('title'));
        $title =~ s/[^a-z0-9_-]+/_/g;

        $form->add_valid(url_title => $title);
        $c->log->debug("tags: " . $form->param("tags")) if $c->debug;
        $form->model->update($object);
        
        # we also allow the category type to save its extensions.
        $object->category->type->extend_page_save($form, $object);
        
        # Fix tags
        $object->set_tags($form->param_value('tags'));
        $object->update();
        
        if ($c->req->param('save') ne 'Save') {
            $c->res->redirect($c->uri_for(''));
        } else {
            $c->res->redirect($c->uri_for($object->id, 'edit'));
        }

    } elsif( !$form->submitted) {
        $form->model->default_values( $object );
    }
    $c->log->debug('uri_for:' . $object->uri_for($c)) if $c->debug;
    
}

sub delete : Chained('load') Args(0) {
    my ( $self, $c ) = @_;
    
    my $object : Stashed;
    
    die "no such page" unless $object;
    my $msg : Stashed;
    
    if ($object->can_remove()) {
        $object->remove;
        $msg = 'Page removed';
    } else {
        $msg = 'Cannot remove non-empty template (has children, categories or pages)';
    }
    $c->res->redirect($c->uri_for(''));
    
}

sub homepage : Chained('load') Args(0) {
    my ( $self, $c ) = @_;
    
    my $object : Stashed;
    
    die "no such page" unless $object;
    
    $c->setting('default-page' => $object->id);
    
    my $msg : Flashed = 'Page successfully set as homepage';
    
    $msg = 'Error while setting page as homepage' if ($c->setting('default-page') != $object->id);
    
    $c->res->redirect($c->uri_for(''));

}


=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
