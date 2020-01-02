Alright. There are 4 different versions of ".yml" configurations. Let's start with the first one. No setup scripts this time, though! Compose makes it easier to configure containers.

`docker-compose up -d` will use "docker-compose.yml" to setup the containers. This command will build web's image, since it does not exist yet.

...aaaaand done! It was pretty easy, huh? Keep in mind that the application is running in the host's 8000 port. If the home page doesn't load, give it a few seconds, the app might not be done starting up.

To try the other versions, kill the services with `docker-compose down` and now run the `up` command again, but specifying the ".yml" file you want to use (e.g. `docker-compose -f docker-compose-v2.yml -d`).

Don't forget that version 4 uses a volume. Check that the files exist in the container.

Lastly, there is a ".txt" file that shows what we'd have to do manually if we didn't use the entrypoint file. Inconvenient, right?

_____

There is not much left to be said. Play with the files however you want and write new ones to practice and keep learning.