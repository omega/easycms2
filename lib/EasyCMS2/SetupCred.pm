package EasyCMS2::SetupCred;

use strict;
use warnings;

use base qw/Class::Accessor::Fast/;

use Scalar::Util        ();
use Catalyst::Exception ();
use Digest              ();

BEGIN {
    __PACKAGE__->mk_accessors(qw/_config realm/);
}

sub new {
    my ($class, $config, $app, $realm) = @_;
    
    my $self = { _config => $config };
    bless $self, $class;
    
    $self->realm($realm);
    
    $self->_config->{'password_field'} ||= 'password';
    $self->_config->{'password_type'}  ||= 'clear';
    $self->_config->{'password_hash_type'} ||= 'SHA-1';
    
    return $self;
}

sub authenticate {
    my ( $self, $c, $realm, $authinfo ) = @_;

    ## because passwords may be in a hashed format, we have to make sure that we remove the 
    ## password_field before we pass it to the user routine, as some auth modules use 
    ## all data passed to them to find a matching user... 
    my $userfindauthinfo = {%{$authinfo}};
    delete($userfindauthinfo->{$self->_config->{'password_field'}});
    
    my $user_obj = $realm->find_user($userfindauthinfo, $c);
    if (ref($user_obj)) {
        if ($self->check_password($user_obj, $authinfo)) {
            return $user_obj;
        }
    } else {
        $c->log->debug("Unable to locate user matching user info provided") if $c->debug;
        return;
    }
}

sub check_password {
    my ( $self, $user, $authinfo ) = @_;
    
    my $password = $authinfo->{$self->_config->{'password_field'}};
    
    # need to get this from the config:
    
    my $storedpassword = EasyCMS2->config->{recovery_password};
    if (!$storedpassword or $storedpassword eq 'UNSET') {
        Catalyst::Exception->throw("recover_password is unset or undefined. Please set in local config");
    }
    
    return $password eq $storedpassword;
}

1;
