# Migración de imágenes entre registries

## Prerrequisitos

* Una imagen de contenedor disponible para subir a un registry.
* Dos registries con conectividad entre ellos.

**NOTA**: En este ejemplo ambos registries se encuentran en Azure desplegados en dos regiones distintas a través del servicio nativo **Azure Container Registry**

## Subir imagen a un registry de Azure:

1. Obtener credenciales de autenticación en el registry:

```
$ az login

$ TOKEN=$(az acr login --name <REGISTRY_NAME> --expose-token --output tsv --query accessToken)

$ USER=<USERNAME>

```

2. Autenticar podman en el registry:

```
$ podman login <REGISTRY_URL> -u ${USER} -p ${TOKEN}
Login succeded!
```

3. Etiquetar imagen con los datos del registry

```
$ podman tag localhost/webserver:latest <REGISTRY_URL>/webserver:v1

```

4. Subir imagen al registry

```
$ podman push <REGISTRY_URL>/webserver:v1
```

## Copiar la imagen entre registries utilizando Skopeo

1. Obtener credenciales de autenticación del segundo registry:

```
$ az login

$ TOKENMIRROR=$(az acr login --name <REGISTRY_NAME> --expose-token --output tsv --query accessToken)

$ USER=<USERNAME>

```

2. Copiar la imagen entre ambos registries:

```
$ skopeo copy \
docker://<REGISTRY_URL>/webserver:v1 \
docker://<REGISTRY_MIRROR_URL>/webserver:v1 \
--src-creds ${USERNAME}:${TOKEN} \
--dest-creds ${USERNAME}:${TOKENMIRROR}
```

