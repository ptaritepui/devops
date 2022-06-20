# Utilización de imágenes de Azure Marketplace

## Obtener la imagen de CentOS Stream 8 publicada por Cognosys que se encuentran disponibles en el Marketplace:

```
$ az vm image list -f centos-8-stream-free -p cognosys --all --output table
```

## Activar la imagen con la suscripción de Azure

### Visualizar los términos de uso de una imagen específica:

```
$ az vm image terms show --urn cognosys:centos-8-stream-free:centos-8-stream-free:22.03.28
```

### Aceptar las condiciones de uso de una imagen específica:

```
$ az vm image accept-terms --urn cognosys:centos-8-stream-free:centos-8-stream-free:22.03.28
```

Una vez completados los pasos anteriores, ya podemos desplegar máquinas virtuales utilizando la imagen activada.
