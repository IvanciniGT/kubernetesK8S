





Pod WEB
    Nginx                       ---------------
        ConfigMap - configuracion               >  PVC            >     PV: Volumen
    Init container              ---------------     ^
        Script inicializacion (git clone)           |
                                                    |
                                                    |
Job Actualización                                   |
    Contenedor                                      |
        Script actualización de la web  ------------       < Configmap
            (git pull)
            
            
Deployment
StatefulSet
DaemonSet
   VVV
PodTemplate ---> Kubernetes ---> Pod

JobTemplate ---> Kubernetes ---> Job
   ^^^
CronJob



10 clusters
3 clusters
Yo con el mio
9 maquinas -cluster
    -> 2 maquinas - cluster
    -> 7 maquinas reparatir entre esos 2 cluster
    
Cluster 1- 5 maquinas
Cluster 2- 4 maquinas

2 nodos los vamos a etiquetas como tipo: servidores-web
Despliegue de nginx (ejemplo 12)
Despliegue 2 replicas: Se tiene que situar en nodos de tipo servidor-web, pero cada replica en un nodo


Bernet ---         tipo:servidor-web
Cristian ----      tipo:servidor-web
David ***
Emilio ----   VOLUNTARIO - MASTER         <<<<<
--------------------------
Eugeniu ----       tipo:servidor-web
Isaac  -----       tipo:servidor-web
Oscar ***
Sergio ----        tipo:servidor-web
Xavi   ----    VOLUNTARIO - MASTER        <<<<<

sudo kubeadm reset


kubectl ---> api-server - En el plano de control de kubernetes
Con cual? Donde está? 
    En los maestros. Emilio, Xavi

Contra qué apiserver estais conectando al ejecutar kubectl?
    Con el que se indica en el fichero ~/.kube/config

Cada nodo :
    kubelet -> docker