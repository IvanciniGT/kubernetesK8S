Contenedor con mysql

Los datos se guardan en esta carpeta: /var/lib/mysql

El contenedor tiene su propio sistema de archivos...
Ese sistema de archivos como en cualquier contenedor, tiene persistencia a nivel de host, en su sistema de archivos.
El problema es que se guardan en una ubicación asociada al ID del contenedor.

Cuando borramos el contenedor, esa ubicación se borra, junto con todos sus datos.


Sistema de Archivos / Filesystem de un contenedor: SUPERPOSICION DE CAPAS

VOLUMEN A                                                        /tmp/miarchivo.txt    > Persistencia real en otro sitio
Ubicación para el contenedor                                    
Imagen del contenedor            /bin     /opt     /var/mysql    /tmp    (Existe en otra ubicación del FS del host)
    (Es inalterable)
    
    
BBDD: MySQL, SQL Server, Oracle
Sistemas de mensajería: KAFKA, RABBITMQ
Indexadores: ES, SolR
No te permiten tener dos instancias en ejecución trabajando sobre los mismos ficheros.

Permiten trabajar en Cluster: 3 instancias de MYSQL cada una con su propio espacio de almacenamiento (ficheros/carpetas)
No me sirve tener 3 instancias de mysql ... no tengo concurrencia en las escrituras de datos... 
me arruino la escalabilidad

MYSQL, MariaDB Galera: 3 nodos
    MariaDB 1    A          E  F
    MariaDB 2        C  B
    MariaDB 3    A   C  B  D

No se pueden montar mediante un Deployment
StatefulSet




Que un fichero lo tenga que tocar lo menos posible para instalarlo en un determinado entorno
------------------------     Inf. Despliegue
- Deployments:
    Configuración de la BBDD o de la configuración de WP                                    < Desarrollo
- Servicios: 
    Puertos funcionan, que nombre le pongo                                                  < Desarrollo
------------------------     Configuración para un determinado entorno de trabajo
- Namespace                                                                                 < Adm. Kubern
                                                                                              Adm. sistemas
                                                                                              Operación

- Volumenes                                                                                 < Adm. Kub
- Credenciales                                                                              < Adm. Kub
    - Secrets
    - ConfigMaps
------------------------
    
Imagen ubuntu                       fedora  
    /bin                                /bin
        ls                                  ls
        mkdir                               mkdir
        chmod                               chmod
        cat                                 cat
        
        apt                                 yum
        apt-get


--------------------------------------------------------------------
Para que sirven los Volumenes en Kubernetes?

VOLUMENES QUE USAMOS CUANDO QUEREMOS PERSISTENCIA   ------ Donde están los datos guardados realmente?  FUERA
- Conseguir persistencia de los datos tras la eliminación de un contenedor

VOLUMENES QUE USAMOS CUANDO NO QUEREMOS PERSISTENCIA   --- Donde sea... ya no hay necesidad de que estén fuera
- Compartir información entre Pods o entre Contenedores (del mismo POD)
- Inyectar código <<<<<   Desarrollo... mas o menos... Producción PELIGROSO DONDE LO HAYA
- Inyectar configuraciones en contenedores
- Permitir acceso por parte del contenedor a datos del HOST:
        Monitorización. Contenedor -> pid
        Docker in docker: Que un contenedor pueda crear otro contenedor
            - Dentro del contenedor padre: Docker instalado
            - Tener accedo al fichero /var/run/docker.sock


------------------------
# Compartir información entre Contenedores (del mismo POD)   --- Los datos pueden estar almacenados en el host
POD: 
    C1: weblogic / Apache, Tomcat, nginx >>>>> logs (RAM)
    C2: filebeat , logstash, fluentd, kafka    ^^^    >>>>>>>      ElasticSearch < Kibana
    
    Weblogic, apache:
        N ficheros en rotacion con un tamaño fijo
        2 - log1  50Kbs
          - log2  50Kbs   100 Kbs
------------------------
# Compartir información entre Pods   --- Los datos (VOLUMEN) necesariamente tiene que ser externo a las máquinas

Upload Imagen
Wordpress: Montar sitio web: Páginas, recursos
    3 paginas, con unas secciones y unos textos
    Carpeta dentro de WP que contendrá la imagen para que un usuario la pueda descargar.
DB <<< Se guardan contenidos/metadatos

3 replicas del servidor de WP (APACHE que dentro tiene instalado en WP)


Cliente ---->   BC     ->       WP1 < - ImagenA        |
                                WP2                     >  BD
Cliente2---->                   WP3                    |

N Pods de WP, todos trabajando contra el mismo VOLUMEN DE DATOS < ----   Deployment


----------
Nodo 1    EXPLOTA !                     OTRO SITIO X
    App1   ----------------------------    datos
Nodo 2                                       ^
    App1  ------------------------------------
Nodo 3
--------------------------------------------

Tipo de Volumen con el quiero trabajar:
    
    NO PERSISTENTES
        emptyDir    -> Cuando quiera compartir datos entre contenedores del mismo pod
                        Crea una carpeta en el host (que no tengo ni idea de donde está... ni me interesa)
                        Pero que podré montar en varios contenedores
        configMap   -> Cuando quiera inyectar ficheros de configuración
        secret      -> Cuando quiera inyectar ficheros de configuración  (clave privada / certificado)
        hostPath    -> Cuando quiera que un contenedor pueda acceder a datos del host
                        Para PERSISTENCIA jugando... para pruebas  (1 nodo)
        
    PERSISTENTES
        nfs
        iscsi
        aws
        azure
        gcp
        ...
        
        Si yo, como eq. de desarrollo, necesito un emplazamiento para guardar datos...
            YO ME METO A CONFIGURAR ESO? a decir donde está, o a contratarlo... es mi responsabilidad? NO
        De quien es la responsabilidad? Admin... infraestructura
            PersistentVolumeClaim
        
        Qué hace desarrollo? Pedir disco con un tamaño... con unas características
        Otro creara ese espacio de almacenamiento
            PersistentVolume
            
        
-----------------------------

POD 
    Volumen < Peticion de volumen persistente < Kubernetes > Volumen persistente
    
POD: FEDORA
PVC: peticion-volumen-fedora
PV:  volumen-fedora

POD: Fedora lo quiero borrar...
    
             Peticion de volumen persistente < Kubernetes > Volumen persistente
POD2: Fedora2
    volumen < Peticion de volumen persistente < Kubernetes > Volumen persistente
    
    
1 Gi
    1 Gibibytes =  1024 Mi = 1024 x 1024 Ki = 1024 x 1024 x 1024 b
    
    
    1 Gigabytes =  1000 Mb = 1000 x 1000 Kb = 1000 x 1000 x 1000 b

Servidor nfs (Accesible por todos los nodos)
    /exportada
Nodo 1
    cliente nfs
Nodo 2
    cliente nfs
Nodo 3
    cliente nfs
Nodo 4    
    cliente nfs

ResourceQuota <<<< 