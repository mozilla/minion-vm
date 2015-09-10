# minion-vm
Vagrantfile and Dockerfiles to make developing against [Mozilla Minion](https://github.com/mozilla/minion) far easier.

**minion-vm** automatically installs the following Minion components:
* https://github.com/mozilla/minion-backend
* https://github.com/mozilla/minion-frontend
* https://github.com/mozilla/minion-nmap-plugin

Configuring minion-vm
---------------------
Prior to installation, it is necessary to edit `backend.sh` to change the default administrator's email address and name:

```
MINION_ADMINISTRATOR_EMAIL="youremail@yourorganization.org"
MINION_ADMINISTRATOR_NAME="Your Name"
```

Configuring Vagrant
-------------------
* Edit the BACKEND\_SRC, FRONTEND\_SRC, and APT\_CACHE\_SRC variables in `Vagrantfile` to point to their locations on your local system
* Edit the IP addresses in `Vagrantfile` and `vagrant-hosts.sh` if you want your private network to use something besides 192.168.50.49 and 192.168.50.50

Running Vagrant
---------------
```
$ vagrant up
```

That's it! The Minion frontend should now be accessible at http://192.168.50.50:8080, or whatever you set the IP address to.

You can also ssh into your new Minion instances with `vagrant ssh minion-frontend` and `vagrant ssh minion-backend`.

Configuring Docker
------------------
```
$ docker build -t 'mozilla/minion-backend'  -f Dockerfile-backend  .
$ docker build -t 'mozilla/minion-frontend' -f Dockerfile-frontend .
```

Running Docker
--------------
```
$ docker run -d --name 'minion-backend' 'mozilla/minion-backend'
$ docker run -d -p 8080:8080 --name 'minion-frontend' --link minion-backend:minion-backend 'mozilla/minion-frontend'
```

The Minion frontend should now be accessible over HTTP at the IP address of the system running Docker, on port 8080.

You can also get a shell on your new Minion instances with `docker exec -i -t minion-frontend /bin/bash` and
`docker exec -i -t minion-backend /bin/bash`.
