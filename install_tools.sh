#!/bin/bash

log_file="/tmp/install_tools.log"

# Function to check if a command exists and install it
check_and_install() {
  local tool=$1
  local install_command=$2
  echo "Checking for $tool..." | tee -a "$log_file"
  
  if ! command -v "$tool" &>/dev/null; then
    echo "$tool is not installed. Proceeding with installation..." | tee -a "$log_file"
    eval "$install_command" >> "$log_file" 2>&1
    
    if command -v "$tool" &>/dev/null; then
      echo "$tool installed successfully." | tee -a "$log_file"
    else
      echo "$tool installation failed." | tee -a "$log_file" >&2
      exit 1
    fi
  else
    echo "$tool is already installed. Skipping installation." | tee -a "$log_file"
  fi
}

# Install Terraform
install_terraform() {
  check_and_install "terraform" "
    sudo yum install -y yum-utils &&
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo &&
    sudo yum -y install terraform &&
    terraform -install-autocomplete
  "
}

# Install Docker
install_docker() {
  check_and_install "docker" "
    sudo yum install -y yum-utils &&
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &&
    sudo yum install -y docker-ce docker-ce-cli containerd.io &&
    sudo systemctl start docker &&
    sudo systemctl enable docker
  "
}

# Install Git
install_git() {
  check_and_install "git" "sudo yum install -y git"
}

# Install AWS CLI
install_aws_cli() {
  check_and_install "aws" "
    curl -s \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"/tmp/awscliv2.zip\" &&
    unzip -q /tmp/awscliv2.zip -d /tmp &&
    sudo /tmp/aws/install &&
    rm -rf /tmp/aws /tmp/awscliv2.zip
  "
}

# Main function
install_tools() {
  echo "Starting installation of tools..." | tee "$log_file"
  install_terraform
  install_docker
  install_git
  install_aws_cli
  echo "All tools installed successfully!" | tee -a "$log_file"
}

install_tools
