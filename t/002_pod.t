# -*- perl -*-

# t/002_pod.t - check pod

use Test::Pod tests => 9;

pod_file_ok( "lib/Text/Phonetic.pm", "Valid POD file" );
pod_file_ok( "lib/Text/Phonetic/Koeln.pm", "Valid POD file" );
pod_file_ok( "lib/Text/Phonetic/DaitchMokotoff.pm", "Valid POD file" );
pod_file_ok( "lib/Text/Phonetic/SoundexNara.pm", "Valid POD file" );
pod_file_ok( "lib/Text/Phonetic/Metaphone.pm", "Valid POD file" );
pod_file_ok( "lib/Text/Phonetic/DoubleMetaphone.pm", "Valid POD file" );
pod_file_ok( "lib/Text/Phonetic/Phonix.pm", "Valid POD file" );
pod_file_ok( "lib/Text/Phonetic/Soundex.pm", "Valid POD file" );
pod_file_ok( "lib/Text/Phonetic/Phonem.pm", "Valid POD file" );