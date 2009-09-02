package EasyCMS2::Controller::Setup;

use strict;
use warnings;
use base qw(Catalyst::Controller::HTML::FormFu Catalyst::Controller::BindLex);
__PACKAGE__->config->{unsafe_bindlex_ok} = 1;

=head1 NAME

EasyCMS2::Controller::Init - Catalyst Controller

=head1 SYNOPSIS

See L<EasyCMS2>

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    unless ( $c->user_exists && $c->user_in_realm('recovery') ) {
        $c->forward('/setup/login');
        $c->log->debug( $c->user ) if $c->debug && $c->user_exists;
        return 0 unless ( $c->user_exists && $c->user_in_realm('recovery') );
    }
    return 1;
}

sub begin : Private {
    my ( $self, $c ) = @_;
    my $templ : Stashed =
      $c->model('Base::Template')->find( { name => 'Admin template' } );
}

sub index : Private {
    my ( $self, $c ) = @_;

    # do app-initialization, unless its already been done!

}

sub login : Local : FormConfig {
    my ( $self, $c ) = @_;
    if ( $c->req->param('pw') ) {
        $c->authenticate(
            {
                username => 'setup',
                password => $c->req->param('pw')
            },
            'recovery'
        ) or my $loginfailed : Stashed = 'Could not log you in.';
    }
    if ( $c->user_exists && $c->user_in_realm('recovery') ) {
        $c->res->redirect( $c->uri_for('/setup') );
    }
    
    $c->stash( template => 'setup/login.tt' );

}

sub reset_admin_pw : Local : FormConfig {
    my ( $self, $c ) = @_;

    # check that we have a admin-user to reset
    my $message : Stashed;
    my $form : Stashed;
    
    my $object : Stashed =
      $c->model('Base::Author')->find( { login => 'admin' } );
    unless ($object) {

        # no admin-user found, create one?
        $message = "No admin user found";
    }
    else {


        if ($form->submitted_and_valid) {
            $form->model()->update($object);
            $c->res->redirect( $c->uri_for('/setup') );

        }
    }
}
sub log : Private {
    my ($self, $c, $str) = @_;

    unless (ref($str) eq 'HASH') {
        $str = {
            title => $str,
        }
    }
    
    my $setup_log : Stashed;
    $setup_log ||= [];
    
    push(@$setup_log, $str);
}

sub fatal : Private {
    my ( $self, $c, $str ) = @_;
    unless (ref($str) eq 'HASH') {
        $str = {
            title => $str,
        }
    }
    $str->{fatal} = 1;
    my $setup_fatal : Stashed = 1;
    $self->log( $c, $str )
}
sub step1 : Local {
    my ( $self, $c ) = @_;

    $self->log($c, "Starting setup step 1");
    my $file_store = $c->config()->{'file_store'};
    
    unless ( -w $file_store ) {
        $c->detach('fatal', [{
            title => "I cannot write to configured upload location",
            description => <<__DESC__
You have configured your upload location to be <em>$file_store</em>, however
whomever you have me configured to be does not seem to have write 
access to that location, or perhaps it simply does not exists?
__DESC__
        }] );
    }
    $self->log($c, 'Creating or updating mime-type-table');

    my $mime_type_file = $c->path_to('/db/mime.types');
    open MIME, $mime_type_file or die "cannot read $mime_type_file: $!";
    my $mime_content;
    { local $/; $mime_content = <MIME>; }
    close MIME;

    my @mimetypes = grep { $_ !~ /^\#/ } split( /\n/, $mime_content );

    $self->log($c,  ' found ' . scalar(@mimetypes) . " mimetypes in file" );

    foreach my $line (@mimetypes) {
        next if ( $line =~ /^\s*$/ );
        my ( $type, $extensions ) = split( /\s/, $line );
        my $mt;
        unless ( $mt =
            $c->model('Base::MimeType')->find( { 'type' => $type, } ) )
        {
            $mt = $c->model('Base::MimeType')->create(
                {
                    'type'       => $type,
                    'name'       => $type,
                    'extensions' => $extensions,
                }
            );
        }
        if ($mt) {
            my $icon;
            my $icon_guess = $type . ".png";
            $icon_guess =~ s|/|-|;
            if (
                -f $c->path_to(
                    '/root/static/images/icons/mimetypes', $icon_guess
                )
              )
            {
                $icon = $icon_guess;
            }
            else {

                # We need to be clever!
                my $clever_searches = {
                    'image-x-generic.png' => qr/^image/,
                    'audio-x-generic.png' => qr/^audio/,
                    'text-x-generic.png'  => qr/^text/,
                    'video-x-generic.png' => qr/^video/,
                };

                foreach $icon_guess ( keys %$clever_searches ) {
                    my $re = $clever_searches->{$icon_guess};
                    $icon = $icon_guess if ( $type =~ $re );
                }
            }
            $mt->icon($icon) if $icon;
            $mt->insert_or_update;

        }
    }

    # Create an default author, that is admin
    # FIXME: Should autogenerate perhaps?


    $self->log($c, 'creating admin-author');

    my $admin_pw : Stashed = 'admin';

    my $def_user;
    unless ( $def_user =
        $c->model('Base::Author')->find( { login => 'admin' } ) )
    {
        $def_user = $c->model('Base::Author')->create(
            {
                'login'    => 'admin',
                'password' => $admin_pw,
                'name'     => 'Admin pwnz',
            }
        );
    }
    $self->log($c,  "user: " . $def_user->id );

# create the "main template", which the others will inherit from, that has the basic
# HTML structure and head etc.

    my $def_template;
    unless ( $def_template =
        $c->model('Base::Template')->find( { name => 'Root template' } ) )
    {
        $def_template = $c->model('Base::Template')->create(
            {
                'name'   => 'Root template',
                'before' => <<__END__
<html>
    <head>
        <title>[% title %]</title>
        <link rel="stylesheet" href="[% c.uri_for('/static/css/main.css') %]" />
        <script lang="javascript" src="[% c.uri_for('/javascript/setup') %]"></script>
        <script lang="javascript" src="[% c.uri_for('/static/js/MochiKit.js') %]"></script>
        <script lang="javascript" src="[% c.uri_for('/static/js/HelpBrowser.js') %]"></script>
        <script lang="javascript" src="[% c.uri_for('/static/js/TextEditor.js') %]"></script>
        <script lang="javascript" src="[% c.uri_for('/static/js/admin.js') %]"></script>
    </head>
    <body[% IF onload %] onload="[% FOREACH onl IN onload %][% onl %];[% END %]"[% END %]>
__END__
                ,
                'after' => <<__END__
    </body>
</html>
__END__
                ,
            }
        );
    }

    $self->log($c,  "template: " . $def_template->id );

    my $admin_template;
    unless (
        $admin_template = $c->model('Base::Template')->find(
            {
                name   => 'Admin template',
                parent => $def_template->id
            }
        )
      )
    {
        $admin_template = $c->model('Base::Template')->create(
            {
                'name'   => 'Admin template',
                'parent' => $def_template->id,
                'before' => << "END"
        <h1>Administration</h1>
        <div id="admin">
            <div id="menu">
                [% INCLUDE \$submenu %]
            </div>
            [% IF message %]<p class="message">[% message %]</p>[% END %]
            [% IF error %]<p class="error">[% error %]</p>[% END %]
END
                ,
                'after' => << "END"
        </div>
END
                ,
            }
        );
    }

    my $def_cat;
    unless ( $def_cat =
        $c->model('Base::Category')
        ->find( { name => 'Default Category', parent => undef } ) )
    {
        $def_cat = $c->model('Base::Category')->create(
            {
                template => $def_template->id,
                name     => 'Default category',
                url_name => 'default_category',
            }
        );
    }

    $self->log($c,  "cat: " . $def_cat->id );
    my $def_page;
    unless ( $def_page =
        $c->model('Base::Page')
        ->find( { url_title => 'default_page', category => $def_cat->id } ) )
    {
        $def_page = $c->model('Base::Page')->create(
            {
                category  => $def_cat->id,
                author    => $def_user->id,
                title     => 'Default page',
                url_title => 'default_page',
                body      => <<__END__
h1. hello and welcome! This is the default page, and will be the homepage untill you edit it

To edit it, you should enter the admin-section.

__END__

            }
        );
    }
    $self->log($c,  'page: ' . $def_page->id );
    $c->setting( 'init_step'    => 1 );
    $c->setting( 'default-page' => $def_page->id );
}

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
