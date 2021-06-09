# Methods for Genome Assembly, Comparison, and Mappping of Reads for CASJ002ΔchpE-ppaC 

## Table of Contents
  [Downloading Reads from Google Drive](#Downloading-Reads-from-Google-Drive)
  </br>
  [Assessing Read Quality](#Assessing-Read-Quality)
  </br>
  [Checking for Contamination](#Checking-for-Contamination)
  </br>
  [Trimming Reads](#Trimming-Reads)
  </br>
  [Assembling Reads to De Novo Assembly](#Assembling-Reads-to-De-Novo-Assembly)
  </br>
  [Compare Contigs to Reference and KO Region](#Compare-Contigs-to-Reference-and-KO-Region)


## 1. Downloading Reads from Google Drive 
This is broken and need to be fixed.

First, I have stored the raw read data in google drive as a safe keeping. In order to then work with it, we need to download it. To do so, we can use wget and bypass some of the security measures by adding the '--ni-check-certificate'. To find more information, check out this [page](https://medium.com/tinghaochen/how-to-download-files-from-google-drive-through-terminal-4a6802707dbb).

```
Step 1. Clone the git from this url:
$ git clone https://github.com/chentinghao/download_google_drive.git

Step 2. In your home directory or the place where you clone, run the command below
$ python download_gdrive.py GoogleFileID /path/for/this/file/to/download/file.zip

Take for example:
If the download link looks like below, then the GoogleFileID is 0Bz7KyqmuGsilT0J5dmRCM0ROVHc
https://drive.google.com/uc?export=download&confirm=1o_3&id=0Bz7KyqmuGsilT0J5dmRCM0ROVHc

If the path for this file to download is /home/ubuntu/myfile/file.zip, then the command you should run is
$ python download_gdrive.py 0Bz7KyqmuGsilT0J5dmRCM0ROVHc /home/ubuntu/myfile/file.zip


python download_gdrive.py 1LTNXFpsiAKaKZ8QHieYpgBAN4Jv-LjgD ~/pSelAct_KO_Clavibacter/raw_reads/

https://drive.google.com/file/d/1LTNXFpsiAKaKZ8QHieYpgBAN4Jv-LjgD/view?usp=sharing
https://drive.google.com/file/d/1JZWkfG4Zx_b4tIx5YsevPqMuq8hF3_am/view?usp=sharing

```

## 2. Assessing Read Quality 

First, we are going to check the read quality of our dataset. We can use fastqc via conda to easily check this.

```
conda install -c bioconda fastqc
fastqc ./2_raw_reads_qc/DMS92_2_S159_R1_001.fastq.gz ./2_raw_reads_qc/DMS92_2_S159_R2_001.fastq.gz
```

We can find the results [here](/raw_reads/DMS92_2_S159_R1_001_fastqc.html) for read set 1 and [here](/raw_reads/DMS92_2_S159_R2_001_fastqc.html) for read set 2 and quickly assess our read quality. To view these files, copy and paste each url (after selecting the file) into https://htmlpreview.github.io/ to view report.

Overall, the read quality looks ok, but based on the average GC-content around 48 percent (which is way too low for Clavibacter) and the bimodal distribution of the sequences across GC-content means there is definitely contamination in our read data set. We can them confirm this using BBtools sendsketch script, which breaks up reads into kmers and returns the closest hits. 


## 3. Checking for Contamination


```
For example:
sendsketch.sh ./2_raw_reads_qc/DMS92_2_S159_R1_001.fastq.gz
sendsketch.sh ./2_raw_reads_qc/DMS92_2_S159_R2_001.fastq.gz
```

![](/images_for_github/DMS092_R1_sendsketch.png)
![](/images_for_github/DMS092_R2_sendsketch.png)


This output above shows that we have some significant contamination of Terribacillus. This will be problematic to downstream processing steps. Since the reads are mostly from two species, we will do a binning approach where we will map the reads to each genome, Clavibacter michiganensis and Terribacillus, and seperate them into groups. We will download two genomes, both Terribacillus species, to perform this. More info on this can be found [here](http://seqanswers.com/forums/showthread.php?t=41288).


| | Species|Strain|RefSeq Accession|
|-----------|--------------|---------------|--------------|
|ASM72536v1|Terribacillus goriensis|MP602|GCF_000725365.1|
|IMG-taxon 2636416060 annotated assembly|Terribacillus saccharophilus|DSM 21619|GCF_900110015.1|

The RefSeq Accession numbers will be stored in a text file. In this case, they are store in the Terribacillus_genomes_filter_contamination.txt. It looks like this:

```
cat Terribacillus_genomes_filter_contamination.txt
GCF_000725365.1
GCF_900110015.1
```

We can use a package known as bioinf_tools [package here](https://github.com/AstrobioMike/bioinf_tools), which we can download using conda.

```
conda install -c conda-forge -c bioconda -c defaults -c astrobiomike bit
bit-dl-ncbi-assemblies -w Terribacillus_genomes_filter_contamination.txt -f fasta
```

Now that we have both genomes downloaded, we can use bbsplit.sh from bbtools to bin the reads based on their hits. 

```
bbsplit.sh in1=./2_raw_reads_qc/DMS92_2_S159_R1_001.fastq.gz in2=./2_raw_reads_qc/DMS92_2_S159_R2_001.fastq.gz \
ref=/media/danimstevens/Second_storage/Genomes/DNA_contigs/CM_CASJ002.fasta,./GCF_000725365.1.fa.gz,./GCF_900110015.1.fa.gz \ basename=out_%.fq outu1=clean1.fq outu2=clean2.fq
```

As we can see from the output, we had a lot of reads that were the contaminant:

|File Name|Description|Mb of Data|
|--------|---------|------------|
|out_CM_CASJ002.fq|Reads Mapped to Our Genome|234 Mb|
|out_GCF_000725365.1.fq|Reads Mapped to Contaminant Reference Genome #1|440.8 Mb|
|out_GCF_900110015.1.fq|Reads Mapped to Contaminant Reference Genome #2|242.3 Mb|
|clean1.fq|forward reads which did not map|80.3 Mb|
|clean2.fq|reveres reads which did not map|80.3 Mb|

And we can confirm our reads are cleaned up by sending this output through sendsketch.sh again.

```
sendsketch.sh in=./out_CM_CASJ002.fq
```

![](/images_for_github/Cleaned_binned_reads_DMS092.png)


Additionally, we can use [sourmash](https://github.com/dib-lab/sourmash) to further confirm this:

```
conda install -c conda-forge -c bioconda sourmash
sourmash compute -k 31 *.fq *.fa /media/danimstevens/Second_storage/Genomes/DNA_contigs/CM_CASJ002.fasta
sourmash compare *.sig -o cmp
sourmash plot cmp --labels
```

![](/3_contamination_check/sourmash_analysis/cmp.matrix.png)

Here we can see our reads match closely to our Clavibacter genome CASJ002 based on the Jaccrd distance. However, one thing that we notice is now our paired reads are interweived. We need to seperate these back out using reformate.sh. We also need to rename the file since these reads are from DMS092 isolate.

```
reformat.sh in=./out_DMS092.fq out1=out_DMS092_R1.fq out2=out_DMS092_R2.fq
```

These files are now 117.3 Mb each. Now we need to recheck the quality of the filtered reads to assess how much trimming we need do (outside of the adapters themselves).

```
fastqc out_DMS092_R1.fq out_DMS092_R2.fq
```

We can find the results [here](/3_contamination_check/fastqc_results/out_DMS092_R1_fastqc.html) for read set 1 and [here](/3_contamination_check/fastqc_results/out_DMS092_R2_fastqc.html) for read set 2. This is to quickly assess our read quality. Overall, the read quality looks ok. They need a little trimming on the end, but that shouldn't be a problem.



## 4. Trimming Reads 

Now that are reads are removed from contaminants, we need to trim off the adapters and the edges were the quality drops. Here we can use a tool called trimmomatic, which again we can install using conda.

```
conda install -c conda-forge -c bioconda trimmomatic

trimmomatic PE out_DMS092_R1.fq out_DMS092_R2.fq DMS92_1.pe.qc.fq DMS92_1.se.qc.fq DMS92_2.pe.qc.fq DMS92_2.se.qc.fq \
LEADING:2 TRAILING:2 \
SLIDINGWINDOW:4:15 \
MINLEN:25
```

Most reads were surviving (97.52%), which is good, and so we will move these files into the Trimmed_reads folder.


## 5. Assembling Reads via Guided De Novo Assembly

Since the overall read coverage is low, we going to take a slightly a typical approach. We will de-novo assemble the trimmed reads and then scaffold the contigs based on the wildtype reference genome. This should prevent the assembler from filling in the knocked out region based on the reference. 

```		
conda install -c bioconda spades
spades.py -1 ./4_trimmed_reads/DMS92_1.pe.qc.fq -2 ./4_trimmed_reads/DMS92_2.pe.qc.fq -o DMS092 --careful
```


We can then scaffold the genome by running it through [medusa](https://academic.oup.com/bioinformatics/article/31/15/2443/188083). We will select the contigs output from spades as the target draft genome and the wildtype reference genome as comparison genomes. But we notice that they are all on the negative strand. The easiest way to reverse complement the contigs based on the reference usign [contiguator2](http://contiguator.sourceforge.net). This will align the contigs and we can download each contig (in this case 3) and put back in the fasta file (from chromosome, pCM1, and pCM2) and save as DMS092_scafold.fasta.


To check the coverage of the assembly:
```
bbmap.sh in=./3_contamination_check/output_cleanning_reads/out_CM_CASJ002.fq.gz ref=./5.fasta covstats=covstats.txt
```

This file is moved to 5_assemble_genome for reference.


## 6. Compare Contigs to Reference


Now we are going to use minimap2 to map different sets of contigs, regions, and genomes against each other to assess 1) the KO is real and 2) no major other structural changes occured.

```
# dotplot - whole genome comparions
minimap2 -c ./GCA_002150935.1.fa ./5_assemble_genome/DMS092_scaffold.fasta > align_contigs_to_reference.paf
```

We can then open up visualize.R script and run the first half which will plot the output as a dotplot using the pafr R package.

## 7. Compare Contigs to KO Region


We can also use fastANI to confirm
```
fastANI -q ./De_novo_DMS092/contigs.fasta -r /media/danimstevens/Second_storage/Genomes/DNA_contigs/CM_CASJ002.fasta --visualize -o ANI_comparison.out
```
 
