awk -F '\t' 'BEGIN{OFS="\t"}{ print $1,$2,$3,$1":"$2":"$3":"$4":"$6,$5,$6 }' out8.peaks.3.bed > out8.peaks.3.addInfo.bed   ### out8.peaks.3.bed for SARS-CoV-2-to-host interaction peaks
bedtools slop -b 200 -i out8.peaks.3.addInfo.bed -g chlSab2.chrom.sizes > out8.peaks.3.extend200bp.bed
bedtools makewindows -i srcwinnum -n 50 -b out8.peaks.3.extend200bp.bed > out8.peaks.3.extend200bp.50wins.bed
bigWigAverageOverBed SPLASH.virus.onlytarget.bigwig out8.peaks.3.extend200bp.50wins.bed result1.SPLASH.around_V-to-H_peaks.tab   ### SPLASH.virus.onlytarget.bigwig for SARS-CoV-2-to-host interaction reads
perl stat_ChIP_around_gene.pl result1.SPLASH.around_V-to-H_peaks.tab > result1.SPLASH.around_V-to-H_peaks.xls
perl tab_file_sum.pl result1.SPLASH.around_V-to-H_peaks.xls 0.01 > result1.SPLASH.around_V-to-H_peaks.avg.xls



