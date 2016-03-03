# docker-certs
Contenedor Docker para crear CA y Certificados SSL a demanda

## Requerimientos
 * Se debe tener instalado [Docker](https://docs.docker.com/installation/) y [Docker-compose](https://docs.docker.com/compose/install/)

## Arranque secuencial de containers

Esta imagen lee un par de variables de entorno que permite encadenar el arranque de los containers
```
    DOCKER_NAME     : Nombre del container, ejemplo "mi_aplicacion"
    DOCKER_WAIT_FOR : Nombre del container al cual esperar por ejemplo "otra_aplicacion"
```

Para que esto funcione los containers involucrados deben compartir un volumen comun publicado en ` /var/local/docker-data/containers-status `, asi mismo se comparte un volumen ` /var/local/docker-data/containers-config ` donde dejar configuraciones del contenedor.

## Variables de entorno relevantes
 * `CA_PWD`  y  `CA_INT_PWD` : Definen los passwords para crear las CA's
 * `LISTA_SERVER` : Define una lista de dominios para los que se crearan certificados
 * `LISTA_CLIENTES` : Define una lista de nombres a los que se les crearan certificados para actuar como clientes
 * `DOCKER_WEB_SCRIPT` : Path a un script ejecutado dentro del contenedor como último paso del ENTRYPOINT
 
 También existen otras variables de entorno que permiten modificar la información de los certificados, su período de validez, etc, para mayor información visualizar el archivo ` docker-template.env `
 
## Notas
Existe un archivo llamado ` CA_INITIALIZED ` que se genera al finalizar la inicialización, la no existencia del mismo eliminará el contenido de la CA intermedia y los certificados que haya generado.
La CA root, queda por si es externa al container.
 
## Build
Hay archivos en las carpetas que contienen configuraciones básicas para openssl y scripts de generación de certificados, ante cualquier cambio a estos archivos (o al Dockerfile), ejecutar lo siguiente para re-generar la imagen

```
docker build -t="siutoba/docker-certs" .
```

Una vez hecho el push a github automáticamente se va a actualizar la imagen en el índice de [hub.docker.com](hub.docker.com)
