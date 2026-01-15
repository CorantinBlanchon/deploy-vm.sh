#!/bin/bash

# Variables

az network vnet subnet show \
RG="AZ104"
LOCATION="westeurope"
VNET_NAME="VNet-Lab-Test"
SUBNET_NAME="Back-end"
--query id -o tsv
