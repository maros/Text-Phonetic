# -*- perl -*-

# t/004_wrapper.t - check wrapped modules

use utf8;
use Test::More tests=>33+1;
use Test::NoWarnings;

use Text::Phonetic::Soundex;
use Text::Phonetic::SoundexNara;
use Text::Phonetic::Metaphone;
use Text::Phonetic::DoubleMetaphone;

require "t/global.pl";

$soundex = Text::Phonetic::Soundex->new();
isa_ok($soundex,'Text::Phonetic::Soundex');
test_encode($soundex,"Euler","E460");
test_encode($soundex,"Gauss","G200");
test_encode($soundex,"Hilbert","H416");
test_encode($soundex,"Knuth","K530");
test_encode($soundex,"Lloydi","L300");
test_encode($soundex,"Lukasiewicz","L222");
test_encode($soundex,"Ashcraft","A226");

$soundexnara = Text::Phonetic::SoundexNara->new();
isa_ok($soundexnara,'Text::Phonetic::SoundexNara');
test_encode($soundexnara,"Ashcraft","A261");

$metaphone = Text::Phonetic::Metaphone->new();
isa_ok($metaphone,'Text::Phonetic::Metaphone');
test_encode($metaphone,"recrudescence","RKRTSNS");
test_encode($metaphone,"moist","MST");
test_encode($metaphone,"Gutenberg","KTNBRK");

$metaphone = Text::Phonetic::Metaphone->new( max_length => 4);
test_encode($metaphone,"recrudescence","RKRT");
test_encode($metaphone,"Gutenberg","KTNB");

$doublemetaphone = Text::Phonetic::DoubleMetaphone->new();
isa_ok($doublemetaphone,'Text::Phonetic::DoubleMetaphone');
test_encode($doublemetaphone,"maurice",["MRS",undef]);
test_encode($doublemetaphone,"cambrillo",["KMPR",undef]);
test_encode($doublemetaphone,"katherine",["K0RN","KTRN"]);
test_encode($doublemetaphone,"Bob",["PP",undef]);

# Compare tests

is($doublemetaphone->compare('Alexander','Alieksandr'),50);
is($doublemetaphone->compare('Alexander','Barbara'),0);
is($doublemetaphone->compare('Alexander','Alexander'),100);
is($doublemetaphone->compare('Alexander','Alexandér'),99);

is($soundex->compare('Alexander','Alieksandr'),50);
is($soundex->compare('Alexander','Barbara'),0);
is($soundex->compare('Alexander','Alexander'),100);
is($soundex->compare('Alexander','Alexandér'),99);

# Multi tests
my @rlist = $soundex->encode('Alexander','Alieksandr','Euler');
my $rlist = $soundex->encode('Alexander','Alieksandr','Euler');
is(scalar(@rlist),3);
is(scalar(@$rlist),3);
is($rlist[2],'E460');
is($rlist->[2],'E460');
