package EasyCMS2::View::Default;

use strict;
use base 'Catalyst::View::TT';

use Data::Dumper::Simple;

sub process {
    my ($self, $c) = @_;
    my $template = $c->stash->{templ};
    my $category = $c->stash->{cat};
    if ($template) {
        my $tmpl_in_header = $template->get_header;
        my $templ_header = $c->view('Default')->render($c, \($template->get_header));
        if (UNIVERSAL::isa($templ_header, 'Template::Exception')) {
            my $error = qq/Coldn't render template "$templ_header"/;
            $c->log->error($error);
            $c->error($error);
            return 0;
        }
        $c->stash->{template_header} = $templ_header;

        my $templ_footer = $c->view('Default')->render($c, \($template->get_footer));
        if (UNIVERSAL::isa($templ_footer, 'Template::Exception')) {
            my $error = qq/Coldn't render template "$templ_footer"/;
            $c->log->error($error);
            $c->error($error);
            return 0;
        }
        $c->stash->{template_footer} = $templ_footer;
        
    }
    if ($category) {
        my $category_index = $c->view('Default')->render($c, \($category->index_page));
        if (UNIVERSAL::isa($category_index, 'Template::Exception')) {
            my $error = qq/Couldn't render template: "$category_index"/;
            $c->log->error($error);
            $c->error($error);
            return 0;
        }
        $c->stash->{category_index} = $category_index;
    }
#    $self->pre_process('INCLUDE header.tt');
#    $self->post_process(qw/footer.tt/);
    
    $self->SUPER::process($c);
}


sub render_snippet {
    my ($self, $template, $args) = @_;

    my $output;
    my $vars = { 
        (ref $args eq 'HASH' ? %$args : { })
    };

    local $self->{include_path} = 
        [ @{ $vars->{additional_template_paths} }, @{ $self->{include_path} } ]
        if ref $vars->{additional_template_paths};

    unless ($self->template->process( $template, $vars, \$output ) ) {
        return $self->template->error;  
    } else {
        return $output;
    }
}
=head1 NAME

EasyCMS2::View::Default - Catalyst TT View

=head1 SYNOPSIS

See L<EasyCMS2>

=head1 DESCRIPTION

Catalyst TT View.

=head1 AUTHOR

Andreas Marienborg

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
