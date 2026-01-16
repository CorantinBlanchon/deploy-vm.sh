#!/bin/bash
set -e
echo "Mode strict activé : arrêt en cas d’erreur"


#Variables:

RG="AZ104"
VNET_NAME="VNet-Lab-Test"
SUBNET_NAME="Back-end"
SUBSCRIPTION_ID="ce0de1ad-a39c-428d-ad59-388ff424ab35"
LOCATION="westeurope"
SUBNET_ID="/subscriptions/ce0de1ad-a39c-428d-ad59-388ff424ab35/resourceGroups/AZ104/providers/Microsoft.Network/virtualNetworks/VNet-Lab-Test/subnets/Back-end"
TAGS="env=lab owner=corantin"

az account set --subscription "$SUBSCRIPTION_ID"

#Création NIC:

NIC_NAME="nic-backend-01"
az network nic create \
  --resource-group "$RG" \
  --name "$NIC_NAME" \
  --subnet "$SUBNET_ID"
  --tags "$TAGS"

#Création VM:

VM_NAME="vm-backend-01"

read -s -p "Enter admin password: " ADMIN_PASSWORD
echo
az vm create \
  --resource-group "$RG" \
  --name "$VM_NAME" \
  --nics "$NIC_NAME" \
  --image Win2019Datacenter \
  --admin-username azureuser \
  --admin-password "$ADMIN_PASSWORD" \
  --size Standard_B2s \
  --tags "$TAGS"
