# Despliegue de una aplicación web en un contenedor de podman 

El siguiente procedimiento se ha ejecutado sobre una distribución Linux basada en RPMs.

1. Instalación de podman


```
$ sudo dnf -y install podman
```

2. Creación de la imagen **webserver**:

```
$ ls ./
Containerfile  index.html  nginx.conf

$ podman build -t webserver .
```

3. Listar las imágenes:

```
$ podman images
REPOSITORY                         TAG         IMAGE ID      CREATED         SIZE
localhost/servidor_web             latest      e6fc63f39884  41 seconds ago  212 MB
registry.fedoraproject.org/fedora  latest      3a66698e6040  6 weeks ago     169 MB
```

4. Crear el contenedor **web1** a partir de la imagen **webserver** para que reenvie el tráfico TCP del puerto 8080 del host hacia el puerto 8080 del contenedor:

```
$ podman run --name web1 --rm -d -p 8080:8080 localhost/webserver
0b03372dea0c5a890f9af51990e99f0cf88b5dce0ae136eb1d33a45effe7d1e2

$ podman ps
CONTAINER ID  IMAGE                          COMMAND               CREATED        STATUS            PORTS                   NAMES
0b03372dea0c  localhost/webserver:latest  /usr/sbin/nginx -...  4 seconds ago  Up 4 seconds ago  0.0.0.0:8080->8080/tcp     web1
```

5. Verificar el estado del servidor web:

```
$ curl localhost:8080
<!DOCTYPE html>
<html>
        <body>

                <h1>Servidor Web corriendo desde un contenedor</h1>

        </body>
</html>
```

6. Crear el contenedor **web2** a partir de la imagen **webserver** para que reenvie el tráfico TCP del puerto 8081 del host hacia el puerto 8080 del contenedor:

```
$ podman run --name web2 --rm -d -p 8081:8080 localhost/webserver
4c12572dea0c5a890f9af51990e99f0cf88b5dce0ae136eb1d33a45effe7e2c3

$ podman ps
CONTAINER ID  IMAGE                          COMMAND               CREATED        STATUS            PORTS                   NAMES
0b03372dea0c  localhost/webserver:latest  /usr/sbin/nginx -...  2 minutes ago  Up 4 minutes ago  0.0.0.0:8080->8080/tcp     web1
4c12572dea0c  localhost/webserver:latest  /usr/sbin/nginx -...  4 seconds ago  Up 4 seconds ago  0.0.0.0:8081->8080/tcp     web2
```
