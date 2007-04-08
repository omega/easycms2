package EasyCMS2::Controller::Help;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

=head1 NAME

EasyCMS2::Controller::Help - Catalyst Controller

=head1 SYNOPSIS

See L<EasyCMS2>

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub default : Private {
    my ( $self, $c, $key) = @_;
    
    my $help_doc : Stashed = {'title' => 'test-title', 'body' => 'test-body'};
}


sub index : Local {
    my ( $self, $c ) = @_;
    my $help_doc : Stashed = {'title' => 'EasyCMS2 Help index', 
        'body' => 'EasyCMS2 should be quite easy to use. <a id="legend">Legend</a>'
    };
    
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
