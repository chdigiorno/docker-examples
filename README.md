## Containerización
La containerización es la técnica de traer virtualización al nivel del sistema operativo; el kernel permite la existencia de múltiples instancias isoladas en user-space. Un hypervisor se encarga de emular recursos de hardware a máquinas virtuales en un host, las cuales viven en una ilusión de que tienen acceso al hardware.

Implica empaquetar una aplicación con todos sus archivos de configuración, librerías y dependencias requeridas para que pueda correr de una manera eficiente y sin problemas en diferentes entornos.


## Docker
Docker es una plataforma de containerización que empaqueta una aplicación junto con todas sus dependencias en la forma de contenedores.

- Cada aplicación correrá en un contenedor separado y tendrá su propio set de librerías y dependencias.
- También se asegurará de que haya aislamiento a nivel de proceso, lo cual significa que las aplicaciones son independientes entre sí, dando la seguridad al desarrollador de poder dejar corriendo aplicaciones sin interferencias entre ellas.

Una de sus mayores características es la simplificación de configuraciones; aunque una máquina virtual es capaz de correr en cualquier plataforma con una configuración propia, Docker provee el mismo beneficio con un "overhead" notablemente menor.

Docker ofrece a los desarrolladores un mayor control y autonomía sobre la plataforma donde se corre el software, con todas sus dependencias ya definidas e integradas y listo para ser deployeado. Los requerimientos de la aplicación quedan desacoplados de los requerimientos de la infraestructura.

A la hora de desarrollar y probar el funcionamiento de una aplicación, es deseable que el entorno de desarrollo sea lo más parecido posible al de producción. Al mismo tiempo, también es útil que el mismo sea lo más rápido posible, ya que se busca un uso interactivo. Teniendo en cuenta todo lo dicho hasta ahora, podemos afirmar que Docker viene como anillo al dedo, debido a su performance y la facilidad que provee para configurar aplicaciones.


### Contenedores de Docker
Un contenedor de Docker es una instancia en ejecución de una imagen. A partir de una misma imagen, se puede crear varios contenedores (todos corriendo la misma aplicación). Un contenedor corre como un proceso en el host.

Debido a que el contenedor corre sin la necesidad de bootear un sistema operativo, es liviano y limita los recursos (ej. memoria) que son necesarios para que pueda mantenerse en ejecución.

Ya que los contenedores no tienen un sistema operativo separado, pueden ser portados a través de diferentes plataformas. Cuando las aplicaciones deben ser desarrolladas y testeadas en plataformas distintas, los contenedores de Docker son una opción ideal.

La plataforma siempre está corriendo encima del host. Los contenedores contienen los binarios, librerías, y a la aplicación en sí. Como esos binarios y librerías corren en el kernel del host, es posible procesar ejecutar rápidamente.

En contraste, las máquinas virtuales corren en un hypervisor (virtual machine monitor) e incluyen su propio sistema operativo. Esto incrementa su tamaño notablemente, haciendo que setupear máquinas virtuales sea más complejo y requiera más recursos tener corriendo cada una.

La containerización es más eficiente debido a que no hay otro sistema operativo más, y se comparten librerías y recursos a medida que se van necesitando.


### Imágenes
Una imagen de Docker contiene todo lo necesario para correr una aplicación como un container. Esto incluye:

- código
- librerías
- variables de entorno
- archivos de configuración

Como todas las dependencias de la aplicación ya existen dentro de la imagen, se simplifica y acelera significativamente el proceso de deploy a otras computadoras. Lo único que éstas requieren es, por supuesto, tener Docker instalado.

Para crear una imagen, se utiliza un archivo de texto llamado Dockerfile, en el cual se especifican todos los comandos necesarios.

Una imagen de docker puede ser buildeada localmente, o descargada de hub.docker.com.

#### Capas
Una imagen contiene capas; cada una de ellas corresponde a determinadas instrucciones del Dockerfile. Docker utiliza una caché de capas para optimizar el proceso de generación de imágenes, logrando que sea más rápido.

Hay comandos especificables para el Dockerfile (ADD, RUN y COPY) que causan que la imagen anterior cambie, creando capas nuevas. Aunque existen otros comandos utilizables, éstos solamente crean capas intermedias que no influencian en el tamaño de la imagen.


### Persistencia en Docker
Un volumen es un mecanismo de persistencia de datos utilizado por contenedores de Docker. Su ciclo de vida es independiente del contenedor junto con el cual fue creado; se puede borrar dicho contenedor sin que el volumen desaparezca. Los datos se almacenan en el host, generalmente en `/var/lib/docker/volumes`, y solamente pueden ser modificados por procesos de Docker.

Los bind mounts son parecidos; hay dos direcciones, una en el host y otra en el contenedor, que apuntan a un mismo archivo. Al contrario de los volúmenes, no pueden ser configurados en un Dockerfile. Pueden existir en el filesystem del host, y ser modificados por procesos fuera de Docker.


### Instalación
```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
sudo apt-get update
sudo apt-get install docker-ce
sudo groupadd docker
sudo gpasswd -a $USER docker
logout
--------- entrar de nuevo
docker run hello-world
	# Si tira error (trusty 14.04?):
		sudo apt-get -y install --force-yes docker-ce=18.06.1~ce~3-0~ubuntu
		docker run hello-world
```


### Algunos comandos

`docker ps` -> muestra los contenedores que están levantados (agregar `-a` muestra también los que terminaron de ejecutar)


`docker images` -> muestra la lista de imágenes existentes


`docker pull {nombre imagen}` -> ahorra tener que descargarla al querer levantar containers de esa imagen


`docker build -t {nombre custom imagen} .` (en el directorio donde hay un Dockerfile) -> crea una imagen


`docker run -it -p 80:80 {nombre imagen}` -> levanta un contenedor en base a una imagen

- se puede agregar `–name {nombre custom}` para darle un nombre custom al contenedor
- `-t`: queremos que haya una pseudo-tty/terminal (text input output environment) generada que sh/bash puedan usar (ej. `docker run ubuntu:14.04` cortaría enseguida por no encontrar ninguna terminal ni tener nada que hacer)
- `-i`/`--interactive` permite enviar comandos al contenedor mediante input estándar ("STDIN"), lo cual significa que se puede tipear comandos a la pseudo-tty/terminal creada por `-t` de forma interactiva
- `-p`: especifica el puerto a utilizar en el host, y el puerto a utilizar en el contenedor
  - Si usamos `expose` en vez de `-p`, el servicio en el contenedor no sería accesible desde afuera de Docker; solamente desde adentro de otros contenedores. `-p` sin `expose` lo usa implícitamente

`docker stop {id container}` -> corta la ejecución de un contenedor

- Diferencia entre stop y kill:
  - Stop: al proceso principal del contenedor se le envía la señal SIGTERM y, después de un tiempo, SIGKILL
  - Kill: al proceso principal del contenedor se le envía la señal SIGKILL, o alguna otra especificada con la opción `-signal`
- En ambos casos, los cambios al filesystem serán persistidos al momento de usar stop o kill, así que usar `docker start {contenedor}` continuará desde donde estaba.


Extra: `docker stop $(docker ps -q)` -> busca los contenedores que están corriendo, uno por uno, y los detiene


`docker start {id container}` -> levanta contenedores detenidos


`docker rm {id contenedor}` -> borra un contenedor

- `--force`: es necesario usarlo si el contenedor está corriendo


`docker rmi {id imagen}` -> borra una imagen


`docker run -dit -p 80:80 {nombre imagen}` -> levanta un contenedor de forma "detachada" 

- `-d`: corre en el background en vez de apoderarse de la consola


`docker run -d -p 80:80 -v {path en host}:{path en container} {nombre imagen}`

- Usando la opción `-v`, creamos volúmenes con nombre (named volumes)
- Se declara `VOLUME` en un Dockerfile para especificar dónde el contenedor va a escribir datos de la aplicación. El volumen es configurado independientemente de lo que se haga en el `docker run`; ningún paso del Dockerfile podrá hacer cambios dentro del árbol de ese directorio. No se pueden utilizar paths del host; son volúmenes anónimos.
  - Ya que se puede usar `docker run -v` sin importar si se declara o no un `VOLUME`, y puede haber efectos secundarios confusos, generalmente se evita declarar `VOLUME` en los Dockerfiles.


`docker rm -v {container}` -> borra el container + sus volúmenes (se pueden especificar cuáles volúmenes borrar y cuáles mantener)


`docker exec -it {container id} {commando}` -> se ejecuta un comando dentro de un contenedor


`docker logs {container}` -> muestra los logs del contenedor

- `-t`: muestra timestamps
- `-f`: sigue el output en vez de mostrar lo que existe y terminar
- `--tail {número}`: cantidad de líneas a mostrar partiendo desde el final (sin este flag, muestra todas)


`docker inspect {container}` -> muestra toda la información del contenedor



## Docker Compose
Es una herramienta que permite manejar con facilidad múltiples contenedores juntos. Funciona aplicando reglas declaradas en un archivo de configuración ".yml".

**Service != container**. Un contenedor se levanta en base a un servicio definido en el ".yml".


### Networks
Las networks definen las reglas de comunicación entre contenedores, y entre un contenedor y su host.

Los contenedores de Docker se comunican entre sí en networks creadas por Docker Compose, ya sea de forma implícita o por cómo se haya configurado la aplicación.


### Dependencias entre servicios
A veces, necesitamos crear una cadena de dependencias entre los servicios, por lo que algunos son cargados antes que otros. Esto se logra utilizando la keyword `depends_on`.


### Instalación
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```


### Algunos comandos

`docker-compose ps`


`docker-compose images` -> muestra los contenedores con sus respectivas imágenes


`docker-compose up` -> crea y levanta los contenedores (es una mezcla entre los comandos `create` y `start`)


`docker-compose build` -> (re)buildea y taguea los servicios (ej. para cuando se modifica el Dockerfile)


`docker-compose stop` -> detiene los servicios (también se puede usar `kill`)


`docker-compose restart` -> reinicia los servicios


`docker-compose rm` -> elimina contenedores detenidos


`docker-compose down` -> detiene y elimina contenedores detenidos

- `-v`: elimina también los volúmenes declarados en el .yml


`docker-compose exec {servicio} {comando}` -> se ejecuta un comando dentro de un servicio

- `-T`: desactiva la asociación a una pseudo terminal (la cual le serviría para interactuar con ella tanto al usuario como a algunos programas)

- Observación: asumiendo que dentro del contenedor existe un archivo "/tmp/prueba" no vacío, podemos intentar ejecutar el comando `docker-compose exec {servicio} cat /tmp/prueba > /tmp/prueba2` para que se cree un archivo en el mismo directorio padre con el mismo contenido. Esto no llevará a cabo el efecto esperado, sino que hará la creación y escritura del nuevo archivo en /tmp/prueba2 _dentro del host_ en vez de dentro del contenedor. Hay que poner el comando entero entre comillas y especificar que es un comando de bash, para que quede `docker-compose exec {servicio} bash -c "cat /tmp/prueba > /tmp/prueba2"`.


`docker-compose logs {servicio}` -> muestra los logs del servicio, y usa los mismos flags que `docker logs`


<br>

Para cualquier comando de docker-compose, se puede agregar el flag `-f {path a un archivo .yml}` para que se lea como configuración.

- Compose busca un archivo `docker-compose.yml` o `docker-compose.yaml` por default; sin embargo, se puede utilizar _otro_ archivo con alguna de esas extensiones gracias al flag.

- Dicho flag se puede usar más de una vez; se apunta a otros archivos que pueden agregar configuraciones.

______________

Cuándo no usar Docker (ejemplos):

- Se quiere maximizar la performance (si bien tiene menos overhead que usar una maquina virtual, lo sigue habiendo)
- Se considera la seguridad como algo crítico: mantener diferentes componentes de la aplicación separados en contenedores tiene sus beneficios relacionados al tema, pero trae problemas difíciles de solucionar (la tecnología de los contenedores tienen acceso a los subsistemas del kernel)
- Aplicaciones demasiado complejas donde usar un Dockerfile o imágenes ya existentes no alcanza
- Es un requerimiento no negociable que haya una interfaz gráfica dentro del contenedor; si bien existen algunos trucos que se pueden utilizar, son muy toscos
