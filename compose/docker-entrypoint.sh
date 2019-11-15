#!/bin/bash
sleep 3 # Aunque web depende de db, y se setea el orden para levantar los contenedores, web no sabe que, para funcionar, necesita que la base de datos esté levantada, así que ponemos un speel de 3 segundos
cd ejemplo_de_django_en_docker_compose
python manage.py makemigrations
python manage.py migrate

if [[ $(echo "from django.contrib.auth.models import User; print(len(User.objects.filter(username='$superuser_name')))" | python manage.py shell) == 0 ]] ; 
then 
	echo "Creando superuser"
	echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('$superuser_name', '$superuser_mail', '$superuser_pass')" | python manage.py shell 
	if [[ $(echo "from django.contrib.auth.models import User; print(len(User.objects.filter(username='$superuser_name')))" | python manage.py shell) != 0 ]] ; 
	then
		echo "Superuser $superuser_name creado exitosamente!"
	else
		echo "Ocurrió un error creando el superuser"
	fi
else 
	echo "No se creará un superuser porque ya existe"
fi

echo "Levantando aplicación! (Esto solamente va a poder verse dentro del contenedor si se usa el modo detachado - usar docker logs)"
python manage.py runserver 0.0.0.0:8000