# -*- perl -*-

# t/010_predicate.t - submodule predicate test

use Test::Most tests=>2+1;
use Test::NoWarnings;
use utf8;

use lib qw(t/lib);
use Text::Phonetic;

require "t/global.pl";

throws_ok {
    my $t1 = Text::Phonetic->load(algorithm => 'Fake');
    is($t1->encode('hase'),'HASE');
} qr/missing/;

throws_ok {
    require Text::Phonetic::Fake;
    my $t2 = Text::Phonetic::Fake->new();
    is($t2->encode('hase'),'HASE');
} qr/missing/;