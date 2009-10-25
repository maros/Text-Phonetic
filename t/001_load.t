# -*- perl -*-

# t/001_load.t - check module loading

use Test::More tests => 8+1;
use Test::NoWarnings;

use Class::MOP;

use_ok( 'Text::Phonetic' );
use_ok( 'Text::Phonetic::Koeln' );
use_ok( 'Text::Phonetic::DaitchMokotoff' );
use_ok( 'Text::Phonetic::Phonix' );
use_ok( 'Text::Phonetic::Phonem' );

load_conditional('Text::Phonetic::Metaphone','Text::Metaphone');
load_conditional('Text::Phonetic::DoubleMetaphone','Text::DoubleMetaphone');
load_conditional('Text::Phonetic::Soundex','Text::Soundex');
#load_conditional('Text::Phonetic::MultiPhone','Text::MultiPhone');

sub load_conditional {
    my ($test_class,$predicate_class) = @_;
    
    SKIP :{
        my $ok = eval {
            Class::MOP::load_class($predicate_class);
            use_ok($test_class);
            return 1;
        };
        unless ($ok) {
            skip "Not testing $test_class: $predicate_class is not installed",1;
        }
    }
}