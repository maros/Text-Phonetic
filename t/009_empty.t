# -*- perl -*-

# t/009_empty.t - empty string test 

use Test::More tests=>(8*4)+1;
use Test::NoWarnings;
use utf8;

foreach my $engine (qw(Phonem DaitchMokotoff Metaphone DoubleMetaphone Koeln Phonix Soundex SoundexNara)) {
    my $class = 'Text::Phonetic::'.$engine;
    eval('use '.$class);
    die($@)
        if $@;
    my $object = $class->new();
    my $encoded1 = $object->encode('');
    my $encoded2 = $object->encode('       ');
    my $encoded3 = $object->encode(undef);
    is($encoded1,undef);
    is($encoded2,undef);
    is($encoded3,undef);
    is($object->compare('\t','   '),0);
}