use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use WEBDB;
use DBCFG;

	my $delquery = "DROP TABLE STOCKHISTORY;";
	my $insquery = qq~
		CREATE TABLE STOCKHISTORY ( 
		ID INTEGER PRIMARY KEY ASC AUTOINCREMENT, 
		STOCKINDEX TEXT NOT NULL,
		STOCK TEXT NOT NULL,
		DATE TEXT NOT NULL,
		OPEN REAL,
		HIGH REAL,
		LOW REAL,
		CLOSE REAL,
		VOLUME INTEGER,
		ADJCLOSE REAL
		);
	~;
my $dbcfg = new DBCFG('../../config/db.cfg');
#my $dbcfg = new DBCFG('../../../skeleton/config/db.cfg');

$dbcfg->getConfig();
my $db_con = $dbcfg->getConnection("STOCKDB");
my $db = new WEBDB($db_con->{DRIVER}.$db_con->{TNS}, "", "");

$db->connect();
$db->deleteSQL($delquery);
$db->commit();
$db->insertSQL($insquery);
$db->commit();
$db->disconnect();