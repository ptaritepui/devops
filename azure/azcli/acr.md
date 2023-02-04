# Creación de un Container Registry desde el AZ CLI

En este ejemplo se creará un **Container Registry** con las siguientes características:

* Grupo de Recursos: ejemplo-acr
* Nombre: ptaritepui
* Region: West Europe
* SKU: Standard

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

4. Antes de crear el ***registry*** es necesario crear el ***Resource Group***.

```
az group create --location westeurope --resource-group ejemplo-acr
```

El comando anterior devolverá un mensaje como este:

```
{
  "id": "/subscriptions/<UUID>/resourceGroups/ejemplo-acr",
  "location": "westeurope",
  "managedBy": null,
  "name": "ejemplo-acr",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```


5. Para crear el ***Container Registry*** con las características indicadas al principio de este ejemplo se ejecuta el siguiente comando:

```
az acr create \
--name ptaritepui \
--resource-group ejemplo-acr \
--sku Standard \
--admin-enable true
```

El comando anterior devolverá un **json** similar a este:

```
{
  "adminUserEnabled": true,
  "anonymousPullEnabled": false,
  "creationDate": "<TIMESTAMP>",
  "dataEndpointEnabled": false,
  "dataEndpointHostNames": [],
  "encryption": {
    "keyVaultProperties": null,
    "status": "disabled"
  },
  "id": "/subscriptions/<UUID>/resourceGroups/ejemplo-acr/providers/Microsoft.ContainerRegistry/registries/ptaritepui",
  "identity": null,
  "location": "westeurope",
  "loginServer": "ptaritepui.azurecr.io",
  "name": "ptaritepui",
  "networkRuleBypassOptions": "AzureServices",
  "networkRuleSet": null,
  "policies": {
    "azureAdAuthenticationAsArmPolicy": {
      "status": "enabled"
    },
    "exportPolicy": {
      "status": "enabled"
    },
    "quarantinePolicy": {
      "status": "disabled"
    },
    "retentionPolicy": {
      "days": 7,
      "lastUpdatedTime": "<TIMESTAMP>",
      "status": "disabled"
    },
    "softDeletePolicy": {
      "lastUpdatedTime": "<TIMESTAMP>",
      "retentionDays": 7,
      "status": "disabled"
    },
    "trustPolicy": {
      "status": "disabled",
      "type": "Notary"
    }
  },
  "privateEndpointConnections": [],
  "provisioningState": "Succeeded",
  "publicNetworkAccess": "Enabled",
  "resourceGroup": "ejemplo-acr",
  "sku": {
    "name": "Standard",
    "tier": "Standard"
  },
  "status": null,
  "systemData": {
    "createdAt": "<TIMESTAMP>",
    "createdBy": "<EMAIL>",
    "createdByType": "User",
    "lastModifiedAt": "<TIMESTAMP>",
    "lastModifiedBy": "<EMAIL>",
    "lastModifiedByType": "User"
  },
  "tags": {},
  "type": "Microsoft.ContainerRegistry/registries",
  "zoneRedundancy": "Disabled"
}
```

6. Ejecutar el siguiente comando para obtener las credenciales de acceso al ***registry***:

```
az acr credential show --name ptaritepui --resource-group ejemplo-acr
{
  "passwords": [
    {
      "name": "password",
      "value": "*****"
    },
    {
      "name": "password2",
      "value": "*****"
    }
  ],
  "username": "ptaritepui"
}

```

7. Probar la autenticación en el ACR

Desde una terminal con **docker** o **podman** instalado autenticarse en el ACR. El siguiente ejemplo aplica para Linux utilizando las credenciales del administrador del acr mostradas arriba:

```
REGISTRY=ptaritepui.azurecr.io
podman login ${REGISTRY}
Username: ptaritepui
Password: *********
```

Llegados a este punto, si queremos eliminar el ***registry**, se puede eliminar directamente el ***Resource Group*** con el siguiente comando:

```
az group delete --name ejemplo-acr -y
```