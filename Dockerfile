FROM continuumio/miniconda3:4.7.12

# install build tools & libraries
RUN apt-get update && apt-get -y install unzip build-essential zlib1g-dev libbz2-dev liblzma-dev time texlive-latex-base

# install R and markdown
RUN /opt/conda/bin/conda install r-base
RUN /opt/conda/bin/conda install -c r r-rmarkdown
RUN /opt/conda/bin/conda install -c r r-ggplot2
RUN /opt/conda/bin/conda install -c r r-data.table
RUN /opt/conda/bin/conda install -c r r-stringr
RUN /opt/conda/bin/conda install -c r r-jsonlite
RUN /opt/conda/bin/conda install -c r r-r.utils
RUN /opt/conda/bin/conda install -c conda-forge pandoc

# install bcftools
RUN wget https://github.com/samtools/bcftools/releases/download/1.10/bcftools-1.10.tar.bz2
RUN tar -xvf bcftools-1.10.tar.bz2
RUN cd bcftools-1.10 && ./configure && make && make test && make install

# install GATK
RUN /opt/conda/bin/conda install -c anaconda openjdk
RUN wget https://github.com/broadinstitute/gatk/releases/download/4.1.5.0/gatk-4.1.5.0.zip
RUN unzip gatk-4.1.5.0.zip
RUN mv gatk-4.1.5.0 /usr/bin

# install gwas2vcf
COPY . /app
WORKDIR /app
RUN cd gwas2vcf && pip install -r requirements.txt && python -m unittest discover test