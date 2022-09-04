# Formato del Repositorio Git

El repositorio debe tener el siguiente formato:

```
├── ansible
│   ├── deploy.sh
│   ├── hosts
│   ├── playbook.yml
└── terraform
    ├── vars.tf
    ├── main.tf
    └── recursos.tf
```


El directorio **ansible** debe contener:

* deploy.sh - Script de bash que ejecuta el playbook de Ansible.

* hosts - Fichero de inventario

* playbook.yml - Uno o más ficheros de playbook.

El directorio **terraform** debe incluir:

* vars.tf - Fichero que incluye al menos las siguientes variables:

```
variable "location" {
  type = string
  description = "Región de Azure donde crearemos la infraestructura"
  default = "<YOUR REGION>" 
}

variable "public_key_path" {
  type = string
  description = "Ruta para la clave pública de acceso a las instancias"
  default = "~/.ssh/id_rsa.pub" # o la ruta correspondiente
}

variable "ssh_user" {
  type = string
  description = "Usuario para hacer ssh"
  default = "<SSH USER>"
}
```

* main.tf - Fichero que indica el proveedor y versiones a utilizar.

* recursos.tf - Uno o más ficheros definiendo los objectos a crear por Terraform.
