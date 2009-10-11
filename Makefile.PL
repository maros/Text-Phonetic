# Load the Module::Install bundled in ./inc/
use strict;
use inc::Module::Install;

my $from = 'lib/Text/Phonetic.pm';

# Define metadata
name            'Text-Phonetic';
all_from        $from;
readme_from     $from;
readme_markdown_from $from;

perl_version    '5.008';

# Specific dependencies
requires        'Moose'                 => 0;
requires        'Module::Find'          => 0;
requires        'Text::Unidecode'       => 0;

recommends      'Text::MultiPhone'      => 0;
recommends      'Text::Soundex'         => '3.00';
recommends      'Text::Metaphone'       => 0;
recommends      'Text::DoubleMetaphone' => 0;
recommends      'Text::MultiPhone'      => 0;

build_requires  'Test::NoWarnings'      => 0;

repository 'git://github.com/maros/Text-Phonetic.git';

WriteAll;