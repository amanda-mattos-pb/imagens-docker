---

##Projeto Kubernetes: Deploy Fullstack com React + Flask + PostgreSQL
## 👥 Integrantes da Equipe
- Amanda Laryssa Rodrigues de Mattos
- José Wilquer Nascimento de Lima
## 🎯 Objetivo do Projeto

Realizar o deploy completo de uma aplicação fullstack em um cluster Kubernetes, composta por:

- Frontend: React
- Backend: Flask (API REST)
- Banco de dados: PostgreSQL
- Comunicação via IngressController (NGINX)
- Alta disponibilidade com múltiplas réplicas
- Configuração via ConfigMap e Secrets
- Persistência de dados via PVC

---

## 🧱 Estrutura do Repositório

```
imagens-docker/
├── README.md
├── namespace.yaml
├── frontend/
│   └── deployment.yaml
├── backend/
│   ├── deployment.yaml
│   ├── configmap.yaml
│   └── secret.yaml
├── database/
│   ├── pvc.yaml
│   ├── statefulset.yaml
│   └── secret.yaml
└── ingress/
    └── ingress.yaml
```

---

## 🚀 Como Executar

> ⚠️ Pré-requisitos:
> - Kubernetes (Minikube, Kind ou cluster real)
> - kubectl configurado
> - Docker com acesso ao DockerHub

### 1. Clone o repositório
```bash
git clone https://github.com/seuusuario/projeto-k8s-deploy.git
cd projeto-k8s-deploy
![Arquitetura da Aplicação](https://raw.githubusercontent.com/pedrofilhojp/kube-students-projects/main/assets/image.png)



---

## 1. Passos para Execução do Deploy

Siga os passos abaixo para configurar o ambiente e realizar o deploy da aplicação.

### 1.1. Construir e Publicar as Imagens Docker

Antes de aplicar os manifestos do Kubernetes, é necessário construir as imagens Docker para o frontend e o backend e publicá-las em um registro de contêineres, como o Docker Hub.

1.  Navegue até o diretório de cada aplicação (`frontend/` e `backend/`).
2.  Construa e publique as imagens. Substitua `seu-usuario-dockerhub` pelo seu nome de usuário.
    ```bash
    # Construindo a imagem do backend
    docker build -t seu-usuario-dockerhub/backend-flask:latest ./backend
    docker push seu-usuario-dockerhub/backend-flask:latest

    # Construindo a imagem do frontend
    docker build -t seu-usuario-dockerhub/frontend-react:latest ./frontend
    docker push seu-usuario-dockerhub/frontend-react:latest
    ```
3.  **Importante:** Após publicar as imagens, atualize os arquivos `backend/deployment.yaml` e `frontend/deployment.yaml` com os nomes corretos das suas imagens.

### 1. Clone este repositório ou copie o script `setup-imagem.sh`

Crie um arquivo chamado `setup-imagem.sh`` e cole o seguinte conteúdo dentro dele:

```bash
#!/bin/bash

set -e
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
### 1.5. Configurar o DNS Local
2. Torne o script executável
'''bash
  chmod +x setup-imagem.sh
3. Execute o script

  ./setup-imagem.sh`
'''
Para acessar a aplicação usando um domínio amigável, adicione a seguinte linha ao seu arquivo de hosts:

*   **Linux/macOS:** `/etc/hosts`
*   **Windows:** `C:\Windows\System32\drivers\etc\hosts`

```
127.0.0.1   meu-app.com
```
*É necessário privilégios de administrador para editar este arquivo.*

---

## 2. Verificação e Acesso

Após a conclusão do deploy, você pode verificar o status dos recursos e acessar a aplicação.

### 2.1. Verificando o Status dos Pods

Para verificar se todos os componentes  estão rodando corretamente, use o seguinte comando:

```bash
  kubectl get pods -A
```

O resultado esperado é ver todos os pods nos namespaces `app-ns`, `db-ns` e `ingress-nginx` com o status `Running`.

### 4.2. Acessando a Aplicação

Abra seu navegador e acesse o seguinte endereço:

> **http://meu-app.com**



---
