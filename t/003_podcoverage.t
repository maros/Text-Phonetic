# -*- perl -*-

# t/003_podcoverage.t - check pod coverage

use Test::More tests=>9;
eval "use Test::Pod::Coverage";
plan skip_all => "Test::Pod::Coverage required for testing POD coverage" if $@;

pod_coverage_ok( "Text::Phonetic", "POD is covered" );
pod_coverage_ok( "Text::Phonetic::Koeln", "Valid POD file" );
pod_coverage_ok( "Text::Phonetic::DaitchMokotoff", "Valid POD file" );
pod_coverage_ok( "Text::Phonetic::SoundexNara", "Valid POD file" );
pod_coverage_ok( "Text::Phonetic::Metaphone", "Valid POD file" );
pod_coverage_ok( "Text::Phonetic::DoubleMetaphone", "Valid POD file" );
pod_coverage_ok( "Text::Phonetic::Phonix", "Valid POD file" );
pod_coverage_ok( "Text::Phonetic::Soundex", "Valid POD file" );
pod_coverage_ok( "Text::Phonetic::Phonem", "Valid POD file" );
