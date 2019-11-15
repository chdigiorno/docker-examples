# Si se lleva a cabo un docker build sin el parámetro "--build-arg PYTHON_VERSION={versión deseada de python}, se usa el ARG PYTHON_VERSION por default
ARG PYTHON_VERSION=3.7
FROM python:$PYTHON_VERSION

RUN mkdir /app
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
RUN django-admin startproject ejemplo_de_django_en_docker
RUN sed -i "s/^ALLOWED_HOSTS.*/ALLOWED_HOSTS = \['\*'\]/" ejemplo_de_django_en_docker/ejemplo_de_django_en_docker/settings.py

COPY docker-entrypoint.sh /app
RUN chmod 777 /app/docker-entrypoint.sh
ENTRYPOINT ["/app/docker-entrypoint.sh"]
