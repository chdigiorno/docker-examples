# If a docker build is run without the argument "--build-arg PYTHON_VERSION={desired python version}", the version in PYTHON_VERSION is used by default
ARG PYTHON_VERSION=3.7
FROM python:$PYTHON_VERSION

RUN mkdir /app
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
RUN django-admin startproject django_in_docker_example
RUN sed -i "s/^ALLOWED_HOSTS.*/ALLOWED_HOSTS = \['\*'\]/" django_in_docker_example/django_in_docker_example/settings.py

COPY docker-entrypoint.sh /app
RUN chmod 777 /app/docker-entrypoint.sh
ENTRYPOINT ["/app/docker-entrypoint.sh"]
