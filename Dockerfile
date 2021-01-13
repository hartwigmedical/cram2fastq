FROM google/cloud-sdk:latest

ENV BASEPATH=/home/dockerguy
WORKDIR $BASEPATH
ENV PATH=$PATH:$BASEPATH

#install stuff
RUN apt-get update
RUN apt-get --yes install openjdk-11-jre
RUN apt-get --yes install picard-tools
RUN apt-get --yes install pigz

# set some environment variables
ENV PICARDDIR="/usr/share/java"
ENV SAMTOOLS_BUILD_DIR="$BASEPATH/samtools-1.11"
ENV SAMTOOLSPATH="$BASEPATH/samtools"

# download samtools
ADD https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 "$SAMTOOLS_BUILD_DIR.tar.bz2"

# install samtools
RUN tar -vxjf "$SAMTOOLS_BUILD_DIR.tar.bz2" &&\
    cd $SAMTOOLS_BUILD_DIR &&\
    ./configure &&\
    make &&\
    make install &&\
    cd $BASEPATH &&\
    mv $SAMTOOLS_BUILD_DIR/samtools $SAMTOOLSPATH &&\
    rm -r $SAMTOOLS_BUILD_DIR

COPY cram2fastq cram2bam bam2fastq ./

ENTRYPOINT ["./cram2fastq"]