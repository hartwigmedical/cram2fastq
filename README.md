# cram2fastq
Run these scripts as a docker container to produce FASTQ files and upload them back to GCP. We'll do everything from our laptops as a 
first step.
  

#### Git Stuff

Make a branch before your start.

```shell script
git checkout -b your_name
```

When you're ready to share some work (even as a work in progress) create a PR

```shell script
git commit -a
git push origin master
```

Log into the GitHub UI and there should be a button telling you to create a PR. From there you can add reviewers.

#### Docker Basics

Image: A reproduceable virtual environment.
Container: A running instance of an image.
Registry: A place to put images.

#### Docker Build

Build your docker container with the following command. You need to re-build your container after each change!

```shell script
docker build . -t hmf-build/cram2fastq
```

Our Dockerfile just has a few simple parts to get your started:
- We extend the gcloud SDK container to make sure we can do GCP stuff.
- We RUN some things, remember this happens at build time, not run time.
- We ADD some things, coming from our local checkout
- We specify our entry point, this will be run when we do `docker run` 

#### Docker Run

Run your docker container with the following command:

```shell script
 docker run -v /your/home/.config/gcloud/:/root/.config/gcloud/ hmf-build/cram2fastq:latest gs://hmf-cram2fastq/cram/CPCT12345678T.cram
```

Quick notes:
- The -v maps a volume on your local filesystem. In this case its used to share your credentials. You can have many volume mappings (but don't cheat!)
- Arguments to pass to the entry point follow the image tag.

#### Debugging

See the containers you've run, including failures:

```shell script
 docker ps -a
```

Grab the logs

```shell script
docker logs [container id]
```

Poke around

```shell script
docker run -it -v /your/home/.config/gcloud/:/root/.config/gcloud/ --entrypoint /bin/sh hmf-build/cram2fastq:latest
```

