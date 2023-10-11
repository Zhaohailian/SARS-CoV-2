## for Vero and A549-ACE2 cells:
perl step2.extract_junction.pl ../0.source/infect_add_merge_Vero_MOI01.virus.TargetAndSource.sam
python 1.junction_fragment_region.py out1.arms.info 50 > out2.junction_in_host.fragment50nt.bed

sort -k1,1 -k2,2n out2.junction_in_host.fragment50nt.bed > tmp.bed
awk -F '\t' 'BEGIN{OFS="\t"}{if($2>=0) print $0 }' tmp.bed > out3.junction_in_host.fragment50nt.sort.bed
grep -E 'PC5UTR|PCCDS|PC3UTR' ../0.source/chlSab2.Refseq_and_ensembl.gene_element.bed > out1.exon_region.bed
bedtools intersect -a out3.junction_in_host.fragment50nt.sort.bed -b out1.exon_region.bed -s -u > out4.reads_in_exon.junction.fragment50nt.bed

Piranha -s -o out8.peaks.piranha.bed -p 0.05 -b 20 -a 0.96 out4.reads_in_exon.junction.fragment50nt.bed
intersectBed -s -u -a out8.peaks.piranha.bed -b out1.exon_region.bed > out8.peaks.piranha.mRNA.bed

### for patient sample:

perl step2.extract_junction.pl ../0.source/patient_merge.virus.TargetAndSource.sam
python 1.junction_fragment_region.py out1.arms.info 50 > out2.junction_in_host.fragment50nt.bed

grep -E 'PC5UTR|PCCDS|PC3UTR' ../0.source/hg19.integrated.gene_element.bed > out1.exon_region.bed
bedtools intersect -a out2.junction_in_host.fragment50nt.bed -b out1.exon_region.bed -s -u > out4.reads_in_exon.junction.fragment50nt.bed
sort -k1,1 -k2,2n out4.reads_in_exon.junction.fragment50nt.bed > tmp.bed
awk -F '\t' 'BEGIN{OFS="\t"}{if($2>=0) print $0 }' tmp.bed > out4.reads_in_exon.junction.fragment50nt.sort.bed

awk -F '\t' 'BEGIN{OFS="\t"}{if($6=="+") print $1,$2,$3,$4,$5,$6 }' out4.reads_in_exon.junction.fragment50nt.sort.bed |bedtools merge -s -i - |awk -F '\t' 'BEGIN{OFS="\t"}{ print $1,$2,$3,"+" }' > out5.reads_in_exon.plus.bed
awk -F '\t' 'BEGIN{OFS="\t"}{if($6=="-") print $1,$2,$3,$4,$5,$6 }' out4.reads_in_exon.junction.fragment50nt.sort.bed |bedtools merge -s -i - |awk -F '\t' 'BEGIN{OFS="\t"}{ print $1,$2,$3,"-" }' > out5.reads_in_exon.minus.bed

cat out5.reads_in_exon.plus.bed out5.reads_in_exon.minus.bed |awk -F '\t' 'BEGIN{OFS="\t"}{ print $1,$2,$3,"Region_"NR,"255",$4 }' > out6.reads_in_exon.junction.fragment50nt.bed

bigWigAverageOverBed ../0.source/patient_merge.virus.onlytarget.bigwig out6.reads_in_exon.junction.fragment50nt.bed out7.reads_in_exon.junction.fragment50nt.tab
python 3.select_peaks.py out7.reads_in_exon.junction.fragment50nt.tab out6.reads_in_exon.junction.fragment50nt.bed 2 > out8.peaks.2.bed

