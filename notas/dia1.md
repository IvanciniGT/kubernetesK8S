# Kubernetes

Orquestador de Contenedores.
Qué me permite?
    Conseguir una copia del programa (descargarla)
    Instalar la copia del programa
    Arrancar el programa
    Escalar una aplicación
    Cargas de trabajo / Monitorización
    Controlar HA
    Aplicar unas reglas de seguridad en red 
    ...
En base a qué?
    Unas instrucciones que le voy a dar ---> En fichero YAML


# Contenedor

Entorno aislado donde ejecutar procesoS dentro de un SO LINUX.
Esos procesos se ejecutan sobre el Kernel del único SO que hay instalado.
Me ofrece una nueva forma de distribuir, instalar y operar software (automatización)

Aislados, en cuanto a qué?
    Propio Sistema de archivos ---- chroot ---  Root: Raiz del filesystem   /
    Propia Configuracion de red. Proceso tenga su propia conf red: IP 
    Limitación de acceso a recursos HW (RAM, CPU, ...)
    Entorno de ejecución (Variables de entorno)
    
Para qué?
    - No ensuciar el sistema cuando deshago una instalación
    - Seguridad
    - Control de recursos
    
Qué hay de nuevo con los contenedores?
    - Más Ligeros que las VM
    - Estandarización (DOCKER): Se distribuyen fácilmente
    
Qué distribuimos en el mundo de los contenedores?
    - Imagen de contenedor (estandarizadas)
        - Un archivo comprimido que dentro tiene carpetas y archivos
        - Una configuración por defecto
        - Una información de cómo usar esa imagen de contenedor
        
Por qué está tan de moda este mundo?
Por qué TODOS los entornos de producción de 
    todas las empresas se están llevando a Kubernetes?
        CAPACIDAD PARA AUTOMATIZARSE (el trabajo con los contenedores)
            Por qué puedo automatizar fácilmente con contenedores?
                Porque están estandarizados
    
    Facilidad para automatizar
        Recrear contenedores donde quiera mediante código (programa)
        Mundo cloud
        Costes Pagar una licencia de un SO... licencia de uun hipervisor
            Que necesito MUCHAS menos personas para hacer el trabajo


# FileSystem linux ---> Unix
/
    bin/
    opt/
        apache/
            bin/
            etc/
            logs/
    var/
    tmp/
    home/
    etc/
    
# Instalaciones de software


App1   |   App2
---------------
C1     |   C2
---------------
  Ejecutor de contenedores   (docker  containerd   podman    crio)
---------------
  ** SO   Linux
---------------
    HIERRO
    
    
DEV--->OPS = Cultura a nivel empresarial que nos dice: Vamos a automatizar TODO

Como automatizabamos instalaciones hace 30-20 años 
    Scripts sh, bash
    Qué problema tiene esto? 
        Artesanía pura y dura
        
Linux -> Kernel de SO
    GNU / Linux -> Redhat, centos, fedora, ubuntu, debian, opensuse
    Android
    
Cloud?
    Conjunto de servicios que una empresa suministra a través de internet  (mundo IT)
    Que ventajas me da un cloud?
        IaaS - Infraestructura: Almacenamiento, máquinas
        Automatizado. No hay intervención humana

--------
Teoria Kubernetes / Contenedores
Instalación de kubernetes: minikube
Despliegues de apps
Montar un cluster más grande
Más conceptos teoricos
Helm

# Cluster IT (grupo)

Varias maquinas o procesos ejecutandose simultaneamente o no ofreciendo un servicio comun y conjuntamente.
Que me ofrece un cluster?
    - Alta disponibilidad   |
    - Escalabilidad         | Entorno de producción
    
Alta disponibilidad:    €€€€€€€
    Tratar de asegurar que el servicio esté en funcionamiento una determinada cantidad de tiempo.
    Lo quiero funcionando el 99,9% - 99,99% del tiempo
        99%   3.5 dias caido al año? Admisible? Una peluqueria de barrio. WEB reservas              €
        99,9% Al año el sistema permito que esté caido 8 horas            Simulacion de hipotecas   €€
        99,99%                                                            Core bancario             €€€
    Que hago?
        Duplicar entornos: Más máquinas. Si una se cae, que haya otra, a ser posible en otra red,
                Con otro suministrador de internet
                Con otro proveedor de energia electrica
                En otra ubicación
Escalabilidad:
    Capacidad de que mis recursos se ajusten a las necesidades puntuales de demanada de mi app.
        Rendimiento... App tiene que responder en 1.5 seg como mucho
    La demanda es cambiante... cómo cambia?
        AppX
            dia n       100 usuarios
            dia n+1  200000 usuarios black friday
            dia n+2    1000 usuarios
            dia n+3 1000000 usuarios ciber monday

Cluster activo/pasivo
    Una parte no esta en funcionamiento, pero entrará a funcionar cuando? Cuando la otra parte no funcione o lo precise
    Alta Disponibilidad, Escalabilidad
Cluster activo/activo
    Todos los nodos / procesos arriba, funcionando, ofreciendo conjuntamente el servicio
    Alta Disponibilidad, Escalabilidad

Cluster de Kubernetes:
    - Varios nodos/máquinas conectados entre si mediante una red, infraestructura
    Cluster de una app:
        - Varios procesos de una app ejecutandose simultaneamente para ofrecer un servicio. Donde (infra)

En kubernetes trabajamos con cluster activo/activo y activo/pasivo

Cuando montamos un cluster a nivel de software / Procesos /servicio ... que necesito por delante?
    Un balanceador de carga

Servicio IT Software?    
    Un programa que se ejecuta en segundo plano y está atendiendo peticiones... de quién?
        De los clientes... de que naturaleza? NO... programas
    Ese servicio se comunica con otros programas.... Cómo:
        A través de un puerto de comunicaciones (RED)
        
    Weblogic              Puerto: 7001
    ElasticSearch         Puerto: 9200, 9300
    Nginx, httpd (Apache) Puerto: 80, 443
    
ESCENARIO 1    
                                        Balanceador de carga:80           Base de datos (MYSQL): 3306
                                        |                                 |
                                        Ordenador3  (192.168.1.110)       Ordenador4 (192.168.1.130)
        Red de mi empresa               |    |                                 |
    -------------------------------------   -------------------------------------Red interna de servicio   
        | Lucia PC (192.168.1.57)           |                                 |
                                           Ordenador1 (192.168.1.100)        Ordenador2 (192.168.1.101)
                                            |                                 |
                                           Weblogic IP:7001                  Weblogic IP:7001
                                           - App simulacion de hipotecas     -App simulacion de hipotecas
    


Lucia ----->   192.168.1.110:80 (BC)   ----->    192.168.1.100:7001
                                       ----->    192.168.1.101:7001

Servidor de DNS interno autogestionado por kubernetes: basedatosprod1 - 192.168.1.200
                                
                                                        192.168.1.200
Weblogic1 --->   nombre de maquina DNS: basedatosprod1   (BC)    ---->  BBDD (192.168.1.131:3306)
Weblogic2 --->   
    Que problema tendría con esta configuración?
        Si el dia de mañana ese MYSQL se me cae... lo levantaré en otro sitio (Kubernetes)
            Ese nuevo MYSQL tendrá seguro, me apuesto el salario de un mes... otra IP: 192.168.1.131

Cuantos servicios tengo corriendo en mi red interna? 2    ... pero accesibles por quién
    Weblogic - App simulacion de hipotecas                    Lucia            .... Este servicio lo quiero exponer
        Cómo lo expongo? A travé del balanceador de carga / Proxy reverso (httpd, nginx, ha proxy)
    BBDD                                                      solo los weblogic.... Este servicio NO lo quiero exponer

Servicio: A nivel de software: Proceso que corre en un computador y se comunican a través de un puerto
          A nivel de funcionalidad que ofrecemos:
            - MySQL
            - Weblogic / app hipotecas
-------------------------------
ESCENARIO 2
    
    RED INTERNA
    |
    |- Weblogic 1:7001 (IP1)           <<<<<   SERVICIO  >>>> Proceso que tengo corriendo en una computadora
    |       ficheros de log: accesos... operaciones del weblogic
    |    Filebeat, fluentD, Logstash   <<<<<   DEMONIOS  >>>> Proceso que tengo corriendo en una computadora
    |       (Lo necesito en el mismo sitio que el weblogic)
    |
    |
    |- Weblogic 2:7001 (IP2)           <<<<<   SERVICIO  >>>> Proceso que tengo corriendo en una computadora
                ---- Contenedor
    |       ficheros de log: accesos... operaciones del weblogic
    |    Filebeat, fluentD, Logstash   <<<<<   DEMONIOS  >>>> Proceso que tengo corriendo en una computadora
    |       (Lo necesito en el mismo sitio que el weblogic)
    |
    |
    |- BBDD MySQL:3306 (IP3) ---- Contenedor          <<<<<   SERVICIO  >>>> Proceso que tengo corriendo en una computadora
    |
    |
    |- ElasticSearch:9200    ----   Contenedor                          < Kibana (GUI)
    |   Repo de lo logs (en tiempo real)
    |
    
Contenedor:
    Entorno aislado dentro de un SO Linux donde ejecutar procesos









---------------------------------------

Imaginaos que quiero instalar en mi ordenador un NGINX, MYSQL, ES
Cómo podría hacerlo... estrategias:  UBUNTU
    - Instalarlo a hierro sobre la máquina: apt       apt-get          * Problemas? NO ME GUSTA !!!!
    - En una maquina virtual?                                          * Problemas? FOLLON !!!!
    - En un contenedor < Imagen de contenedor 
    
     
    Instalador de office ** Descargo
        ---> Instalación de office       c:\archivos de programa\office
    
    Imagen de contenedor : Un archivo que contiene una instalación de un programa ya realizada por alguien
    
        Tenemos en internet ... y las empresas de forma privada: REPOSITORIOS DE IMAGENES DE CONTENEDOR
        docker hub













-------------------------------
Software:
    Aplicación
    Scripts
    Servicio
    Demonio
    Driver
    SO


----------------------------------------------------------------------------
Objetos Kubernetes
----------------------------------------------------------------------------
Lo que quiero tener en el cluster. De serie tenemos unos 40 tipos de objetos
Esa cifra puede aumentar: OPERADORES

Openshift? Distribución de kubernetes. Es un producto REDHAT.

Quién está detrás de Kubernetes? GOOGLE
----------------------------------------------------------------------------

NODE: Un nodo/maquina donde poder ejecutar PODS
NAMESPACE: Espacio de nombres.
           División LOGICA del cluster de kubernetes
           Al crear ciertos tipos de objetos... lo haremos dentro de un NAMESPACE.
           Esto nos permitirá separar contenidos/programas/reglas/politicas dentro del cluster.
            Namespace: produccion 
            Namespace: desarrollo
            ---
            Namespace: App1
            Namespace: App2
            ---
            Namespace: Cliente1 
            Namespace: Cliente2
            Siempre que trabajemos con la mayor parte de objetos de kubernetes lo haremos en un NS
            Por defecto en Kubernetes existe un NS llamado DEFAULT ! Este no lo usamos.
POD: Conjunto de contenedores que comparten una serie de características:
            - Comparten configuración de red
            - Pueden compartir carpetas / volumenes
            - Se instalan en la misma máquina física
            - Escalan de la misma forma
    
    Nuestro cluster de Kubernetes lo que va a tener es un monton de PODs, 
        distribuidos entre nuestras máquinas físicas
    
    Quien va a crear esos PODs? YO? NO... podría ... pero no... Las creará KUBERNETES
    Por qué? 
        Un pod, basicamente es una inslación de un programa corriendo en un maquina en su propio entorno independiente.

POD_TEMPLATE: Plantilla desde la cual Kubernetes va a crear PODs  

Despliegues de nuestras app:
    * DEPLOYMENT      Plantilla de POD + Numero de replicas deseadas
    * STATEFULSET     Plantilla de POD + Numero de replicas deseadas + ...
    DAEMONSET       Plantilla de POD. Kubernetes creará un pod basado en esa plantilla en cada nodo del cluster

SERVICE: Un balanceo de carga, junto con un nombre resoluble a través de DNS
                Un balanceo a muy bajo nivel en la capa de RED
                    No tenemos disponible gestión de colas    ------    ISTIO LINKERD

CONFIGMAPs
SECRETS
PV
PVC
ServiceAccount
Role
RoleBinding




--------------
Docker engine
    cliente  ---- docker  
                    V
    servidor ---- dockerd
                    --- Crear imagenes de contenedor
                    --- Crear y gestionar contenedores    *containerd
                    --- Gestionar imagenes de contenedor  *containerd
                    --- Ejecutar contenedores             *containerd     *runc
                    
Contenedores tienen su propia IP / Configuración de red, independiente de la del host
Interfaz de red?                     / Lógico . Acceso a una red
NIC: Network interface card: TARJETA / HW

Interfaces de red en vuetro portatil?
    - ethernet   -> RED FISICA   192.168.1.100
    - wifi       -> RED FISICA   172.10.0.1009
    - loopback  (localhost)  -> RED LOGICA dentro del host:
            Permitir comunicaciones entre procesos que se ejecutan dentro del host
            127.0.0.0/8         127.0.0.1=localhost
    - docker      RED LOGICA que solo existe dentro del host (eq. loopback)
            172.17.0.1 OTRA IP que tenemos en el host
Al crear un contenedor, el contenedor es pinchado a la red de docker
    Y en esa red se le asigna IP
    NGINX: 172.17.0.2
    
Weblogic        Contenedor   |
    Filebeat    Contenedor   |   POD
    
    Que hacemos con filebeat?
        - Meterlo en el mismo contenedor de weblogic
            Inconvenientes?
                2 procesos que querria monitorizar
                    weblogic   1
                    filebeat  23. Si este se cae... el gestor de contenedores que use (docker.... kubernetes)
                                  A priori no se enteraría de que se cayó... y por tanto no trataría de levantarlo.
                                    AUTOMATIZAR ese trabajo
                    Contenedores... que monitorizo? el proceso 1 que corre ene cada contenedor
                Que pasa si quiero actualizar uno de los 2 programas, pero no el otro.
                    FOLLON
        - Meterlo en su propio contendor
            Los contenedores tenian su propio entorno aislado de ejecucion de procesos....
    

Contenedor mysql 5.3.1
    Lo hago desde una imagen 5.3.1 de mysql
Que pasa si quiero actualizar mysql a la versión 5.3.2... que hago?
    Muy facil. Borro el contenedor que tiene instalada la imagen 5.3.1 y creo otro contenedor desde la imagen 5.3.2
    
    
    C-5.3.1      C-5.3.2
                  V
    Datos de la BBDD (Los guarde en un espacio de almacenamiento externo al contenedor (cabina de almacenamiento, NFS, iSCSI)
    
    Es habitual guardad la informacion en un entorno de produccion fuera del servidor? ES LO HABITUAL
    Sistemas de almacenamiento de alta disponibilidad (replicas, backup) alto rendimiento
    
    Imagen del contenedor:
        MySQL.... me dicen en la imagen: Los datos se guardan en la carpeta /var/datos
            Que podría hacer yo....
                Podría montar una carpeta en red en /mnt/carpetaEnServidorRemoto
                    mount
                Podría ahora crear un Enlace simbolico:
                /var/datos    ---->     /mnt/carpetaEnServidorRemoto
        Volumenes
    
    
    
    
    
    
POD:                Problema?   Escalabilidad       H/A y Escalabilidad
    Weblogic                        3                   SI... cluster activo/activo
        Filebeat
    MySQL                           1                   SI... cluster activo/pasivo
    
    POD MYSQL 1   PUF
    POD MYSQL 2 ON !     5 segundos
    
    
    MySQL ON
    
    MySQL OFF.... Esto me interesa? Inconvenientes? Pasta que pago por un recurso que no estoy utilizando
                    Por qué lo creo de antemano?    Tiempo de disponibilidad 
                    
                    
    Si yo creo un pod.... si se cae.... me jodo... me quedo sin pod
    Si yo creo una plantilla de pod y digo a kubernetes qui siempre quiero tener 1 pod funcionando CLUSTER ACTIVO/PASIVO
    
-----------------------------------------------------------------------------------------------------------------------

| Red de mi empresa
|- Maquina 0 Kubernetes
||
||- Servidor de DNS:
||       mi-mysql <> 20.0.0.1
||       mi-weblogic <> 20.0.0.2
|- Maquina 1                                                                                        192.168.2.101
||   SO: Linux  - Kubernetes - Docker
||     || Kernel Linux - netFilter. Se encarga de la gestión de TODOS los paquetes de red
||     ||       20.0.0.1   -> 10.0.0.10
||     ||       20.0.0.2   -> 10.0.0.2,10.0.0.3
||     ||       192.168.2.101:30000 -> mi-weblogic > 7001
||     ||--Pod Mysql1 :                                                                     10.0.0.10
||     ||  --Contenedor MYSQL:           3306          
|- Maquina 2                                                                                        192.168.2.102 
||   SO: Linux  - Kubernetes - Docker
||     ||       20.0.0.1   -> 10.0.0.10
||     ||       20.0.0.2   -> 10.0.0.2,10.0.0.3
||     ||       192.168.2.102:30000 -> mi-weblogic > 7001
||     ||--Pod WEBLOGIC                                                                     10.0.0.2        
||     ||  --Contenedor de Weblogic:     7001 
||              ----> mi-mysql -> 20.0.0.1
|- Maquina 3                                                                                        192.168.2.103
|   SO: Linux  - Kubernetes - Docker
|      ||       20.0.0.1   -> 10.0.0.10
|      ||       20.0.0.2   -> 10.0.0.2,10.0.0.3
|      ||       192.168.2.103:30000 -> mi-weblogic > 7001
|      ||--Pod WEBLOGIC                                                                     10.0.0.3        
|      ||  --Contenedor de Weblogic:     7001 
|               ----> mi-mysql -> 20.0.0.1
|
|- Balanceador de carga ................ Estar configurandolo // Operandolo
|           192.168.2.250:80
|                192.168.2.101:30000
|                192.168.2.102:30000
|                192.168.2.103:30000
|       Si este balanceador es COMPATIBLE con Kubernetes, Kubernetes se puede encargar de su operacion/configuracion
|       On premisses montamos uno que se llama METALLB
|
|- Lucia 192.168.2.10
    192.168.2.250:80
                


0 - Al instalar Kubernetes: hemos de montar un vlan
1 - Quiero un MYSQL
    Definir una plantilla (YAML) de POD y pedir a kubernetes que quiero 1 pod basado en esa plantilla 
        Dar de alta en kubernets esa plantilla
        Qué hace kubernetes?
            - Buscar una maquina on los recursos suficientes para instalar aquello: Maquina 1  -  Scheduler
            - El kubernetes de esa maquina le pedirá al docker de esa maquina que descargue la imagen de mysql
            - El kubernetes de esa maquina le pedirá al docker de esa maquina que cree un(os) contenedor(es)
            - El kubernetes de esa maquina crea el pod
                - A partir de este momento kubernetes monitoriza el proceso 1 del contenedor
                    - Si se cae lo intenta reiniciar
                    - Si se cae el nodo, intentará llevarlo a otro nodo
2 - Quiero dos WEBLOGIC
        Lo mismo que el paso 1
3 - Quiero que Weblogic ataque a la BBDD
        Que configuración pongo?                  Servicio:   
            mi-mysql                                    Nombre dns             ----- mi-mysql
                                                        IP de balanceo de carga----- 20.0.0.1:3306
4 - Monto el servicio de mi-weblogic > IP de balanceo : 20.0.0.2
5 - Quiero que lucia entre al Weblogic
        ClusterIP: nombre DNS + balanceo de carga
        NodePort:  ClusterIP                      + regla de publicacion de un puerto a nivel de host (>30000)
                        Exponer un servicio hacia el exterior del cluster
        LoadBalancer: NodePort + gestion automatizada de un balanceador de carga externo compatible con Kubernetes.
    
Antiguamente para abrir o cerrar puertos de un ordenador linux usabamos IPTABLES -> que da reglas a NETFILTER