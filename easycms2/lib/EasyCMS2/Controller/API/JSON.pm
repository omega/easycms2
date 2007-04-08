package EasyCMS2::Controller::API::JSON;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

=head1 NAME

EasyCMS2::Controller::API::JSON - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub default : Private {
    my ( $self, $c , @args) = @_;
    my $func = pop @args;
    my $rel = pop @args;
    
    $c->log->debug('func: ' . $func . " rel: " . $rel);
    
    my $model = $c->model('Base::' . ucfirst($rel));
    
    if ($model and $model->can($func)) {
        my $api_list : Stashed = [];
        my $objs = $model->$func;
        while (my $obj = $objs->next) {
            push @$api_list, $obj->toHash;
        }
        $c->log->debug('found ' . $objs->count . " objects");
    }
    
}
sub categorytype_defaults : Local {
    my ( $self, $c ) = @_;
    my $ct = EasyCMS2::CategoryType->new(id => $c->req->param('type'));
    my $api_obj : Stashed = $ct->get_defaults;
    
}
sub end : Private {
    my ( $self, $c ) = @_;
    $c->forward($c->view('JSON'));
}

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
