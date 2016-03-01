# docker-certs
Contenedor Docker para crear CA y Certificados SSL a demanda

## Requerimientos
 * Se debe tener instalado [Docker](https://docs.docker.com/installation/) y [Docker-compose](https://docs.docker.com/compose/install/)

## Build
Hay archivos en las carpetas `/bin` y `/scripts` que contienen script de generacion de estructuras y certificados, ante cualquier cambio a este script (o al Dockerfile), ejecutar lo siguiente para re-generar la imagen 
```
docker build -t="siutoba/docker-certs" .
```
Una vez hecho el push a github automáticamente se va a actualizar la imagen en el índice de [hub.docker.com](hub.docker.com)
