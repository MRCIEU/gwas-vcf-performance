FROM continuumio/miniconda3:4.7.12

# install build tools & libraries
RUN apt-get update && apt-get -y install build-essential zlib1g-dev libbz2-dev liblzma-dev

# install R and markdown
RUN /opt/conda/bin/conda install r-base
RUN /opt/conda/bin/conda install -c r r-markdown

# install bcftools
RUN wget https://github.com/samtools/bcftools/releases/download/1.10/bcftools-1.10.tar.bz2
RUN tar -xvf bcftools-1.10.tar.bz2
RUN cd bcftools-1.10 && ./configure && make && make test && make install

# install gwas2vcf
RUN cd /app/gwas2vcf && pip install -r requirements.txt && python -m unittest discover test