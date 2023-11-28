FROM summerwind/actions-runner:ubuntu-22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERRAFORM_VERSION=1.6.4
ENV VAULT_VERSION=1.15.0

RUN sudo apt-get update \
&& sudo apt-get install -y make \
&& sudo apt-get install -y jq \
&& sudo apt-get install -y wget

# AWS CLI
RUN sudo curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && sudo unzip awscliv2.zip \
    && sudo ./aws/install \
    && sudo rm -f awscliv2.zip

# Ansible
RUN sudo apt-add-repository ppa:ansible/ansible -y \
    && sudo apt-get update \
    && sudo apt-get install ansible -y

# Packer
RUN sudo curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
RUN sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN sudo apt-get update && sudo apt-get install -y packer
RUN sudo apt-get update && sudo apt-get install -y gnupg software-properties-common apt-transport-https

# Terraform
RUN sudo wget --quiet "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && sudo unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && sudo mv terraform /usr/local/bin \
    && sudo rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Vault
RUN sudo wget --quiet "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" \
    && sudo unzip vault_${VAULT_VERSION}_linux_amd64.zip \
    && sudo mv vault /usr/local/bin \
    && sudo rm vault_${VAULT_VERSION}_linux_amd64.zip