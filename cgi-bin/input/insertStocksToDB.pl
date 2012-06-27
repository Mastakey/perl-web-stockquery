use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use WEBDB;
use DBCFG;

my $dbcfg = new DBCFG('../../config/db.cfg');
#my $dbcfg = new DBCFG('../../../skeleton/config/db.cfg');

$dbcfg->getConfig();
my $db_con = $dbcfg->getConnection("STOCKDB");
my $db = new WEBDB($db_con->{DRIVER}.$db_con->{TNS}, "", "");

$db->connect();
dir_walker('../../Input/ExtractedData/', \&toDB, '');
$db->disconnect();

sub dir_walker
{
	my $dirFile = shift;
	my $coderef = shift;
	my $fileName = shift;
	if (-f $dirFile) #if it's a file
	{
		$coderef->($dirFile, $fileName);
	}
	else #if it's a directory
	{
		my $dir_dh;
		if (opendir($dir_dh, $dirFile)) #open directory
		{
			while(my $subDirFile = readdir($dir_dh)) #read files in directory
			{
				if ($subDirFile eq '.' || $subDirFile eq '..'){next;} #skip current or parent directory
				dir_walker($dirFile."/".$subDirFile, $coderef, $subDirFile);
			}
		}
		else #directory can not be opened
		{
			warn "directory cannot be opened\n";
			return;
		}
	}
}

sub toDB
{

	my $fileDir = shift;
	my $file = shift;
	my $stockex = "";
	$file =~ s/\.csv//;
	
	print "Processing $file ...";
	
	if ($fileDir =~ m/nyse/g)
	{
		$stockex = "NYSE";
	}
	elsif ($fileDir =~ m/nasdaq/g)
	{
		$stockex = "NASDAQ";
	}
	elsif ($fileDir =~ m/amex/g)
	{
		$stockex = "AMEX";
	}
	
	#print $fileDir."\n";
	open my $file_fh, "<$fileDir" or die "can't open file: $!\n";
	my @lines = <$file_fh>;
	close $file_fh;

	my $dataArray = _toArrayOfHash($file, \@lines);
	#print Dumper($dataArray);
	foreach my $data (@$dataArray)
	{
		my $query = qq~
			INSERT INTO STOCKHISTORY (STOCKINDEX, STOCK, DATE, OPEN, HIGH, LOW, CLOSE, VOLUME, ADJCLOSE) 
			VALUES ('$stockex', '$file', Date('$data->{Date}'), $data->{Open}, $data->{High}, $data->{Low}, $data->{Close}, $data->{Volume}, $data->{AdjClose});
		~;
		$db->insertSQL($query);
	}
	$db->commit();
	print "Done\n";
	
}

sub _toArrayOfHash
{
	my $stock = shift;
	my $lines = shift;
	my @array = ();
	foreach my $line (@$lines)
	{
		if (!($line =~ m/^Date/gi)) #IGNORE FIRST LINE
		{
			#print $line;
			my @data = split(',', $line);
			my $data_hash = {
				Stock => $stock,
				Date => $data[0],
				Open => $data[1],
				High => $data[2],
				Low => $data[3],
				Close => $data[4],
				Volume => $data[5],
				AdjClose => $data[6],
			};
			$data_hash->{AdjClose} =~ s/\n//;
			push(@array, $data_hash);
		}
	}
	return \@array;
}

sub _dateStrConvert
{
	#CONVERT mm/dd/yyyy to yyyy-mm-dd
	my $str = shift;
	if ($str =~ m/(d+)\/(d+)\/(d+)/g) 
	{
		my $mm = $1;
		my $dd = $2;
		my $yyyy = $3;
		return $yyyy."-".$mm."-".$dd;
	}
	else
	{
		die "Can not convert date $str";
	}
}

sub printFileDir
{
	my $fileDir = shift;
	print $fileDir."\n";
}