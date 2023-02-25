# VSCode & Docker Setup
Because sometimes you forget how easy the local environment *should* be.

### Setup

1. Install [VSCode](https://code.visualstudio.com/download)
2. Install the [official Docker VSCode Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
3. Install [Docker Engine](https://docs.docker.com/desktop/install/mac-install/)
4. Install & configure [VSCode official Python Extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python)


### Setup Flask App

1. `from flask import Flask` and include `flask[all]` and `gunicorn[standard]` in requirements.txt
2. Don't forget to initiate a sqlalchemy connection (here we just use in memory db to get started).

### Setup Docker
1. Use `From` and `AS` statements to define development vs production
2. Share resources (like deps if no prod deps) between layers
3. Build image with `docker build --rm -f "Dockerfile.prod" --target=development -t flaskdev:v0.0.1 .`
This builds an image using the `development` target, named `flaskdev` versioned `v0.0.1`.
4. Run image with `docker run -it -p 5000:5000/tcp flaskdev:v0.0.1`
This runs interactively (you see logs etc), closing the terminal session kills the container.
Flask wants to run on port 5000, here we tell Docker to foward the Host port 5000 -> 5000.
5. Primitive use of `bind-mount` will allow dependencies to be built in the Docker image, with
python files remaining on the local machine (host). This prevents the need to rebuild the image
with every change to application code `docker run -it --mount type=bind,source="$(pwd)"/app,target=/app -p 5000:5000/tcp flaskdev:v0.0.3`.

### Setup PostgreSQL Container
1. Leverage an [init sql file](/postgres/create.sql) to create default user & tables
2. Build the **local use only** image for postgres `docker build -f "Dockerfile.sql" -t psql:v0.0.1 .`
3. Run the postgres container, use `/postgres/data/` to store data locally. 
`docker run -it -p 5432:5432 --mount 'type=volume,source=pgdata,destination=/var/lib/postgresql/data' psql:v0.0.1`
4. Test the local PG container by connecting `docker exec -it <container_id> psql -h <container_id> -U myuser -d mydb`


### Nice things to think about

**Script** a quick hup tool to restart the GUnicorn server after file save timestamp changes in project dir.
This assumes no built-in from the IDE that can restart the webserver in a container (or some better means).
**Better** would be to use Docker --mount type=bind to include the local /app/ files, (see docker setup #5).
This utilizes the Flask dev mode to automatically hup the server when files are changed.

Test against different build patterns and `time $(build)` or something similar

Think on how to best use local deps and cache them in the container since `pip freeze > requirements.txt` is only a local -> container thing.

Look into the local K8s yaml setup to run services - command line options are long and get confusing, tweaking yml is fast.