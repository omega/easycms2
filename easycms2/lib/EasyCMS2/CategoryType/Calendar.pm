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
    my $date;
    if (defined($rest_path) and $rest_path ne '' and $rest_path =~ m|^(\d{4})/(\d{2})$|) {
        $date = DateTime->new(year => $1, month=> $2);
    } else {
        $date = DateTime->now()->truncate(to => month);
    }
    
    my $stash_add = {};
    $stash_add->{'title'} = $date->month_name.", ".$date->year;
    
    my $prev = $date->clone->subtract(months => 1);
    my $next = $date->clone->add(months => 1);
    
    $stash_add->{'prev'} = $prev->year . "/" . sprintf("%02d", $prev->month);
    $stash_add->{'next'} = $next->year . "/" . sprintf("%02d", $next->month);
    
    my @cal = Calendar::Calendar::generic_calendar($date->month, $date->year);
    $stash_add->{'month'} = $date->month;
    $stash_add->{'year'} = $date->year;
    
    $stash_add->{'calendar'} = \@cal;
    
    my $items = $self->row->pages({-or => [
        'from_date' => { '-between' => [$date, $next] },
        'to_date' => { '-between' => [$date, $next] }
    ]}, { 'order_by' => 'from_date ASC'});
    $stash_add->{'items'} = $items;
    
    return $stash_add;
};

override 'extend_page_widget' => sub {
    my $self = shift;
    my $widget = shift;
    my $page = shift;
    
    $widget->element('Checkbox', 'confirmed')->label('Confirmed')->checked( $page->get_extra('confirmed') ? 1 : 0 );
    
    $widget->element('Textfield', 'from_date')->label('From');
    $widget->element('Textfield', 'to_date')->label('To');
    $widget->element('Textfield', 'booker_name')->label('Booker')->value($page->get_extra('booker_name'));
    $widget->element('Textfield', 'booker_email')->label('Email')->value($page->get_extra('booker_email'));
    $widget->element('Textfield', 'booker_phone')->label('Phone')->value($page->get_extra('booker_phone'));
    $widget->element('Textfield', 'booker_addr1')->label('Address')->value($page->get_extra('booker_addr1'));
    $widget->element('Textfield', 'booker_addr2')->label('Address #2')->value($page->get_extra('booker_addr2'));
    $widget->element('Textfield', 'booker_zip')->label('Zip-code')->value($page->get_extra('booker_zip'));
    $widget->element('Textfield', 'booker_city')->label('City')->value($page->get_extra('booker_city'));
    $widget->element('Textfield', 'booker_number')->label('Number')->value($page->get_extra('booker_number'));
    return $widget;
};

override 'extend_page_save' => sub {
    my $self = shift;
    my $result = shift;
    my $page = shift;
    
    $page->set_extra('confirmed', $result->param('confirmed'));
    $page->set_extra('booker_name', $result->param('booker_name'));
    $page->set_extra('booker_email', $result->param('booker_email'));
    $page->set_extra('booker_phone', $result->param('booker_phone'));
    $page->set_extra('booker_addr1', $result->param('booker_addr1'));
    $page->set_extra('booker_addr2', $result->param('booker_addr2'));
    $page->set_extra('booker_zip', $result->param('booker_zip'));
    $page->set_extra('booker_city', $result->param('booker_city'));
    $page->set_extra('booker_number', $result->param('booker_number'));
    
};
1;

__DATA__
{
    'template' => qq{
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

<td[% IF in_order %] class="taken"[% END %]>[% day %]</td>
[% END %]
</tr>
[% END %]
</table>
    },
    'css' => q{
td.taken {
    background-color: red;
}
    }
}