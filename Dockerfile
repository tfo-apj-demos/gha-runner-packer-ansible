FROM summerwind/actions-runner:ubuntu-22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERRAFORM_VERSION=1.6.5
ENV VAULT_VERSION=1.15.4
ENV PSModulePath="/home/runner/.local/share/powershell/Modules:/usr/local/share/powershell/Modules:/opt/microsoft/powershell/7/Modules"

RUN sudo apt-get update \
&& sudo apt-get install -y make \
&& sudo apt-get install -y jq \
&& sudo apt-get install -y wget \
&& sudo apt-get install -y git \
&& sudo apt-get install -y sudo \
&& sudo apt-get install -y coreutils

# allow ansible local rsa ssh connection
RUN sudo mkdir /home/runner/.ssh/
RUN sudo tee /home/runner/.ssh/config <<EOF
Host *
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
   HostKeyAlgorithms ssh-rsa,ssh-ed25519,ecdsa-sha2-nistp384
   PubkeyAcceptedKeyTypes +ssh-rsa,ecdsa-sha2-nistp256,ssh-ed25519,ecdsa-sha2-nistp384
EOF

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
RUN sudo apt-add-repository universe
RUN sudo apt-get update && sudo apt-get install -y xorriso

# HCP Vault Secrets CLI
RUN sudo apt install -y vlt

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

RUN sudo mkdir -p /usr/local/share/powershell/Modules
RUN sudo mkdir -p /home/runner/.local/share/powershell/Modules
RUN sudo mkdir -p /opt/microsoft/powershell/7/Modules

# Powershell 
RUN sudo wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb \
    && sudo dpkg -i packages-microsoft-prod.deb \
    && sudo rm packages-microsoft-prod.deb \
    && sudo apt-get update \
    && sudo apt-get install -y powershell

RUN sudo wget -q https://vdc-download.vmware.com/vmwb-repository/dcr-public/4ab0abc0-b6ee-4cff-9b43-1d5038daab94/41f1195e-67d1-4d3e-bbcf-950d803c30d7/VMware-PowerCLI-13.2.0-22746353.zip \
    && sudo unzip VMware-PowerCLI-13.2.0-22746353.zip -d /opt/microsoft/powershell/7/Modules

RUN sudo mkdir -p /home/runner/.local/share/VMware
RUN sudo mkdir -p /home/runner/.local/share/VMware/PowerCLI
RUN sudo chown -R runner: /home/runner/.local/share/VMware/PowerCLI
RUN sudo chown -R runner: /home/runner/.local/share/VMware
