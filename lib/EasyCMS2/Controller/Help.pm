package EasyCMS2::Controller::Help;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';
__PACKAGE__->config->{unsafe_bindlex_ok} = 1;

=head1 NAME

EasyCMS2::Controller::Help - Catalyst Controller

=head1 SYNOPSIS

See L<EasyCMS2>

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub default : Private {
    my ( $self, $c, $help, $key) = @_;
    
    my $help_doc : Stashed;
    
    unless ($key) {
        $help_doc = {'title' => 'test-title', 'body' => 'test-body'};
    } else {
        # We have a key, lets try to load this from a template
        my $content = $c->view('Default')->render($c, 'help/' . $key . '.tt', {});
        # Should be extract the title from $content?
        my $title = ucfirst($key);
        if ($content =~ s|<title>(.*?)</title>||) {
            $title = $1;
        }
        $help_doc = {
            title => $title,
            body => $content,
        };
    }
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
