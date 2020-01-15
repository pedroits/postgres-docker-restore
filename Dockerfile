FROM alpine:3

RUN apk update
RUN apk add postgresql
RUN rm -rf /var/cache/apk/*

RUN mkdir /etc/postgresql
RUN mkdir /etc/postgresql/data
RUN mkdir /run/postgresql
RUN chown postgres -R /etc/postgresql
RUN chown postgres -R /run/postgresql
RUN chown postgres -R /var/log/postgresql

ARG BACKUP_PATH=backup.db
ARG DB_NAME=postgres

USER postgres

ENV TZ=America/Sao_Paulo
ENV PGDATA /etc/postgresql/data/
ENV DB_NAME $DB_NAME

RUN initdb

COPY conf/pg_hba.conf ${PGDATA}
COPY conf/postgresql.conf ${PGDATA}

COPY $BACKUP_PATH /etc/postgresql/backup.db
COPY conf/restore.sh /etc/postgresql/

EXPOSE 5432

CMD ["postgres"]
