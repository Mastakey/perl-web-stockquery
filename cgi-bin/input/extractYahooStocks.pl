use strict;
use FindBin;
use lib "$FindBin::Bin/../lib/";
use Yahoo::FinanceDownload;

my $inputDir = '../../Input/CSV';
#my $inputDir = '../../../StockAnalysis/Input/CSV';
my $outputDir = '../../Input/ExtractedData';
#my $outputDir = '../../../StockAnalysis/Input/ExtractedData';

#AMEX
my $amexInputFile = $inputDir.'/amex.csv';
my $amexOutputDir = $outputDir.'/amex/';

#NASDAQ
my $nasdaqInputFile = $inputDir.'/nasdaq.csv';
my $nasdaqOutputDir = $outputDir.'/nasdaq/';

#NYSE
my $nyseInputFile = $inputDir.'/nyse.csv';
my $nyseOutputDir = $outputDir.'/nyse/';



processCSVFile($amexInputFile, $amexOutputDir);
processCSVFile($nasdaqInputFile, $nasdaqOutputDir);
processCSVFile($nyseInputFile, $nyseOutputDir);

sub processCSVFile
{
	my $inputFile = shift;
	my $outputDir = shift;
	open my $file_fh, "<$inputFile" or die "can't open file: $!\n";
	my @lines = <$file_fh>;
	my @stocks = ();
	foreach my $line (@lines)
	{
		my @values = split(',', $line);
		my $stockname = $values[0];
		if (!($stockname =~ m/.*\^.*/) && !($stockname =~ m/.*\/.*/)) #IGNORE ANYTHING with ^ or /
		{
			$stockname =~ s/\"//g; #REMOVE QUOTES
			$stockname =~ s/\s//g; #REMOVE SPACES
			push(@stocks, $stockname);
		}	
	}
	close $file_fh;
	
	foreach my $stock (@stocks)
	{
		my $downloader = new FinanceDownload(
			{
				CSVURL => 'http://ichart.finance.yahoo.com/table.csv?s='.$stock.'&d=5&e=22&f=2012&g=d&a=1&b=1&c=1900&ignore=.csv',
				CSVFILE => $outputDir.$stock.'.csv'
			}
		);
		$downloader->downloadCSV();
		sleep(2);
	}
}