# Creación de una máquina virtual mediante AZ CLI

En este ejemplo se creará una máquina virtual con las siguientes características:

* Grupo de Recursos: azure-ej-1
* Nombre: vm01
* Region: UK-South
* Opciones de Disponibilidad: Zona de Disponibilidad
* Zona de Disponibilidad: Zones 1
* Sistema Operativo: AlmaLinux 8.5
* Tamaño: Standard_B1s (1 vCPU - 1 GiB de memmoria)
* Usuario administrador: azureuser
* Clave SSH: Generar una nueva con el nombre key-ej-1

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

4. Antes de crear la máquina virtual es necesario crear el ***Resource Group***.

```
az group create --location uksouth --resource-group azure-ej-1
```

El comando anterior devolverá un mensaje como este:

```
{
  "id": "/subscriptions/<UUID>/resourceGroups/azure-ej-1",
  "location": "uksouth",
  "managedBy": null,
  "name": "azure-ej-1",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```

5. Seguidamente, es necesario crear el par de claves SSH o indicar una clave previamente creada. El siguiente comando crea un nuevo par de claves llamado **key-ej-1**

```
$ az sshkey create --location uksouth --resource-group azure-ej-1 --name key-ej-1
No public key is provided. A key pair is being generated for you.
Private key is saved to "/home/<USERNAME>/.ssh/1674947658_9482238".
Public key is saved to "/home/<USERNAME>/.ssh/1674947658_9482238.pub".
{
  "id": "/subscriptions/<UUID>/resourceGroups/AZURE-EJ-1/providers/Microsoft.Compute/sshPublicKeys/key-ej-1",
  "location": "uksouth",
  "name": "key-ej-1",
  "publicKey": "<PUBLIC_SSH_KEY>",
  "resourceGroup": "AZURE-EJ-1",
  "tags": null,
  "type": null
}
```

Es necesario restringir los permisos del fichero de la clave privada creada en el comando anterior. Por ejemplo para que sólo tenga permisos el usuario que es propietario fichero:

```
chmod 0600 /home/<USERNAME>/.ssh/1674947658_9482238
```

6. Para crear una máquina virtual en Azure a través de la línea de comandos primero se deben identificar las imágenes de sistema operativo disponibles.

Para obtener el catálogo de todas las imágenes disponibles en Azure se utiliza el siguiente comando:

```
$ az vm image list --all
```

Sin embargo, el comando anterior puede tardar varios minutos antes de obtener un resultado y devolverá una lista extensa de imágenes. Para acotar la lista de imágenes se puede filtrar la búsqueda indicando uno o varios parámetros. Consultar la ayuda para más detalles: `az vm image list --help`

Para este ejemplo vamos a buscar una imagen de AlmaLinux versión 8.5. Para ello aplicaremos los filtros de **arquitectura**, ***offer*** y ***sku***. 

```
$ az vm image list --architecture x64 --offer almalinux --sku 8_5 --all
[
  {
    "architecture": "x64",
    "offer": "almalinux",
    "publisher": "almalinux",
    "sku": "8_5",
    "urn": "almalinux:almalinux:8_5:8.5.20211118",
    "version": "8.5.20211118"
  },
  {
    "architecture": "x64",
    "offer": "almalinux",
    "publisher": "almalinux",
    "sku": "8_5",
    "urn": "almalinux:almalinux:8_5:8.5.20220311",
    "version": "8.5.20220311"
  },
  ...
```

Utilizaremos la versión más reciente de las dos anteriores, es decir, la imagen cuyo **urn** es **almalinux:almalinux:8_5:8.5.20220311**.

7. Para crear la máquina virtual con las características indicadas al principio de este ejemplo se ejecuta el siguiente comando:

```
az vm create \
--name vm01 \
--resource-group azure-ej-1 \
--image almalinux:almalinux:8_5:8.5.20220311 \
--size Standard_B1s \
--zone 1 \
--admin-username azureuser \
--ssh-key-name key-ej-1
```

Una vez se haya creado la máquina el comando anterior nos devolverá la IP pública para poder conectarnos.

```
Starting Build 2023 event, "az vm/vmss create" command will deploy Trusted Launch VM by default. To know more about Trusted Launch, please visit https://docs.microsoft.com/en-us/azure/virtual-machines/trusted-launch
{
  "fqdns": "",
  "id": "/subscriptions/<UUID>/resourceGroups/azure-ej-1/providers/Microsoft.Compute/virtualMachines/vm01",
  "location": "uksouth",
  "macAddress": "60-45-BD-F2-15-F5",
  "powerState": "VM running",
  "powerState": "VM running",
  "privateIpAddress": "10.0.0.4",
  "publicIpAddress": "20.90.116.206",
  "resourceGroup": "azure-ej-1",
  "zones": "1"
}
```

Del comando anterior, podemos observar la IP pública mediante la cual podremos conectarnos por SSH a la máquina virtual:

```
ssh -i .ssh/1674947658_9482238 azureuser@20.90.116.206
The authenticity of host '20.90.116.206 (20.90.116.206)' can't be established.
ED25519 key fingerprint is SHA256:3XgtwuV9XBrBLlvtkYA9TLhA5rftbJHL2uOEQ1G2QmM.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Activate the web console with: systemctl enable --now cockpit.socket

[azureuser@vm01 ~]$
```

Podemos comprobar que el sistema operativo es **AlmaLinux 8.5** y el nombre de la máquina es **vm01**

```
hostnamectl
   Static hostname: vm01
         Icon name: computer-vm
           Chassis: vm
        Machine ID: cc5151bcc4a64afb9a5a787ad3063b01
           Boot ID: e83f1f6dd5b146ad96e2a88ea7d65597
    Virtualization: microsoft
  Operating System: AlmaLinux 8.5 (Arctic Sphynx)
       CPE OS Name: cpe:/o:almalinux:almalinux:8::baseos
            Kernel: Linux 4.18.0-348.20.1.el8_5.x86_64
      Architecture: x86-64
```

Llegados a este punto, si queremos eliminar la máquina virtual y todos sus recursos: interfaz de red, disco, etc, se puede eliminar directamente el ***Resource Group*** con el siguiente comando:

```
az group delete --name azure-ej-1 -y
```