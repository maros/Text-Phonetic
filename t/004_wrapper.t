# -*- perl -*-

# t/004_wrapper.t - check wrapped modules

use Test::More tests=>19;

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

$doublemetaphone = Text::Phonetic::DoubleMetaphone->new();
isa_ok($doublemetaphone,'Text::Phonetic::DoubleMetaphone');
test_encode($doublemetaphone,"maurice",["MRS",undef]);
test_encode($doublemetaphone,"cambrillo",["KMPR",undef]);
test_encode($doublemetaphone,"katherine",["K0RN","KTRN"]);
test_encode($doublemetaphone,"Bob",["PP",undef]);
