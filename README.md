# VCF vs plain text GWAS storage formats

To view comparison results open ```output.html``` in a web browser.

To reproduce the analysis follow the following instructions.

### Obtain source code

```sh
git clone --recurse-submodules git@github.com:MRCIEU/gwas-vcf-performance.git
```

### Build docker image

```sh
cd gwas-vcf-performance
docker build -t gwas-vcf-performance:latest .
```

### Download FASTA file

These files are needed to harmonise the data ensuring a consistent effect allele

```sh
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37.fasta.gz
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37.fasta.fai.gz
gzip -d human_g1k_v37.fasta.gz
gzip -d human_g1k_v37.fasta.fai.gz
```

### Run evaluation

Output will be a single html file ```output.html```

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('evaluation.Rmd',output_file='/data/output.pdf')"
```