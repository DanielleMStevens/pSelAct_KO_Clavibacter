# pSelAct KO Clavibacter

Danielle M. Stevens<sup>1,2</sup>, Andrea Tang<sup>1,</sup>, and Gitta Coaker<sup>1</sup>.

<sup>1</sup>Department of Plant Pathology, University of California, Davis, USA <br />
<sup>2</sup>Integrative Genetics and Genomics Graduate Program, University of California, Davis, USA <br />

---

#### Purpose: This repo hold the scripts to analyze gene knockout in Clavibacter using the pSelAct Knockout system.


The script tracks the genomics necessary to conclude if using the pSelAct system caused any other large rearrangement, which it does not appear to.

|Species|Strain|Gene Knockout|Details on Methods|
|------|----------|---------|-------------------|
|C. michiganensis|CASJ002|chpE-ppaC|[Assembly and Mapping Reads for CASJ002ΔchpE-ppaC](Assembly_and_Mapping_methods_DMS092.md)|

We can see based on the final figures below that acrross the genome even with low coverage sequencing, that there are no large structural rearnagements and the region is deleted cleanly. Since the coverage is low, the 5'Flank is broken into two contigs, but the regions are correct and based on molecular work suggests they are ok. Therefore, it is fair to conclude this method can be use to make clean, unmakred deletions in C. michiganensis and likely other Clavibacter bacteria.

|Dot plot comparing whole genome of WT and KO |  Comparing region from 5'Flank through 3'Flank between WT and KO |
:-------------------------:|:-------------------------:
![](/Final_Figures/Figure2D.pdf) |  ![](/Final_Figures/Figure2E.pdf)


Any questions or concerns, please feel free to submit an issue.

