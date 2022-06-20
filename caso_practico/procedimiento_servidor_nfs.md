# Procedimiento de instalación de un servidor NFS en una distribución Linux basada en RPMs: Fedora, CentOS Stream, Alma Linux, etc

1. Instalar los rpms necesarios:
```
$ sudo dnf -y install nfs-utils
```

2. Crear los directorios que serán compartidos por el servidor:

```
$ sudo mkdir -p /mnt/<DIRECTORY>
```

3. Establecer la configuración del propietario del directorio:

```
$ sudo chown -R nobody: /mnt/<DIRECTORY>
```

4. Modificar los permisos al directorio:

```
$ sudo chmod -R 777 /mnt/<DIRECTORY>
```

5. Añadir al fichero **/etc/exports** todos los directorios que se desean compartir:

```
$ sudo cat <<EOF > /etc/exporsts
<DIRECTORY>  <SUBNET_CIDR>(rw,sync,no_subtree_check)
EOF
```

6. Habilitar e iniciar el servicio NFS:

```
$ sudo systemctl enable nfs-server --now
```

7. Exportar el sistema de ficheros:

```
$ sudo exportfs -arv
```

8. Verificar que el directorio está siendo exportado correctamente:

```
$ sudo exportfs -s
```

9. Habilitar en el cortafuegos el tráfico correspondiente al servicio NFS:

```
$ for service in nfs rpc-bind mountd;do firewall-cmd --add-service=${service} --permanent;firewall-cmd --reload;done
```
