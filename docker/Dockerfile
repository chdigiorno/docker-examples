# Si se lleva a cabo un docker build sin el parámetro "--build-arg PYTHON_VERSION={versión deseada de python}, se usa el ARG PYTHON_VERSION por default
ARG PYTHON_VERSION=3.7
FROM python:$PYTHON_VERSION

RUN mkdir /app
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
RUN django-admin startproject ejemplo_de_django_en_docker
RUN sed -i "s/^ALLOWED_HOSTS.*/ALLOWED_HOSTS = \['\*'\]/" ejemplo_de_django_en_docker/ejemplo_de_django_en_docker/settings.py
RUN python ejemplo_de_django_en_docker/manage.py migrate

CMD ["python", "ejemplo_de_django_en_docker/manage.py", "runserver", "0.0.0.0:8009"]  # Levanto la aplicación Django en el puerto 8009 del container (no confundir con el puerto 8009 del host)
