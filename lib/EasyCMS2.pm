package EasyCMS2;

use Moose;

#
# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a YAML file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root 
#                 directory
#
use Catalyst qw/
        StackTrace
        ConfigLoader 
        I18N
        Authentication

        Session
        Session::Store::FastMmap
        Session::State::Cookie
        
        Static::Simple 
        Server
        Server::XMLRPC
/;

use CatalystX::RoleApplicator;

extends 'Catalyst';
__PACKAGE__->apply_request_class_roles(qw/
    Catalyst::TraitFor::Request::ProxyBase
/);

our $VERSION = '0.13';

__PACKAGE__->config(setup_components => { search_extra => [ qw/::CategoryType/ ] });

sub category_types { 
    my $self = shift;
    my @names = $self->_comp_names(qw/CategoryType/);
    
    return grep { ("EasyCMS2::CategoryType::" . $_)->public } @names;
}

#
# Start the application
#
__PACKAGE__->setup;

sub setting {
    my ($self, $key, $value) = @_;
    
    my $setting = $self->model('Base::Setting')->find_or_create({key => $key});
    
    if (defined $value) { 
        $setting->value($value);
        $setting->update();
    }
    return $setting->value();
}

sub get_snippet {
    my $self = shift;
    
    my $url = shift;
    
    $self->log->debug('getting snippet with url: ' . $url) if $self->debug;
    my $snip = $self->model('Base::Snippet')->find_by_path($url);
    $self->log->debug("found snippet: " 
        . ($snip ? $snip->name : "no snippet found")) if $self->debug;
    my $args;
    unless (ref($self)) {
        $args = {'test' => 'test2'};
    } else {
        $args = $self->stash();
        $args->{c} = $self;
    }
    return undef unless $snip;
    
    my $stash_add = $snip->category->prepare_index($self);
    
    foreach my $key (keys %$stash_add) {
        $self->log->debug("Adding $key: " 
            . $stash_add->{$key} . " for snippet " 
            . $snip->name . "(" . $snip->url_name . ")") if $self->debug;
        $args->{$snip->url_name}->{$key} = $stash_add->{$key};
    }
    $snip = $self->view('Default')->render_snippet(\($snip->text), $args);
    return $snip;
    
}
#
# IMPORTANT: Please look into EasyCMS2::Controller::Root for more
#

=head1 NAME

EasyCMS2 - Catalyst based application

=head1 SYNOPSIS

    script/easycms2_server.pl

=head1 DESCRIPTION

Catalyst based application.

=head1 SEE ALSO

L<EasyCMS2::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
