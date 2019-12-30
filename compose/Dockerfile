# If a docker build is run without the argument "--build-arg PYTHON_VERSION={desired python version}", the version in PYTHON_VERSION is used by default
ARG PYTHON_VERSION=3.7
FROM python:$PYTHON_VERSION

RUN mkdir /app
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
RUN django-admin startproject django_in_docker_example_with_compose
COPY settings.py /app/django_in_docker_example_with_compose/django_in_docker_example_with_compose/settings.py  
# ^ This COPY saves us from having to run complex `sed`s, since we have to edit the DATABASES section (that was not necessary in the Docker example)

RUN echo $(find / -name settings.py)
RUN echo $(find / -name manage.py)
# RUN python django_in_docker_example_with_compose/manage.py migrate | We can't run the migrations yet because db's container is not up and running yet :(

COPY docker-entrypoint.sh /app
RUN chmod 777 /app/docker-entrypoint.sh
ENTRYPOINT ["/app/docker-entrypoint.sh"]
