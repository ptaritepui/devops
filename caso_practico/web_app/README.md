# Servidor Web contenerizado

A continuación se describe el procedimiento (manual) de instalación de un servidor Web (Apache) contenerizado en Podman.

## Requisitos

* Una máquina con sistema operativo Linux.
* Usuario con privilegios de administrador del sistema (root).
* Un ***Registry*** para almacenar la imagen del contenedor a desplegar.

## Procedimiento

1. Instalar las siguientes herramientas:

* podman
* skopeo
* httpd-tools
* openssl

```
sudo dnf -y install podman skopeo httpd-tools openssl
```

2. Crear un directorio de trabajo.

```
mkdir webserver && cd webserver
```

3. Crear el fichero de credenciales para la autenticación básica en el servidor Web.

```
htpasswd -cBb .creds <USERNAME> <PASSWORD>
```

4. Generación del certificado autofirmado.

4.1 Crear clave privada para el certificado:

```
openssl genrsa -out <KEY_NAME>.key 2048
```

4.2 Crear la petición de firma del certificado:

```
openssl req -key <KEY_NAME>.key -new -out <CSR_NAME>.csr -subj "/C=ES/ST=Madrid/L=Madrid/O=DevOps/OU=Ejemplo/CN=vm1"
```

4.3 Crear certificado utilizando la clave privada y la petición de firma:

```
openssl x509 -signkey <KEY_NAME>.key -in <CSR_NAME>.csr -req -days 365 -out <CERT_NAME>.crt
```

5. Definir la página principal del servidor Web:

```
cat <<EOF > index.html
<p>This is the web server</p>
EOF
```

6. Definir la configuración del servidor Web:

```
cat <<EOF > httpd.conf
ServerRoot "/usr/local/apache2"
Listen 443

LoadModule mpm_event_module modules/mod_mpm_event.so
LoadModule authn_file_module modules/mod_authn_file.so
LoadModule authn_core_module modules/mod_authn_core.so
LoadModule authz_host_module modules/mod_authz_host.so
LoadModule authz_groupfile_module modules/mod_authz_groupfile.so
LoadModule authz_user_module modules/mod_authz_user.so
LoadModule authz_core_module modules/mod_authz_core.so
LoadModule access_compat_module modules/mod_access_compat.so
LoadModule auth_basic_module modules/mod_auth_basic.so
LoadModule reqtimeout_module modules/mod_reqtimeout.so
LoadModule filter_module modules/mod_filter.so
LoadModule mime_module modules/mod_mime.so
LoadModule log_config_module modules/mod_log_config.so
LoadModule env_module modules/mod_env.so
LoadModule headers_module modules/mod_headers.so
LoadModule setenvif_module modules/mod_setenvif.so
LoadModule version_module modules/mod_version.so
LoadModule unixd_module modules/mod_unixd.so
LoadModule status_module modules/mod_status.so
LoadModule autoindex_module modules/mod_autoindex.so
LoadModule ssl_module modules/mod_ssl.so

<IfModule !mpm_prefork_module>
	#LoadModule cgid_module modules/mod_cgid.so
</IfModule>
<IfModule mpm_prefork_module>
	#LoadModule cgi_module modules/mod_cgi.so
</IfModule>
LoadModule dir_module modules/mod_dir.so
LoadModule alias_module modules/mod_alias.so

<IfModule unixd_module>
User www-data
Group www-data
</IfModule>

ServerAdmin you@example.com
ServerName localhost
SSLEngine on
SSLCertificateFile "/usr/local/apache2/localhost.crt"
SSLCertificateKeyFile "/usr/local/apache2/localhost.key"

<Directory />
    AllowOverride none
    Require all denied
</Directory>

DocumentRoot "/usr/local/apache2/htdocs"
<Directory "/usr/local/apache2/htdocs">
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>

<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>

<Files ".ht*">
    Require all denied
</Files>

ErrorLog /proc/self/fd/2

LogLevel warn

<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    <IfModule logio_module>
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>
    CustomLog /proc/self/fd/1 common
</IfModule>

<IfModule alias_module>
    ScriptAlias /cgi-bin/ "/usr/local/apache2/cgi-bin/"
</IfModule>

<IfModule cgid_module>
</IfModule>

<Directory "/usr/local/apache2/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>

<IfModule headers_module>
    RequestHeader unset Proxy early
</IfModule>

<IfModule mime_module>
    TypesConfig conf/mime.types
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
</IfModule>

<IfModule proxy_html_module>
Include conf/extra/proxy-html.conf
</IfModule>

<IfModule ssl_module>
SSLRandomSeed startup builtin
SSLRandomSeed connect builtin
</IfModule>
EOF
```

7. Establecer la configuración de autenticación básica:

```
cat <<EOF > .htaccess
AuthType Basic
AuthName "Restricted Content"
AuthUserFile /usr/local/apache2/.creds
Require valid-user
EOF
```

8. Definir el fichero para la creación de la imagen del contenedor:

```
cat <<EOF > Containerfile
FROM docker.io/httpd:latest
COPY index.html /usr/local/apache2/htdocs/
COPY .htaccess /usr/local/apache2/htdocs/
COPY httpd.conf /usr/local/apache2/conf/
COPY .creds /usr/local/apache2/
COPY localhost.key /usr/local/apache2/
COPY localhost.crt /usr/local/apache2/
EOF
```

9. Generar la imagen del contenedor

```
sudo podman build -t webserver .
```

10. Etiquetar la imagen del contenedor

```
sudo podman tag localhost/webserver:latest <REGISTRY_URL>/<REPOSITORY>:TAG
```

11. Subir la imagen del contenedor al registry

11.1 Autenticarse en el ***Registry***

```
sudo podman login -u <USERNAME> -p <PASSWORD>
```

11.2 Subir la imagen del contenedor al ***Registry***

```
sudo podman push <REGISTRY_URL>/<REPOSITORY>:TAG
``` 

12. Crear el contenedor del servicio Web a partir de la imagen creada en el paso anterior:

```
sudo podman create --name web -p 8080:443 localhost/webserver
```

13. Generar los ficheros para gestionar el contenedor a través de **systemd**

```
sudo podman generate systemd --new --files --name web
```

14. Copiar los ficheros generados en el paso previo al directorio de **systemd**

```
sudo cp -Z container-web.service /etc/systemd/system/
```

15. Recargar la configuración de systemd

```
sudo systemctl daemon-reload
```

16. Iniciar la aplicación Web desde **systemd**

```
sudo systemctl enable container-web.service --now
```

17. Verificar la conectividad al servidor Web

```
curl -k https://<USERNAME>:<PASSWORD>@localhost:8080
```
