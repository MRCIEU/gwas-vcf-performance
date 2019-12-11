FROM continuumio/miniconda3:4.7.12

# install build tools & libraries
RUN apt-get update && apt-get -y install build-essential zlib1g-dev libbz2-dev liblzma-dev time texlive-latex-base

# install R and markdown
RUN /opt/conda/bin/conda install r-base
RUN /opt/conda/bin/conda install -c r r-rmarkdown
RUN /opt/conda/bin/conda install -c r r-ggplot2
RUN /opt/conda/bin/conda install -c r r-data.table
RUN /opt/conda/bin/conda install -c conda-forge pandoc

# install bcftools
RUN wget https://github.com/samtools/bcftools/releases/download/1.10/bcftools-1.10.tar.bz2
RUN tar -xvf bcftools-1.10.tar.bz2
RUN cd bcftools-1.10 && ./configure && make && make test && make install

# install gwas2vcf
COPY . /app
WORKDIR /app
RUN cd gwas2vcf && pip install -r requirements.txt && python -m unittest discover test