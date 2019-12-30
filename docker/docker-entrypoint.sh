#!/bin/bash
python django_in_docker_example/manage.py makemigrations
python django_in_docker_example/manage.py migrate
echo "Setting up the application! (If detached mode is used, you will only be able to read this in the logs)"
python django_in_docker_example/manage.py runserver 0.0.0.0:8009 # Setting up the Django app in the container's port 8009 (not to be confused with the host's 8009 port)