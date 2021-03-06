#!/usr/bin/perl

use strict;
use warnings;

use feature "switch";

use WWW::Mechanize;

sub main
{
    my $self = shift;
    my $agent = WWW::Mechanize->new();
    $agent->get("https://www.americanexpress.com/uk/cardmember.shtml");
    $agent->form_id("ssoform") or die "Can't get form\n";
    $agent->set_fields('UserID' => 'timothymollba' );
    $agent->set_fields('Password' => 'bbapwev4' );
    $agent->submit() or die "can't login\n";
    print $agent->content();
#    $agent->follow_link(text => 'Download PDF Statements');
#
#    warn "Loading page\n";
#
#    my $results = getAvailablePDFs($agent);
#
#    foreach my $filename (keys %$results)
#    {
#	unless ( -e $filename )
#	{
#	    my $data = $$results{$filename};
#	    savePdf($agent, $$data[1], $$data[0], $$data[2], $filename);
#	}
#    }
#
}

sub getAvailablePDFs
{
    my ($agent) = @_;
    my %results;

    my @matches = ( $agent->content() =~ m/(?s)javascript:GoToPDFPage.*?','([0-9]+)', '(.*?)', '([0-9]+).*?href="">(.*?)<\/a>/g );

    while (scalar @matches)
    {
	my $sortedIndex = shift @matches; 
	my $face = shift @matches; 
	my $pdfIndex = shift @matches; 
	my $date = shift @matches; 
	print "$sortedIndex, $face, $pdfIndex, $date\n";

	my $filename = dateFormat($date) . '.pdf';

	my @results = ($sortedIndex, $face, $pdfIndex);
	$results{$filename} = \@results;

    }

    return \%results;
}

sub dateFormat
{
    my ($dateIn) = @_;
    $dateIn =~ m/([^ ]*) ([^ ]*) ([0-9]{4})/;
    my $month;
    given ($2)
    {
	when ('January') { $month = '01'; }
	when ('February') { $month = '02'; }
	when ('March') { $month = '03'; }
	when ('April') { $month = '04' }
	when ('May') { $month = '05' }
	when ('June') { $month = '06' }
	when ('July') { $month = '07' }
	when ('August') { $month = '08' }
	when ('September') { $month = '09' }
	when ('October') { $month = '10' }
	when ('November') { $month = '11' }
	when ('December') { $month = '12' }
    }

    return "$3-$month";

}

sub savePdf
{
    my ($agent, $face, $sortedIndex, $pdfIndex, $fileName) = @_;
    
    $agent->form_name('EStmtImageInfoPage_form');
    
    my $form = $agent->current_form();
    $form->action('https://global.americanexpress.com/myca/intl/pdfstmt/emea/statementPDFDownload.do?request_type=');
    $form->method('post');

    $agent->set_fields( 'Face' => $face );
    $agent->set_fields( 'sorted_index' => $sortedIndex );
    $agent->set_fields( 'PDFIndex' => $pdfIndex );

    $agent->submit();

    open (my $file, '>', $fileName);
    print $file $agent->content();
    close($file);

    $agent->back();

}


main();
