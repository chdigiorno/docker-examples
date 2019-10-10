# Si se lleva a cabo un docker build sin el parámetro "--build-arg PYTHON_VERSION={versión deseada de python}, se usa el ARG PYTHON_VERSION por default
ARG PYTHON_VERSION=3.7
FROM python:$PYTHON_VERSION

RUN mkdir /app
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
RUN django-admin startproject ejemplo_de_django_en_docker_compose
COPY settings.py /app/ejemplo_de_django_en_docker_compose/ejemplo_de_django_en_docker_compose/settings.py
RUN echo $(find / -name settings.py)
RUN echo $(find / -name manage.py)
# RUN python ejemplo_de_django_en_docker_compose/manage.py migrate | No podemos correr el migrate porque el container de la db no está levantado :(
