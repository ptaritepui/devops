# Ansible

## Ejemplos de Playbooks

En este subdirectorio se encuentran un conjunto de playbooks de ejemplo:

|Playbook|Descripción|
|:---:|:---:|
|[00_playbook.yaml](./00_playbook.yaml)|<ul><li>Fijar huso horario</li><li>Actualizar sistema operativo.</li></ul>|
|[01_playbook.yaml](./01_playbook.yaml)|Modificar el motd en base a una plantilla.|
|[02_playbook.yaml](./02_playbook.yaml)|Almacenar el contenido de un fichero en una variable.|
|[03_playbook.yaml](./03_playbook.yaml)|Actualización del sistema operativo y reinicio del sistema.|
|[04_playbook.yaml](./04_playbook.yaml)|<ul><li>Rol de actualización del sistema operativo.</li><li>Rol de instalación de servidor Apache</li><li>Rol de instalación de MongoDB</li></ul>|
|[05_playbook.yaml](./05_playbook.yaml)|Despliega una aplicación no persistente en AKS|

## Módulos útiles

### Genéricos

* [ansible.builtin.dnf](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/dnf_module.html) o [ansible.builtin.yum](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/yum_module.html) o [ansible.builtin.apt](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html)
* [ansible.builtin.file](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html)
* [ansible.builtin.copy](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html)
* [ansible.builtin.template](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)
* [ansible.builtin.systemd](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/systemd_module.html)
* [ansible.posix.firewalld](https://docs.ansible.com/ansible/latest/collections/ansible/posix/firewalld_module.html)

### Autenticación y TLS

* [community.general.htpasswd](https://docs.ansible.com/ansible/latest/collections/community/general/htpasswd_module.html)
* [community.crypto.openssl_privatekey](https://docs.ansible.com/ansible/latest/collections/community/crypto/openssl_privatekey_module.html)
* [community.crypto.openssl_csr](https://docs.ansible.com/ansible/latest/collections/community/crypto/openssl_csr_module.html)
* [community.crypto.x509_certificate](https://docs.ansible.com/ansible/latest/collections/community/crypto/x509_certificate_module.html)

### Contenedores e imágenes de Podman

* [containers.podman.podman_login](https://docs.ansible.com/ansible/latest/collections/containers/podman/podman_login_module.html)
* [containers.podman.podman_image](https://docs.ansible.com/ansible/latest/collections/containers/podman/podman_image_module.html)
* [containers.podman.podman_tag](https://docs.ansible.com/ansible/latest/collections/containers/podman/podman_tag_module.html)
* [containers.podman.podman_container](https://docs.ansible.com/ansible/latest/collections/containers/podman/podman_container_module.html)

### Kubernetes

* [kubernetes.core.k8s](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_module.html)
* [kubernetes.core.k8s_info](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_info_module.html)
