#!/bin/bash

set -e  # Para o script em caso de erro
set -o pipefail

CLUSTER_NAME="projeto-kubernates"
REPO_URL="https://github.com/amanda-mattos-pb/imagens-docker.git"
REPO_DIR="imagens-docker"

echo "🔧 Criando cluster Kind com nome: $CLUSTER_NAME..."
kind create cluster --name $CLUSTER_NAME --config kind-config.yaml

echo "🌐 Instalando NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo "⏳ Aguardando o Ingress Controller ficar pronto..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

echo "📦 Clonando o repositório com os manifestos..."
git clone $REPO_URL

cd $REPO_DIR

echo "📁 Criando Namespaces..."
kubectl apply -f namespace.yaml

echo "🗄️ Criando recursos do Banco de Dados..."
kubectl apply -f database/

echo "🔧 Criando recursos do Backend..."
kubectl apply -f backend/

echo "🎨 Criando recursos do Frontend..."
kubectl apply -f frontend/

echo "🌍 Aplicando regras de Ingress..."
kubectl apply -f ingress/

echo "✅ Tudo pronto! O cluster Kind está configurado com a aplicação."
