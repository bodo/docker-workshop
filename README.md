

# Overview

This repo contains a few directories with various use-cases.
From step to step we add/implement another best-practise.
Skip into any step or try them one by one.

The examples and their use-case are:

1. 01_alpine-top shows a one-of tool that is available in common linux distro. Stateless, no daemon, no network, no compiler, no run-time.
2. 02_go-hello-multistage compiles a GO source code and transfers only the executable into a final image. No GO compiler left in the final image. Tiny size!
3. 03_go-hello-bake uses a better build system. You could 'compile' your SASS CSS etc into a frontend image and similar for backend image. So bundle multiple multi-stage builds, for example. Also useful for multi-image and/or multi-arch.
4. 04_js-todo-compose is a multi-container App with docker-compose. The App is implemented in JS, so it is based on a run-time container (NodeJS)


## 01_alpine-top

The bare minimum. Build a container from a tiny base image (alpine).

Have a look at the file `Dockerfile`.
```Shell
# build it
docker build . -t top

# run it
docker run top
```

If you adjust the content of the `Dockerfile` you most likely also want change the image name, so the TAG, `-t`. 

## Cleanup

``` Shell
docker image rm top 
```

Ooops. This didn't work!

`Error response from daemon: conflict: unable to delete top:latest (must be forced) - container 725eb4420a70 is using its referenced image 4ee6b460d5d5`

- Should we use the force?
- Do we need this container? 

It depends. 😉

a) You can go to Docker Desktop, container and copy the ID (here: `725eb4420a70`) in the search bar.
Also you can delete it there.

Or:

b)
```Shell
# list all running containers
docker ps

# list also the stopped ones, -a as in 'all'
docker ps -a

# -l as in 'latest'
docker ps -l

# in case you ran the image _many_ times (without --rm)
# find all (-a) containers but filter to those from image "top"
docker ps -a --filter "ancestor=top"

# May the force be with you! -f
docker image rm -f top
# Beware: you remove the image and (maybe) leave containers (of this image) behind. #fail
# Docker Desktop let you easily find and remove these too. #fixed
```

> ### Learning, thinking, what can be improved
> 1. When you build, you must specify the name (tag) of the resulting image!
> 2. Running the `top` image just shows _one_ process. Why?
> 3. About point 1, we'll handle this in example 03.
> 4. When we ran the image, it created a container.  (ID: 725eb4420a70)
> 5. run your one-of containers with 'remove': `docker run --rm top`


# ENTRYPOINT vs CMD

Edit the Docker file (last line) to:
``` Dockerfile
ENTRYPOINT ["top"]
CMD ["-b"]
```

then `docker build . -t top`

The difference:
```Shell
# this uses ENTTYPOINT _and_ CMD
docker run --rm top

# this uses ENTRYPOINT _but_ CMD gets overridden by the `--help` argument
docker run --rm top --help
```

> ### Learning
> - put params _into_ `ENTRYPOINT` if you want to enforce them
> - move args that you are 'reasonable defaults' into a following `CMD`.
> - 

## 02_go-hello-multistage

Let's compile and containerize our own app!
Yeah, a tiny one, but can be the start of your single container app.
        
``` Shell
docker build . -t helloworld

docker run --rm helloworld
```

On first sight, it looks the same.
Study the Dockerfile.

> ### Learning
> It works in two steps!
> 1. Download a Docker Container with the GO language compile. Copy the source code into it and compile.
> 2. Copy the binary executable into our final image.


> [!CAUTION]
> `docker build` is the legacy system, `docker buildx`is the current approach.
> As of now `build` uses `buildx` internally, beware of slight differences! See the Buildx reference.


## 03_go-hello-bake

Have a look at docker-bake.hcl.
Looks like a traditional Makefile?
Right.

```Shell
# just build the "cli" target
docker buildx bake cli

# no target = default
# either target "default" or group "default"
docker buildx bake
```

> ### Learning
> 1. Now all the build details of a complex, multi-stage scenario are in one file, no shell scripts needed.
> 2. Use this to generate multiple outputs, multiple architectures.



## 04_js-todo-compose

Now let us 'compose' a web app which needs a SQL database.
Remember: one service = one container.
The directory is empty, let's get the content ...

```Shell
# download the source code from Docker's official examples repo
cd 04_js-todo-compose
git clone https://github.com/dockersamples/todo-list-app .

# build & run
docker compose up -d --build

# visit http://localhost:3000/
```

http://localhost:3000/


> ### Learning
> 1. We can run and build (if necessary) in one step. 
> See: `docker compose up --help`
> 2. `-d` puts the container in the background (daemon), so our terminal is not blocked.
> 3. The app and the MySQL Server are connected with a _private_ network!
> 4. Only the JS App exposes one TCP/IP Port! MySQL is unreachable from the outside!

> [!TIP]
> 1. one project = directory
> 2. Have your directory structure clean & separated:
> README, compose.yaml, /src, /.docker

