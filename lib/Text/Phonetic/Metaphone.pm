# ================================================================
package Text::Phonetic::Metaphone;
# ================================================================
use strict;
use warnings;
use utf8;

use base qw(Text::Phonetic);

use Text::Metaphone;

use vars qw($VERSION);
$VERSION = $Text::Phonetic::VERSION;

# -------------------------------------------------------------
sub _do_encode
# -------------------------------------------------------------
{
	my $obj = shift;
	my $string = shift;
	
	$obj->{'max_length'} ||= 0;
	
	return Metaphone($string,$obj->{'max_length'});
}

1;

=pod

=head1 NAME

Text::Phonetic::Metaphone - Metaphone algorithm

=head1 DESCRIPTION

Metaphone was developed by Lawrence Philips as a response to deficiencies in 
the Soundex algorithm. It is more accurate than Soundex because it uses a 
larger set of rules for English pronunciation. (Wikipedia, 2007)

This module is a thin wrapper arround L<Text::Metaphone>.

The parameter C<max_length> can be set to limit the length of the encoded 
string.

=head1 AUTHOR

    Maroš Kollár
    CPAN ID: MAROS
    maros [at] k-1.com
    http://www.k-1.com

=head1 COPYRIGHT

Text::Phonetic::Metaphone is Copyright (c) 2006,2007 Maroš. Kollár.
All rights reserved.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=head1 SEE ALSO

Description of the algorithm can be found at 
L<http://en.wikipedia.org/wiki/Metaphone>

L<Text::Metaphone>

=cut
