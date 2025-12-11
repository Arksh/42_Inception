# FROM alpine:3.18

# RUN apk update && apk upgrade && apk add --no-cache \ 
	# mariadb

FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY conf/init.sql /etc/mysql/init.sql
COPY tools/script.sh .

RUN chmod +x ./script.sh
RUN mkdir /run/mysqld

CMD [ "./script.sh" ] 