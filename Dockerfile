FROM google/cloud-sdk:latest

# add repo tools
RUN apt-get update
RUN apt-get --yes install wget pigz openjdk-11-jre picard-tools

# add non-repo tools
COPY cram2fastq cram2fastq
RUN wget -qO- https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2 | tar xjf - \
    && cd samtools-1.10 \
    && ./configure --prefix=/usr \
    && make \
    && make install

# final preparations
RUN chmod +x cram2fastq

ENTRYPOINT ["./cram2fastq"]