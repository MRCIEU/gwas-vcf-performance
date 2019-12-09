FROM continuumio/miniconda3:4.7.12

# install R
RUN /opt/conda/bin/conda install r-base

# install bcftools
RUN wget https://github.com/samtools/bcftools/releases/download/1.10/bcftools-1.10.tar.bz2
RUN tar -xvf bcftools-1.10.tar.bz2
RUN cd bcftools-1.10 && ./configure && make && && make test && make install