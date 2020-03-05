# VCF vs plain text GWAS storage formats

To view comparison results open html files in a web browser.

1. [workflow](workflow.html) - set up GWAS and prepare queries
2. [rsid_query_performance](rsid_query_performance.html) - performance queries on rsID
3. [chrpos_query_performance](chrpos_query_performance.html) - performance queries on chromosome position
4. [interval_query_performance](interval_query_performance.html) - performance queries on chromosome interval
5. [pval_query_performance](pval_query_performance.html) - performance queries on association P value

To reproduce the analysis follow these instructions.

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
--name gwas-vcf-performance-workflow \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/workflow.Rmd', output_file='/data/workflow.html')"
```

## Run evaluations

### rsID query

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance-rsid \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/rsid_query_performance.Rmd', output_file='/data/rsid_query_performance.html')"
```

### chromosome position query

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance-chrpos \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/chrpos_query_performance.Rmd', output_file='/data/chrpos_query_performance.html')"
```

### interval query

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance-interval \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/interval_query_performance.Rmd', output_file='/data/interval_query_performance.html')"
```

### P value query

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance-pval \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/pval_query_performance.Rmd', output_file='/data/pval_query_performance.html')"
```
