#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
Getopt::Long::Configure('pass_through');

my $SEPERATOR = ';';
my $HEAD_FILE = '';
my $USE_STDIN = 1;
my $INPUT_FILE = '';
my $HEADER_FROM_FILE = 0;
my $PRINT_LINE_NUMBERS = 0;
my $HEAD_BODY_SEPARATOR = '';
my $EMPTY_HEAD_VALUE = '<MISSING>';
my $MAX_HEAD_LENGTH = length ($EMPTY_HEAD_VALUE);
my $STRIP_WHITESPACE = 0;

sub processArgs
{
    GetOptions(	'field-separator=s' => \$SEPERATOR,
		'header-file=s' => \$HEAD_FILE,
		'line-numbers' => \$PRINT_LINE_NUMBERS,
		'whitespace' => \$STRIP_WHITESPACE,
		'use-header' => \$HEADER_FROM_FILE
	      ) or die "Incorrect Arguments\n";

    if ($#ARGV >= 1)
    {
        $USE_STDIN = 0;
        $INPUT_FILE = $ARGV[1];
    }
}

sub generateHeader
{
    my @output;
    if ($HEAD_FILE or $HEADER_FROM_FILE)
    {
	
	$HEAD_FILE = $INPUT_FILE if ($HEADER_FROM_FILE);
	my $line;
	if ($HEAD_FILE)
	{
	    open (my $fh, '<', $HEAD_FILE) or die "Cannot open $HEAD_FILE\n";
	    $line = <$fh>;
	    close($fh);
	}
	else
	{
	    # will try and find filename in args
	    $line = <>;
	}
	chomp $line;
	$line =~ s/\r//;
	@output = split (/$SEPERATOR/, $line);
    }
    foreach ( @output )
    {
	$MAX_HEAD_LENGTH = length ($_) if (length($_) > $MAX_HEAD_LENGTH);
	$_ =~ s/  *// if ($STRIP_WHITESPACE);
    }
    return \@output;
}

sub generateBody
{
    my (@data, $line);
    if ($USE_STDIN)
    {
	$line = <>;
	$line = <> if ($HEADER_FROM_FILE);
    }
    else
    {
	open (my $fh, '<', $INPUT_FILE) or die "Cannot open $INPUT_FILE\n";
	if ($HEADER_FROM_FILE)
	{
	    # Throw away the first line
	    $line = <$fh>;
	}

	$line = <$fh>;
	close ($fh);
    }
    chomp $line;
    $line =~ s/\r//;
    @data = split (/$SEPERATOR/, $line);
    foreach (@data) {$_ =~ s/  *// if ($STRIP_WHITESPACE);}
    return \@data;
}

sub headerSpace
{
    my $head = shift;
    my $length = length ($head);
    my $return = "    ";
    while ($length < $MAX_HEAD_LENGTH )
    {
	$return .= " ";
	$length += 1;
    }
    return $return;
}

sub printResults
{
    my ($head, $body) = @_;
    my $length = @$head;
    $length = @$body if (@$body > $length);
    my $i;
    my $useHead = ($HEAD_FILE or $HEADER_FROM_FILE);
    for ( $i = 0; $i < $length; $i++)
    {
	print $i + 1,":\t" if ($PRINT_LINE_NUMBERS);
	if (exists $$head[$i] and $useHead)
	{
	    print $$head[$i],headerSpace($$head[$i]) if (exists $$head[$i]);
	}
	elsif ($useHead)
	{
	    print $EMPTY_HEAD_VALUE,headerSpace($EMPTY_HEAD_VALUE);
	}
	print $$body[$i] if (exists $$body[$i]);
	print "\n";
    }
}

sub main
{
    processArgs();
    my $head = generateHeader();
    my $body = generateBody();
    printResults($head, $body);
}

main();

