package EasyCMS2::Controller::Admin;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

=head1 NAME

EasyCMS2::Controller::Admin - Catalyst Controller

=head1 SYNOPSIS

See L<EasyCMS2>

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub auto : Private {
    my ($self, $c) = @_;
    
    unless ($c->user_exists) {
        # need to make this user log in
        $c->forward('/auth/login');
        return 0 unless $c->user_exists;
    }
    my $submenu : Stashed = 'admin/submenu.tt';
    my $onload : Stashed = 'admin_onload()';
    return 1;
}

sub begin : Private {
    my ($self, $c) = @_;
    my $templ : Stashed = $c->model('Base::Template')->find({ name => 'Admin template'});
}
sub index : Private {
    my ($self, $c) = @_;    
}

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
