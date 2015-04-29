#!/usr/bin/perl

use strict;
use warnings;

sub main
{
	my $prefix=shift;
	my @prefixParts=split(//, $prefix);
	my $newPrefix='';
	my $overflow = 1;
	for (my $i = scalar @prefixParts -1 ; $i >= 0; $i--)
	{
		my $chrOrd=ord($prefixParts[$i]);
		if ($overflow == 1)
		{
			$overflow = 0;
			$chrOrd += 1;
			if ($chrOrd > ord('Z'))
			{
				$newPrefix = 'A' . $newPrefix;
				$overflow = 1;
			} else {
				$newPrefix = chr($chrOrd) . $newPrefix;
			}
		}
		else
		{
			$newPrefix = $prefixParts[$i] . $newPrefix;
		}
	
	}
	return $newPrefix;
}


print main($ARGV[0]),"\n";
