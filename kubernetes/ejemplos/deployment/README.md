## Despliegue de una aplicación

1. Se crea un namespace llamado **example**

```
$ kubectl create namespace example
```

2. Se comprueba que se ha creado el namespace

```
$ kubectl get namespaces
```

3. Se crean los recursos de la aplicación: 2 Deployments y 2 Servicios:

```
$ kubectl create -f app.yaml
```

4. Consultamos los recursos de tipo  deployments,pods,services

```
$ kubectl get deployment,pods,services -n example
```
