#!/usr/bin/perl
die "perl $0 <*.tab> > *.windows.xls\n" if(@ARGV != 1);
my $tab=shift;

my %hash;
my %gene_strand;
my %gene_info;
open(IN,$tab) || die;
while(my $line=<IN>){
	chomp $line;
	my @sub=split/\s+/,$line;
	my ($chr,$start,$end,$peak_id,$info)=split/:/,$sub[0];
	my ($strand,$win_id)=split/_/,$info;
	$hash{$peak_id}{$win_id}=$sub[4];
	$gene_strand{$peak_id}=$strand;
	$gene_info{$peak_id}=$chr.":".$start.":".$end.":".$peak_id.":".$strand;
}

foreach my $peak_id (sort {$a<=>$b} keys %hash){
	my @signal;
	foreach my $win_id (sort {$a<=>$b} keys %{$hash{$peak_id}}){
		push (@signal,$hash{$peak_id}{$win_id});
	}
	if($gene_strand{$peak_id} eq "+"){
	}
	elsif($gene_strand{$peak_id} eq "-"){
		@signal=reverse @signal;
	}
	else{
		die "wrong strand symbol\n";
	}
	print $gene_info{$peak_id},"\t";
	foreach (@signal){
		print $_,"\t";
	}
	print "\n";
}
	
