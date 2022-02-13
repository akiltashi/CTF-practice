sed -i '1ilocal all realuser trust' /etc/postgresql/10/main/pg_hba.conf
pg_ctlcluster 10 main start && \
  su postgres -c "psql -c 'ALTER SYSTEM SET track_activities=false;'" && \
  su postgres -c "psql -c 'ALTER USER postgres WITH ENCRYPTED PASSWORD \$\$`head /dev/urandom | tr -dc '0-9a-z' | fold -w 5 | head -n1`\$\$;'" && \
  pg_ctlcluster 10 main restart -m fast && \
  apache2ctl start
tail -f /var/log/apache2/access.log
