#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use LWP::Simple;
use CGI::Carp qw(fatalsToBrowser);
use feature qw(say);
use JSON qw(decode_json);

my $_content = get 'http://media1.clubpenguin.com/play/en/web_service/game_configs/rooms.json';
my $_data = decode_json $_content;

my $_icontent = get 'http://media1.clubpenguin.com/play/en/web_service/game_configs/paper_items.json';
my $_items = decode_json $_icontent;

my $_info = '';
my $_item_id = '';

map {
	my $_key = $_;
	my $_pin = $_data->{$_key}->{pin_id};
	$_item_id .= $_pin;
	if ($_pin) {
		foreach my $_item (sort @{$_items}) {
			if ($_item->{paper_item_id} == $_pin) {
				$_info .= 'The ' . $_item->{label} . ' is available at the ' . ucfirst($_data->{$_key}->{short_name});
			}
		}
	}
} sort keys %{$_data};

my $_html = CGI->new;

print $_html->header;

say $_html->start_html(
	-title => 'Pin Tracker',
	-author => 'neilmario@protonmail.com', 
	-id => "bodybg", 
	-script => {-type=>'JAVASCRIPT', -src=>'http://mystcp.pw/js/test.js'}, 
	-style => {'src' => 'http://mystcp.pw/pintracker.css'
});
say $_html->div({-id => "boxSep"});
say $_html->div({-id => "imgLiquidFill imgLiquid"});
say $_html->h1({id => "pinheader"}, 'Pin Tracker');
say $_html->div({id => "pinimage"}, $_html->img({src => 'http://media8.clubpenguin.com/game/items/images/paper/icon/120/' . $_item_id . '.png'}));
say $_html->end_div;
say $_html->p({id => "pininfo"}, $_info);
say $_html->end_div;
say $_html->end_div;
say $_html->end_html;

exit 0;
