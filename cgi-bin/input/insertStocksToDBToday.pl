use strict;
use Data::Dumper;

insertToDb('../extractYahooStocks/output/test/', \&analysis, '');

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
	$file =~ s/\.csv//;
	#print $fileDir."\n";
	open my $file_fh, "<$fileDir" or die "can't open file: $!\n";
	my @lines = <$file_fh>;
	close $file_fh;
	my $stock = "";
	my $dataArray = _toArrayOfHash($file, \@lines);
	#print Dumper($dataArray);
	foreach my $data (@$dataArray)
	{
		my $query = qq~
		~;
	}
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

sub printFileDir
{
	my $fileDir = shift;
	print $fileDir."\n";
}