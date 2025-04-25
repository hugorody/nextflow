#!/bin/bash

set -e  # interrompe se ocorrer erro

echo "Atualizando pacotes do sistema..."
sudo apt update && sudo apt upgrade -y

echo "Instalando dependências básicas..."
sudo apt install -y curl wget gnupg lsb-release ca-certificates software-properties-common

echo "Instalando Docker..."

# Remover entradas antigas, se houver
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/keyrings/docker.gpg

# Adicionar chave e repositório Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

UBUNTU_CODENAME=$(grep UBUNTU_CODENAME /etc/os-release | cut -d= -f2)
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Adicionando usuário ao grupo docker..."
sudo usermod -aG docker $USER

echo "Baixando e instalando Miniconda..."
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p $HOME/miniconda
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
conda init
source ~/.bashrc

echo "Criando ambiente Conda para Nextflow..."
#conda create -n nextflow_env -y
#conda activate nextflow_env
conda install -c conda-forge openjdk=11 -y
conda install -c bioconda nextflow -y