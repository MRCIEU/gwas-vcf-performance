# compare VCF vs tab-separated GWAS file formats

## source

```sh
git clone git@github.com:MRCIEU/gwas-vcf-performance.git
```

## build docker image

```sh
cd gwas-vcf-performance
docker build --name gwas-vcf-performance -t .
```

## run comparison

```sh
docker run -it -d --name gwas-vcf-performance gwas-vcf-performance
```