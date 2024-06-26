# Telepresence
Este repositorio ofrece una guía de instalación y configuración de la herramienta Telepresence así como una pequeña demo para validar su correcto funcionamiento.

# Prerrequistos
Para poder seguir esta guía, es necesario tener instaladas las siguientes herramientas:
1. Docker
2. Kubectl
3. Telepresence

A mayores se usará kind para crear un clúster sobre el que realizar las pruebas de manera local. Con el script install_tools.sh proporcionado, se podrá verificar si estas 4 herramientas están instaladas y en el caso de que no lo estén, hacerlo.
```
./install_tools.sh
```

# Inicialización e instalación de Telepresence en el propio clúster 
Con el siguiente comando crearemos un clúster local con kind:
```
kind create cluster
```
Hecho esto, dentro del mismo, instalaremos la herramienta de Telepresence con Helm:
```
telepresence helm install
```
Este comando instala en el clúster un Traffic Manager. Es el encargado de interceptar y redireccionar el tráfico entre el clúster y la máquina local. Por defecto, se creará un nuevo namesapce llamado ambassador en el que se despliega la instalación.

# Contenerización mediante Docker de la aplicación que se quiere desplegar
El archivo app.py crea una aplicación web con Python que imprime por pantalla un simple HOLA MUNDO. Fue necesario contenerizarla mediante Docker para poder desplegarla en el clúster. Posteriormente se subió a Docker Hub para hacerla accesible.
```
docker build -t arodal/demo:v1 .
docker login
docker push arodal/demo:v1
```
