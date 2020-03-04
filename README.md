# VCF vs plain text GWAS storage formats

To view comparison results open html files in a web browser.

To reproduce the analysis follow the following instructions.

## Obtain source code

```sh
git clone --recurse-submodules git@github.com:MRCIEU/gwas-vcf-performance.git
```

## Build docker image

```sh
cd gwas-vcf-performance
docker build -t gwas-vcf-performance:latest .
```

## Download FASTA file

These files are needed to harmonise the data ensuring a consistent effect allele

```sh
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37.fasta.gz
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37.fasta.fai.gz
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37.dict.gz
gzip -d human_g1k_v37.fasta.gz
gzip -d human_g1k_v37.fasta.fai.gz
gzip -d human_g1k_v37.dict.gz
```

## Download dbSNP file

These files are needed to update dbSNP identifiers

```sh
wget ftp://ftp.ncbi.nih.gov/snp/latest_release/VCF/GCF_000001405.25.gz
wget ftp://ftp.ncbi.nih.gov/snp/latest_release/VCF/GCF_000001405.25.gz.tbi
mv GCF_000001405.25.gz dbsnp.v153.b37.vcf.gz
mv GCF_000001405.25.gz.tbi dbsnp.v153.b37.vcf.gz.tbi
```

## Prepare GWAS

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance \
--rm \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/workflow.Rmd', output_file='/data/workflow.html')"
```

## Run evaluations

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance \
-it -d \
--rm \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/rsid_query_performance.Rmd', output_file='/data/rsid_query_performance.html')"
```

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance \
--rm \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/chrpos_query_performance.Rmd', output_file='/data/chrpos_query_performance.html')"
```

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance \
--rm \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/interval_query_performance.Rmd', output_file='/data/interval_query_performance.html')"
```

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance \
--rm \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/pval_query_performance.Rmd', output_file='/data/pval_query_performance.html')"
```
