use Net::Twitter::Lite::WithAPIv1_1;
use bigint;
use utf8;
use open qw/:std :utf8/;
use strict;
use warnings;
use Path::Class;
use Time::Piece;
use autodie;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");

my $date = localtime->strftime('%Y%m%d');
my $filename = "TweetFile_Nordirland_".$date.".txt";
my $dir = dir("../Output");
my $file = $dir->file($filename);
my $file_handle = $file->openw();

  my $searchterm = "nordirland OR northern_ireland OR nordire OR nordirin OR
  					nordiren OR nordirinnen OR nordirisch OR belfast";

  my $nt = Net::Twitter::Lite::WithAPIv1_1->new(
      traits   => [qw/API::Search/],
      consumer_key        => "4CmmEPwA7ddOi94EoOBYJz4Xk",
      consumer_secret     => "3gKLa57CwoAvEeoQONNhYwnLlDoLOPjucH3xxiyerxPVCZjjWr",
      access_token        => "424193298-Vt2UPLanePcN4eJgnWx5xyMky1CbFoGx5rojD9oV",
      access_token_secret => "y5BSZ3x6EW6BZYjoEMmvPaA3pfeT2hwo44h55LmTMhEaR",
      ssl => 1 
  );
  
my $r;
  eval {
	my $lastid = 0;
	my $more = 0;
	my $wait = 0;
	my $cn = 0;
	my $time;
	print "please provide current wait status (calls since last wait):\n";
	$wait = <>;
	do {
		if ($more == 0) {
			$r = $nt->search({q => $searchterm, count => "100" , lang => "de" });
		} else {
			$r = $nt->search({q => $searchterm, count => "100" , lang => "de" , max_id => $lastid });
		}
		$more = 0;
		my $no = 0;
		for my $status ( @{$r->{statuses}} ) {
			$more = 1;
			$cn++;
			$no++;
			$lastid = $status->{id};
			 
			# print "$lastid\t$no";
			#binmode(STDOUT, ":utf8");
			$file_handle->print($cn."\t".$status->{id}."\t".$status->{created_at}."\t".$status->{text}."\n")
			#'\t' {text} . "\n");	
		}
		if($no <= 1){
			$more = 0;
		}
		$wait++;
		if($wait >= 175 && $more == 1){
			$time = localtime;
			print "$time - Reached 175 Calls, sleeping for 15 minutes!\n";
			sleep 5;
			sleep 900;
			$wait = 0;
		}
    } while ($more == 1);
	my $end = localtime;
	print "$end - finished running script. $cn tweets! - Calls since last wait: $wait";
  };
  warn "Error: $@\n" if $@;
