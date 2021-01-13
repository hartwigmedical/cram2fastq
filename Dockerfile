FROM google/cloud-sdk:latest

ENV BASEPATH=/home/dockerguy
WORKDIR $BASEPATH
ENV PATH=$PATH:$BASEPATH

# set environment variables
ENV SAMTOOLS_BUILD_DIR="$BASEPATH/samtools-1.11"
ENV SAMTOOLS_PATH="$BASEPATH/samtools"
ENV PICARDDIR="/usr/share/java"
ENV PICARD_PATH="$BASEPATH/picard"

# install command line stuff
RUN apt-get update
RUN apt-get --yes install openjdk-11-jre
RUN apt-get --yes install picard-tools
RUN apt-get --yes install pigz

# download picard jar
ADD https://github.com/broadinstitute/picard/releases/download/2.24.0/picard.jar $PICARD_PATH

# download samtools
ADD https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 "$SAMTOOLS_BUILD_DIR.tar.bz2"

# install samtools
RUN tar -vxjf "$SAMTOOLS_BUILD_DIR.tar.bz2" &&\
    cd $SAMTOOLS_BUILD_DIR &&\
    ./configure &&\
    make &&\
    make install &&\
    cd $BASEPATH &&\
    mv $SAMTOOLS_BUILD_DIR/samtools $SAMTOOLS_PATH &&\
    rm -r $SAMTOOLS_BUILD_DIR

# add scripts
COPY cram2fastq cram2bam bam2fastq $BASEPATH

ENTRYPOINT ["./cram2fastq"]