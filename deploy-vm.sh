#!/bin/bash
set -e
echo "Mode strict activé : arrêt en cas d’erreur"


# Variables

# Subscription dans laquelle tu veux travailler
SUBSCRIPTION_ID="ce0de1ad-a39c-428d-ad59-388ff424ab35"

# Ressources réseau
RG="AZ104"
RG_LOCATION="westeurope"    
VNET_LOCATION="francecentral" 
VNET_NAME="VNet-Lab-Test"
SUBNET_NAME="Back-end"
ADDRESS_PREFIX="10.0.0.0/16"
SUBNET_PREFIX="10.0.1.0/24"

# Ressources NIC + VM
NIC_NAME="nic-backend-01"
VM_NAME="vm-backend-01"

# Tags (FinOps / gouvernance)
TAGS="env=lab owner=corantin"


# Contexte Azure

echo "Sélection de la subscription : $SUBSCRIPTION_ID"
az account set --subscription "$SUBSCRIPTION_ID"


# Création du VNet en francecentral
az network vnet create \
  --resource-group "$RG" \
  --name "$VNET_NAME" \
  --location "$VNET_LOCATION" \
  --address-prefixes "$ADDRESS_PREFIX" \
  --subnet-name "$SUBNET_NAME" \
  --subnet-prefixes "$SUBNET_PREFIX" \
  >/dev/null


echo "Récupération de l'ID du subnet..."
SUBNET_ID=$(az network vnet subnet show \
  --resource-group "$RG" \
  --vnet-name "$VNET_NAME" \
  --name "$SUBNET_NAME" \
  --query id -o tsv)

echo "Subnet ID = $SUBNET_ID"


# NIC


echo "Création de la NIC : $NIC_NAME"

az network nic create \
  --resource-group "$RG" \
  --name "$NIC_NAME" \
  --subnet "$SUBNET_ID" \
  --tags "$TAGS" \
  >/dev/null


# VM

echo "Saisie du mot de passe admin pour la VM..."
read -s -p "Enter admin password: " ADMIN_PASSWORD
echo

echo "Création de la VM : $VM_NAME"

az vm create \
  --resource-group "$RG" \
  --name "$VM_NAME" \
  --nics "$NIC_NAME" \
  --image Win2019Datacenter \
  --admin-username azureuser \
  --admin-password "$ADMIN_PASSWORD" \
  --size Standard_B2s \
  --tags "$TAGS"

echo "Déploiement terminé ✅"

