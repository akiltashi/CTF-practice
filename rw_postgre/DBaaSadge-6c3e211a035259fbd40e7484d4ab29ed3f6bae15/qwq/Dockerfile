FROM ubuntu:18.04

# add flag
COPY flag.txt readflag /
RUN chown 0:1337 /flag.txt /readflag && \
  chmod 040 /flag.txt && \
  chmod 2555 /readflag

# set timezone
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install tzdata
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

# install PostgreSQL, PHP and cURL
RUN apt-get install -y postgresql-10 postgresql-10-mysql-fdw apache2 libapache2-mod-php php-pgsql curl

USER postgres
RUN pg_ctlcluster 10 main start && \
  psql -c " \
    CREATE USER realuser WITH NOSUPERUSER ENCRYPTED PASSWORD 'realpass'; \
    ALTER ROLE realuser SET statement_timeout=10000; \
    GRANT ALL PRIVILEGES ON DATABASE postgres TO realuser; \
    CREATE EXTENSION dblink; CREATE EXTENSION mysql_fdw; \
    GRANT USAGE ON FOREIGN DATA WRAPPER mysql_fdw TO realuser;" && \
  pg_ctlcluster 10 main stop -m fast

USER root
