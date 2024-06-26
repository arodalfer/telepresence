#!/bin/bash

# Actualizar el sistema
sudo apt-get update
sudo apt-get upgrade -y

# Función para instalar Docker
install_docker() {
  echo "Instalando Docker..."
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli
  echo "Docker instalado correctamente."
}

# Comprobar si Docker está instalado
if command -v docker &> /dev/null
then
  echo "Docker ya está instalado. Versión: $(docker --version)"
else
  install_docker
fi

# Función para instalar kubectl
install_kubectl() {
  echo "Instalando kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  echo "kubectl instalado correctamente."
}

# Comprobar si kubectl está instalado
if command -v kubectl &> /dev/null
then
  echo "kubectl ya está instalado. Versión: $(kubectl version --client)"
else
  install_kubectl
fi

# Función para instalar Telepresence
install_telepresence() {
  echo "Instalando Telepresence..."
  sudo curl -fL https://app.getambassador.io/download/tel2oss/releases/download/v2.18.0/telepresence-linux-amd64 -o /usr/local/bin/telepresence
  sudo chmod a+x /usr/local/bin/telepresence
  echo "Telepresence instalado correctamente."
}

# Comprobar si Telepresence está instalado
if command -v telepresence &> /dev/null
then
  echo "Telepresence ya está instalado. Versión: $(telepresence version)"
else
  install_telepresence
fi

# Función para instalar Kind
install_kind() {
  echo "Instalando Kind..."
  curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/kind
  echo "Kind instalado correctamente."
}

# Comprobar si Kind está instalado
if command -v kind &> /dev/null
then
  echo "Kind ya está instalado. Versión: $(kind --version)"
else
  install_kind
fi

echo "Instalación completada."

