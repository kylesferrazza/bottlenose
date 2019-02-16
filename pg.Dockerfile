FROM postgres:11.1

RUN chown -R postgres /var/lib/postgresql/data
RUN chmod 0750 /var/lib/postgresql/data
RUN echo "createuser -d bottlenose" > /docker-entrypoint-initdb.d/init-user.sh
