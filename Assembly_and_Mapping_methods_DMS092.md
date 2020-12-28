# Methods for Genome Assembly, Comparison, and Mappping of Reads for CASJ002ΔchpE-ppaC 

## Table of Contents
  [Downloading Reads from Google Drive](#Downloading-Reads-from-Google-Drive)
  </br>
  [Checking for Contamination + Assessing Read Quality](#Checking-for-Contamination-Assessing-Read-Quality)
  </br>
  [Trimming Reads](#Trimming-Reads)


## Downloading Reads from Google Drive 
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

## Checking for Contamination + Assessing Read Quality 

First, we are going to check the read quality of our dataset. We can use fastqc via conda to easily check this.

```
conda install -c bioconda fastqc
fastqc DMS92_2_S159_R1_001.fastq.gz DMS92_2_S159_R2_001.fastq.gz
```

We can find the results [here](/raw_reads/DMS92_2_S159_R1_001_fastqc.html) for read set 1 and [here](/raw_reads/DMS92_2_S159_R2_001_fastqc.html) for read set 2 and quickly assess our read quality. Overall, the read quality looks ok, but based on the average GC-content around 48 percent (which is way too low for Clavibacter) and the bimodal distribution of the sequences across GC-content means there is definitely contamination in our read data set. We can them confirm this using BBtools sendsketch script, which breaks up reads into kmers and returns the closest hits. 

```
For example:
sendsketch.sh DMS92_2_S159_R1_001.fastq.gz
sendsketch.sh DMS92_2_S159_R2_001.fastq.gz
```

![](/images/DMS092_R1_sendsketch.png)
![](/images/DMS092_R2_sendsketch.png)


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
bbsplit.sh in1=./raw_reads/DMS92_2_S159_R1_001.fastq.gz in2=./raw_reads/DMS92_2_S159_R2_001.fastq.gz\
ref=/media/danimstevens/Second_storage/Genomes/DNA_contigs/CM_CASJ002.fasta,./GCF_000725365.1.fa.gz,\
./GCF_900110015.1.fa.gz basename=out_%.fq outu1=clean1.fq outu2=clean2.fq
```

As we can see from the output, we had a lot of reads that were the contaminant:

|File Name|Description|Mb of Data|
|--------|---------|------------|
|out_CM_CASJ002.fq|Reads Mapped to Our Genome|217 Mb|
|out_GCF_000725365.1.fq|Reads Mapped to Contaminant Reference Genome #1|440.8 Mb|
|out_GCF_900110015.1.fq|Reads Mapped to Contaminant Reference Genome #2|242.3 Mb|
|clean1.fq|forward reads which did not map|89 Mb|
|clean2.fq|reveres reads which did not map|89.1 Mb|

And we can confirm our reads are cleaned up by sending this output through sendsketch.sh again.

```
sendsketch.sh in=./out_CM_CASJ002.fq
```

![](/images/Cleaned_binned_reads_DMS092.png)


Additionally, we can use [sourmash](https://github.com/dib-lab/sourmash) to further confirm this:

```
conda install -c conda-forge -c bioconda sourmash
sourmash compute -k 31 *.fq *.fa /media/danimstevens/Second_storage/Genomes/DNA_contigs/CM_CASJ002.fasta
sourmash compare *.sig -o cmp
sourmash plot cmp --labels
```

![](/Files_for_cleanning_reads/cmp.matrix.png)

Here we can see our reads match closely to our Clavibacter genome CASJ002 based on the Jaccrd distance. However, one thing that we notice is now our paired reads are interweived. We need to seperate these back out using reformate.sh. We also need to rename the file since these reads are from DMS092 isolate.

```
reformat.sh in=./out_DMS092.fq out1=out_DMS092_R1.fq out2=out_DMS092_R2.fq
```

Now we need to recheck the quality of the filtered reads to assess how much trimming we need do (outside of the adapters themselves).

```
fastqc out_DMS092_R1.fq out_DMS092_R2.fq
```

We can find the results [here](/fastqc_resultd/out_DMS092_R1_fastqc.html) for read set 1 and [here](/fastqc_resultd/out_DMS092_R2_fastqc.html) for read set 2. This is to quickly assess our read quality. Overall, the read quality looks ok. They need a little trimming on the end, but that shouldn't be a problem.



## Trimming Reads 

Now that are reads are removed from contaminants, we need to trim off the adapters and the edges were the quality drops. Here we can use a tool called trimmomatic, which again we can install using conda.

```
conda install -c conda-forge -c bioconda trimmomatic

trimmomatic PE out_DMS092_R1.fq out_DMS092_R2.fq DMS92_1.pe.qc.fq DMS92_1.se.qc.fq DMS92_2.pe.qc.fq DMS92_2.se.qc.fq LEADING:2 TRAILING:2 \
SLIDINGWINDOW:4:15 \
MINLEN:25
```

Most reads were surviving (97.52%), which is good, and so we will move these files into the Trimmed_reads folder.


## Assembling Reads to De Novo Assembly with assistance



```		
conda install -c bioconda spades
spades.py -1 ./Trimmed_reads/DMS92_1.pe.qc.fq -2 ./Trimmed_reads/DMS92_2.pe.qc.fq -o De_novo_DMS092 --trusted-contigs /media/danimstevens/Second_storage/Genomes/DNA_contigs/CM_CASJ002.fasta
```
 bbmap.sh in=./Files_for_cleanning_reads/out_DMS092.fq ref=./De_novo_DMS092/contigs.fasta covstats=covstats.txt


```
fastANI -q ./De_novo_DMS092/contigs.fasta -r /media/danimstevens/Second_storage/Genomes/DNA_contigs/CM_CASJ002.fasta --visualize -o ANI_comparison.out

fastANI -q /path/to/genome_to_map.fasta -r /path/to/genome_to_compare_to.fasta --visualize -o ANI_comparison.out

```
 minimap2 -c /media/danimstevens/Second_storage/Genomes/DNA_contigs/CM_CASJ002.fasta ~/pSelAct_KO_Clavibacter/Files_for_cleanning_reads/out_DMS092.fq > align_reads_to_reference.paf