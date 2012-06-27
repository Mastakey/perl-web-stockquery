package FinanceDownload;
use LWP::Simple;
use strict;

sub new
{
	my $class = shift;
	my $hash = shift;
    my $self = 
    {
		CSVURL => $hash->{CSVURL},
		CSVFILE => $hash->{CSVFILE},
    };    
    bless $self, $class;
    return $self;
}

sub downloadCSV
{
	my $self = shift;
	my $url = $self->{CSVURL};
	my $file = $self->{CSVFILE};
	getstore($url, $file) or die "Can not store";
}


sub test
{
	my $downloader = new FinanceDownload(
		{
			CSVURL => 'http://ichart.finance.yahoo.com/table.csv?s=AAPL&d=5&e=22&f=2012&g=d&a=1&b=1&c=1900&ignore=.csv',
			CSVFILE => 'output/nasdaq/AAPL.csv'
		}
	);
	$downloader->downloadCSV();
}

test();

1;