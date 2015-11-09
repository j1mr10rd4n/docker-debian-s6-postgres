# A Debian/Postgres image for Docker

[![](https://badge.imagelayers.io/j1mr10rd4n/docker-debian-s6-postgres:latest.svg)](https://imagelayers.io/?images=j1mr10rd4n/docker-debian-s6-postgres:latest 'Get your own badge on imagelayers.io')

Docker-debian-s6-postgres is a [Docker](https://www.docker.com) image that runs a [PostgreSQL](http://www.postgresql.org) database supervised by the [s6 supervision suite](http://skarnet.org/software/s6) based on [docker-debian-s6](https://github.com/j1mr10rd4n/docker-debian-s6).

The postgres installation was ported from the [official postgres image](https://hub.docker.com/_/postgres/) and modified to run postgres under s6. This means other processes (e.g. sshd) could be run within the same container.
Postgres logging is set to /var/log/postgres/ using the [s6-log](http://skarnet.org/software/s6/s6-log.html) service.

## Still to do:
* Make sure that setting a non-blank database user password works as per the official postgres image, and output a warning if it is not set. One of the changes in this image is that messages are logged to the s6-log catchall log, meaning a user won't see them at their terminal on container initialization.
* Parameterizing postgres configuration, e.g. log levels etc.

