# Kubernetes:

Orquestador de contenedores en un cluster de maquinas

# Contenedor:

Entorno aislado donde ejecutar procesos en un SO Linux

# Objetos Kubernetes: Ficheros YAML

## Node

Un nodo al que pueden ir pods

## Namespace

Una segmentación del cluster.
Me ayuda a agrupar objetos, limitar permisos, recursos.

## Pod

Conjunto de contenedores que comparten:
- Configuración de red: Se hablan "localhost"
- Pueden compartir volumenes/ficheros
- Están en la misma máquina física
- Escalan juntos, de la misma forma

## PodTemplate

Plantillas que usa K8S para crear pods

## Objetos que permiten trabajar con plantillas de pod:

### Deployment

Plantilla + número de réplicas que queriamos de pod basados en esa plantilla
    ReplicaSet < - Programa que trata de asegurar en todo momento que 
                   el número de replicas actual es igual al deseado
### StatefulSet

Plantilla + número de réplicas que queriamos de pod basados en esa plantilla
+ algo más...

### DaemonSet

Plantilla. K8S genera tantos pods como nodos del cluster

## Service

Hacer accesible un puerto o varios a alguien interno/externo.

### ClusterIP: Hacer accesible un puerto o varios internamente en el cluster 

IP interna en el cluster + Nombre DNS + Balanceo de carga

### NodePort: Exponer un servicio fuera del cluster

ClusterIP + Redirección de puertos (30000-32700) a nivel de host (red pública)

Limitación... desventaja... algo incomodo:
    Necesitaba montar yo externamente al cluster el que? Un balanceador de carga
    Que yo tengo que gestionar

### LoadBalancer:  Exponer un servicio fuera del cluster

NodePort + gestión automatizada del balanceador externo (solo si es compatible)
    Fuera de los entornos cloud, tengo uno que se llama MetalLB


Cliente -> BC externo -> Cluster:
                           Nodo 0
                            DNS Interno de kubernetes (autogestionado)
                                weblogic > IPS1
                           Nodo 1 IP-PUBLICA-HOST-1:30007
                            [IPS1:7001 > IP1:7001 o IP2:7001]
                            [IP-PUBLICA-HOST-1:30007 > weblogic:7001]
                           Nodo 2 IP-PUBLICA-HOST-2:30007
                            [IPS1:7001 > IP1:7001 o IP2:7001]
                            [IP-PUBLICA-HOST-2:30007 > weblogic:7001]
                            Weblogic IP1:7001
                           Nodo 3 IP-PUBLICA-HOST-3:30007
                            [IPS1:7001 > IP1:7001 o IP2:7001]
                            [IP-PUBLICA-HOST-3:30007 > weblogic:7001]
                            Weblogic IP2:7001

# Arquitectura de kubernetes

kubeadm - apt
    Tambien lo necesito en todas las maquinas del cluster.
    Operaciones de gestión del cluster: Crear el cluster, añadir nodos
    -> kubelet
            Se ejecuta en todos los nodos del cluster
            Recibe ordenes del "cerebro de kubernetes" y las manda al 
            ejecutor de contenedores que haya instalado en el nodo
    -> kubectl *** Podríamos tenerlo en cualquier ordenador del mundo mundial
                   Cliente con el que conectarnos

Un monton de programas más, que se van a instalar como PODs dentro de kubernetes.
    Namespace: kube-system - Plano de control de kubernetes
        DNS Interno: CoreDNS
        Scheduler:   Determinar en qué nodo se va a montar un POD
        API-Manager: Establece comunicaciones con el cliente
                     Y manda esas instrucciones a el resto de componentes
        Controller-Manager: Se asegura que los pods se están ejecutando (monitorización)
                            Se asegura que los nodos están arriba
        Base de datos interna: clave-valor   etcd 
        kube-proxy:  Genera las reglas de netfilter en cada nodo: DaemonSet 

Instalación de un cluster:
    Desactivar la swap
    Cambio en la conf de docker
    
    Instalar kubeadm, kubelet, kubectl (sobre el hierro)
    kubeadm -> crear un cluster:
        Montar el plano de control de kubernetes... todos esos programas adicionales
    Montar una vlan - driver que la gestiona - POD
        Otro programa dentro de kubernetes (driver) < - cliente de kubernetes: kubectl
        
        
        KUB_Sergio
        Pa$$w0rd
        
kubectl <VERBO> <TIPO-OBJETO> <ARGS> 
        get        pod
        create     daemonset
        delete     deployment
        edit       statefulset
        describe   namespace
                   node
                   
ARGS:
    -n NOMBRE_NAMESPACE
    --all-namespaces
    
    
nginx   PID 1 esta vivo? SI... pero es suficiente? NO
curl puerto 80 < HTTP 200    OK !

mysql
    cuanto funciona aquello?
        si el proceso 1 está vivo, vamos bien? si
        me vale? no
    
    initialized 
    ready
    



Pod nginx -                 mi-servidor-web
    10.244.0.5

Pod nginx -                 produccion
    10.244.0.6
        curl localhost  -> YO
        curl 10.244.0.5 -> EL OTRO?
            Esto es recomendable?
            NO... puede cambiar la IP
            
            
Cluster 
    Nodo 1 - 18.202.229.12
        nginx4
    Nodo 2 - 18.202.229.13
    Nodo 3 - 18.202.229.14
        nginx1
        nginx2
        nginx3
    Nodo 4 - 18.202.229.15
    
IP-BC-EXTERNO:80
    18.202.229.12:30080
    18.202.229.13:30080
    18.202.229.14:30080
    18.202.229.15:30080

http://IP-BC-EXTERNO:30080

Alta disponibilidad?

---
Cluster donde hay 100 servicios

Cuantos voy a poner de cada?                                EN LA REALIDAD
    ClusterIP:          60%     No exponer / Interno        100% menos 1
    NodePort:            0
    LoadBalancer:       40%     Exponer                         1
    
Quien es nuestro servicio público?
    Un proxy reverso, que da entrada al cluster   ---- IngressController
        nginx     *****
        ha-proxy
        httpd
        envoy
        f5
        
        
Apache httpd
    VirtualHost
    
    http://app1.com                 -> Servicio1 interno ----- Ingress: Regla para un proxy reverso
    http://app1.com/registro        -> Servicio2 interno
    http://subapp2.produccion.com   -> Servicio3 interno

-------------------------------
Servicio - NodePort
VVV
Wordpress                   ------ Pod? NO... Deployment
    Apache - php
        configuracion: BBDD?????
    vvvvvv (Servicio ClusterIP)
BBDD
    MySQL                   ------ Pod? NO... Deployment
        configuracion: usuario/Contraseña
        