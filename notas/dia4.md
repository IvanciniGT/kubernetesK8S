Volumes
    No persistentes
        ConfigMap   |
        Secrets     |  Inyectar ficheros de configuración
        EmptyDir       Compartir datos (ficheros, carpetas) entre contenedores del mismo pod
        HostPath       Acceder a datos del host. En entornos de pruebas para dar persistencia a nivel de 1 solo nodo
    Persistentes
        PersistentVolumeClaim
            Detalles del volumen que necesitamos para nuestro pod:
                - Tipo de volumen
                - Tamaño
        PersistentVolume
            nfs
            iscsi
            aws
            azure
            gcp
            ceph
            cinder

Gestión de recursos de HW en los pods
    
    Propietario de la app... Eq desarrollo
        Demanda de recursos
    Administración del cluster
        Limitación de recursos


Control de:
    RAM
    CPU

Pod < - Container
    Limitación de recursos (esta es poco habitual) CUIDADO!
    Solicitud de recursos *****
---
Deployment
spec:
    PodTemplate
        spec:
            containers:
                - UN CONTENEDOR concreto:
                    resources:
                        requests:
                            memory:     1000Mi
                            cpu:        1500m
                            #cpu:        1.5
                        limits:
                            memory:     1000Mi   # Me lo planteo
                                                 # La memoria la suelo limitar a nivel de app
                                                    Weblogic, Webphere, Tomcat  <<< Como mucho 3 Gbs
---
Request:
    memory: 1000Mi   ->    Mínimo garantizado de memoria para mi contenedor 
    
    Para quien es importante el dato de request?  Scheduler


Cluster:            Memoria Total        Memoria Comprometida       Memoria en uso
    Nodo 1              10
        PodA                                        4                   5     ***** CRUJO
        PodC                                        2                   2
        PodD                                        4                   3
    Nodo 2               8
        PodB                                        5


PodA-> 4 Gbs
PodB-> 5 Gbs
PodC-> 2 Gbs

PodA.... 3 Gbs.... 4Gbs.... 5Gbs?   Podría? SI

PodD-> 4 Gbs

PodD.... 3 Gbs

PodC ....2 Gbs.... 1 Gbs? Puedo? No... no queda RAM y además tu me habias pedido 2 Gbs garantizados... ya te los di
PodD ....3 Gbs.... 4 Gbs? Puedo? Si... no queda RAM... que hago? yo cluster de kubernetes? 
    Me crujo el PodA
        Le da al podD su espacio de RAM garantizado
        Y reinicia el podA


Cluster             CPU Disponible                  CPU Comprometida              CPU uso
    Nodo 1              4
        PodA                                                2                       4 (cierro el grifo)
        PodC                                                2                       2
    Nodo 2              4
        PodB                                                3

PodA    ---> 2000m
    Como interpretamos esto?
        Kubernetes al menos necesito que me dejes usar el equivalente a tener 2 CPUs al 100% cada segundo
                4 cpus durante medio segundo
                1 cpu al 100% par mi durante 1 segundo
                    Y 2 cpus al 50%
PodB   ---> 3
PodA.....  demandar mucha CPU ... quiere usar las 4 cpus que tiene el nodo 1 al 100%

PodC    ---> 2
---------------
LimitRange
    Permite dentro de un determinado NS limitar recursos a nivel de POD y Contenedor (en generico)
    
    Los Pods del NS X no pueden solicitar más de 4 Gbs de RAM
    Los Contenedores del NS X no pueden solicitar más de 2 Gbs de RAM

ResourceQuota   *** MAS HABITUAL
    También trabaja a nievl de Namespace
        Limitaciones globales:
            Memoria TOTAL
            CPU TOTAL 8 
            Numero de Pods
            Numero de servicios
            Numero de petiviones de volumen

App simulacion de hipotecas:          10 Gbs RAM y 8 CPUs
    Servidor de apps BACK END           8Gbs    o     2 de 4 Gbs 
    Servidor web FRONTEND
    BBDD
    ...

Autoescalador de aplicaciones
    Deployment... scale
        kubectl scale deployment NOMBRE-DEPLOYMENT --replicas=NUMERO

HorizontalPodAutoscaler

Entre 1 y 10 replicas en base al 50% CPU

    Media    50%
Replica 1    60%
Replica 2    50%
Replica 3    40%
Replica 4

-----------------------------------------------------------------------
Afinidades

Nosotros estamos cargando PODs dentro del cluster
    Manual
    Deployment
        Scale
        Autoscale
Donde van esos PODs... lo decide el Scheduler

El scheduler trabaja en base a :
- Recursos disponibles en los nodos
- Indicaciones / Pistas / Reglas acerca de los nodos en los que montar un pod

Esas indicaciones las configuramos a nivel de POD/POD Template (deployment, statefulset, daemonset)




Servicio de tipo LoadBalancer Weblogic: 30000

Nodo 1:30000 -> WL          |
    Weblogic                        MetalLB (Corre dentro de Kubernetes)
Nodo 2:30000 -> WL          |   BC EXTERNO IP   < Clientes
Nodo 3:30000 -> WL          |       Nodo 1:30000
Maestro                             Nodo 2:30000
      
                        Afinidad            Antiafinidad
                        REGLA 1             REGLA 2
Nodo 1                      x                  x
    Pod: app:nginx
Nodo 2                      √                  √
    Pod: app:mysql
Nodo 3                      √                  x
    Pod: app:nginx
    Pod: app:mysql
Nodo 4                      x                  √
    

----------------------------------------------------------

ZONA: EU
                        Afinidad            Antiafinidad
                        REGLA 1             REGLA 2
    Nodo 1                      √               x
        Pod: app:nginx
    Nodo 2                      √               x
        ** Pod: app:mysql   
    Nodo 3                      √               x
        Pod: app:nginx
        ** Pod: app:mysql
    Nodo 4                      √               x
    

----------------------------------------------------------
nodeSelector: EU ASIA
PodAntifiantity Nginx
Instalar el pod Nginx

EU   - 5 nodos
    NGINX SOLO 1
ASIA - 5 nodos
    NGINX SOLO 1
USA
AFRICA
AMERICA
topologia ZONA
------------------
PodAntifiantity Weblogic
Instalar el pod Weblogic
6 replicas -> 6 maquinas diferentes
topologia: MAQUINA: kubernetes.io/hostname
----------------------------------------------------
Memchached
Antiafinidad Memchached

Weblogic
Afinidad con Memchached
Antiafinidad Weblogic
3 replicas

3 maquinas cada una con Memchached y weblogic
topologia : MAQUINA: kubernetes.io/hostname
-----------------------------------------------------


Kustomize
Helm <<<<<<<<

Chart de HELM
Eq. Desarrollo ---> 
                    Plantilla de archivos YAML
                    + Fichero de configuración
                    
                    
                    
                    
------------------------------------------------------
Que ponemos en los contenedores de los Pods que montamos en Kubernetes?
Que tipo de software ejecuto?
    Los procesos que siempre se queden arriba ejecutándose:
        Servicios (que operan a través de un puerto)
        Demonios ( que hacen su trabajo y no reciben comunicaciones a través de ningún puerto)


Script: TAREA QUE DURARÁ LO QUE DURE 
    Backup
    
    Podemos ejecutar esto dentro de un contenedor de un POD? Si... pero  que piensa kubernetes al respecto?
            Que el contenedor ha muerto 
        Y que hace?
            Reiniciar que? Todos los contenedores del pod  Vaya follon... cuantos backups vampos a tener... Cuantas veces borro las carpetas...
                Consigo que el Oracle se me quede arriba... No se reinicia de continuo

2 utilidades para ejecutar Scripts en Kubernetes:
    Pod
        - No en contenedores: Marca: "containers"
        - Marca: "initContainers"
            Los initContainers son contenedores que DEBEN ejecutar un SCRIPT que ACABE
        Kubernetes al crear un POD primero ejecuta SECUENCIALMENTE todos los INITCONTAINERS definidos. Despues arranca en pararelo los Contenedores
    Job
        Un conjunto de contenedores que se ejecutan de forma secuencial hasta que acaban... momento en el que se considera que el Job Acabó
        Creeis que vamos a crear muchos Jobs en Kubernetes... En ficheros YAML? NO
                                Tantos como PODS.... Cuantos PODS creamos nosotros en ficheros YAML? NINGUNO   >>> TEMPLATES
                                                                                                                        Deployments
                                                                                                                        Statefulset
                                                                                                                        DaemonSets
        Lo que crearemos en la realidad CRONJOB < JOBTEMPLATE

Pod 
    Volumen compartido emptyDir
    initContainer:
        appweb < - repositorio de artefactos (nexus artifactory < git)
        rellenar el volumen
    nginx
        leer el volumen que dentro tiene la app ya recien descargada



Contenedor - Ubuntu

apt-get update && apt-get install git -y
git clone https://github.com/IvanciniGT/webEjemploAnsible /misitioWeb