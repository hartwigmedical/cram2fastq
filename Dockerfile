FROM google/cloud-sdk:latest

RUN apt-get update
RUN apt-get --yes install openjdk-11-jre

ADD bam2fastq bin/
ADD cram2bam bin/
ADD cram2fastq bin/

RUN chmod +x bin/bam2fastq
RUN chmod +x bin/cram2bam
RUN chmod +x bin/cram2fastq

ENTRYPOINT ["bin/cram2fastq"]