# Ejemplos de almacenamiento persistente en Kubernetes

## Creación de PVC en la StorageClass por defecto

```
kubectl create -f pvc.yaml
```

## Creación de PVC en la StorageClass azurefile

```
kubectl create -f pvc_file.yaml
```

## Cambiar la política de retención de un PV:

```
 kubectl patch pv <IDENTIFICADOR_PV>  -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
```

## Desplegar 3 Pods haciendo uso del mismo PV:

```
kubectl create -f pvc_file.yaml
```

```
kubectl create -f pod{1,2,3}.yaml
```

Para conectarse a un Pod específico:

```
kubectl exec -it <POD> -- /bin/bash
```

## Evacuar un nodo Worker

```
kubectl cordon <WORKER>
kubectl drain <WORKER> --force --ignore-daemonsets
```
