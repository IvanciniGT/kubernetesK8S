Deployment: nginx -2 replicas
    POD         ----------------------------
        Instalación de NGINX                |   < -- Servicio NodePort 30080---> Aleatorio
            WEB (github)                    |
        Contenedor de Inicializacion        |
                script(git clone)           |
CronJob                                     V
    Jobs (Cada 2 minutos)  ----------> PVC  Volumen ---------> Volumen PV (hostpath)
        script(git pull)

NAMESPACE: ivan        
    solo en maquinas que tengan tipo=servidor-web
    Solamente 1 pod por maquina
        
Cluster A
    Nodo 1 - Maestro - Emilio
    Nodo 2 - tipo=servidor-web - Volumen - NGINX
    Nodo 3 - tipo=servidor-web           - NGINX

Cluster B
    Nodo 1 - Maestro - Xavi
    Nodo 2 - tipo=servidor-web
    Nodo 3 - tipo=servidor-web
    Nodo 4 - tipo=servidor-web
    
    
Provisionador automatico de volumenes nfs
    storageClass - volumen-nfs-ivan

pvc: storageClass: volumen-nfs-ivan
    YAML ----> kubectl apply -f
    
HELM > charts > Plantilla de despliegue

curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm template bitnami/wordpress


Crear un pvc -< StorageClass

Que hace el provisionador?
1- Mirar los pvcs que se crean en el cluster y si alguno hay de su tipo storageClass Asociado

    >>> kubectl get pvc --watch
    
    Y si lo hay entonces: 
2- Crear una carpeta dentro del servidor nfs
3- Crear un volumen que apunte a esa nueva carpeta

    Escribo un fichero .yaml
    >>> kubectl create -f fichero
    
    
pvc 
    - storage (Tamaño)
    - accessModes
    - storageclassName
    
                    En background dentro de Kubernetes un provisionador:
                        Ups!!! si tenemos una pvc nueva... será para mi?
                         Voy a verlo:
                            - storageClassName... Ah, es ek mismo que el mio
                            - accessModes: Ah, pues también
                        Listo!
                            Voy a crear un PV para atender a ese pvc
                            PV -> Carpeta dentro del servidor nfs
                                                                    ^
Deployment                                                          |
    Pod                                                             |
        Volumen.... el que esté asociado a el pvc que he creado ----
        initContainer --> Rellena 
    
    
El provisionador crea una carpeta dentro del servidor nfs, en una ruta que se genera aleatoriamente
                 Crea un pv dentro de kubernetes

