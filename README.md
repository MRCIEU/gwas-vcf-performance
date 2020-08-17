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

### Plot

[Combined plot](plot.pdf)

### Workflow

Process GWAS to GWAS-VCF

- [body_mass_index](https://mrcieu.github.io/gwas-vcf-performance/workflow.html)

### Prepare queries

Subsample the data, prepare multisample GWAS-VCF and record expected output results for comparison with command-line tools

- [single-sample-2.5M](https://mrcieu.github.io/gwas-vcf-performance/single-sample-2.5M/prepare_query.html)
- [single-sample-10M](https://mrcieu.github.io/gwas-vcf-performance/single-sample-10M/prepare_query.html)
- [multi-sample-2.5M](https://mrcieu.github.io/gwas-vcf-performance/multi-sample-2.5M/prepare_query.html)
- [multi-sample-10M](https://mrcieu.github.io/gwas-vcf-performance/multi-sample-10M/prepare_query.html)

### RSID query performance

Performance queries on rsID

- [single-sample-2.5M](https://mrcieu.github.io/gwas-vcf-performance/single-sample-2.5M/rsid_query_performance.html)
- [single-sample-10M](https://mrcieu.github.io/gwas-vcf-performance/single-sample-10M/rsid_query_performance.html)
- [multi-sample-2.5M](https://mrcieu.github.io/gwas-vcf-performance/multi-sample-2.5M/rsid_query_performance.html)
- [multi-sample-10M](https://mrcieu.github.io/gwas-vcf-performance/multi-sample-10M/rsid_query_performance.html)

### Genomic position query performance

Performance queries on chromosome position

- [single-sample-2.5M](https://mrcieu.github.io/gwas-vcf-performance/single-sample-2.5M/chrpos_query_performance.html)
- [single-sample-10M](https://mrcieu.github.io/gwas-vcf-performance/single-sample-10M/chrpos_query_performance.html)
- [multi-sample-2.5M](https://mrcieu.github.io/gwas-vcf-performance/multi-sample-2.5M/chrpos_query_performance.html)
- [multi-sample-10M](https://mrcieu.github.io/gwas-vcf-performance/multi-sample-10M/chrpos_query_performance.html)

### Genomic interval query performance

- [single-sample-2.5M](https://mrcieu.github.io/gwas-vcf-performance/single-sample-2.5M/interval_query_performance.html)
- [single-sample-10M](https://mrcieu.github.io/gwas-vcf-performance/single-sample-10M/interval_query_performance.html)
- [multi-sample-2.5M](https://mrcieu.github.io/gwas-vcf-performance/multi-sample-2.5M/interval_query_performance.html)
- [multi-sample-10M](https://mrcieu.github.io/gwas-vcf-performance/multi-sample-10M/interval_query_performance.html)

### P value query performance

- [single-sample-2.5M](https://mrcieu.github.io/gwas-vcf-performance/single-sample-2.5M/pval_query_performance.html)
- [single-sample-10M](https://mrcieu.github.io/gwas-vcf-performance/single-sample-10M/pval_query_performance.html)
- [multi-sample-2.5M](https://mrcieu.github.io/gwas-vcf-performance/multi-sample-2.5M/pval_query_performance.html)
- [multi-sample-10M](https://mrcieu.github.io/gwas-vcf-performance/multi-sample-10M/pval_query_performance.html)

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

### Convert GWAS to VCF

Make a folder for the GWAS-VCF files, copy in the reference genome files & dbsnp files, change into the dir and then execute:

```sh
docker run \
-v `pwd`:/data \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/app/workflow.Rmd', output_file='/data/workflow.html', params = list(ukbb_id = 21001))"
```

### Prepare queries

Create project folder, hard-link GWAS-VCF file(s) using unique name (not gwas.vcf.gz) from above into the project folder and then execute:

```sh
docker run \
-v `pwd`:/data \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/app/prepare_query.Rmd', output_file='/data/prepare_query.html', params = list(n_sim = 100, n_variants = 10000000))"
```

### Run evaluation

In the project folder from above execute the evaluations:

#### RSID query

```sh
docker run \
-v `pwd`:/data \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/app/rsid_query_performance.Rmd', output_file='/data/rsid_query_performance.html', params = list(n_sim = 100))"
```

#### Chromosome position query

```sh
docker run \
-v `pwd`:/data \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/app/chrpos_query_performance.Rmd', output_file='/data/chrpos_query_performance.html', params = list(n_sim = 100))"
```

#### Interval query

```sh
docker run \
-v `pwd`:/data \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/app/interval_query_performance.Rmd', output_file='/data/interval_query_performance.html', params = list(n_sim = 100))"
```

#### P value query

```sh
docker run \
-v `pwd`:/data \
-it -d \
gwas-vcf-performance \
R -e "rmarkdown::render('/app/pval_query_performance.Rmd', output_file='/data/pval_query_performance.html', params = list(n_sim = 100))"
```

#### Figure

```sh
cd data
Rscript combined_plot.R
```
