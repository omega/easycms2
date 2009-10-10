package EasyCMS2::CategoryType::Calendar;
use strict;
use warnings;

use Moose;
use Calendar::Calendar qw(calendar);
use Data::Dumper::Simple;
use DateTime;

$Calendar::Calendar::week_start_day = 1;
extends 'EasyCMS2::CategoryType';

override 'catch_all' => sub {
    return 1;
};

override 'index' => sub {
    my $self = shift;
    my $c = shift;
    my $rest_path = shift;
    my $stash_add = {};
    
    my $date;
    if (defined($rest_path) and $rest_path ne '' and $rest_path =~ m|^(\d{4})/(\d{2})$|) {
        $date = DateTime->new(year => $1, month=> $2);
    } else {
        $date = DateTime->now()->truncate(to => 'month');
    }
    
    if ($c->req->param('from')) {
        # Present a form
        my $w = HTML::FormFu->new();
        
        my $a = $c->model('Base::Author')->find_or_create({
            name => 'Bookings', 
            login => 'booking', 
            password => 'apejens'
        });
        my $page = $c->model('Base::Page')->new({
            author => $a->id, 
            category => $self->row->id,
            from_date => $c->req->param('from') 
        });
        
        $self->extend_page_form($w, $page, 0);
        $self->insert_elements($w->element({
            type => 'Submit',
            name => 'save',
            label_loc => 'save',
        }));
        
        $w->process($c->req);
        $stash_add->{'book_form'} = $w;
        
        $c->log->debug($w) if $c->debug;
        
        if ($c->req->method eq 'POST' and $w->submitted_and_valid ) {
            $c->log->debug("SHOULD SAVE PAGE") if $c->debug;
            
            my $title = "Booking: " . $page->from_date->ymd("-");
            $w->add_valid(title => $title);
            $w->add_valid(body => $title);
            
            $title = lc($title);
            $title =~ s/[^a-z0-9_-]+/_/g;
            
            $w->add_valid(url_title => $title);

            $w->model->update($page);
            # we also allow the category type to save its extensions.
            $page->category->type->extend_page_save($w, $page);
            $page->update();

            $c->res->redirect($page->category->uri_for($c, {confirm => 1}));
            
            # process the form
        }
    }
    $stash_add->{'title'} = $date->month_name.", ".$date->year;
    
    my $prev = $date->clone->subtract(months => 1);
    my $next = $date->clone->add(months => 1);
    
    $stash_add->{'prev'} = $prev->year . "/" . sprintf("%02d", $prev->month);
    $stash_add->{'next'} = $next->year . "/" . sprintf("%02d", $next->month);
    
    my @cal = Calendar::Calendar::generic_calendar($date->month, $date->year);
    $stash_add->{'month'} = $date->month;
    $stash_add->{'year'} = $date->year;
    $stash_add->{'curr'} = $date->year . "/" . sprintf("%02d", $date->month);
    $stash_add->{'book_ym'} = $date->year . "-" . sprintf("%02d", $date->month) . "-";
    
    $stash_add->{'calendar'} = \@cal;
    
    my $items = $self->row->pages({-or => [
        'from_date' => { '-between' => [$date, $next] },
        'to_date' => { '-between' => [$date, $next] }
    ]}, { 'order_by' => \'from_date ASC'});
    $stash_add->{'items'} = $items;
    
    return $stash_add;
};

override 'extend_page_form' => sub {
    my $self = shift;
    my $form = shift;
    my $page = shift;
    my $admin = shift;

    if ($admin) {
        $self->insert_elements(
            $form, $form->element({
                type => 'Checkbox',
                name => 'confirmed',
                label_loc => 'confirmed',
            })->checked( $page->get_extra('confirmed') ? 1 : 0 ))
    }
    $self->insert_elements(
        $form,
        $form->element({
            type => 'Text',
            name => 'from_date',
            label_loc => 'from',
        })->value($page->from_date ? $page->from_date->ymd('-') : undef),
        
        $form->element({
            type => 'Text',
            name => 'to_date',
            label => 'to',
        })->value($page->to_date ? $page->to_date->ymd('-') : undef),
        $form->element({
            type => 'Text',
            name => 'booker_name',
            label_loc => 'booker',
        })->value($page->get_extra('booker_name')),
        $form->element({
            type => 'Text',
            name => 'booker_email',
            label_loc => 'email'
        })->value($page->get_extra('booker_email')),
        $form->element({
            type => 'Text',
            name => 'booker_phone',
            label_loc => 'phone'
        })->value($page->get_extra('booker_phone')),
        $form->element({
            type => 'Text',
            name => 'booker_addr1',
            label_loc => 'address'
        })->value($page->get_extra('booker_addr1')),
        $form->element({
            type => 'Text',
            name => 'booker_addr2',
            label_loc => ''
        })->value($page->get_extra('booker_addr2')),
        $form->element({
            type => 'Text',
            name => 'booker_zip',
            label_loc => 'zip-code'
        })->value($page->get_extra('booker_zip')),
        $form->element({
            type => 'Text',
            name => 'booker_city',
            label_loc => 'city'
        })->value($page->get_extra('booker_city')),
        $form->element({
            type => 'Text',
            name => 'booker_number',
            label_loc => 'number'
        })->value($page->get_extra('booker_number')),
        
        
        
    );
    return $form;
};

override 'extend_page_save' => sub {
    my $self = shift;
    my $form = shift;
    my $page = shift;
    
    $page->set_extra('confirmed', $form->param('confirmed'));
    $page->set_extra('booker_name', $form->param('booker_name'));
    $page->set_extra('booker_email', $form->param('booker_email'));
    $page->set_extra('booker_phone', $form->param('booker_phone'));
    $page->set_extra('booker_addr1', $form->param('booker_addr1'));
    $page->set_extra('booker_addr2', $form->param('booker_addr2'));
    $page->set_extra('booker_zip', $form->param('booker_zip'));
    $page->set_extra('booker_city', $form->param('booker_city'));
    $page->set_extra('booker_number', $form->param('booker_number'));
    
};
1;

__DATA__
{
    'template' => qq{
[% IF c.req.param('from') %]

<p>Present booking form</p>
[% category.book_form %]

[% ELSE %]

[% IF c.req.param('confirm') %]
<p>Your booking is now registered</p>
[% END %]
[% SET cal = category.calendar %]
[% SET items = category.items %]
[% SET i = items.next %]
[% SET in_order = 0 %]
<table>
<tr>
<td colspan="1"><a href="[% cat.uri_for(c, category.prev) %]">&lt;&lt;</a></td>
<th colspan="5">[% category.title %]</th>
<td colspan="1"><a href="[% cat.uri_for(c, category.next) %]">&gt;&gt;</a></td>
<tr>
<th>Man</th><th>Tir</th><th>Ons</th><th>Tor</th><th>Fre</th><th>Lør</th><th>Søn</th>
</tr>
[% FOREACH week IN cal %]
<tr>
[% FOREACH day IN week %]
[% IF day AND in_order == 0 AND i.to_date.month == category.month AND i.from_date.month < category.month ;
SET in_order = 1;
ELSIF i AND in_order == 0 AND i.from_date AND i.from_date.month == category.month AND i.from_date.day <= day ;
SET in_order = 1 ;
ELSIF in_order == 1 AND ((i.to_date.month == category.month AND i.to_date.day < day) OR NOT day) ;
SET in_order = 0 ;
WHILE (i = items.next);
IF i.get_extra('confirmed') == 1;
BREAK;
END;
END;
END %]

<td[% IF in_order %] class="[% i.get_extra('confirmed') ? 'confirmed ' : '' %]taken"[% END %]>
[% IF NOT in_order %]<a href="[% cat.uri_for(c, category.curr, {from => category.book_ym _ day}) %]">[% END %][% day %]
[% IF NOT in_order %]</a>[% END %]</td>
[% END %]
</tr>
[% END %]
[% END %]
</table>
    },
    'css' => q{
@import "/static/css/forms.css";

td.taken {
    background-color: red;
}
td.confirmed {
    background-color: green;
}

    }
}