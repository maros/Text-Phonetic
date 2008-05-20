# -*- perl -*-

# t/001_load.t - check module loading

use Test::More tests => 9;

use_ok( 'Text::Phonetic' );
use_ok( 'Text::Phonetic::Koeln' );
use_ok( 'Text::Phonetic::DaitchMokotoff' );
use_ok( 'Text::Phonetic::SoundexNara' );
use_ok( 'Text::Phonetic::Metaphone' );
use_ok( 'Text::Phonetic::DoubleMetaphone' );
use_ok( 'Text::Phonetic::Phonix' );
use_ok( 'Text::Phonetic::Soundex' );
use_ok( 'Text::Phonetic::Phonem' );

