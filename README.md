# Poetry managed Python CLI application ((Typer)) with Docker multi-stage builds

### This repo serves as a minimal reference on setting up docker multi-stage builds with poetry

### Requirements

- [Docker >= 17.05](https://www.python.org/downloads/release/python-381/)
- [Python >= 3.8](https://www.python.org/downloads/release/python-386/)
- [Poetry](https://github.com/python-poetry/poetry)

---
**NOTES**

- Run all commands from the project root
- The root module is `my_package` (with underscores between words), while the package is `my-package`. However, upon
  installation this package creates a binary named `myapp`. Please check `pyproject.toml` to see how to modify these names.

## Local development

Create the virtual environment and install dependencies with:

    poetry install

See the [poetry docs](https://python-poetry.org/docs/) for information on how to add/update dependencies.

Spawn a shell inside the virtual environment with

    poetry shell

Run commands inside the virtual environment with:

    poetry run my_package Bruce --city Gotham

It is also possible to execute commands as python scripts

    python my_package/main.py Bruce --city Gotham

Or as modules

    python -m my_package.main Bruce --city Gotham

We can omit the name of the `main` module thanks to `__main__.py` calling method `app()` from it.

    python -m my_package Bruce --city Gotham   

Furthermore, since have installed the package in our environment, we can simply execute (it is called `myapp`)

    myapp Bruce --city Gotham

To test locally you would execute test in the [scripts directory](/scripts).

    pytest tests/

We can also test it with coverage

    pytest --cov=my_package.main tests/

To uninstall the package

    poetry run pip uninstall my-package

---

## Docker

### Build

Build images with:

        docker build --tag poetry-docker:0.1.0 --file docker/Dockerfile . 

The Dockerfile uses multi-stage builds to run lint and test stages before building the production stage. If testing
fails the build will fail.

You can stop the build at specific stages with the `--target` option:

        docker build --tag poetry-docker:0.1.0 --file docker/Dockerfile --target <stage> .

For example, if we wanted to stop at the **test** stage:

        docker build --tag poetry-docker:0.1.0 --file docker/Dockerfile --target test .

If a target is not specified, the resulting image will be the last image defined, which in our case is the 'production'
image. Different images can be identified by different tags. For example, we can build separate images for development
and production, as follows:

    docker build --tag poetry-docker:dev --file docker/Dockerfile --target development .
    docker build --tag poetry-docker:0.1.0 --file docker/Dockerfile  .

### Run

By default, the development image will open a `bash` terminal when executed. So, to run it just execute the `docker run`
command without passing additional arguments. In development, it would be useful to mount the project folder in the
container by specifying a volume, which would result in the following command:

    docker run -it -v $PWD/.:/app poetry-docker:dev

To execute commands using the production imag append the python command to the `docker run` command

    docker run --rm  poetry-docker:0.1.0 python -m my_package Bruce --city Gotham

Or, since the package is also installed, simply pass the binary name

    docker run --rm  poetry-docker:0.1.0 myapp Bruce --city Gotham

To get a shell inside the production container execute:

     docker run -it --rm poetry-docker:0.1.0 bash

### Docker-compose

There is also a `docker-compose.yml` file to facilitate common docker tasks.

Build the development image

    docker-compose build dev

Build production image

    docker-compose build app

Run development image mounting local project folder in the container

    docker-compose run dev

Run production image and pass arguments to the entrypoint command

    docker-compose run app python -m my_package Bruce --city Gotham

Or use the installed binary

    docker-compose run app myapp Bruce --city Gotham