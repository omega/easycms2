package EasyCMS2::Controller::Admin::Template;

use strict;
use warnings;
use base qw(Catalyst::Controller::HTML::FormFu Catalyst::Controller::BindLex);
__PACKAGE__->config->{unsafe_bindlex_ok} = 1;

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
sub load : Chained('/admin/admin') PathPart('template') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $object : Stashed = $c->model('Base::Template')->find($id);
}
sub create : Local : FormConfig {
    my ($self, $c) = @_;
    my $parent = $c->req->param('parent');
    
    my $object : Stashed = $c->model('Base::Template')->new({parent => $parent || undef });
    
    $c->forward('doit');
}

sub edit : Chained('load') Args(0) FormConfig {
    my ($self, $c) = @_;
    
    $c->forward('doit');
}
sub doit : Private {
    my ( $self, $c ) = @_;

    my $object : Stashed;
    die "no template" unless $object;
    
    # Load all other templates that might be parents
    my $roots = $c->model('Base::Template')->search({parent => undef}, {order_by => 'name'});
    
    my @templates;
    push @templates, { id => '', name => 'No parent'};
    while (my $root = $roots->next) {
        push @templates, $root->node('-- ');
    }
    
    
    my $form : Stashed;
    # Find the 'parent'-select and set the options
    my $parent_select = $form->get_all_element({ name => 'parent'});
    my @options = map { {'value' => $_->{id}, 'label' => $_->{name}} } @templates;
    $parent_select->options(
        \@options
    );
    
    $form->model('DBIC')->default_values($object);
    
    if ($c->req->method eq 'POST' and $form->submitted_and_valid) {
        $form->model()->update($object);
    }
    
}

sub delete : Chained('load') Args(0) {
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
