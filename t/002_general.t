# -*- perl -*-

# t/002_load.t - some general checks

use Test::More tests => 8+1;
use Test::NoWarnings;

use Class::MOP;

use_ok( 'Text::Phonetic' );

my @list = Text::Phonetic->available_algorithms();

ok(scalar @list >= 8,'Found at least 8 installed algorithms');
ok((grep { $_ eq 'Soundex'} @list),'Found soundex algorithm');

ok(Text::Phonetic::_is_inlist('hase','baer','hase','luchs'),'Helper function ok');
ok(! Text::Phonetic::_is_inlist('hase','baer','ratte','luchs'),'Helper function ok');
ok(Text::Phonetic::_is_inlist('hase',['baer','hase','luchs']),'Helper function ok');

ok(Text::Phonetic::_compare_list(['hase','baer'],['luchs','ratte','hase']),'Helper function ok');
ok(! Text::Phonetic::_compare_list(['hase','baer'],['luchs','ratte']),'Helper function ok');