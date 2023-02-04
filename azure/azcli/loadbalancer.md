# Despliegue de un balanceador de carga delante de tres máquinas virtuales mediante AZ CLI

En este ejemplo se creará un balanceador de carga junto con tres máquinas virtuales. 

## Características de las máquinas virtuales:

* Grupo de Recursos: azure-ej-lb
* Nombre: vm0{1 2 3}
* Region: UK-South
* Opciones de Disponibilidad: Zona de Disponibilidad
* Zona de Disponibilidad: Zones { 1 2 3 }
* Sistema Operativo: AlmaLinux 8.5
* Tamaño: Standard_B1s (1 vCPU - 1 GiB de memmoria)
* Usuario administrador: azureuser
* Clave SSH: Generar una nueva con el nombre key-ej-lb

## Procedimiento:

### Despliegue de las máquinas virtuales 

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

4. Antes de crear cualquier recurso es necesario crear el ***Resource Group***.

```
az group create --location uksouth --resource-group azure-ej-lb
```

El comando anterior devolverá un mensaje como este:

```
{
  "id": "/subscriptions/<UUID>/resourceGroups/azure-ej-vmss",
  "location": "uksouth",
  "managedBy": null,
  "name": "azure-ej-lb",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```
5. Seguidamente, es necesario crear el par de claves SSH o indicar una clave previamente creada. El siguiente comando crea un nuevo par de claves llamado **key-ej-lb**

```
$ az sshkey create --location uksouth --resource-group azure-ej-lb --name key-ej-lb
No public key is provided. A key pair is being generated for you.
Private key is saved to "/home/<USERNAME>/.ssh/1674947658_9482238".
Public key is saved to "/home/<USERNAME>/.ssh/1674947658_9482238.pub".
{
  "id": "/subscriptions/<UUID>/resourceGroups/AZURE-EJ-1/providers/Microsoft.Compute/sshPublicKeys/key-ej-1",
  "location": "uksouth",
  "name": "key-ej-lb",
  "publicKey": "<PUBLIC_SSH_KEY>",
  "resourceGroup": "AZURE-EJ-LB",
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

7. Creación del grupo de seguridad (***network security group***) que se vinculará a las máquinas virtuales:

```
GROUP="azure-ej-lb"
LOCATION="uksouth"
SECURITY_GROUP="nsg-ej-lb"
SECURITY_RULE="http-rule"
SSHKEY="sshkey-ej-lb"

az network nsg create -g ${GROUP} -n ${SECURITY_GROUP}
```

8. Añadir regla para permitir el tráfico HTTP en el grupo de seguridad:

```
az network nsg rule create \
--name ${SECURITY_RULE} \
--nsg-name ${SECURITY_GROUP} \
--resource-group ${GROUP} \
--priority 1001 \
--access Allow \
--direction Inbound \
--protocol TCP \
--destination-port-ranges 80
```

9. Para crear la máquina virtual con las características indicadas al principio de este ejemplo se ejecutan los siguientes comandos:

```
for id in 1 2 3
do
        echo "Creating VM ${id}"
        az vm create \
        -n vm0${id} \
        --resource-group ${GROUP} \
        --image almalinux:almalinux:8_5:8.5.20220311 \
        --ssh-key-name ${SSHKEY} \
        --zone ${id} \
        --size Standard_B1s \
        --nsg ${SECURITY_GROUP} \
        --admin-username azureuser \
        --public-ip-address ""
done
```

### Configuración del servidor Web en cada una de las máquinas virtuales

10. Se define un script de configuración del servicio Web:

```
cat <<EOF > 01_setup_httpd.sh
#!/bin/bash
dnf -y install httpd
cp /usr/share/httpd/noindex/index.html /var/www/html/
for service in httpd firewalld;
do
    systemctl enable ${service} --now
done
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload
EOF
```

11. Se ejecuta el script en cada una de las máquinas virtuales:

```
for id in 1 2 3
do
        echo "Setting up httpd server in VM ${id}"
        az vm run-command invoke \
        --resource-group ${GROUP} \
        -n vm0${id} \
        --command-id RunShellScript \
        --scripts @01_setup_httpd.sh
done
```

### Despliegue del balanceador de carga

12. Se crea una IP pública para atender las peticiones del servicio Web

```
az network public-ip create \
--resource-group ${GROUP} \
--name VIP \
--sku Standard \
--zone 1 2 3
```

NOTA: Conservar el valor de la IP pública creada, pues será utilizada en el último paso de este ejercicio.

13. Se crea el balanceador de carga asociado a la IP pública creada anteriormente.

```
az network lb create \
--resource-group ${GROUP} \
--name lb1 \
--sku Standard \
--public-ip-address VIP \
--frontend-ip-name fe1 \
--backend-pool-name be1
```

14. Se define la sonda de monitorización del servicio Web

```
az network lb probe create \
--resource-group ${GROUP} \
--lb-name lb1 \
--name probe1 \
--protocol http \
--port 80 \
--path /
```

15. En este paso se crea la regla de balance de tráfico a utilizar

```
az network lb rule create \
--resource-group ${GROUP} \
--lb-name lb1 \
--name httprule \
--protocol tcp \
--frontend-port 80 \
--backend-port 80 \
--frontend-ip-name fe1 \
--backend-pool-name be1 \
--probe-name probe1 \
--disable-outbound-snat true \
--idle-timeout 15 \
--enable-tcp-reset true
```

16. Se añaden las tarjetas de red correspondientes a las 3 VMs al pool de backend del balanceador de carga:

```
for id in 1 2 3
do
  echo "Adding VNIC from VM vm0${id}"
  az network nic ip-config address-pool add \
  --address-pool be1 \
  --ip-config-name ipconfigvm0${id} \
  --nic-name vm0${id}VMNic \
  --resource-group ${GROUP} \
  --lb-name lb1
done
```

### Prueba de conectividad al servidor Web

17. Establecer la conexión a la IP pública del balanceador de carga y comprobar que se muestra la Web por defecto del servidor Apache.

Desde una terminal Linux:

```
curl -v http://<PUBLIC_IP>
```

Desde un navegador Web:

http://<PUBLIC_IP>