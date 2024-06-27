# Telepresence
Este repositorio ofrece una guía de instalación y configuración de la herramienta Telepresence así como una pequeña demo para validar su correcto funcionamiento.

# Prerrequistos
Para poder seguir esta guía, es necesario tener instaladas las siguientes herramientas:
1. Docker
2. Kubectl
3. Telepresence

A mayores se usará Kind para crear un clúster en local sobre el que realizar las pruebas. Con el script install_tools.sh proporcionado, se podrá verificar si estas 4 herramientas están ya instaladas y en el caso de que no lo estén, hacerlo.
```
$ ./install_tools.sh
```

# Inicialización e instalación de Telepresence en el propio clúster 
Con el siguiente comando se creará un clúster local con kind:
```
$ kind create cluster
```
Hecho esto, dentro del mismo, se instala la herramienta de Telepresence con Helm:
```
$ telepresence helm install
```
![image](https://github.com/arodalfer/telepresence/assets/136476284/f823ab77-0267-422e-94a8-4aa9c40c8b0b)

Este comando instala en el clúster un Traffic Manager. Es el encargado de interceptar y redireccionar el tráfico entre el clúster y la máquina local. Por defecto, se creará un nuevo namespace llamado ambassador en el que se despliega la instalación.

![image](https://github.com/arodalfer/telepresence/assets/136476284/25515ecb-9561-4d60-a813-ab0840e05db1)

# Contenerización mediante Docker de la aplicación que se quiere desplegar
El archivo app.py ejecuta una aplicación web con Python que imprime por pantalla un simple HOLA MUNDO. Fue necesario contenerizarla mediante Docker para poder desplegarla en el clúster. Posteriormente se subió a Docker Hub para hacerla accesible.
```
docker build -t arodal/demo:v1 .
docker login
docker push arodal/demo:v1
```
![image](https://github.com/arodalfer/telepresence/assets/136476284/f9a0fa57-a9a1-4593-8051-9d3c84ca0198)

# Despliegue de la aplicación en el clúster de Kubernetes
En la carpeta kubernetes, están definidos los recursos necesarios para realizar el despligue. Existe un deployment que usa como imagen base del contenedor la anterior y un servicio que expone la aplicación. Para realizar esto, basta con ejecutar los siguientes comandos:
```
kubectl apply -f pod.yaml
kubectl apply -f service.yaml
```
![image](https://github.com/arodalfer/telepresence/assets/136476284/cfd288dc-5c62-4f24-ae0a-b23bdae6e862)
![image](https://github.com/arodalfer/telepresence/assets/136476284/f39c8679-2059-44b1-a64e-8e5fd28c258b)

Con Telepresence se intercepta el tráfico que llega a través del servicio y este es redirigido a un puerto de la máquina local.

# Establecimiento de conexión con el clúster
Para establecer una sesión con el clúster es necesario ejecutar el siguiente comando:
```
telepresence connect
```
![image](https://github.com/arodalfer/telepresence/assets/136476284/43c44b2c-cb1b-40e6-930b-17056cd848c3)

Desde este momento, Telepresence estará conectado al namespace por defecto del clúster y todos los servicios deplegados en él podrán ser interceptados.

# Interceptación del servicio y reenvío del tráfico a nuestra máquina local
```
telepresence list
```
Con este comando se aprecian todos los servicios que pueden ser interceptados. Para esta demostración, se elige el servicio desplegado anteriormente denominado "demo":
```
telepresence intercept demo --port 4000
```
![image](https://github.com/arodalfer/telepresence/assets/136476284/30947aa4-51cb-4479-a8f5-97e744883582)

Esto hará que todo el tráfico que llegue a través del servicio sea enviado al puerto 4000 de la máquina local. Por lo tanto, si ahora se ejecuta el archivo app.py localmente en ese mismo puerto, todos los cambios que se hagan en local, se verán reflejados directamente en el clúster. Para lanzar la aplicación web localmente usaremos el siguiente comando:
```
pip install -r requirements && python3 app.py
```
Se puede acceder a la aplicación web desplegada en el clúster mediante la ip del nodo en el que se ejecuta y el puerto que expone el servicio asociado:
http://172.18.0.2:32066/

![image](https://github.com/arodalfer/telepresence/assets/136476284/ff986326-66cf-4ad6-a232-2740586f183b)
![image](https://github.com/arodalfer/telepresence/assets/136476284/0d567aad-98b9-4ca7-adca-657321a2d565)

Si en el código ejecutado en local se realiza algún cambio, automáticamente se verá reflejado en el propio clúster.

![image](https://github.com/arodalfer/telepresence/assets/136476284/5609a2ff-3c71-4c98-a484-71088e4f2c5b)

![image](https://github.com/arodalfer/telepresence/assets/136476284/b231c283-7913-47a0-975b-d588d9e952d5)

Una vez se cierre la sesión establecida con Telepresence, los cambios realizados hasta el momento desaparecerán y el servicio volverá a su estado inicial.
Para cerrar sesión, es necesario ejecutar el siguiente comando:
```
telepresence quit -s
```
