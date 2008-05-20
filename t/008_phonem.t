# -*- perl -*-

# t/008_phonem.t - phonem test 

use Test::More tests=>17;
use utf8;

use Text::Phonetic::Phonem;

require "t/global.pl";

my $phonix = Text::Phonetic::Phonem->new();

my %TEST = (
    'Müller'    => 'MULR',
    schneider   => 'CNAYDR',
    fischer     => 'VYCR',
    weber       => 'BR',
    meyer       => 'MAYR',
    mair        => 'MAYR',
    wagner      => 'BACNR',
    schulz      => 'CULC',
    becker      => 'BCR',
    bäker       => 'BACR',
    hoffmann    => 'OVMAN',
    schäfer     => 'CAVR',
    schaeffer   => 'CVR',
    computer    => 'COMDUR',
    pfeifer     => 'VAYVR',
    pfeiffer    => 'VAYVR',

);

isa_ok($phonix,'Text::Phonetic::Phonem');

while (my($key,$value) = each(%TEST)) {
    test_encode($phonix,$key,$value);
}