package EasyCMS2::Controller::Setup;

use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

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
    unless ($c->user_exists && $c->user_in_realm('recovery')) {
        $c->forward('/setup/login');
        $c->log($c->user);
        return 0 unless ($c->user_exists && $c->user_in_realm('recovery'));
    }

    return 1;
}
sub begin : Private {
    my ($self, $c) = @_;
    my $templ : Stashed = $c->model('Base::Template')->find({ name => 'Admin template'});
}

sub index : Private {
    my ( $self, $c ) = @_;
    
    # do app-initialization, unless its already been done!

}
sub login : Local {
    my ( $self, $c ) = @_;
    
    if ($c->req->param('pw')) {
		$c->authenticate(
		    {
		        username => 'setup',
		        password => $c->req->param('pw')
		    }, 'recovery') 
			or my $loginfailed : Stashed = 'Could not log you in.';
	}
	unless ($c->user_exists && $c->user_in_realm('recovery')) {
	    $c->widget('login')->method('post')->action($c->uri_for(''));
        $c->widget('login')->indicator(sub { $c->req->method eq 'POST' } );

        $c->widget('login')->element('Password','pw')->label('Password');
        
        $c->widget('login')->element('Submit','login')->label('Login');
        
		my $result : Stashed = $c->widget_result('login');
	
	    my $template : Stashed = 'setup/login.tt';
	    
	} else {
	    $c->res->redirect($c->uri_for('/setup'));
	}
	
    
}
sub reset_admin_pw : Local {
    my ($self, $c) = @_;
    # check that we have a admin-user to reset
    my $message : Stashed;
    my $object : Stashed = $c->model('Base::Author')->find({login => 'admin'});
    unless ($object) {
        # no admin-user found, create one?
        $message = "No admin user found";
    } else {
        $c->widget('edit_author')->method('post')->action($c->uri_for($c->action->name(), $object->id ));
        $c->widget('edit_author')->indicator(sub { $c->req->method eq 'POST' } );
        $c->widget('edit_author')->element('Password','password')->label('Password');
        $c->widget('edit_author')->element('Password','confirm_password')->label('Confirm password');

        $c->widget('edit_author')->element('Submit','save')->label('Set password');

        $c->widget('edit_author')->constraint('All', 'password', 'confirm_password');
        $c->widget('edit_author')->constraint('Equal', 'password', 'confirm_password');

        my $result : Stashed = $c->widget_result($c->widget('edit_author'));

        if (! $result->has_errors and $c->req->method() eq 'POST') {

            $object->populate_from_widget($result);
            $c->res->redirect($c->uri_for('/setup'));
        }
        
    }
}
sub step1 : Local {
    my ( $self, $c ) = @_;

    my $file_store = $c->config()->{'file_store'};
    unless (-w $file_store) {
        die "cannot write to file_store: $file_store";
    }
    # Create an default author, that is admin
    # FIXME: Should autogenerate perhaps?
    
    $c->log->debug('Creating or updating mime-type-table');
    
    my $mime_type_file = $c->path_to('/db/mime.types');
    open MIME, $mime_type_file or die "cannot read $mime_type_file: $!";
    my $mime_content;
    { local $/; $mime_content = <MIME>;}
    close MIME;
    
    my @mimetypes = grep { $_ !~ /^\#/ } split(/\n/, $mime_content);
    
    $c->log->debug(' found ' . scalar(@mimetypes) . " mimetypes in file");
    
    foreach my $line (@mimetypes) {
        next if ($line =~ /^\s*$/);
        my ($type, $extensions) = split(/\s/, $line);
        my $mt;
        unless ( $mt = $c->model('Base::MimeType')->find({'type' => $type,}) ) {
            $mt = $c->model('Base::MimeType')->create({
                'type' => $type,
                'name' => $type,
                'extensions' => $extensions,
            });
        }
        if ($mt) {
            my $icon;
            my $icon_guess = $type . ".png";
            $icon_guess =~ s|/|-|;
            if (-f $c->path_to('/root/static/images/icons/mimetypes', $icon_guess)) {
                $icon = $icon_guess;
            } else {
                # We need to be clever!
                my $clever_searches = {
                    'image-x-generic.png' => qr/^image/,
                    'audio-x-generic.png' => qr/^audio/,
                    'text-x-generic.png' => qr/^text/,
                    'video-x-generic.png' => qr/^video/,
                };

                foreach $icon_guess (keys %$clever_searches) {
                    my $re = $clever_searches->{$icon_guess};
                    $icon = $icon_guess if ($type =~ $re);
                }
            }
            $mt->icon($icon) if $icon;
            $mt->insert_or_update;

        }
    }
    
    $c->log->debug('creating admin-author');
    
    my $admin_pw : Stashed = 'admin';
    
    my $def_user;
    unless($def_user = $c->model('Base::Author')->find({login => 'admin'})) {
        $def_user = $c->model('Base::Author')->create({
            'login' => 'admin',
            'password' => $admin_pw,
            'name' => 'Admin pwnz',      
        });
    }    
    $c->log->debug("user: " . $def_user->id);
    # create the "main template", which the others will inherit from, that has the basic
    # HTML structure and head etc.

    my $def_template;
    unless ($def_template = $c->model('Base::Template')->find({name => 'Root template'})) {
        $def_template = $c->model('Base::Template')->create({
            'name' => 'Root template',
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
        });
    }
     
    $c->log->debug("template: " . $def_template->id);
    
    my $admin_template;
    unless ($admin_template = $c->model('Base::Template')->find({
        name => 'Admin template', parent => $def_template->id
    })) {
        $admin_template = $c->model('Base::Template')->create({
            'name' => 'Admin template',
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
        });
    }
    
    my $def_cat;
    unless ($def_cat = $c->model('Base::Category')->find({name => 'Default Category', parent => undef}) ) {
        $def_cat = $c->model('Base::Category')->create({
            template => $def_template->id,
            name => 'Default category',
            url_name => 'default_category',
        });
    }
    
    $c->log->debug("cat: " . $def_cat->id);
    my $def_page;
    unless ($def_page = $c->model('Base::Page')->find({url_title => 'default_page', category => $def_cat->id})) {
        $def_page = $c->model('Base::Page')->create({
            category => $def_cat->id,
            author => $def_user->id,
            title => 'Default page',
            url_title => 'default_page',
            body => <<__END__
h1. hello and welcome! This is the default page, and will be the homepage untill you edit it

To edit it, you should enter the admin-section.

__END__
        
        });
    }
    $c->log->debug('page: ' . $def_page->id);
    $c->setting('init_step' => 1);
    $c->setting('default-page' => $def_page->id);
	$c->res->redirect($c->uri_for('/setup'));
}    



=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
