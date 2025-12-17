#!/bin/bash
set -e

# Lade .env falls vorhanden
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Fehler: .env Datei nicht gefunden!"
    exit 1
fi

DOCKER_TOKEN="${DOCKER_TOKEN:-}"

# Konfiguration

CLUSTER_NAME="c1"
MUSIC_NAMESPACE="musicevents"
ARGO_NAMESPACE="argocd"
DOCKER_USERNAME="lauradubach"
DOCKER_EMAIL="laura.dubach@edu.tbz.ch"
SECRET_FILES=("ghcr-secret.yaml" "ticketmaster-secret.yaml")

# Minikube Cluster auf Docker starten

echo "Setze Minikube Treiber auf Docker"
minikube config set driver docker

echo "Alten Cluster löschen (falls vorhanden)"
minikube delete -p $CLUSTER_NAME || true

echo "Starte neuen Cluster"
minikube start -p $CLUSTER_NAME

echo "Cluster Profile prüfen"
minikube profile list

# Namespaces erstellen

echo "Erstelle Namespaces"
kubectl create namespace $MUSIC_NAMESPACE || true
kubectl create namespace $ARGO_NAMESPACE || true

# Ingress aktivieren

echo "Aktiviere Ingress Addon"
minikube addons enable ingress -p $CLUSTER_NAME

# ArgoCD installieren

echo "ArgoCD installieren"
kubectl apply -n $ARGO_NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Warte bis ArgoCD Secret erstellt ist

echo "Warte auf ArgoCD Secret..."
sleep 10

# Secret YAMLs in Music Namespace deployen

echo "Deploye Secrets in Music Namespace"
for secret_file in "${SECRET_FILES[@]}"; do
    if [ -f "$secret_file" ]; then
        kubectl apply -n $MUSIC_NAMESPACE -f "$secret_file"
        echo "$secret_file deployed in $MUSIC_NAMESPACE"
    else
        echo "$secret_file nicht gefunden!"
    fi
done

# ArgoCD Application deployen

echo "ArgoCD Application deployen"
kubectl apply -f argocd/application.yaml -n $ARGO_NAMESPACE

echo "Alles erledigt! Cluster ist bereit."