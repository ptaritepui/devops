# Procedimiento de instalación de Kubernetes en CentOS Stream 8.

## Recursos necesarios:

| Rol | CPUs | Memoria (GB) | Disco |
|-----|------|--------------|-------|
| NFS |  2   |   4          |  20   |
| Master| 2 | 8 | 20 |
| Worker | 2 | 4 | 20

## Prerrequisitos

- Dos subredes:

  10.0.0.0/24 -> Red de servicio.

  192.168.0.0/16 -> Red interna para Pods.

- Un nombre de dominio por máquina, por ejemplo:

| Rol | Nombre de máquina| Dirección IP|
|-----|------------------|-------------|
| NFS| nfs.example.com| 10.0.0.2/24|
|Master|master.example.com| 10.0.0.3/24|
|Worker|worker.example.com|10.0.0.4/24|

```
$ sudo hostnamectl set-hostname nfs.example.com
```

* Los nombres de máquina deben estar registrados en el DNS. En caso de no disponer de DNS, se deben definir en el fichero **/etc/hosts** de todos los servidores:

```
$ sudo cat <<EOF >> /etc/hosts
10.0.0.2 nfs.example.com nfs
10.0.0.3 master.example.com master
10.0.0.4 worker.example.com worker
```


* Instaladas las últimas actualizaciones disponibles en todos los repositorios correspondientes:

```
$ sudo dnf -y update
```

* El servicio chronyd iniciado con la correspondiente zona horaria:

```
$ timedatectl set-timezone Europe/Madrid
$ sudo dnf -y install chrony
$ sudo systemctl enable chronyd --now
```

* El cortafuegos está habilitado:

```
$ sudo dnf -y install firewalld
$ systemctl enable firewalld --now
```

* SELinux deshabilidado:

```
$ sudo setenforce 0
$ sudo reboot
```

## Procedimiento de instalación

En todos los nodos de Kubernetes: 

1. Habilitar **transparent masquerading** 

```
$ sudo modprobe br_netfilter
$ sudo firewall-cmd --add-masquerade --permanent 
$ sudo firewall-cmd --reload
$ sudo cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
$ sudo sysctl --system 
```
2. Desactivar la partición de swap:
```
$ sudo swapoff -a
$ sed -i '/swap/d' /etc/fstab
```

3. Instalación de CRI-O como runtime en CentOS Stream 8:

```
$ VERSION=1.24
$ OS=CentOS_8_Stream
$ sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/devel:kubic:libcontainers:stable.repo
$ sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo
$ sudo dnf -y install cri-o
```

Si desea instalar **cri-o** en otras distribuciones de Linux por favor consulte el [procedimiento](https://cri-o.io/) correspondiente.

4. Habilitar los módulos de kernel necesarios:

```
$ sudo cat <<EOF > /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF
```

5. Habilitar e iniciar el servicio de cri-o:

```
$ sudo systemctl enable crio --now
```

6. Habilitar el repositorio de Kubernetes:

```
$ sudo cat <<EOF > /etc/yum.repos.d/kubernetes
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
```

7. Instalar kubernetes

```
$ sudo dnf -y install kubelet kubeadm kubectl --disableexcludes=kubernetes

```

8. Habilitar e iniciar el servicio de kubelet:

```
$ sudo systemctl enable kubelet --now
```

**En el nodo Master**

9. Permitir en el cortafuegos el tráfico necesario para el servicio:

|Protocolo|Dirección|Rango de puertos| Propósito|
|---------|---------|----------------|----------|
|TCP| Entrante|6443|Kubernetes API server|
|TCP| Entrante|2379-2380|etcd server client API|
|TCP| Entrante|10250|Kubelet API|
|TCP| Entrante|10251|kube-scheduler|
|TCP| Entrante|10252|kube-controller-manager|
|TCP| Entrante|10255|Statistics|

```
$ for port in 6443 2379-2380 10250-10252 10255;do sudo firewall-cmd --add-port=${port}/tcp --permanent;sudo firewall-cmd --reload;done
```

10. Permitir en el cortafuegos las conexiones desde cada nodo worker:

```
$ sudo firewall-cmd --permanent --add-rich-rule 'rule family=ipv4 source address=<IP_WORKER>/32 port port=6443 protocol=tcp accept'
$ sudo firewall-cmd --reload
```

11. Configurar kubeadm:

```
$ sudo kubeadm config images pull
```

12. Instalar el plugin CNI:


```
$ sudo kubeadm init --pod-network-cidr=<PODS_NETWORK>/PREFIX
[init] Using Kubernetes version: v1.20.2
[preflight] Running pre-flight checks
...
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.110:6443 --token gmk4le.8gsfpknu99k78qut \
    --discovery-token-ca-cert-hash sha256:d2cd35c9ab95f4061aa9d9b993f7e8742b2307516a3632b27ea10b64baf8cd71 
```

**NOTA:** Conserva el último comando para unir a los workers al cluster.

13. Exportar la configuración de kubeadmin

```
$ sudo export KUBECONFIG=/etc/kubernetes/admin.conf
```

14. Autorizar el acceso al cluster

```
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
$ kubectl get nodes
NAME             STATUS     ROLES                  AGE     VERSION
master.example.com   NotReady   control-plane,master   9m49s   v1.20.2
```

**NOTA:** El estado es **NotReady** porque aún no se ha desplegado la red de los Pods.

15. Instalar la SDN en entorno local (Opcional):

**NOTA**: Este paso es opcional y consiste en la instalación de Calico como SDN para un entorno de Kubernetes en local. No aplica para la solución del caso práctico 2 que estará desplegada en Azure.

15.1 Instalar el operador Tigera:

```
$ kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/installations.operator.tigera.io created
customresourcedefinition.apiextensions.k8s.io/tigerastatuses.operator.tigera.io created
namespace/tigera-operator created
podsecuritypolicy.policy/tigera-operator created
serviceaccount/tigera-operator created
clusterrole.rbac.authorization.k8s.io/tigera-operator created
clusterrolebinding.rbac.authorization.k8s.io/tigera-operator created
deployment.apps/tigera-operator created
```

15.2 Descargar la definición de CR:

```
$ wget https://docs.projectcalico.org/manifests/custom-resources.yaml
```

15.3 Modificar el CIDR con el valor correspondiente a la red de PoDs:

```

$ # This section includes base Calico installation configuration.
# For more information, see: https://projectcalico.docs.tigera.io/v3.22/reference/installation/api#operator.tigera.io/v1.Installation
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  # Configures Calico networking.
  calicoNetwork:
    # Note: The ipPools section cannot be modified post-install.
    ipPools:
    - blockSize: 26
      cidr: <PODS_NETWORK>/PREFIX
      encapsulation: VXLANCrossSubnet
      natOutgoing: Enabled
      nodeSelector: all()

---

# This section configures the Calico API server.
# For more information, see: https://projectcalico.docs.tigera.io/v3.22/reference/installation/api#operator.tigera.io/v1.APIServer
apiVersion: operator.tigera.io/v1
kind: APIServer 
metadata: 
  name: default 
spec: {}
```

15.4 Se aplican los cambios:

```
$ kubectl apply -f custom-resources.yaml

```

16. Instalar la SDN en Azure:


16.1 Permitir el tráfico en el cortafuegos del master y workers:

```
$ sudo firewall-cmd --permanent --add-port=8285/udp
$ sudo firewall-cmd --permanent --add-port=8472/udp
$ sudo firewalld-cmd --reload
```

16.2 Aplicamos la definción de las políticas de red en el nodo master:

```
kubectl apply -f https://docs.projectcalico.org/manifests/canal.yaml
```

16.3 Reiniciar el master:

```
$ sudo reboot
```

17. Instalación del Ingress Controller (HAProxy)

```
$ kubectl apply -f https://raw.githubusercontent.com/haproxytech/kubernetes-ingress/master/deploy/haproxy-ingress.yaml
```

**En los nodos worker**


18. Habilitar el tráfico entrante en el cortafuegos:

```
$ sudo firewall-cmd --permanent --add-port=8285/udp
$ sudo firewall-cmd --permanent --add-port=8472/udp
$ sudo firewall-cmd --permanent --add-port=10250/tcp
$ sudo firewall-cmd --permanent --add-port=30000-32767/tcp
$ sudo firewalld-cmd --reload
```

19. Añadir el worker al cluster de Kubernetes:

```
$ kubeadm join 192.168.1.110:6443 --token gmk4le.8gsfpknu99k78qut --discovery-token-ca-cert-hash sha256:d2cd35c9ab95f4061aa9d9b993f7e8742b2307516a3632b27ea10b64baf8cd71
...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```
