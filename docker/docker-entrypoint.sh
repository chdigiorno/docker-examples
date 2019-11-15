#!/bin/bash
python ejemplo_de_django_en_docker/manage.py makemigrations
python ejemplo_de_django_en_docker/manage.py migrate
echo "Levantando aplicación! (Esto solamente va a poder verse dentro del contenedor si se usa el modo detachado - usar docker logs)"
python ejemplo_de_django_en_docker/manage.py runserver 0.0.0.0:8009 # Levanto la aplicación Django en el puerto 8009 del container (no confundir con el puerto 8009 del host)