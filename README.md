# VCF vs plain text GWAS storage formats

Runtime performance for querying GWAS summary statistics in plain/tabular text and VCF

## Citation

```
The variant call format provides efficient and robust storage of GWAS summary statistics
Matthew S Lyon, Shea J Andrews, Benjamin L Elsworth, Tom R Gaunt, Gibran Hemani, Edoardo Marcora
bioRxiv 2020.05.29.115824; doi: https://doi.org/10.1101/2020.05.29.115824
```

## Results

To view comparison results open html files in a web browser.

1. [workflow](https://mrcieu.github.io/gwas-vcf-performance/workflow.html) - set up GWAS and prepare queries
2. [rsid_query_performance](https://mrcieu.github.io/gwas-vcf-performance/rsid_query_performance.html) - performance queries on rsID
3. [chrpos_query_performance](https://mrcieu.github.io/gwas-vcf-performance/chrpos_query_performance.html) - performance queries on chromosome position
4. [interval_query_performance](https://mrcieu.github.io/gwas-vcf-performance/interval_query_performance.html) - performance queries on chromosome interval
5. [pval_query_performance](https://mrcieu.github.io/gwas-vcf-performance/pval_query_performance.html) - performance queries on association P value

## Run

### Obtain source code

```sh
git clone --recurse-submodules git@github.com:MRCIEU/gwas-vcf-performance.git
cd gwas-vcf-performance
```

### Docker

Pull existing image from DockerHub or build

```sh
docker pull mrcieu/gwas-vcf-performance
# OR
docker build -t gwas-vcf-performance .
```

### Download FASTA file

These files are needed to harmonise the data ensuring a consistent effect allele

```sh
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37.fasta.gz
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37.fasta.fai.gz
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37.dict.gz
gzip -d human_g1k_v37.fasta.gz
gzip -d human_g1k_v37.fasta.fai.gz
gzip -d human_g1k_v37.dict.gz
```

### Download dbSNP file

These files are needed to update dbSNP identifiers

```sh
wget ftp://ftp.ncbi.nih.gov/snp/latest_release/VCF/GCF_000001405.25.gz
wget ftp://ftp.ncbi.nih.gov/snp/latest_release/VCF/GCF_000001405.25.gz.tbi
mv GCF_000001405.25.gz dbsnp.v153.b37.vcf.gz
mv GCF_000001405.25.gz.tbi dbsnp.v153.b37.vcf.gz.tbi
```

### Prepare GWAS

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance-workflow \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/workflow.Rmd', output_file='/data/workflow.html', params = list(n_sim = 100))"
```

### Run evaluation

#### RSID query

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance-rsid \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/rsid_query_performance.Rmd', output_file='/data/rsid_query_performance.html', params = list(n_sim = 100))"
```

#### Chromosome position query

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance-chrpos \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/chrpos_query_performance.Rmd', output_file='/data/chrpos_query_performance.html', params = list(n_sim = 100))"
```

#### Interval query

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance-interval \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/interval_query_performance.Rmd', output_file='/data/interval_query_performance.html', params = list(n_sim = 100))"
```

#### P value query

```sh
docker run \
-v `pwd`:/data \
--name gwas-vcf-performance-pval \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/data/pval_query_performance.Rmd', output_file='/data/pval_query_performance.html', params = list(n_sim = 100))"
```
