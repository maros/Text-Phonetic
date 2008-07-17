# ================================================================
package Text::Phonetic;
# ================================================================
use strict;
use warnings;
use utf8;

use Exporter::Lite;
use Text::Unidecode;

use Carp;

use vars qw($VERSION);
$VERSION = '1.05';

use 5.008000;

# ----------------------------------------------------------------
sub new
# ----------------------------------------------------------------
{
	my $class = shift;
	my $params = (scalar(@_) == 1 && ref($_[0]) eq 'HASH') ? shift : { @_ };

	$params->{'unidecode'} = 1 unless (defined($params->{'unidecode'}));
	
	my $obj = bless $params,$class;
	return $obj;
}

# ----------------------------------------------------------------
sub encode
# ----------------------------------------------------------------
{
	my $obj = shift;

	if (scalar(@_) == 1) {
		my $string = shift;
		$string = unidecode($string) if ($obj->{'unidecode'});
		return $obj->_do_encode($string);
	} elsif (scalar(@_) > 1) {
		my @result_list;
		foreach my $string (@_) {
		    my $string_decode = ($obj->{'unidecode'}) ? 
		        unidecode($string) : 
		        $string;
			push @result_list,$obj->_do_encode($string_decode);
		}
		return wantarray ? @result_list : \@result_list;
	}
	return;
}

# ----------------------------------------------------------------
sub compare
# ----------------------------------------------------------------
{
	my $obj = shift;
	my $string1 = shift;
	my $string2 = shift;

	# Extremely rare case ;-)	
	return 100 if ($string1 eq $string2);

	if ($obj->{'unidecode'}) {
		$string1 = unidecode($string1);
		$string2 = unidecode($string2);
		
		# Also not very likely, but has to be checked
		return 99 if ($string1 eq $string2);
	}
	
	return $obj->_do_compare($obj->_do_encode($string1),$obj->_do_encode($string2));
}
	
# ----------------------------------------------------------------
sub _do_compare
# ----------------------------------------------------------------
{
	my $obj = shift;
	my $result1 = shift;
	my $result2 = shift;

	return 50 if ($result1 eq $result2);
	return 0;
}
		
# ================================================================
# Utility functions
# ================================================================

# ----------------------------------------------------------------
sub _is_inlist
# ----------------------------------------------------------------
{
	my $string = shift;
	my $list = (scalar @_ == 1 && ref($_[0]) eq 'ARRAY') ? shift : \@_;
	 
	return 1 if grep {$string eq $_ } @$list;
	return 0;
}

# ----------------------------------------------------------------
sub _compare_list
# ----------------------------------------------------------------
{
	my $list1 = shift;
	my $list2 = shift;

	return 0 unless ref($list1) eq 'ARRAY' && ref($list2) eq 'ARRAY';

	foreach my $element1 (@$list1) {
		next unless defined $element1;
		foreach my $element2 (@$list2) {
			next unless defined $element2;
			return 1 if	$element1 eq $element2;
		}
	} 
	
	return 0;
}

"Schmitt ~ Smith ~ Schmitz";

=encoding utf8

=pod

=head1 NAME

Text::Phonetic - A module implementing various phonetic algorithms

=head1 SYNOPSIS

  use Text::Phonetic;
  
  my $phonetic = Text::Phonetic::Metaphone->new();
  $encoded_string = $phonetic->encode($string);
  @encoded_list = $phonetic->encode(@list);
  
  my $same = $phonetic->compare($string1,$string2);

This module provides an easy and convinient way to encode names with various 
phonetic algorithms. It acts as a wrapper arround other phonetic algorithm
modules like L<Text::Metaphone>, L<Text::DoubleMetaphone>, L<Text::Soundex>
and also implements some other algorithms such as 
L<Text::Phonetic::DaitchMokotoff>, L<Text::Phonetic::Koeln>,
L<Text::Phonetic::Phonem> and L<Text::Phonetic::Phonix>.

The module can easily be subclassed.

=head1 DESCRIPTION

=head2 new

 $obj = Text::Phonetic::SUBCLASS->new({ %PARAMETERS })
 
You can pass arbitrary attributes to the constructor. The only global 
attribute is C<unidecode> which defaults to 1 if not set. This attribute 
controlls if non-latin characters should be transliterated to A-Z 
(see also L<Text::Unidecode>).

Additional attributes may be defined by the various implementation classes.

=head2 encode

 $RETURN_STRING = $obj->encode($STRING);
 OR
 @RETURN_LIST = $obj->encode(@LIST);
 OR
 $RETURN_LIST_REF = $obj->encode(@LIST);
 
Encodes the given string or list of strings. Returns a single value, array or
array reference depending on the caller context and parameters.

=head2 compare

 $RETURN_CODE = $obj->compare($STRING1,$STRING2);
 
The return code is an integer between 100 and 0 indicating the likelihood that
the to results are the same. 100  means that the strings are completely
identical. 99 means that the strings match after all non-latin characters
have been transliterated. Values in between 98 and 1 usually mean that the given 
strings match. 0 means that the used alogorithm couldn't match the two 
strings at all.
C<compare> is a shortcut to the C<$obj-&gt;_do_compare($CODE1,$CODE2)> method. 

=head1 SUBLCASSING

You can easily subclass Text::Phonetic and add your own phonetic algorithm.
All subclasses must use Text::Phonetic as their base class, and the 
following methods need to be implemented:

=head2 _do_encode

 $RESULT = $obj->_do_encode($STRING);

This method does the actual encoding. It should return only one element. (eg.
string or some kind of reference)

=head2 _do_compare

 $RETURN_STRING = $obj->_do_compare($RESULT1,$RESULT2);
 
If your C<_do_encode> method doesn't return a single scalar value you also 
might need to implement a comparison method. It takes two results as returned
by C<_do_encode> and returns an integer value between 98 and 0 
(see L<"compare">).

=head2 Object structure

The object is a simple Hash reference containing all parameters passed during
construction.

=head2 Helper class methods

=over 2

=item _is_inlist

 Text::Phonetic::_is_inlist($STRING,@LIST);
 OR
 Text::Phonetic::_is_inlist($STRING,$LIST_REF);
 
Returns a true value if $STRING is in the supplied list. Otherwise returns
false.

=item _compare_list

 Text::Phonetic::_compare_list($LIST1_REF,$LIST2_REF);

Compares the two arrays and returns true if at least one element is equal 
(ignoring the position) in both lists.  

=back

=head1 SUPPORT

Please report any bugs or feature requests to C<text-phonetic@rt.cpan.org>, or 
through the web interface at 
L<http://rt.cpan.org/Public/Bug/Report.html?Queue=Text::Phonetic>.  
I will be notified, and then you'll automatically be notified of progress on 
your report as I make changes.

=head1 AUTHOR

    Maroš Kollár
    CPAN ID: MAROS
    maros [at] k-1.com
    http://www.k-1.com

=head1 COPYRIGHT

Text::Phonetic is Copyright (c) 2006,2007 Maroš. Kollár.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
