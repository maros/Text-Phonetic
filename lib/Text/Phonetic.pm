# ============================================================================
package Text::Phonetic;
# ============================================================================
use Moose;
use utf8;

use Text::Unidecode;
use Carp;
use Module::Find;

use version;
our $AUTHORITY = 'cpan:MAROS';
our $VERSION = version->new("2.00");

use 5.008000;

our $DEFAULT_ALGORITHM = 'Phonix';
our @AVAILABLE_ALGORITHMS = grep { s/^Text::Phonetic::(.+)$/$1/x } 
    findsubmod Text::Phonetic;

has 'unidecode' => (
    is              => 'rw',
    isa             => 'Bool',
    default         => 1,
    required        => 1,
    documentation   => q[Transliterate strings to ASCII before processing]
);

__PACKAGE__->meta->make_immutable;

# ----------------------------------------------------------------------------
# Class methods

sub available_algorithms {
    return @AVAILABLE_ALGORITHMS;
}

sub register_algorithm {
    my ($class,$algorithm) = @_;
    push @AVAILABLE_ALGORITHMS,$algorithm
        unless grep { $algorithm eq $_ } @AVAILABLE_ALGORITHMS;
    return $algorithm;
}

# ----------------------------------------------------------------------------
# Constructor (new provided by Moose)

sub load {
    my $self = shift;
    my $params = (scalar @_ == 1 && ref($_[0]) eq 'HASH') ? shift : { @_ };
    
    my $algorithm = delete($params->{algorithm}) || $DEFAULT_ALGORITHM;
    my $class = __PACKAGE__.'::'.$algorithm;
    
    unless (grep { $algorithm eq $_ } @AVAILABLE_ALGORITHMS) {
        croak("Could not load '$algorithm' phonetic algorithm: Algorithm not available");
    }
    
    unless (Class::MOP::is_class_loaded($class)) {
        my $ok = eval {
            Class::MOP::load_class($class);
        };
        unless ($ok) {
            my $error = $@ || 'Unknown error while loading '.$class;
            croak("Could not load '$algorithm' phonetic algorithm: $error")
        }
    }
    
    return $class->new($params);
}



# ----------------------------------------------------------------------------
# Public methods

sub encode {
    my $self = shift;
    
    
    # Single value
    if (scalar(@_) == 1) {
        my $string = shift;
        $string = Text::Unidecode::unidecode($string) 
            if ($self->unidecode);
        return 
            unless defined $string && $string !~ /^\s*$/;
        return $self->_do_encode($string);
    # Expand list
    } elsif (scalar(@_) > 1) {
        my @result_list;
        foreach my $string (@_) {
            push @result_list,$self->encode($string);
        }
        return wantarray ? @result_list : \@result_list;
    }
    # Fallback
    return;
}


sub compare {
    my ($self,$string1,$string2) = @_;

    return 0 unless defined $string1 && $string1 !~ /^\s*$/;
    return 0 unless defined $string2 && $string2 !~ /^\s*$/;

    # Extremely rare case ;-)    
    return 100 if ($string1 eq $string2);

    if ($self->unidecode) {
        $string1 = Text::Unidecode::unidecode($string1);
        $string2 = Text::Unidecode::unidecode($string2);
        
        # Also not very likely, but has to be checked
        return 99 if ($string1 eq $string2);
    }
    
    my $value1 = $self->_do_encode($string1);
    my $value2 = $self->_do_encode($string2);
    
    return 0 unless (defined $value1 && defined $value2);
    
    return $self->_do_compare($self->_do_encode($string1),$self->_do_encode($string2));
}
    
sub _do_compare {
    my ($self,$result1,$result2) = @_;
    
    return 50 if ($result1 eq $result2);
    return 0;
}

sub _do_encode {
    carp('_do_encode is an abstract method!');
}

# ----------------------------------------------------------------------------
# Utility functions

sub _is_inlist {
    my $string = shift;
    return 0 unless defined $string;
    my $list = (scalar @_ == 1 && ref($_[0]) eq 'ARRAY') ? shift : \@_;
     
    return 1 if grep {$string eq $_ } @$list;
    return 0;
}

sub _compare_list {
    my ($list1,$list2) = @_;

    return 0 unless ref($list1) eq 'ARRAY' && ref($list2) eq 'ARRAY';

    foreach my $element1 (@$list1) {
        next unless defined $element1;
        foreach my $element2 (@$list2) {
            next unless defined $element2;
            return 1 if    $element1 eq $element2;
        }
    } 
    
    return 0;
}

"Schmitt ~ Smith ~ Schmitz";

=encoding utf8

=pod

=head1 NAME

Text::Phonetic - A base class for phonetic algorithms

=head1 SYNOPSIS

  use Text::Phonetic::Metaphone;
  
  my $phonetic = Text::Phonetic::Metaphone->new();
  $encoded_string = $phonetic->encode($string);
  @encoded_list = $phonetic->encode(@list);
  
  my $same = $phonetic->compare($string1,$string2);

Or

  use Text::Phonetic;
  my $phonetic = Text::Phonetic->load( algorithm => 'Phonix' );
  $encoded_string = $phonetic->encode($string);

This module provides an easy and convinient way to encode names with various 
phonetic algorithms. It acts as a wrapper arround other phonetic algorithm
modules like L<Text::Metaphone>, L<Text::DoubleMetaphone>, L<Text::Soundex>
and also implements some other algorithms such as 
L<Text::Phonetic::DaitchMokotoff>, L<Text::Phonetic::Koeln>,
L<Text::Phonetic::Phonem> and L<Text::Phonetic::Phonix>. 

The module can easily be subclassed.

=head1 DESCRIPTION

=head2 Constructors

=head3 new

 $obj = Text::Phonetic::SUBCLASS->new(%PARAMETERS)
 
You can pass arbitrary attributes to the constructor. The only global 
attribute is C<unidecode> which defaults to 1 if not set. This attribute 
controlls if non-latin characters should be transliterated to A-Z 
(see also L<Text::Unidecode>).

Additional attributes may be defined by the various implementation classes.

=head3 load

 $obj = Text::Phonetic->new(algorithm => $algorithm, %PARAMETERS)

Alternative constructor which also loads the requested algorithm subclass.

=head2 Methods

=head3 encode

 $RETURN_STRING = $obj->encode($STRING);
 OR
 @RETURN_LIST = $obj->encode(@LIST);
 OR
 $RETURN_LIST_REF = $obj->encode(@LIST);
 
Encodes the given string or list of strings. Returns a single value, array or
array reference depending on the caller context and parameters.

Returns undef on an empty/undefined/whitespace only string.

=head3 compare

 $RETURN_CODE = $obj->compare($STRING1,$STRING2);
 
The return code is an integer between 100 and 0 indicating the likelihood that
the to results are the same. 100  means that the strings are completely
identical. 99 means that the strings match after all non-latin characters
have been transliterated. Values in between 98 and 1 usually mean that the 
given strings match. 0 means that the used alogorithm couldn't match the two 
strings at all.
C<compare> is a shortcut to the C<$obj-&gt;_do_compare($CODE1,$CODE2)> method.

=head2 Class Methods

=head3 available_algorithms 

 my @available = Text::Phonetic->available_algorithms;

Returns a list of all available/installed algorithms

=head1 SUBLCASSING

You can easily subclass Text::Phonetic and add your own phonetic algorithm.
All subclasses must use Text::Phonetic as their base class, reside in
the Text::Phonetic namespace, and implement the following methods:

=head2 _do_encode

 $RESULT = $obj->_do_encode($STRING);

This method does the actual encoding. It should return either a string or
an array reference.

=head2 _do_compare

 $RETURN_STRING = $obj->_do_compare($RESULT1,$RESULT2);
 
If your C<_do_encode> method doesn't return a single scalar value you also 
might need to implement a comparison method. It takes two results as returned
by C<_do_encode> and returns an integer value between 98 and 0 
(see L<"compare">).

=head2 Object structure

Text::Phonetic uses L<Moose> to declare attributes.

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

=head2 Example class

 package Text::Phonetic::MyAlgorithm;
 use Moose;
 extends qw(Text::Phonetic);
 
 has someattribute => (
    is  => 'rw',
    isa => 'Str',
 );
 
 __PACKAGE__->meta->make_immutable;
 
 sub _do_encode {
     my ($self,$string) = @_;
     # Do something
     return $phonetic_representation;
 }
 1;

=head1 SEE ALSO

L<DBIx::Class::PhoneticSearch> (Build phonetic indices via DBIx::Class),
L<Text::Phonetic::VideoGame> (Phonetic encoding for video game titles)

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
