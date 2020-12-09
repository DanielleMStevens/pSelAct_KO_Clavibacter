# Methods for Genome Assembly, Comparison, and Mappping of Reads


## Downloading Reads from Google Drive



## Assessing read Quality

```
conda install -c bioconda fastqc
fastqc DMS92_2_S159_R1_001.fastq.gz DMS92_2_S159_R2_001.fastq.gz
```
This is to quickly assess our read quality. If it looks ok, proceed as normal and if not, adjust protocol as need or consider resequencing.

## Trimming and Assembling Reads to De Novo Assembly

```
trimmomatic PE {input.read01} {input.read02} {output.pe.1} {output.se.1} {output.pe.2} {output.se.2} LEADING:2 TRAILING:2 \
		SLIDINGWINDOW:4:15 \
		MINLEN:25"

# In this case, each statement should be swapped out for the names of the files being inputed and outputed. An example below:


		trimmomatic PE DMS92_2_S159_R1_001.fastq.gz DMS92_2_S159_R2_001.fastq.gz DMS92_1.pe.qc.fastq.gz DMS92_1.se.qc.fastq.gz DMS92_2.pe.qc.fastq.gz DMS92_2.se.qc.fastq.gz LEADING:2 TRAILING:2 \
		SLIDINGWINDOW:4:15 \
		MINLEN:25
		
		
conda install -c bioconda spades
spades.py -1 DMS92_1.pe.qc.fastq.gz -2 DMS92_2.pe.qc.fastq.gz -o De_novo_DMS092 --trusted-contigs /path/to/contigs.fasta

		
```