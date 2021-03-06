#!/usr/bin/perl

use strict;
use warnings;

use Cwd;

use Getopt::Std;
my %OPTIONS;

# Default sleep time 
use constant SLEEP_TIME => 10;

sub startup
{
    getopts("d:s:e:",\%OPTIONS);
    $OPTIONS{'d'} = getcwd() unless (defined $OPTIONS{'d'});
    $OPTIONS{'s'} = SLEEP_TIME unless (defined $OPTIONS{'s'});
}

sub getFileList
{
    my %currentFiles;
    my @files = <$OPTIONS{'d'}/*>;
    foreach (@files)
    {
        chomp ($_);
        # ignore dirs
        next if ( -d $_);
	$_ =~ s/^$OPTIONS{'d'}//g;
	$_ =~ s/^\/+//;
        #
        #open(*FILE,$_) or next;
        #my $ctx = Digest::MD5->new;
        #$ctx->addfile(*FILE);
        # assuming using filename as key will result in no collisions
        #$currentFiles{$_} = $ctx->hexdigest;
        #close(*FILE);
        $currentFiles{$_} = 1;
    }
    return \%currentFiles;
}

sub areEqual
{
    my ($one, $two) = @_;
    foreach (keys %$one)
    {
        return 0 unless ($$two{$_});
    }
    foreach (keys %$two)
    {
        return 0 unless ($$one{$_});
    }
    return 1;
}


# Modes:
# 0:  full
# 1:  delta
sub details
{
    my ($fileList, $newFileList) = @_;
    my $details = '=== Listing: ' . localtime() . "===\n\n";
    if ( keys %$fileList or keys %$newFileList )
    {
    	foreach (keys %$fileList) { $details .= $_."\n" if (defined $$newFileList{$_})  }
    	foreach (keys %$newFileList) { $details .= '+ ' . $_."\n" unless (defined $$fileList{$_})  }
    	foreach (keys %$fileList) { $details .= '- ' . $_."\n" unless (defined $$newFileList{$_})  }
    }
    else
    {
	$details .= "  --empty--\n";
    }
    $details .= "\n----------------------------------------\n\n";
    return $details;
}

sub emailDetails
{
    my $details = shift;
    print $details,"\n";
    print "echoing details\n";
    `echo details $details`;
}

sub main
{
    startup();
    my $fileList = getFileList();
    print details($fileList, $fileList);
    while (1)
    {
        my $newFileList = getFileList();
        unless (areEqual $newFileList,$fileList)
        {
            # Different!
            my $details = details($fileList, $newFileList);
            print $details,"\n";
            emailDetails($details) if (defined ($OPTIONS{'e'}));
            $fileList = $newFileList;
        }
        sleep $OPTIONS{'s'};
    }
}

main();


