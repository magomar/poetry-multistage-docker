# Multistage Docker image for Poetry
# Based on https://github.com/michaeloliverx/python-poetry-docker-example/blob/master/docker/Dockerfile

######################### PYTHON-BASE #######################################
# Provides python and libraries for building packages

FROM python:3.10.10-slim as python-base
ENV PYTHONUNBUFFERED=true \
    PYTHONDONTWRITEBYTECODE=true \
    PIP_NO_CACHE_DIR=false \
    PIP_DISABLE_PIP_VERSION_CHECK=true \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=true \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv" \
    APP_PATH="/app"

# prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

######################### BUILDER #######################################
# Provides virtual environment with runtime dependencies to build the project
# Uses poetry to create venv (internally, inside the project) and mangage project dependencies

FROM python-base as builder-base
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        build-essential

# install poetry in $POETRY_HOME
RUN curl -sSL https://install.python-poetry.org | python3 -

# copy project requirement files here to ensure they will be cached.
# and install runtime dependencies using poetry (--only main implies
WORKDIR $PYSETUP_PATH
COPY ./poetry.lock ./pyproject.toml ./
RUN poetry install --only main --no-root

########################### PRODUCTION #########################################
# Provides a production ready image

FROM python-base as production
ENV FASTAPI_ENV=production
# copy venv from builder image
COPY --from=builder-base $VENV_PATH $VENV_PATH
WORKDIR $APP_PATH
# copy assets, config file and entry point
COPY config.yaml .
COPY assets ./assets
COPY docker/entrypoint.sh .
RUN chmod +x ./entrypoint.sh
COPY pegasus_eq_metrics .

ENTRYPOINT ./entrypoint.sh $0 $@
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "80"]