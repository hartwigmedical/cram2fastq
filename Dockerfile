FROM google/cloud-sdk:latest

ENV BASEPATH=/home/dockerguy
WORKDIR $BASEPATH
ENV PATH=$PATH:$BASEPATH

# set environment variables
ENV SAMTOOLS_BUILD_DIR="$BASEPATH/samtools-1.11"
ENV SAMTOOLS_PATH="$BASEPATH/samtools"
ENV PICARD_PATH="$BASEPATH/picard"

# install command line stuff
RUN apt-get update &&\
    apt-get --yes install openjdk-11-jre=11.0.9.1+1-1~deb10u2 &&\
    apt-get --yes install pigz=2.4-1 &&\
    # necessary for building samtools
    apt-get --yes install libncurses5-dev=6.1+20181013-2+deb10u2 &&\
    apt-get --yes install zlib1g-dev=1:1.2.11.dfsg-1 &&\
    apt-get --yes install libbz2-dev=1.0.6-9.2~deb10u1 &&\
    apt-get --yes install liblzma-dev=5.2.4-1 &&\
    echo "Done"

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
    rm -r $SAMTOOLS_BUILD_DIR &&\
    echo "Done"

# add scripts
COPY cram2fastq cram2bam bam2fastq $BASEPATH

ENTRYPOINT ["./cram2fastq"]