





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