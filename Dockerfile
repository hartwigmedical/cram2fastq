FROM google/cloud-sdk:317.0.0

# add repo tools
RUN apt-get update
RUN apt-get --yes install \
    wget=1.20.1-1.1 \
    pigz=2.4-1 \
    openjdk-11-jre=11.0.9.1+1-1~deb10u2 \
    # necessary for building samtools
    libncurses5-dev=6.1+20181013-2+deb10u2 \
    zlib1g-dev=1:1.2.11.dfsg-1 \
    libbz2-dev=1.0.6-9.2~deb10u1 \
    liblzma-dev=5.2.4-1

# add non-repo tools
RUN wget -qO- https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2 | tar xjf - \
    && cd samtools-1.10 \
    && ./configure --prefix=/usr \
    && make \
    && make install
ADD https://github.com/broadinstitute/picard/releases/download/2.24.0/picard.jar picard.jar

# add script
COPY cram2fastq cram2fastq

# final preparations
RUN chmod +x cram2fastq

ENTRYPOINT ["./cram2fastq"]