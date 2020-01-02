## General Concepts

### Execution modes in operating systems
Operating systems (OS) manage differently the execution of their own code and the code defined by the user. For the former, they utilize their [kernel](https://en.wikipedia.org/wiki/Kernel_(operating_system)), which is a program that functions as the OS's core, and has total control over the system.
- Kernel mode: it is the mode that is used in order to protect the OS, because the code that has to be run might have instructions that can cause damage; therefore, the system is protected by allowing the execution of instructions known as privileged (those that can cause alterations in the OS, its resources, or input/output devices) only in this mode.
- User mode: this mode is used when a user application is being run; however, it is necessary to switch to kernel mode every time a privileged instruction needs to be executed. Once that instruction is finished, it goes back to user mode.

### Virtualization
It is the process of creating a virtual representation of something such as applications, servers, storage devices, and networks. One of the most classic examples of virtualization is one or more OS (known as guests) running within another OS (the host).

Applications running in a virtual machine cannot access the hardware directly; every time they try, an emulation is run by a software called [hypervisor](https://docs.oracle.com/cd/E50245_01/E50249/html/vmcon-hypervisor.html) in order to complete the task.

We can say that a virtual machine represents a hardware level virtualization. It is isolated from the host, managing its own kernel and resources.

### Containerization
It is a method for bringing virtualization to OS level; the kernel allows the existence of multiple isolated user-space instances. It does not require a hypervisor, since the goal is not hardware level virtualization, which speeds up its operational time.

As a container runs without the need of booting an OS inside, it is lightweight and limits the resources (e.g. memory) it uses to keep running.

The application you want to run in the container is packaged along with all the configuration files, libraries and dependencies it requires, and will function consistently in different environments.


## Docker
Docker is a containerization platform that packages an application along with all its dependencies as containers.

- Every application runs in a separate container and has its own set of libraries and dependencies
- It will also make sure there will be process level isolation, which means the applications will be independent of each other, and thus there will be no interference between them.

Even though a virtual machine is able to run in any platform using its own configuration, Docker provides a similar benefit but with a noticeably lower overhead.

Docker offers developers greater control and autonomy over the platform the software is being run in, with all its dependencies already defined and integrated, and ready to be deployed. The application's requirements are disengaged from the infrastructure's.

When it comes to developing and testing an application, it is desirable for the development environment to be as similar as possible to the productive environment. On the other hand, it should be as fast as possible, as an interactive usage is sought.

Since Docker runs Linux images, employing it on Windows or MacOS implies using tools for machine virtualization, greatly losing performance. However, [Docker Windows Containers](https://www.docker.com/products/windows-containers) were introduced, which helps mitigating the problem.


### Installation

#### Ubuntu
```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo docker run hello-world
  # If it throws an error (trusty 14.04?):
    sudo apt-get -y install --force-yes docker-ce=18.06.1~ce~3-0~ubuntu
    sudo docker run hello-world
```

#### Debian
```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo docker run hello-world
```

#### CentOS
```
sudo yum -y update
sudo yum -y install yum-utils device-mapper-persistent-data lvm2 epel-release
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable rhel-7-server-extras-rpms
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker && sudo systemctl start docker
sudo docker run hello-world
```

#### Post installation
Manage Docker as a non-root user:
```
sudo groupadd docker
sudo gpasswd -a $USER docker
logout
# Log in again so you don't need to run docker with sudo
# Try running hello-world again, but without sudo
docker run hello-world
```


### Docker containers
A Docker container is a running instance of an image as a process within the host. From that same image, multiple containers can be created.

Containers contain all the binaries, libraries, and the application itself. Since those binaries and libraries are run with the host's kernel, it is possible to do so rapidly.

In contrast, virtual machines run with a hypervisor and have their own OS. This notably increments its size, making setting virtual machines be more complex and require more resources to keep running. Containers are more efficient because there are no extra OS involved, and the libraries and resources they use are shared as they are needed.


### Images
An image contains everything required to run applications in containers. This includes:

- code
- libraries
- environment variables
- configuration files

Since all the application's dependencies already exist within the image, the deployment process to other computers is fast. All they require is, of course, having Docker installed.

In order to create an image locally, we use a text file called Dockerfile, within which all the instructions that need to be executed and an image that must be used as a base are specified. Or, if you want to use an already existing image, you can download it from https://hub.docker.com if it has been uploaded there.

#### Layers
An image contains layers; every one of them is a set of differences from the previous layer caused by certain instructions in the Dockerfile. Docker uses a layer cache to optimize the image generation process, making it become faster since it will not have to be rebuilt from scratch.

Some of the possible commands for the Dockerfile (ADD, RUN and COPY) cause the previous image to change, creating new layers. However, if an instruction for which there is no cached layer is found (which happens if you modify an existing instruction or write a new one) while building the image, the cache will not be used from that point onward; it is convenient to minimize the cache invalidation with practices such as avoiding writing commands that are often modified at the beginning of the Dockerfile (they could be left for execution as late as possible).

The problematic part is that layers increase the image's size, which means it will occupy more space, take longer to be downloaded, and it is even possible that some components will be part of it even if it won't be used in the future. I suggest that you write multiple related commands in the same line.

Furthermore, it is strongly recommended not to use commands such as `apt-get update` in a separate instruction from the one that will install packages, since the update might be cached (which means Docker will not run it) and changing the packages to be installed will make it so Docker does run them; there might be issues regarding the versions that can be found available and the ones that the installation might be trying to search for. Therefore, it's best to write the apt update and install instructions in the same line.


### Data persistence in Docker
Data isn't persisted once a container no longer exists, which is why volumes exist.
A volume is a data persistence mechanism used by Docker containers. Its life cycle is independent from the container's; said container can be brought down without the volume disappearing. The data is stored in the host, generally in /var/lib/docker/volumes.

Bind mounts are a similar option; there are two locations, one from the host and another one from the container, that point to the same file. Unlike volumes, they cannot be configured in a Dockerfile. They can exist in the host's filesystem, and be modified by other containers or the host's processes.


### Dockerfile
It is the file where the instructions that need to run on a parent image will be specified. It is used to build an image which will be used to set up containers with the command `docker run`.

Instructions that can be used:

_Note: anything between [ ] is optional._

- `ARG <VAR_NAME>=<value>`: it creates a variable with a default value; a different value can be assigned directly as an argument in the `docker build` as `--build-arg <VAR_NAME>=<value>`. ARG can be used one o more times, but _only_ above the FROM instruction, and it only exists while the image is being built.

- `ENV <VAR_NAME> <value>`: it creates an environment variable that will be used in the containers setup based on the image being built. This variable can be used in a RUN instruction within the same Dockerfile.

- `FROM <parent image's name>[:<tag>]`: it specifies the image the new one will be based on. A tag can be specified por it; in case it isn't, the "latest" version will be downloaded.

- `WORKDIR <directory inside the image>`: it specifies a directory where all the instructions below will be run.

- `RUN <command>`: it executes a command inside the image.

- `COPY [--chown=<user>:<group>]<source inside the host> <path inside the image>`: copies a file or directory and adds it to the container's filesystem.

- `ADD [--chown=<user>:<group>] <src> <dest>`: copies a file or directory from the host or files from a URL and adds them to the image's filesystem. It works differently from COPY, supporting URLs and local ".tar" extractions. It is recommended to avoid this instruction and use COPY or multiple RUNs instead, since ADD does has an ocasionally unpredictable managment of tards and, even though it offers extractions, it does not do them when the file comes from a URL (the extractions, then, have to be done through RUNs, adding layers to the image). The option `--chown` is only for Linux based containers.

- `VOLUME <directory inside the image>`: it specifies a directory where the container will write some of the application's data for its persistence. The volume is configured regardless of what might be written in the `docker run` command. None of the instructions in the Dockerfile will be able to make changes in the directory's tree. Paths from the host cannot be used (these are anonymous volumes). (Recommendation: create named volumes in the `docker run` command)

- `USER <user name>[:group name>]`: it specifies the username (or UID) and, optionally, the user's group (or GID) to be used when running the image and executing the Dockerfile's instructions.

- `EXPOSE <port> [<port>/<protocol>]`: it informs Docker that the container will listen on the specified network ports at runtime, allowing other containers to communicate with this one. The port is not published for processes outside of Docker (that has to be done in the `docker run` command). By default, the protocol is TCP.

- `ENTRYPOINT`: it specifies an instruction for the container to execute when it starts running. There is always one; if none are specified in the Dockerfile or `docker run`, it's `/bin/sh -c`. If an executable is run, it will use the arguments passed to `docker run`, or the ones the CMD instruction contains. If CMD is used, it *must* be below ENTRYPOINT. There are 2 ways to use ENTRYPOINT:
  - Exec form: `ENTRYPOINT ["command or executable file", "argument 1", "argument 2", ..., "argument N"]` -> it uses the specified arguments _and_ the ones in the CMD instruction or `docker run`.
  - Shell form: `ENTRYPOINT <command> <argument 1> <argument 2> ... <argument N>` -> it ignores any other arguments.

- `CMD`: it specifies an instruction for the container to execute when it starts running, although if there is another instruction defined in `docker run` then that one will be used. There can only be *one* CMD in the same Dockerfile. There are three ways to use it:
  - Exec form: `CMD ["command or executable file", "argument 1", "argument 2", ..., "argument N"]` -> the executable is run directly, without any shell processing.
  - Shell form: `CMD <command> <argument 1> <argument 2> ... <argument N>` -> the command is run as `/bin/sh -c <command + arguments>`, applying shell utilities like environment variables replacement and allowing the use of backslashes (`\`) to continue with the CMD instruction in the Dockerfile's next line.
  - Arguments for `ENTRYPOINT`: `CMD ["argument 1", "argument 2", ..., "argument N"]` -> it is used when a `ENTRYPOINT` is specified, giving it default arguments in case the container is not provided with them.


### Some Docker commands
`docker ps` -> shows running containers (adding `-a` at the end makes it show stopped containers as well)


`docker images` -> shows a list of existing images in the computer


`docker pull {image name}` -> downloads the image from dockerhub, avoiding having to do it when setting up containers with that image


`docker build -t {custom name for the image} [--build-arg {variable name}={value}] .` -> creates an image using a Dockerfile and, optionally, uses one or more variables received as arguments (they replace variables previously set with the same name in the Dockerfile through the ARG instruction)


`docker run -dit -p 80:80 [--env-file={env_file name}] [--name {custom name for container}] {image name}[:tag] [{command}] [--entrypoint {entrypoint}]` -> sets up a container based on an image (and, optionally, a tag for that image); it is also possible to give the container a name, a command and/or an entrypoint (which will replace the Dockerfile's), and provide an env_file so Docker can read its variables

- `-d`: sets up the container in detached mode, so it runs in the background instead of attaching to the terminal (if the terminal is killed, the container stops as well)
- `-t`: allocates a pseudo-tty (text input output environment) that sh/bash can use (e.g. `docker run ubuntu:14.04` would stop instantly because it would be unable to use a terminal and have nothing to do)
- `-i`/`--interactive` allows to send commands to the container through standard input ("STDIN"); interactive processes require the use of both -i and -t (-it) together in order to allocate a tty for the container
- `-p`: especifica el puerto a utilizar en el host, y el puerto a utilizar en el contenedor
- `-p`: takes a port from the host and a port from the container, and exposes the latter so it becomes reachable from the host
  - `--expose` instead of `-p`: the container can only be accessed from other Docker containers (using `-p` uses `--expose` implicitly)
- `--env-file`: specifies an env_file's name, which is a file that contains one or more environment variables to use in the container; if an env var were to already exist because it was created by the Dockerfile, it is replaced



`docker start {container id}` -> starts a stopped container


`docker stop {container id}` -> stops a running container

- Difference between `stop` and `kill`:
  - Stop: the container's main process receives the SIGTERM signal and, after a grace period, SIGKILL
  - Kill: the container's main process receives the SIGKILL signal, or another one specified with `--signal {signal}`
- In both cases, changes to the filesystem will be persisted, so using `docker start` will find it as it was before

Extra: `docker stop $(docker ps -q)` -> looks for every running container and stops them one by one


`docker rm {container id}` -> deletes the container

- `--force`: it's necessary if the container is still running


`docker rmi {image id}` -> deletes the image


`docker run -d -p 80:80 -v {name for the volume}:{path in container} {image name}`

- Using `-v`, a named volume is created
  - Since `-v` can be used regardless of whether a VOLUME was declared or not in the Dockerfile, and volumes declared in a Dockerfile might have confusing side effects, it is generally advisable to only create them with `docker run -v`.
- Instead of a name for the volume, a path from the host can be specified so data can be shared. This is known as a bind mount, and it is easy to know where said data will be stored when the container decides to write in the specified host path.


`docker rm -v {container id}` -> borra el container + sus volúmenes (se pueden especificar cuáles volúmenes borrar y cuáles mantener)
`docker rm -v {container id}` -> deletes the container along with all its volumes (it is possible to add the names of specific volumes so the rest are kept intact)


`docker exec -it {container id} {command}` -> a command is executed in the container


`docker logs {container id}` -> shows the container's logs

- `-t`: shows timestamps for every line
- `-f`: also follows the output instead of just showing the output and finishing
- `--tail {number}`: amount of lines to show, starting from the bottom (without this flag, the command shows all of them)


`docker inspect {container id}` -> shows all the container's information



## Docker Compose
It is a tool that allows you to easily manage multiple containers that are related to each other. It works by applying rules declared in a ".yml" configuration file; these rules are used for the services, every one of them is the representation of the configuration managed by Docker Compose that corresponds to a certain container.

Instead of using docker run, you merely need to run a compose command such as docker-compose up -d so all containers start one after the other.

Service != container. A container starts up based on a service defined in the ".yml" file, and there can be multiple containers being run per service.


### Installation
```
# At the time of writing (Dec. 2019), the current stable release of Docker Compose is 1.25.0. However, feel free to change it.
COMPOSE_VERSION=1.25.0
sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```


### Networks
Networks define communication rules between services, and between a container and its host. Docker containers on the same network can find each other and communicate.


### Dependencies between services
It is possible that a service needs to start before another one (e.g. the web application needs to communicate with the database's container at startup). You can set the dependency in the ".yml" file, specifying in a service's configuration which other service (or services) it needs to wait for before trying to start.


### Some compose commands
`docker-compose ps` -> shows all running containers related to the services from the `.yml` file


`docker-compose images` -> shows the containers and the images they use


`docker-compose up {services}` -> creates and starts the containers (it's a mix between the commands `create`, which has been deprecated, and `start`); if no services are specified, then all of them are chosen

- `-d`: the containers will be started in detached mode
- `--no-start`: the containers are not started, just created


`docker-compose build` -> (re)builds y tags the servicies (e.g. for when the Dockerfile is modified)


`docker-compose stop {services}` -> stops the services (`kill` can be used instead); if no services are specified, then all of them are chosen


`docker-compose restart {services}` -> resets the services; if no services are specified, then all of them are chosen


`docker-compose rm {services}` -> deletes stopped containers; if no services are specified, then all of them are chosen


`docker-compose down {services}` -> stops and deletes containers; if no services are specified, then all of them are chosen

- `-v`: also deletes the volumes declared in the .yml file


`docker-compose exec {service} {command}` -> executes a command inside the container

- `-T`: desactiva la asociación a una pseudo terminal (la cual le serviría para interactuar con ella tanto al usuario como a algunos programas)
- `-T`: disables pseudo-tty allocation

- Observación: asumiendo que dentro del contenedor existe un archivo "/tmp/prueba" no vacío, podemos intentar ejecutar el comando `docker-compose exec {servicio} cat /tmp/prueba > /tmp/prueba2` para que se cree un archivo en el mismo directorio padre con el mismo contenido. Esto no llevará a cabo el efecto esperado, sino que hará la creación y escritura del nuevo archivo en /tmp/prueba2 _dentro del host_ en vez de dentro del contenedor. Hay que poner el comando entero entre comillas y especificar que es un comando de bash, para que quede `docker-compose exec {servicio} bash -c "cat /tmp/prueba > /tmp/prueba2"` y Docker-Compose lo reconozca como un comando entero a ejecutar en el contenedor en vez de leer solamente `cat /tmp/prueba`.
- Observation: assuming there is a non-empty file "/tmp/test.txt" inside the container, we can try to run `docker-compose exec {service} cat /tmp/test.txt > /tmp/test2.txt` so a file with the same content is created. This will not get us to the desired outcome, but will create and write the new file in "/tmp/test2.txt" _inside the host instead of the container_. We need to edit the command so Docker Compose can recognize it as a single instruction instead of just reading `cat /tmp/prueba`; it would look like `docker-compose exec {service} bash -c "cat /tmp/test.txt > /tmp/test2.txt"`.


`docker-compose logs {service}` -> shows the container's log (even though more than one service can be specified, it is not recommended when their logs are too long for legibility reasons)
- `-t`: shows timestamps for every line
- `-f`: also follows the output instead of just showing the output and finishing
- `--tail {number}`: amount of lines to show, starting from the bottom (without this flag, the command shows all of them)


<br>

For any Docker compose commands, the option `-f {path to a .yml file}` can be used so its configuration is read

- Compose searches for a file named `docker-compose.yml` or `docker-compose.yaml` by default; however, a file with a different name can be used through this option.

- This option can be used more than once; it looks for multiple files and adds their configurations.

______________

## When not to use Docker (examples):

- You want to maximize your application's performance (even though it has less overhead than virtual machines, it is not zero)
- You consider security as a critical consideration: keeping different components isolated in containers has its benefits, but brings a bit of trouble to the table; container technology has access to the kerlen's subsystems (so a "kernel panic" caused by a container will affect the host as well) and its resources (if a container can monopolize some of the resources, it might affect the other containers, facilitating a denial-of-service attack because there would be inaccessible parts of the system), and if an attacker manages to access a container and escape from it entering another one (or even the host), he will have the same user privileges he had in the first container he got inside of (which makes  having the root user as a default difficult to recommend)
- Having a GUI for everything is a must; containers run on terminals and, even though there are some tricks you can use (such as X-forwarding or VNC), they are somewhat ugly and difficult to manage.
