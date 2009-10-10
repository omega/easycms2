package EasyCMS2::Schema::Base::Page;

use base qw/DBIx::Class/;
use strict;
use warnings;

use Text::Textile;

my $textile=Text::Textile->new();
$textile->charset('utf-8');

use Data::Dumper::Simple;

use EasyCMS2::Extra;

__PACKAGE__->load_components(qw/UTF8Columns TimeStamp Core/);
__PACKAGE__->table('page');
__PACKAGE__->add_columns(
    'id'    => { data_type => 'INTEGER', is_auto_increment => 1 },
    
    'title' => { data_type => 'TEXT' },
    'url_title' => { data_type => 'varchar', size => 255 },
    
    'body'  => { data_type => 'TEXT' },
    
    'author' => { data_type => 'INTEGER' },
    'template' => { data_type => 'INTEGER', is_nullable => 1 },
    'category' => { data_type => 'INTEGER' },
    'allow_comments' => {data_type => 'INTEGER', is_nullable => 1},
        
    'created' => {data_type => 'timestamp', set_on_create => 1,},
    'updated' => {
        data_type => 'timestamp', 
        set_on_create => 1, set_on_update => 1,
    },
    
    'extra' => { data_type => 'TEXT', is_nullable => 1 },
    'extra_search1' => { data_type => 'TEXT', is_nullable => 1 },
    'extra_search2' => { data_type => 'TEXT', is_nullable => 1 },
    'from_date' => { data_type => 'date', is_nullable => 1 },
    'to_date' => { data_type => 'date', is_nullable => 1 },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->utf8_columns(qw/title body extra/);

__PACKAGE__->belongs_to(author => 'EasyCMS2::Schema::Base::Author');
__PACKAGE__->belongs_to(template => 'EasyCMS2::Schema::Base::Template');
__PACKAGE__->belongs_to(category => 'EasyCMS2::Schema::Base::Category');


__PACKAGE__->add_unique_constraint('unique_url' => ['category', 'url_title']);

__PACKAGE__->has_many('comments' => 'EasyCMS2::Schema::Base::Comment', 'page', {order_by => 'created'});

__PACKAGE__->has_many('page_tags' => 'EasyCMS2::Schema::Base::PageTag', 'page');
#__PACKAGE__->many_to_many('tags' => '_page_tags', 'tag');

__PACKAGE__->inflate_column('extra' => {
    'inflate' => sub { return EasyCMS2::Extra->new({'stored' => shift})},
    'deflate' => sub { return shift->store(); }
});

__PACKAGE__->resultset_class('EasyCMS2::Schema::ResultSet::Page');


__PACKAGE__->utf8_columns(qw/title body extra/);

sub get_extra {
    my $self = shift;
    my $extra = shift;
    my $h = $self->extra;
    
    return ($h ? $h->get($extra) : undef);
}

sub set_extra {
    my $self = shift;
    my $extra = shift;
    my $value = shift;
    my $h = $self->extra || EasyCMS2::Extra->new();
    
    $h->set($extra => $value);
    $self->extra($h);
    
    return $value;
}


sub toHash {
    my $self = shift;
    
    my $hash = {
        'id' => $self->id,
        'title' => $self->title,
        'body' => $self->body,
        'uri_base' => $self->uri_for,
    };
    return $hash;
}

sub get_template {
    my $self = shift;
    
    if ($self->template) {
        return $self->template;
    } else {
        return $self->category->get_template;
    }
}

sub formated_body {    
    return $textile->process( shift->body );
}


sub uri_for {
    my $self = shift;
    my $c = shift;
    my @parents;
    
    return undef unless $self->category;
    
    my $cat = $self->category;
    while ($cat) {
        unshift @parents, $cat->url_name;
        $cat = $cat->parent || undef;
    }
    push @parents, $self->url_title;
    
    return ($c ? $c->uri_for('/', @parents)->path_query : join ('/', @parents));
}
sub can_remove {
    my $self = shift;
    
    return 1;
    
}
sub remove {
    my $self = shift;
    if ($self->can_remove) {
        $self->delete();
        return 1;
    } else {
        return 0;
    }
}

sub allow_comment {
    my $self = shift;
    
    return 1 if $self->allow_comments;
    
    my $cat = $self->category;
    while ($cat) {
        return 1 if $cat->allow_comments;
        $cat = $cat->parent || undef;
    }
    return 0;
}

sub comment_form {
    my $self = shift;
    
}

sub tags {
    my $self = shift;


    if (@_) {
        # We need to set
#        $self->set_tags(@_);
    }
    return $self->get_tags();
}


sub set_tags {
    my ($self, $tags) = @_;
    $self->page_tags->delete_all;
    my @tags = $self->parse_tags($tags);
    foreach my $name (@tags) {
        $self->tag($name);
    }
}

sub parse_tags {
    my ($self, $tags) = @_;
    my @tags;
    my $w;
    my $q = 0;
    foreach (split(//, $tags)) {
        if (/\s/ and !$q) {
            # end of a word
            next if ($w eq '');
            push @tags, $w;
            $w = '';
        }
        elsif (/["'`]/ and $q) {
            # we end a quote
            push @tags, $w;
            $q = 0;
            $w = '';
        }
        elsif (/["'`]/ and !$q) {
            # we begin a quote
            $q = 1;
            $w = '';
        } 
        else {
            $w .= $_;
        }
    }
    push @tags, $w if ($w ne '');

    return (wantarray ? @tags : \@tags);
}
sub get_tags {
    my ($self) = @_;
    $self->page_tags->stringify;
}

sub tag {
    my ($self, $name) = @_;
    return unless $name;
    $name = lc($name);
    my $tag = $self->result_source->schema->resultset('Tag')->find_or_create({
        'name' => $name
    });
    
    $self->add_to_page_tags({'page' => $self, 'tag' => $tag});
}

sub untag {
    my ($self, $name) = @_;
    return unless $name;
    $name = lc($name);
    $self->page_tags->find({'tag' => {'name' => $name}})->delete_all;
}
1;