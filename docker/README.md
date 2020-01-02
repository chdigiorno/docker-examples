As the first step you'll want to build the image, giving it a specific name.

Try doing it by yourself. Just in case, I'm leaving the command in the following line:

`docker build -t django_in_docker_example .`

What now? Well, you will see there are three bash scripts in this directory named "setup_image_..."; each and every one of them is a different version of a `docker run`, and the amount of arguments increases along with the version's number. These scripts will setup a container named "dd".

Run the v1 script. Once it's done, it will be evident that the container is not being run in detached mode, since it took over the terminal. Oh, well. Anyway, read the script's contents and try entering your app's URL. There are two ports there... but the URL only uses one of them. If you remember which one is which, you should be able to see Django's home page with the little ship and whatnot. This means it worked!

Now that you are done with the first version, let's go for the second one. Check it out; there is something different. Naturally, it will fail if you try to run it immediately because there already is a container named "dd" running. Destroy it and run the second script.

And now, version 3! You need to do pretty much the same as before. Once the container starts running, get inside (`docker exec -it dd bash`). If you were paying attention to the script's content, you'll notice a volume is specified in the `docker run`; that means the three ".txt" files inside "volume_content/" should be in the container as well.

_____

Feel free to create your own setup scripts using everything you have learned so far. Also, you can change the Dockerfile to create new images with more stuff.
