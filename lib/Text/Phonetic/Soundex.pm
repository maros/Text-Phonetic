# ================================================================
package Text::Phonetic::Soundex;
# ================================================================
use strict;
use warnings;
use utf8;

use base qw(Text::Phonetic);

use Text::Soundex qw( soundex );

use vars qw($VERSION);
$VERSION = $Text::Phonetic::VERSION;

# -------------------------------------------------------------
sub _do_encode
# -------------------------------------------------------------
{
	my $obj = shift;
	my $string = shift;
	
	return soundex($string);
}

1;

=encoding utf8

=pod

=head1 NAME

Text::Phonetic::Soundex - Soundex algorithm

=head1 DESCRIPTION

Soundex is a phonetic algorithm for indexing names by sound, as pronounced in 
English. Soundex is the most widely known of all phonetic algorithms. 
Improvements to Soundex are the basis for many modern phonetic algorithms. 
(Wikipedia, 2007)

This module is a thin wrapper arround L<Text::Soundex>.

=head1 AUTHOR

    Maroš Kollár
    CPAN ID: MAROS
    maros [at] k-1.com
    http://www.k-1.com

=head1 COPYRIGHT

Text::Phonetic::Soundex is Copyright (c) 2006,2007 Maroš. Kollár.
All rights reserved.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=head1 SEE ALSO

Description of the algorithm can be found at 
L<http://en.wikipedia.org/wiki/Soundex>

L<Text::Soundex>

=cut
