#!/usr/bin/perl -w

use strict;

my @aTestcases = (
	['Leuthner','Läutner','Lautner','Leutner'],
	['Sostakovic','Shostakovich','Sjostakovits','Schostankovitsch','Schostankovits'],
	['Meyer','Mier','Maier','Meier','Maya','Mayer'],
	['Kollar','Koller','Koler','Kola','Kolla','Koler','Koljar','köhler','Koala','Gollar','Kollár'],
	['Fysik','Physik','Fisik','Phisyk'],
	['Hofstädter','Hofstadder','Hofstäter','Hofstetter'],
	['Test','Testa','Tusta','Täsd'],
	['Maroš','Maros','Maroß','Möros',],
);

foreach my $aCase (@aTestcases) {
	print qq[- TESTCASE -------------------\n];
	foreach (@{$aCase}) {
		print phonetikKoeln($_).qq[ ($_)\n];
	}
}

# -------------------------------------------------------------
sub phonetikKoeln
# Liefert einen Zahlencode anhand der Regeln der Kölner Phonetik
# zurück. Liefert für deutsche Namen bessere Resultate als der
# Soundex Algorithmus.
#
# sPhonetik = &phonetikKoeln('STRING');
# -------------------------------------------------------------
{
	my ($sString,@aChars,$sResult,$sLast);
	$sString = shift;

	require Unicode::Normalize;
	
	for ( $sString ) {
		s/\xe4/AE/g;
		s/\xf1/NY/g;
		s/\xf6/OE/g;
		s/\xfc/UE/g;
		s/\xff/YU/g;
		s/\xff/YZ/g;
		
		$_ = Unicode::Normalize::NFD( $_ );
 		s/\pM//g;
		
		s/\x{00df}/SS/g;  #  ß
		s/[\x{00c6}|\x{00e6}]/AE/g;  #  Æ
		s/[\x{0132}\x{0133}]/IJ/g;  #  IJ
		s/[\x{0152}\x{0153}]/OE/g;  #  Œ
		s/[\x{010c}\x{010d}]/TSCH/g;  #  Œ
		
		tr/\x{00d0}\x{0110}\x{00f0}\x{0111}\x{0126}\x{0127}/DDDDHH/; # Ð?ð???
		tr/\x{0131}\x{0138}\x{013f}\x{0141}\x{0140}\x{0142}/IKLLLL/; # ??L.?l.?
		tr/\x{014a}\x{0149}\x{014b}\x{00d8}\x{00f8}\x{017f}/NNNOOS/; # ?n?Øøs
		tr/\x{00de}\x{0166}\x{00fe}\x{0167}/TTTT/;                   # Þ?þ?
		tr/\x{010c}\x{010d}/CC/;                   # Þ?þ?
	}
		
	$sString = uc($sString);	
	
	print $sString;
	
	# Doppelte Konsonanten ersetzen
	$sString =~ s/([BCDFGHJKLMNPQRSTßVWXZ])\1+/$1/g;
	# Umlaute ersetzen
	$sString =~ s/ß/S/g;
	$sString =~ s/Ä/AE/g;
	$sString =~ s/Ö/OE/g;
	$sString =~ s/Ü/UE/g;

	# String in Array aufsplitten
	@aChars = split //,$sString;
	$sResult = '';
	
	# Spezielle Regeln für Anlaute
	if ($aChars[0] =~ m/[AEIJYOU]/) {
		$sResult .= 0;
		$sLast = shift @aChars;
	} elsif ($aChars[0] eq 'C' && $aChars[1] =~ m/[AHKLOQRUX]/) {
		$sResult .= 4;
		$sLast = shift @aChars;
	} elsif ($aChars[0] eq 'C') {
		$sResult .= 8;
		$sLast = shift @aChars;
	}
	
	# Schleife wird ausgeführt bis alle Buchstaben abgearbeitet wurden
	while (scalar(@aChars) > 0) {
		#last if (length($sResult) == 5);
		if ($aChars[0] =~ m/[DT]/) {
			if (defined($aChars[1]) && $aChars[1] =~ m/[CSZ]/) {
				$sResult .= 8;
			} else {
				$sResult .= 2;
			}
			$sLast = shift @aChars;
			next;
		}
		if ($aChars[0] =~ m/[FVW]/) {
			$sResult .= 3;
			$sLast = shift @aChars;
			next;
		} 
		if ($aChars[0] eq 'P' && $aChars[1] eq 'H') {
			$sResult .= 3;
			$sLast = shift @aChars;
			next;
		}
		if ($aChars[0] =~ m/[BP]/) {
			$sResult .= 1;
			$sLast = shift @aChars;
			next;
		}
		
		if ($aChars[0] =~ m/[GQK]/
			|| ($aChars[0] eq 'C' && defined($aChars[1]) && $aChars[1] =~ m/[AOUHKXQ]/)) {
			$sResult .= 4;
			$sLast = shift @aChars;
			next;
		}
		if ($aChars[0] eq 'X') {
			if ($sLast !~ m/[CKQ]/) {
				$sResult .= 4;
			}
			$sResult .= 8;
			$sLast = shift @aChars;
			next;
		}
		if ($aChars[0] eq 'L') {
			$sResult .= 5;
			$sLast = shift @aChars;
			next;
		}
		if ($aChars[0] =~ /[MN]/) {
			$sResult .= 6;
			$sLast = shift @aChars;
			next;
		}	
		if ($aChars[0] eq '7') {
			$sResult .= 5;
			$sLast = shift @aChars;
			next;
		}
		if ($aChars[0] =~ /[SZ]/) {
			$sResult .= 8;
			$sLast = shift @aChars;
			next;
		}
		if ($aChars[0] eq 'C'
			&& !(defined($aChars[1]) && $aChars[1] =~ m/AOUHKXQ/)
			&& $sLast =~ m/[SZ]/) {
			$sResult .= 8;
			$sLast = shift @aChars;
			next;
		}
		
		# Keine Regel trifft zu
		$sLast = shift @aChars;
	}
	
	# Mehrfache Zahlen ersetzen
	$sResult =~ s/(\d)\1+/$1/g;
	
	return $sResult;
}


