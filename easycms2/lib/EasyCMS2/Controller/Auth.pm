package EasyCMS2::Controller::Auth;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

=head1 NAME

EasyCMS2::Controller::Auth - Catalyst Controller

=head1 SYNOPSIS

See L<EasyCMS2>

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub login : Private {
    my ($self, $c) = @_;
    
    if ($c->req->param('user') && $c->req->param('pw')) {
		$c->login($c->req->param('user'), $c->req->param('pw')) 
			or my $loginfailed : Stashed = 'Could not log you in.';
	}
	
	unless ($c->user_exists) {
	    $c->widget('login')->method('post')->action($c->uri_for(''));
        $c->widget('login')->indicator(sub { $c->req->method eq 'POST' } );

        $c->widget('login')->element('Textfield','user')->label('User');
        $c->widget('login')->element('Password','pw')->label('Password');
        
        $c->widget('login')->element('Submit','login')->label('Login');
        
		my $template : Stashed = 'auth/login.tt';
		
		my $result : Stashed = $c->widget_result('login');
	}
	
	
	
}
#
# Uncomment and modify this or add new actions to fit your needs
#
#=head2 default
#
#=cut
#
#sub default : Private {
#    my ( $self, $c ) = @_;
#
#    # Hello World
#    $c->response->body('EasyCMS2::Controller::Auth is on Catalyst!');
#}


=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
