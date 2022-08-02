perl extract_junction.pl ../0.source/infect_merge.virus.TargetAndSource.sam  ### sam file(infect_merge.virus.TargetAndSource.sam) for SARS-CoV-2-to-host chimeric reads
python 1.junction_fragment_region.py out1.arms.info 50 > out2.junction_in_host.fragment50nt.bed

awk -F '\t' 'BEGIN{OFS="\t"}{if($7=="Plus") print $4,$5,$5+1,$9,"255","+"; else if($7=="Minus") print $4,$5,$5+1,$9,"255","-"; }' out1.arms.info > out2.junction_in_host.bed
awk -F '\t' 'BEGIN{OFS="\t"}{ print $1,$2,$2+1,$9,"255","+" }' out1.arms.info > out2.junction_in_virus.bed


intersectBed -u -wa -a out2.junction_in_virus.bed -b ../0.source/Virion_Cell_ChangedMost_region_final.bed > out3.junction_in_virus.filtby.ChangedMost.bed ##junctions of structurally variable regions
python 2.filtbyHostReads.py out3.junction_in_virus.filtby.ChangedMost.bed out2.junction_in_host.fragment50nt.bed out3.junction_in_host.fragment50nt.filtby.ChangedMost.bed

bedtools sort -i out3.junction_in_host.fragment50nt.filtby.ChangedMost.bed > out3.junction_in_host.fragment50nt.filtby.ChangedMost.sort.bed
grep -E 'PC5UTR|PCCDS|PC3UTR|NCExon' chlSab2.Refseq_and_ensembl.gene_element.bed > out1.exon_region.bed
bedtools intersect -a out3.junction_in_host.fragment50nt.filtby.ChangedMost.sort.bed -b out1.exon_region.bed -s -u > out4.reads_in_exon.junction.fragment50nt.filtby.ChangedMost.bed

awk -F '\t' 'BEGIN{OFS="\t"}{if($6=="+") print $1,$2,$3,$4,$5,$6 }' out4.reads_in_exon.junction.fragment50nt.filtby.ChangedMost.bed |bedtools merge -s -i - |awk -F '\t' 'BEGIN{OFS="\t"}{ print $1,$2,$3,"+" }' > out5.reads_in_exon.plus.bed
awk -F '\t' 'BEGIN{OFS="\t"}{if($6=="-") print $1,$2,$3,$4,$5,$6 }' out4.reads_in_exon.junction.fragment50nt.filtby.ChangedMost.bed |bedtools merge -s -i - |awk -F '\t' 'BEGIN{OFS="\t"}{ print $1,$2,$3,"-" }' > out5.reads_in_exon.minus.bed
cat out5.reads_in_exon.plus.bed out5.reads_in_exon.minus.bed |awk -F '\t' 'BEGIN{OFS="\t"}{ print $1,$2,$3,"Region_"NR,"255",$4 }' > out6.reads_in_exon.junction.fragment50nt.filtby.ChangedMost.bed

bigWigAverageOverBed ../0.source/infect_merge.filtby.ChangedMost.onlyHost.bw out6.reads_in_exon.junction.fragment50nt.filtby.ChangedMost.bed out7.reads_in_exon.junction.fragment50nt.filtby.ChangedMost.tab ### bw file(infect_merge.filtby.ChangedMost.onlyHost.bw) for coverage of reads in host transcripts linking to structurally variable regions
python 3.select_peaks.py out7.reads_in_exon.junction.fragment50nt.filtby.ChangedMost.tab out6.reads_in_exon.junction.fragment50nt.filtby.ChangedMost.bed 3 > out8.peaks.3.bed