# Creación de un cluster de AKS mediante el AZ CLI

En este ejemplo se creará una máquina virtual con las siguientes características:

* Grupo de Recursos: azure-ej-aks
* Configuración predefinida del cluster: Dev/Test
* Nombre del cluster: aks01
* Region: UK-South
* Zona de Disponibilidad: None
* Versión de Kubernetes: 1.24.6 (default)
* AKS Pricing Tier: Free
* Actualización automática: Manual
* Tamaño de nodos: Standard_B4ms (4 vCPUs - 16 GiB de memmoria)
* Cantidad de nodos: 1

## Procedimiento

1. En primer lugar es necesario autenticarse en Azure mediante el comando `az login`

```
$ az login
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code ******* to authenticate.
```

2. Abrir un navegador web, luego ir a la URL https://microsoft.com/devicelogin e introducir el código indicado en la salida del comando `az login`


<p align="center">
  <img width="274" height="211" src="./imagenes/01_az_login.png">
</p>

---

<p align="center">
  <img width="274" height="138" src="./imagenes/02_az_login.png">
</p>

3. Volver a la terminal y consultar el resultado del proceso de autenticación que mostrará los siguientes datos:

```
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "<TENANT_ID>",
    "id": "<UUID>",
    "isDefault": true,
    "managedByTenants": [],
    "name": "<SUBSCRIPTION_NAME>",
    "state": "Enabled",
    "tenantId": "<TENANT_ID>",
    "user": {
      "name": "<EMAIL>",
      "type": "user"
    }
  }
]
```

4. Antes de crear el cluster de AKS es necesario crear el ***Resource Group***.

```
az group create --location uksouth --resource-group azure-ej-aks
```

El comando anterior devolverá un mensaje como este:

```
{
  "id": "/subscriptions/<UUID>/resourceGroups/azure-ej-aks",
  "location": "uksouth",
  "managedBy": null,
  "name": "azure-ej-aks",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```

5- El siguiente comando crea un cluster de AKS con las características descritas al inicio de este ejemplo:

```
az aks create \
--name aks01 \
--resource-group azure-ej-aks \
--node-vm-size Standard_B4ms \
--kubernetes-version 1.24.6 \
--node-count 1
```

El comando anterior devolverá la información del cluster de Kubernetes creado:

```
{
  "aadProfile": null,
  "addonProfiles": null,
  "agentPoolProfiles": [
    {
      "availabilityZones": null,
      "count": 1,
      "creationData": null,
      "currentOrchestratorVersion": "1.24.6",
      "enableAutoScaling": false,
      "enableEncryptionAtHost": false,
      "enableFips": false,
      "enableNodePublicIp": false,
      "enableUltraSsd": false,
      "gpuInstanceProfile": null,
      "hostGroupId": null,
      "kubeletConfig": null,
      "kubeletDiskType": "OS",
      "linuxOsConfig": null,
      "maxCount": null,
      "maxPods": 110,
      "minCount": null,
      "mode": "System",
      "name": "nodepool1",
      "nodeImageVersion": "AKSUbuntu-1804gen2containerd-2023.01.19",
      "nodeLabels": null,
      "nodePublicIpPrefixId": null,
      "nodeTaints": null,
      "orchestratorVersion": "1.24.6",
      "osDiskSizeGb": 128,
      "osDiskType": "Managed",
      "osSku": "Ubuntu",
      "osType": "Linux",
      "podSubnetId": null,
      "powerState": {
        "code": "Running"
      },
      "provisioningState": "Succeeded",
      "proximityPlacementGroupId": null,
      "scaleDownMode": null,
      "scaleSetEvictionPolicy": null,
      "scaleSetPriority": null,
      "spotMaxPrice": null,
      "tags": null,
      "type": "VirtualMachineScaleSets",
      "upgradeSettings": {
        "maxSurge": null
      },
      "vmSize": "Standard_B4ms",
      "vnetSubnetId": null,
      "workloadRuntime": null
    }
  ],
  "apiServerAccessProfile": null,
  "autoScalerProfile": null,
  "autoUpgradeProfile": null,
  "azurePortalFqdn": "aks01-azure-ej-aks-<UUID>.portal.hcp.uksouth.azmk8s.io",
  "currentKubernetesVersion": "1.24.6",
  "disableLocalAccounts": false,
  "diskEncryptionSetId": null,
  "dnsPrefix": "aks01-azure-ej-aks-<UUID>",
  "enablePodSecurityPolicy": null,
  "enableRbac": true,
  "extendedLocation": null,
  "fqdn": "aks01-azure-ej-aks-<UUID>.hcp.uksouth.azmk8s.io",
  "fqdnSubdomain": null,
  "httpProxyConfig": null,
  "id": "/subscriptions/<UUID>/resourcegroups/azure-ej-aks/providers/Microsoft.ContainerService/managedClusters/aks01",
  "identity": {
    "principalId": "<PRINCIPAL_ID>",
    "tenantId": "<TENANT_ID>",
    "type": "SystemAssigned",
    "userAssignedIdentities": null
  },
  "identityProfile": {
    "kubeletidentity": {
      "clientId": "<CLIENT_ID>",
      "objectId": "<OBJECT_ID>",
      "resourceId": "/subscriptions/<UUID>/resourcegroups/MC_azure-ej-aks_aks01_uksouth/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aks01-agentpool"
    }
  },
  "kubernetesVersion": "1.24.6",
  "linuxProfile": {
    "adminUsername": "azureuser",
    "ssh": {
      "publicKeys": [
        {
          "keyData": "<PUBLIC_KEY>"
        }
      ]
    }
  },
  "location": "uksouth",
  "maxAgentPools": 100,
  "name": "aks01",
  "networkProfile": {
    "dnsServiceIp": "10.0.0.10",
    "dockerBridgeCidr": "172.17.0.1/16",
    "ipFamilies": [
      "IPv4"
    ],
    "loadBalancerProfile": {
      "allocatedOutboundPorts": null,
      "effectiveOutboundIPs": [
        {
          "id": "/subscriptions/<UUID>/resourceGroups/MC_azure-ej-aks_aks01_uksouth/providers/Microsoft.Network/publicIPAddresses/<PIB_ID>",
          "resourceGroup": "MC_azure-ej-aks_aks01_uksouth"
        }
      ],
      "enableMultipleStandardLoadBalancers": null,
      "idleTimeoutInMinutes": null,
      "managedOutboundIPs": {
        "count": 1,
        "countIpv6": null
      },
      "outboundIPs": null,
      "outboundIpPrefixes": null
    },
    "loadBalancerSku": "Standard",
    "natGatewayProfile": null,
    "networkMode": null,
    "networkPlugin": "kubenet",
    "networkPolicy": null,
    "outboundType": "loadBalancer",
    "podCidr": "10.244.0.0/16",
    "podCidrs": [
      "10.244.0.0/16"
    ],
    "serviceCidr": "10.0.0.0/16",
    "serviceCidrs": [
      "10.0.0.0/16"
    ]
  },
  "nodeResourceGroup": "MC_azure-ej-aks_aks01_uksouth",
  "oidcIssuerProfile": {
    "enabled": false,
    "issuerUrl": null
  },
  "podIdentityProfile": null,
  "powerState": {
    "code": "Running"
  },
  "privateFqdn": null,
  "privateLinkResources": null,
  "provisioningState": "Succeeded",
  "publicNetworkAccess": null,
  "resourceGroup": "azure-ej-aks",
  "securityProfile": {
    "azureKeyVaultKms": null,
    "defender": null
  },
  "servicePrincipalProfile": {
    "clientId": "msi",
    "secret": null
  },
  "sku": {
    "name": "Basic",
    "tier": "Free"
  },
  "storageProfile": {
    "blobCsiDriver": null,
    "diskCsiDriver": {
      "enabled": true
    },
    "fileCsiDriver": {
      "enabled": true
    },
    "snapshotController": {
      "enabled": true
    }
  },
  "systemData": null,
  "tags": null,
  "type": "Microsoft.ContainerService/ManagedClusters",
  "windowsProfile": null,
  "workloadAutoScalerProfile": {
    "keda": null
  }
}
```

6. Obtener las credenciales del cluster de AKS mediante el AZ CLI desde la terminal

```
CLUSTER=aks01
RESOURCEGROUP=azure-ej-aks
az aks get-credentials --overwrite-existing --name ${CLUSTER} --resource-group ${RESOURCEGROUP}
 ```

 El comando anterior devolverá el siguiente mensaje:

 ```
 Merged "aks01" as current context in /home/admin/.kube/config
```

Ya es posible utilizar el cliente **kubectl** para realizar operaciones sobre el cluster de AKS. Por ejemplo para consultar el estado de los nodos del cluster:

```
kubectl get nodes
NAME                                STATUS   ROLES   AGE    VERSION
aks-nodepool1-35538020-vmss000000   Ready    agent   8m7s   v1.24.6
```

Llegados a este punto, si queremos eliminar el cluster de AKS, se puede eliminar directamente el ***Resource Group*** con el siguiente comando:

```
az group delete --name ejemplo-aks -y
```