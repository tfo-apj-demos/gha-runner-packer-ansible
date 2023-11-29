# gha-runner-packer-ansible
Custom docker image for self-hosted github action using arc controller



# Note platform must be specified otherise will default to build host platform.
docker build --platform linux/amd64 -t tfoapjdemos/gha-dind-runner-packer-ansible:latest .
docker push tfoapjdemos/gha-dind-runner-packer-ansible:latest


docker build --platform linux/amd64 -t tfoapjdemos/gha-runner-packer-ansible:latest .
docker push tfoapjdemos/gha-runner-packer-ansible:latest