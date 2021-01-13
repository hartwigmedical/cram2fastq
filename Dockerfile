FROM google/cloud-sdk:latest

# add repo tools
RUN apt-get update
RUN apt-get --yes install openjdk-11-jre
RUN apt-get --yes install pigz
RUN apt-get --yes install picard-tools

# add helper scripts
ADD cram2fastq cram2fastq

# install samtools
ADD "https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2" "samtools-1.10.tar.bz2"
RUN tar xjf "samtools-1.10.tar.bz2" \
    && cd samtools-1.10 \
    && ./configure --prefix=/usr \
    && make \
    && make install

# final preparations
RUN chmod +x cram2fastq

ENTRYPOINT ["./cram2fastq"]