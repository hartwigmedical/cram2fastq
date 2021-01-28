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
git push origin your_name
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

#### Pushing to a Registry

The first step is to add a version to your tag and push it:

Get set up to connect to the GCP registry:
```shell script
gcloud auth configure-docker
```

Then build an image and push it:
```shell script
docker build . -t eu.gcr.io/hmf-build/cram2fastq:your_name.1(.2,.3)
docker push eu.gcr.io/hmf-build/cram2fastq:your_name.1(.2,.3)
```

Note we added the following to the tag in part #1:
- eu.gcr.io, this is the EU docker registry in GCP
- a "version" after the image name. Increment your version after each change to make sure its not getting cached anywhere.

Now we can run our image anywhere with Docker, including a Kubernetes cluster.

#### Running in Kubernetes

Kubernetes runs docker containers for you. This lets you run jobs in the cloud without having to worry about provisioning and managing VMs.

Kubernetes (K8) has a lot of functionality, today we're just doing to deal with 2 concepts:
- A [pod](https://kubernetes.io/docs/concepts/workloads/pods/): The basic unit of work in K8, a pod runs 1..n containers within it.
- A [job](https://kubernetes.io/docs/concepts/workloads/controllers/job/): A higher abstraction for tasks which run to completion
  (ie don't run indefinitely like a webserver). A job controls pods.

You can find the skeleton `yaml` file in `k8/hmf-crunch/deploy.yaml`. Fill it with your container and arguments. When you are ready to test
you can connect to the hmf-crunch cluster with:

```shell script
gcloud container clusters get-credentials rerun-cluster --region europe-west4 --project hmf-crunch
```

```shell script
kubectl create -f k8/hmf-crunch/deploy.yaml
```

Kubectl is the command line tool to work with a kubernetes cluster. You can use it to monitor jobs and check logs:

```shell script
kubectl get jobs
kubectl get pods
kubectl logs <pod-name>
```

The [GKE UI in the console](https://console.cloud.google.com/kubernetes/list?project=hmf-crunch) is also quite handy for monitoring and
exploration.