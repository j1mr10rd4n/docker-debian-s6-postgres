FROM j1mr10rd4n/docker-debian-s6:8.2.1
MAINTAINER Jim Riordan <jim@j1mr10rd4n.info>

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

ENV PG_MAJOR 9.4
ENV PG_VERSION 9.4.5-1.pgdg80+1

# explicitly set user/group IDs before postgres install
RUN groupadd -r postgres --gid=999 && useradd -r -g postgres --uid=999 postgres

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update \
	&& apt-get install -y postgresql-common \
	&& sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf \
	&& apt-get install -y \
		postgresql-$PG_MAJOR=$PG_VERSION \
		postgresql-contrib-$PG_MAJOR=$PG_VERSION

ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
ENV PGDATA /var/lib/postgresql/data

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql
 #&& mkdir -p /var/log/postgresql && chown -R nobody:nogroup /var/log/postgresql && chmod g+s /var/log/postgresql

ENV S6_LOGGING 1

VOLUME /var/lib/postgresql/data
VOLUME /var/log/postgresql

RUN echo $PGDATA 'true postgres 0600 0700' > /etc/fix-attrs.d/01-postgresql-data-dir
RUN echo '/var/log/postgresql true nobody 0600 0770' > /etc/fix-attrs.d/02-postgresql-log-dir

COPY service-scripts/postgres-init /etc/cont-init.d/01-postgres-init
COPY service-scripts/postgres-run /etc/services.d/postgres/run
COPY service-scripts/postgres-log /etc/services.d/postgres/log/run

EXPOSE 5432
