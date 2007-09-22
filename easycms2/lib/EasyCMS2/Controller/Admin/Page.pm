package EasyCMS2::Controller::Admin::Page;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

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

sub create : Local {
    my ($self, $c) = @_;
    my $category = $c->req->param('category');
    
    my $object : Stashed = $c->model('Base::Page')->new({author => $c->user->user->id, category => $category });
    
    $c->forward('edit');
}

sub edit : Local {
    my ($self, $c, $id) = @_;
    my $onload : Stashed;

    if (ref($onload)) {
        push @$onload, 'page_onload()';
    } else {
        $onload = ['page_onload()'];
    }
    
    my $object : Stashed;
    $object = $c->model('Base::Page')->find($id) unless $object;
    die "no page" unless $object;
    $c->widget('edit_page')->method('post')->action($c->uri_for($c->action->name(), $object->id ));
    $c->widget('edit_page')->indicator(sub { $c->req->method eq 'POST' } );

    $c->widget('edit_page')->element('Textfield','title')->label('Title');
    $c->widget('edit_page')->element('Textarea','body')->label('Body');
    
    {
        my $roots = $c->model('Base::Category')->search({parent => undef}, {order_by => 'name'});
        my @categories;
        while (my $root = $roots->next) {
            push @categories, $root->node('-- ');
        }
        my $category_select = $c->widget('edit_page')->element('Select','category')->label('Category')->options(
            map { $_->{id} => $_->{name} } @categories
        );
    }

    {
        my $roots = $c->model('Base::Template')->search({parent => undef}, {order_by => 'name'});
    
        my @templates;
        push @templates, { id => 'undef', name => 'Inherit from category'};

        while (my $root = $roots->next) {
            push @templates, $root->node('-- ');
        }

    
        my $template_select = $c->widget('edit_page')->element('Select','template')->label('Template')->options(
            map { $_->{id} => $_->{name} } @templates
        );
    }
    
    $c->widget('edit_page')->element('Checkbox','allow_comments')->label('Allow comments');
    $c->widget('edit_page')->element('Textfield', 'tags')->label('Tags')->value($object->get_tags)
        ->comment('Seperate tags with space. Tags that need to contain spaces can be quoted with "this is one tag"');

    $c->widget('edit_page')->element('Span', 'index_page_default')
        ->content($c->model('Base::Tag')->search({})->stringify)->class("hidden");

    $object->category->type->extend_page_widget($c->widget('edit_page'), $object, 1);
        
    $c->widget('edit_page')->element('Submit','save')->label('Save');
    $c->widget('edit_page')->element('Submit','save')->label('Save and Close');
    # We extend the widget with the categorytypes extensions, if any
    
    my $result : Stashed = $c->widget_result($c->widget('edit_page'));
    
    if (! $result->has_errors and $c->req->method() eq 'POST') {
        
        my $title = lc($result->param('title'));
        $title =~ s/[^a-z0-9_-]+/_/g;
        $object->url_title($title);
        $c->log->debug("tags: " . $result->param("tags"));
        $object->set_tags($result->param('tags'));
        $object->populate_from_widget($result);
        # we also allow the category type to save its extensions.
        $object->category->type->extend_page_save($result, $object);
        $object->update();
        
        if ($c->req->param('save') ne 'Save') {
            $c->res->redirect($c->uri_for(''));
        } else {
            $c->res->redirect($c->uri_for('edit', $object->id));
        }
    }
    $object->fill_widget($c->widget('edit_page'));
    $c->log->debug('uri_for:' . $object->uri_for($c));
    
    
}

sub delete : Local {
    my ( $self, $c, $id) = @_;
    
    my $object : Stashed = $c->model('Base::Page')->find($id) if $id;
    
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

sub homepage : Local {
    my ( $self, $c, $id ) = @_;
    
    my $object : Stashed = $c->model('Base::Page')->find($id) if $id;
    
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
