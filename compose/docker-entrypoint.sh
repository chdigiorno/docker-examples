#!/bin/bash
sleep 3 # Even though web depends on db, and the order to set them up is specified, web does not really know that, in order to funcion well, it needs the database to be already running, so we put it to sleep por 3 seconds
cd django_in_docker_example_with_compose
python manage.py makemigrations
python manage.py migrate

if [[ $(echo "from django.contrib.auth.models import User; print(len(User.objects.filter(username='$superuser_name')))" | python manage.py shell) == 0 ]] ; 
then 
	echo "Creating superuser"
	echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('$superuser_name', '$superuser_mail', '$superuser_pass')" | python manage.py shell 
	if [[ $(echo "from django.contrib.auth.models import User; print(len(User.objects.filter(username='$superuser_name')))" | python manage.py shell) != 0 ]] ; 
	then
		echo "Superuser $superuser_name created successfully!"
	else
		echo "An error occurred while creating a superuser"
	fi
else 
	echo "A superuser will not be created because there is one already"
fi

echo "Setting up the application! (If detached mode is used, you will only be able to read this in the logs)"
python manage.py runserver 0.0.0.0:8000
