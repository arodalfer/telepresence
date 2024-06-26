# Telepresence
Este repositorio ofrece una guía de instalación y configuración de la herramienta Telepresence así como una pequeña demo para validar su correcto funcionamiento.

# Prerrequistos
Para poder seguir esta guía, es necesario tener instaladas las siguientes herramientas:
1. Docker
2. Kubectl
3. Telepresence

A mayores se usará Kind para crear un clúster en local sobre el que realizar las pruebas. Con el script install_tools.sh proporcionado, se podrá verificar si estas 4 herramientas están ya instaladas y en el caso de que no lo estén, hacerlo.
```
./install_tools.sh
```

# Inicialización e instalación de Telepresence en el propio clúster 
Con el siguiente comando se creará un clúster local con kind:
```
kind create cluster
```
Hecho esto, dentro del mismo, se instala la herramienta de Telepresence con Helm:
```
telepresence helm install
Traffic Manager installed successfully
```
```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
Este comando instala en el clúster un Traffic Manager. Es el encargado de interceptar y redireccionar el tráfico entre el clúster y la máquina local. Por defecto, se creará un nuevo namesapce llamado ambassador en el que se despliega la instalación.

# Contenerización mediante Docker de la aplicación que se quiere desplegar
El archivo app.py ejecuta una aplicación web con Python que imprime por pantalla un simple HOLA MUNDO. Fue necesario contenerizarla mediante Docker para poder desplegarla en el clúster. Posteriormente se subió a Docker Hub para hacerla accesible.
```
docker build -t arodal/demo:v1 .
docker login
docker push arodal/demo:v1
```
# Despliegue de la aplicación en el clúster de Kubernetes
En la carpeta kubernetes, están definidos los recursos necesarios para realizar el despligue. Existe un deployment que usa como imagen base del contenedor la anterior y un servicio que expone la aplicación. Para realizar esto, basta con ejecutar los siguientes comandos:
```
kubectl apply -f pod.yaml
kubectl apply -f service.yaml
```
Con Telepresence se intercepta el tráfico que llega a través del servicio y este es redirigido a un puerto de la máquina local.

# Establecimiento de conexión con el clúster
Para establecer una sesión con el clúster es necesario ejecutar el siguiente comando:
```
telepresence connect
```
Desde este momento, Telepresence estará conectado al namespace por defecto del clúster y todos los servicios deplegados en él podrán ser interceptados.

# Interceptación del servicio y reenvío del tráfico a nuestra máquina local
```
telepresence list
```
Con este comando se aprecian todos los servicios que pueden ser interceptados. Para esta demostración, se elige el servicio desplegado anteriormente denominado "demo":
```
telepresence intercept demo --port 4000
```
Esto hará que todo el tráfico que llegue a través del servicio sea enviado al puerto 4000 de la máquina local. Por lo tanto, si ahora se ejecuta el archivo app.py localmente en ese mismo puerto, todos los cambios que se hagan en local, se verán reflejados directamente en el clúster. Para lanzar la aplicación web localmente usaremos el siguiente comando:
```
pip install -r requirements && python3 app.py
```
