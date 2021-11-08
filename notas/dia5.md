





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


