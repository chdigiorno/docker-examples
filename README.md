## Conceptos Generales

### Modos de operación de un sistema operativo
Los sistemas operativos manejan de manera diferente la ejecución de su propio código y el código definido por el usuario. Para el primer caso se emplea el uso del kernel, un programa que funciona como el núcleo del sistema operativo con control total sobre el sistema.
- Modo kernel: es el modo que se utiliza con el fin de proteger al sistema operativo, ya que existe la posibilidad donde el código que se debe ejecutar pueda causar daño; por lo tanto, la protección se consigue permitiendo la ejecución algunas de las instrucciones calificadas como privilegiadas (aquellas que pueden provocar alteraciones en el sistema operativo, sus recursos, o dispositivos de entrada/salida) únicamente en este modo.
- Modo usuario: este modo se utiliza cuando se está ejecutando una aplicación de usuario, pero es necesario realizar el cambio al modo kernel cada vez que se requiera la ejecución de una o más instrucciones privilegiadas. Una vez que éstas terminan, se vuelve al modo usuario.

### Virtualización
Es el proceso de crear una representación virtual de algo, como aplicaciones, servidores, dispositivos de almacenamiento, y redes. El ejemplo más clásico de virtualización consiste en tener múltiples sistemas operativos (considerados invitados/guests) corriendo en otro (anfitrión/host).

A las aplicaciones que corren en una máquina virtualizada les parece que están utilizando directamente el hardware, pero esto es solamente una ilusión; lo que se supone que es un acceso al hardware no es más que una emulación realizada mediante software denominado hypervisor.

Podemos decir que una máquina virtual representa una virtualización a nivel de hardware. Está aislada del host, manejando su propio kernel y sus propios recursos.

### Containerización
La containerización es la técnica de traer virtualización al nivel del sistema operativo; el kernel permite la existencia de múltiples instancias isoladas en user-space. No se utiliza un hypervisor, debido a que no se busca virtualizar a nivel de hardware, lo cual agiliza su funcionamiento.

Debido a que el contenedor corre sin la necesidad de bootear un sistema operativo, es liviano y limita los recursos (ej. memoria) que son necesarios para que pueda mantenerse en ejecución.

Implica empaquetar una aplicación con todos sus archivos de configuración, librerías y dependencias requeridas para que pueda correr de una manera eficiente, y logrando siempre el mismo funcionamiento en distintos entornos.


## Docker
Docker es una plataforma de containerización que empaqueta una aplicación junto con todas sus dependencias en la forma de contenedores.

- Cada aplicación correrá en un contenedor separado y tendrá su propio set de librerías y dependencias.
- También se asegurará de que haya aislamiento a nivel de proceso, lo cual significa que las aplicaciones son independientes entre sí, dando la seguridad al desarrollador de poder dejar corriendo aplicaciones sin interferencias entre ellas.

Una de sus mayores características es la simplificación de configuraciones; aunque una máquina virtual es capaz de correr en cualquier plataforma con una configuración propia, Docker provee el mismo beneficio con un "overhead" notablemente menor.

Docker ofrece a los desarrolladores un mayor control y autonomía sobre la plataforma donde se corre el software, con todas sus dependencias ya definidas e integradas y listo para ser deployeado. Los requerimientos de la aplicación quedan desacoplados de los requerimientos de la infraestructura.

A la hora de desarrollar y probar el funcionamiento de una aplicación, es deseable que el entorno de desarrollo sea lo más parecido posible al de producción. Al mismo tiempo, también es útil que el mismo sea lo más rápido posible, ya que se busca un uso interactivo. Teniendo en cuenta todo lo dicho hasta ahora, podemos afirmar que Docker viene como anillo al dedo, debido a su performance y la facilidad que provee para configurar aplicaciones.

Como Docker corre imágenes de Linux, utilizarlo en Windows o MacOS implica la utilización de herramientas de Docker que emplean virtualización de máquinas, perdiéndose performance de manera notable. Sin embargo, se introdujo la existencia de contenedores de Windows, los cuales utilizan los binarios del sistema operativo, eliminando la necesidad de depender de máquinas virtuales y hypervisors.


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


### Contenedores de Docker
Un contenedor de Docker es una instancia en ejecución de una imagen. A partir de una misma imagen, se puede crear varios contenedores (todos corriendo la misma aplicación). Un contenedor corre como un proceso en el host.

La plataforma siempre está corriendo encima del host. Los contenedores contienen los binarios, librerías, y a la aplicación en sí. Como esos binarios y librerías corren en el kernel del host, es posible procesar ejecutar rápidamente.

En contraste, las máquinas virtuales corren en un hypervisor e incluyen su propio sistema operativo. Esto incrementa su tamaño notablemente, haciendo que setupear máquinas virtuales sea más complejo y requiera más recursos tener corriendo cada una.

La containerización es más eficiente debido a que no hay otro sistema operativo más, y se comparten librerías y recursos a medida que se van necesitando.


### Imágenes
Una imagen de Docker contiene todo lo necesario para correr una aplicación como un container. Esto incluye:

- código
- librerías
- variables de entorno
- archivos de configuración

Como todas las dependencias de la aplicación ya existen dentro de la imagen, se simplifica y acelera significativamente el proceso de deploy a otras computadoras. Lo único que éstas requieren es, por supuesto, tener Docker instalado.

Para crear una imagen, se utiliza un archivo de texto llamado Dockerfile, en el cual se especifican todos los comandos necesarios.

Una imagen de docker puede ser buildeada localmente en base a otra, o descargada de hub.docker.com.

#### Capas
Una imagen contiene capas; cada una de ellas es un conjunto de diferencias con respecto a la capa anterior causadas por determinadas instrucciones del Dockerfile. Docker utiliza una caché de capas para optimizar el proceso de generación de imágenes, logrando que sea más rápido debido a que éstas no se deben rebuildear desde cero.

Hay comandos especificables para el Dockerfile (ADD, RUN y COPY) que causan que la imagen anterior cambie, creando capas nuevas. Aunque existen otros comandos utilizables, éstos solamente crean capas intermedias que no influencian en el tamaño de la imagen. Sin embargo, si al momento de buildear la nueva imagen se encuentra una instrucción para la cual no hay una capa cacheada, no se intentará leer de la caché ninguna de las siguientes instrucciones, por lo que es conveniente llevar a cabo prácticas para minimizar la invalidación de la caché como solamente copiar archivos que sean necesarios en el próximo paso y evitar usar comandos al principio del Dockerfile que siempre vayan a generar cambios.

La parte problemática de las capas es que aumentan el tamaño de la imagen, haciendo que ocupen más espacio, se tarde más en descargarlas, e incluso es posible que queden componentes que jamás vayan a ser usados.

Se recomienda fuertemente no utilizar comandos como `apt-get update` en una instrucción separada a la instrucción donde se realizan instalaciones en base al update, debido a que el `update` puede estar cacheado (por lo que no se ejecutará) pero cambiar las instalaciones va a invalidar la caché y puede haber problemas con los paquetes a descargar; en vez de eso, conviene juntar todo en una sola instrucción del Dockerfile.


### Persistencia en Docker
Un volumen es un mecanismo de persistencia de datos utilizado por contenedores de Docker. Su ciclo de vida es independiente del contenedor junto con el cual fue creado; se puede borrar dicho contenedor sin que el volumen desaparezca. Los datos se almacenan en el host, generalmente en `/var/lib/docker/volumes`, y solamente pueden ser modificados por procesos de Docker.

Los bind mounts son parecidos; hay dos direcciones, una en el host y otra en el contenedor, que apuntan a un mismo archivo. Al contrario de los volúmenes, no pueden ser configurados en un Dockerfile. Pueden existir en el filesystem del host, y ser modificados por procesos fuera de Docker.


### Dockerfile

Es el archivo que contiene las instrucciones que se correrán sobre una imagen padre especificada. Se lo utiliza a la hora de buildear una imagen, cuyos contenedores serán levantados con el comando `docker-run`.

Instrucciones que se pueden utilizar:

- `ARG <VAR_NAME>=<value>`: crea una variable con un valor default; se le puede asignar otro distinto enviándolo directamente por parámetro en el `docker build` de la forma `--build-arg <VAR_NAME>=<value>`. ARG puede ser utilizado una o más veces, pero sólo arriba de la instrucción `FROM`. Sirve solamente dentro del proceso de buildeo de la imagen.

- `ENV <VAR_NAME> <value>`: crea una variable de entorno que será utilizada en los contenedores que se levanten en base a la imagen que se está buildeando. Esta variable puede ser utilizada dentro de un comando `RUN` dentro del mismo Dockerfile.

- `FROM <nombre imagen padre>`: especifica la imagen en base a la cuál se creará la imagen de la aplicación.

- `WORKDIR <directorio dentro de la imagen>`: especifica un directorio donde se ejecutarán todas las instrucciones que se encuentren abajo de ésta.

- `RUN <comando>`: se ejecuta un comando dentro de la imagen.

- `COPY <directorio donde se encuentra el Dockerfile> <directorio dentro de la imagen>`: copia un archivo que existe dentro del host, buscando a partir de donde se encuentra ubicado el Dockerfile, y lo replica dentro de un directorio perteneciente a la imagen a crear.

- `ADD [--chown=<usuario>:<grupo>] <src> <dest>`: copia un archivo que existe dentro del host o pertenezca a una URL, y lo replica dentro de un directorio perteneciente a la imagen a crear. Funciona distinto a `COPY`, con soporte de URLs y extracciones de .tar de forma local. Entre las buenas prácticas de Docker, se recomienda evitar usar esta instrucción y usar `COPY` o múltiples `RUN`, ya que posee un manejo ocasionalmente impredecible de tars y, aunque ofrece extracciones, no lo realiza cuando el archivo proviene de una URL (la extracción se debe hacer mediante un `RUN` en el Dockerfile, lo cual implica una capa más, aumentando el tamaño de la imagen). La opción `--chown` solamente puede ser usada para contenedores de Linux.

- `VOLUME <directorio dentro de la imagen>`: especifica dónde el contenedor va a escribir datos de la aplicación para su persistencia. El volumen es configurado independientemente de lo que se haga en el `docker run`; ningún paso del Dockerfile podrá hacer cambios dentro del árbol de ese directorio. No se pueden utilizar paths del host; son volúmenes anónimos. (Recomendación: crear volúmenes con nombre en el `docker run`)

- `USER <nombre de usuario>[:<nombre de grupo>]`: especifica el nombre de usuario (o UID) y, opcionalmente, el grupo de usuario (o GID) a usar al correr la imagen y para ejecutar las instrucciones del Dockerfile que se encuentren abajo de ésta.

- `EXPOSE <puerto> [<puerto>/<protocolo>]`: le informa a Docker que el contenedor escuchará en los puertos especificados, permitiendo que los demás contenedores se puedan comunicar con éste; el puerto no se publica para procesos ajenos a Docker con esta instrucción (lo cual se hace en el `docker run`). Por default, el protocolo es TCP.

- `ENTRYPOINT`: especifica una instrucción para que ejecute el contenedor al ser levantado. Siempre hay uno; si no se lo especifica en el Dockerfile o en el `docker run`, es `/bin/sh -c`. Si corre un ejecutable, usará los parámetros que se le pasen al `docker run`, o los que contenga `CMD`. Si se utiliza `CMD`, éste debe estar abajo de `ENTRYPOINT`. Existen 2 formas de utilizarlo:
  - Forma exec: `ENTRYPOINT ["comando o archivo ejecutable", "parámetro 1", "parámetro 2", ..., "parámetro N"]` -> se utilizan los parámetros especificados más los que se le intente enviar mediante `CMD` o `docker run`.
  - Forma shell: `ENTRYPOINT <comando> <parámetro 1> <parámetro 2> ... <parámetro N>` -> ignora cualquier parámetro que se le intente enviar mediante `CMD` o `docker run`.

- `CMD`: especifica una instrucción para que ejecute el contenedor al ser levantado, aunque si se provee uno en el `docker run` se utilizará ese. Solamente puede haber *un* `CMD` en el mismo Dockerfile. Existen 3 formas de utilizarlo:
  - Forma exec: `CMD ["comando o archivo ejecutable", "parámetro 1", "parámetro 2", ..., "parámetro N"]` -> se ejecuta el ejecutable de forma directa, sin ningún shell processing.
  - Forma shell: `CMD <comando> <parámetro 1> <parámetro 2> ... <parámetro N>` -> se ejecuta el comando de la forma `/bin/sh -c <comando + parámetros>`, aplicando utilidades de shell como reemplazo de variables de entorno y permitiendo el uso de backslashes (`\`) para continuar la instrucción en la siguiente línea del Dockerfile.
  - Forma de parámetros default para `ENTRYPOINT`: `CMD ["parámetro 1", "parámetro 2", ..., "parámetro N"]` -> se utiliza cuando se emplea el uso de `ENTRYPOINT`, pasándole al mismo parámetros default que se usan en los casos donde al contenedor no se le den unos.


### Algunos comandos

`docker ps` -> muestra los contenedores que están levantados (agregar `-a` muestra también los que terminaron de ejecutar)


`docker images` -> muestra la lista de imágenes existentes localmente


`docker pull {nombre imagen}` -> descarga la imagen especificada de dockerhub, ahorrando tener que hacerlo al querer levantar containers de esa imagen


`docker build -t {nombre custom que se le dará a la imagen} --build-arg {variable}={valor} .` -> crea una imagen utilizando el Dockerfile existente en el directorio y uno o más argumentos a través de `--build-arg` (se lo puede utilizar más de una vez) que reemplazarán los especificados con `ARG` en el Dockerfile


`docker run -dit -p 80:80 --env-file={nombre del env_file} {nombre imagen} {comando}` -> levanta un contenedor en base a una imagen

- se puede agregar `–name {nombre custom}` para darle un nombre custom al contenedor
- se puede especificar al final un comando que el contenedor deba correr (si no se escribe ninguno, se utiliza el descripto en el Dockerfile), y un entrypoint con `--entrypoint {ejecutable}` para overridear el especificado en el Dockerfile (o el default)
- `-d`: levanta un contenedor de forma "detachada"; corre en el background en vez de apoderarse de la consola
- `-t`: queremos que haya una pseudo-tty/terminal (text input output environment) generada que sh/bash puedan usar (ej. `docker run ubuntu:14.04` cortaría enseguida por no encontrar ninguna terminal ni tener nada que hacer)
- `-i`/`--interactive` permite enviar comandos al contenedor mediante input estándar ("STDIN"), lo cual significa que se puede tipear comandos a la pseudo-tty/terminal creada por `-t` de forma interactiva
- `-p`: especifica el puerto a utilizar en el host, y el puerto a utilizar en el contenedor
  - `--expose`: el servicio en el contenedor no sería accesible desde afuera de Docker; solamente desde adentro de otros contenedores. `-p` sin `--expose` lo usa implícitamente
- `--env-file`: especifica el nombre de un env_file, el cual es archivo que contiene una o más variables de entorno para utilizar en el contenedor; en caso de que una variable de entorno existiese previamente por haber sido creada en el Dockerfile, ésta es reemplazada por la nueva


`docker start {id container}` -> levanta contenedores detenidos


`docker stop {id container}` -> corta la ejecución de un contenedor

- Diferencia entre stop y kill:
  - Stop: al proceso principal del contenedor se le envía la señal SIGTERM y, después de un tiempo, SIGKILL
  - Kill: al proceso principal del contenedor se le envía la señal SIGKILL, o alguna otra especificada con la opción `-signal`
- En ambos casos, los cambios al filesystem serán persistidos al momento de usar stop o kill, así que usar `docker start {contenedor}` continuará desde donde estaba.

Extra: `docker stop $(docker ps -q)` -> busca los contenedores que están corriendo, uno por uno, y los detiene


`docker rm {id contenedor}` -> borra un contenedor

- `--force`: es necesario usarlo si el contenedor está corriendo


`docker rmi {id imagen}` -> borra una imagen


`docker run -d -p 80:80 -v {nombre para el volumen}:{path en container} {nombre imagen}`

- Usando la opción `-v`, creamos volúmenes con nombre (named volumes)
  - Ya que se puede usar `docker run -v` sin importar si se declara o no un `VOLUME`, y puede haber efectos secundarios confusos, generalmente se evita declarar `VOLUME` en los Dockerfiles.
- En vez de un nombre para el volumen, se puede especificar un path del host, para que los datos se compartan. Es fácil saber dónde se guardarán los datos cuando el contenedor quiera escribir en el directorio, ya que se está especificando un lugar dentro del host, y Docker no se encargará de manejar todo por sí mismo. Se lo conoce como bind mount.


`docker rm -v {container}` -> borra el container + sus volúmenes (se pueden especificar cuáles volúmenes borrar y cuáles mantener)


`docker exec -it {container id} {commando}` -> se ejecuta un comando dentro de un contenedor


`docker logs {container}` -> muestra los logs del contenedor

- `-t`: muestra timestamps
- `-f`: sigue el output en vez de mostrar lo que existe y terminar
- `--tail {número}`: cantidad de líneas a mostrar partiendo desde el final (sin este flag, muestra todas)


`docker inspect {container}` -> muestra toda la información del contenedor



## Docker Compose
Es una herramienta que permite manejar con facilidad múltiples contenedores juntos. Funciona aplicando reglas declaradas en un archivo de configuración ".yml"; estas reglas son utilizadas para armar servicios, los cuales son representaciones de la configuración manejada por Docker-Compose que corresponderá a un contenedor especificado.

**Service != container**. Un contenedor se levanta en base a un servicio definido en el ".yml".


### Instalación
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```


### Networks
Las networks definen las reglas de comunicación entre contenedores, y entre un contenedor y su host.

Los contenedores de Docker se comunican entre sí en networks creadas por Docker Compose, ya sea de forma implícita o por cómo se haya configurado la aplicación.


### Dependencias entre servicios
A veces, necesitamos crear una cadena de dependencias entre los servicios, por lo que algunos son cargados antes que otros. Esto se logra utilizando la keyword `depends_on`.


### Algunos comandos

`docker-compose ps` -> muestra los contenedores levantados relacionados a los servicios descriptos en el `.yml`


`docker-compose images` -> muestra los contenedores con sus respectivas imágenes


`docker-compose up` -> crea y levanta los contenedores (es una mezcla entre los comandos `create`, el cual está deprecado, y `start`) (se puede especificar uno o más servicios para no hacerlo con todos)

- `-d`: levanta los contenedores de forma detachada
- `--no-start`: no levanta los contenedores, sino que solamente los crea


`docker-compose build` -> (re)buildea y taguea los servicios (ej. para cuando se modifica el Dockerfile)


`docker-compose stop` -> detiene los servicios (también se puede usar `kill`) (se puede especificar uno o más servicios para no hacerlo con todos)


`docker-compose restart` -> reinicia los servicios (se puede especificar uno o más servicios para no hacerlo con todos)


`docker-compose rm` -> elimina contenedores detenidos (se puede especificar uno o más servicios para no hacerlo con todos)


`docker-compose down` -> detiene y elimina contenedores detenidos (se puede especificar uno o más servicios para no hacerlo con todos)

- `-v`: elimina también los volúmenes declarados en el .yml


`docker-compose exec {servicio} {comando}` -> se ejecuta un comando dentro de un servicio

- `-T`: desactiva la asociación a una pseudo terminal (la cual le serviría para interactuar con ella tanto al usuario como a algunos programas)

- Observación: asumiendo que dentro del contenedor existe un archivo "/tmp/prueba" no vacío, podemos intentar ejecutar el comando `docker-compose exec {servicio} cat /tmp/prueba > /tmp/prueba2` para que se cree un archivo en el mismo directorio padre con el mismo contenido. Esto no llevará a cabo el efecto esperado, sino que hará la creación y escritura del nuevo archivo en /tmp/prueba2 _dentro del host_ en vez de dentro del contenedor. Hay que poner el comando entero entre comillas y especificar que es un comando de bash, para que quede `docker-compose exec {servicio} bash -c "cat /tmp/prueba > /tmp/prueba2"` y Docker-Compose lo reconozca como un comando entero a ejecutar en el contenedor en vez de leer solamente `cat /tmp/prueba`.


`docker-compose logs {servicio}` -> muestra los logs del servicio, y usa los mismos flags que `docker logs`  (aunque se puede especificar más de un servicio, no se recomienda hacerlo cuando los logs son demasiado largos por cuestiones de legibilidad)


<br>

Para cualquier comando de docker-compose, se puede agregar el flag `-f {path a un archivo .yml}` para que se lea como configuración.

- Compose busca un archivo `docker-compose.yml` o `docker-compose.yaml` por default; sin embargo, se puede utilizar _otro_ archivo con alguna de esas extensiones gracias al flag.

- Dicho flag se puede usar más de una vez; se apunta a otros archivos que pueden agregar configuraciones.

______________

## Cuándo no usar Docker (ejemplos):

- Se quiere maximizar la performance (si bien tiene menos overhead que usar una maquina virtual, lo sigue habiendo).
- Se considera la seguridad como algo crítico: mantener diferentes componentes de la aplicación separados en contenedores tiene sus beneficios relacionados al tema, pero trae problemas difíciles de solucionar; la tecnología de los contenedores tienen acceso a los subsistemas del kernel (por lo que un "kernel panic" causado por un contenedor afectará también al host) y sus recursos (si un contenedor puede monopolizar el uso de ciertos recursos, puede afectar a los demás contenedores, facilitando un ataque denial-of-service debido a que hay partes del sistema a las que ya no se puede acceder), y si un atacante logra el acceso a un contenedor y escapa del mismo llegando a otro o incluso al host, tendrá los mismos privilegios de usuario que tenía en el contenedor al que entró originalmente (por eso se recomienda no usar por default al usuario root).
- Es un requerimiento no negociable que haya una interfaz gráfica dentro del contenedor; si bien existen algunos trucos que se pueden utilizar, como X-forwarding o VNC, son muy toscos.
