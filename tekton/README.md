# tekton
Repositorio que incluye recursos y ejemplos de utilización de Tekton

## Instalación de Tekton

1. Instalar la última release de Tekton:

```
kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
```

2. Esperar hasta que ambos Pods: **tekton-pipelines-controller** y **tekton-pipelines-webhook** se desplieguen correctamente en en *namespace* **tekton-pipelines**:

```
kubectl get pods --namespace tekton-pipelines --watch
```

3. Instalar **tkn** (CLI de Tekton):

```
sudo dnf copr enable chmouel/tektoncd-cli -y
sudo dnf install tektoncd-cli -y
```

4. Instalar tareas esenciales desde Tekton Hub

Se instalarán las siguientes tareas:

* git-clone
* kaniko

```
for name in git-clone kaniko;do tkn hub install task ${name};done
```

## Uso de tkn

* Listar recursos: pipelines,pipelineruns,tasks,taskruns

```
tkn <RECURSO> list
```

* Recopilar logs de una **pipelinerun**:

```
tkn pipelinerun logs <NOMBRE> -f
```
