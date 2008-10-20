# Load the Module::Install bundled in ./inc/
use strict;
use inc::Module::Install;

# Define metadata
name            'Text-Phonetic';
all_from        'lib/Text/Phonetic.pm';

perl_version    '5.008';

# Specific dependencies
requires        'Text::Unidecode'       => 0;
requires        'Text::Soundex'         => '3.00';
requires        'Text::Metaphone'       => 0;
requires        'Text::DoubleMetaphone' => 0;
requires        'Exporter::Lite'        => 0;
build_requires  'Test::Pod'             => 0;
build_requires  'Test::Pod::Coverage'   => 0;
build_requires  'Test::NoWarnings'      => 0;

WriteAll;