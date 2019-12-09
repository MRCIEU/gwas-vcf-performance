# Compare VCF vs tab-separated GWAS file formats

To view comparison results open ```output.html``` in a web browser.

To reproduce the analysis follow the following instructions.

### obtain source code

```sh
git clone --recurse-submodules git@github.com:MRCIEU/gwas-vcf-performance.git
```

### build docker image

```sh
cd gwas-vcf-performance
docker build -t gwas-vcf-performance:latest .
```

### download FASTA file

These files are need to harmonise the data ensuring a consistent effect allele

```sh
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37.fasta.gz
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37.fasta.fai.gz
gzip -d human_g1k_v37.fasta.gz
gzip -d human_g1k_v37.fasta.fai.gz
```

### run comparison

Output will be a single html file ```output.html```

```sh
docker run \
-v `pwd`: /app \
-it \
--rm \
gwas-vcf-performance \
R -e "rmarkdown::render('/app/performance_comparison.Rmd',output_file='/app/output.html')"
```