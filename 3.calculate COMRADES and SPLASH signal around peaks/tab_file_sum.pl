#!/usr/bin/perl
die "tab_file remove_how_many_percent\n" if(@ARGV != 2);
my $in_file=shift;
my $remove_percent=shift;
my %total;

open(IN,$in_file) || die;
while(my $line=<IN>){
	chomp $line;
	my @sub=split/\s+/,$line;

	my $sum;
	my $contain_nan;
	foreach (1..$#sub){
		if($sub[$_] =~ /nan/){
			$contain_nan=1;
		}
		$sum+=$sub[$_];
	}
	if($sum <= 0 ){
		next;
	}	
	if($contain_nan){
		next;
	}

	foreach (1..$#sub){
		push(@{$total{$_}},$sub[$_]);
	}
}

$in_file=~s/\.\w+$//;

print $in_file,"\n";
foreach (sort {$a<=>$b} keys %total){
	my @tmp=@{$total{$_}};
	#my ($avg,$min,$max)=normal_average(@tmp);
	#print $avg,"\t",$min,"\t",$max,"\n";
	my $avg=normal_average(@tmp);
	print $avg,"\n";
}


sub normal_average{
	my @in=@_;
	@in=sort{$a<=>$b} @in;
	my $remove=int($remove_percent*($#in+1));
	foreach (1..$remove){
		shift @in;
		pop @in;
	}
	my $total;
	my $avg;
	foreach (0..$#in){
		$total+=$in[$_];
	}
	$avg=$total/($#in+1);
	return  $avg;
	#return ($avg,$in[0],$in[-1]);
	#return ($avg,$in[int(0.25*$#in)],$in[int(0.75*$#in)]);
	#return ($in[int(0.5*$#in)],$in[int(0.25*$#in)],$in[int(0.75*$#in)]);
}

