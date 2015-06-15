# minion-vagrant
Vagrantfile and Dockerfiles to make developing against Mozilla Minion far easier.

Mozilla Minion is available:
* https://github.com/mozilla/minion
* https://github.com/mozilla/minion-backend
* https://github.com/mozilla/minion-frontend

# To configure Vagrant:
* Edit the BACKEND\_SRC, FRONTEND\_SRC, and APT\_CACHE\_SRC variables in `Vagrantfile` to point to their locations on your local system
* Edit the IP addresses in `Vagrantfile` and `hosts.sh` if you want your private network to use something besides 192.168.50.49 and 192.168.50.50
* Edit `backend.sh` to change the default administrator's email address and name

# To run Vagrant:
* `vagrant up`

That's it!  You can ssh into your new (and hopefully fully-functioning) Minion instances with `vagrant ssh minion-frontend` and `vagrant ssh minion-backend`.

You can also access the minion-frontend web site at http://192.168.50.50:8080 (or whatever you set the IP to).

# To configure Docker:
* `docker build -t 'mozilla/minion-backend'  -f Dockerfile-backend  .`
* `docker build -t 'mozilla/minion-frontend' -f Dockerfile-frontend .`

# To run Docker:
* `docker run -d --name 'minion-backend' 'mozilla/minion-backend'`  (note that it will take some time to come up)
* `docker run -d -p 8080:8080 --name 'minion-frontend' --link minion-backend:minion-backend 'mozilla/minion-frontend'`
