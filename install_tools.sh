#!/bin/bash

install_tools() {
  echo "Starting installation of Terraform, Docker, and Git..." | tee -a /tmp/log_file
  
  # Install Terraform
  if ! terraform --version &>/dev/null; then
    echo "Terraform is not installed. Proceeding with installation..." | tee -a /tmp/log_file
    sudo yum install -y yum-utils >> /tmp/log_file 2>&1
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo >> /tmp/log_file 2>&1
    sudo yum -y install terraform >> /tmp/log_file 2>&1
    
    if terraform --version &>/dev/null; then
      echo "Terraform installed successfully." | tee -a /tmp/log_file
      terraform -install-autocomplete >> /tmp/log_file 2>&1
    else
      echo "Terraform installation failed." | tee -a /tmp/log_file >&2
      exit 1
    fi
  else
    echo "Terraform is already installed. Skipping installation." | tee -a /tmp/log_file
  fi

  # Install Docker
  if ! docker --version &>/dev/null; then
    echo "Docker is not installed. Proceeding with installation..." | tee -a /tmp/log_file
    sudo yum install -y yum-utils >> /tmp/log_file 2>&1
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo >> /tmp/log_file 2>&1
    sudo yum install -y docker-ce docker-ce-cli containerd.io >> /tmp/log_file 2>&1
    sudo systemctl start docker >> /tmp/log_file 2>&1
    sudo systemctl enable docker >> /tmp/log_file 2>&1
    
    if docker --version &>/dev/null; then
      echo "Docker installed successfully." | tee -a /tmp/log_file
    else
      echo "Docker installation failed." | tee -a /tmp/log_file >&2
      exit 1
    fi
  else
    echo "Docker is already installed. Skipping installation." | tee -a /tmp/log_file
  fi

  # Install Git
  if ! git --version &>/dev/null; then
    echo "Git is not installed. Proceeding with installation..." | tee -a /tmp/log_file
    sudo yum install -y git >> /tmp/log_file 2>&1
    
    if git --version &>/dev/null; then
      echo "Git installed successfully." | tee -a /tmp/log_file
    else
      echo "Git installation failed." | tee -a /tmp/log_file >&2
      exit 1
    fi
  else
    echo "Git is already installed. Skipping installation." | tee -a /tmp/log_file
  fi

  echo "Installation of Terraform, Docker, and Git completed successfully!" | tee -a /tmp/log_file
  exit 0
}

install_tools
