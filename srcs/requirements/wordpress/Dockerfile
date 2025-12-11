# FROM alpine:3.18

# RUN apk update && apk upgrade && apk add --no-cache \
# 	php-fpm \
# 	php-mysqli \
# 	curl

FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	php8.2-fpm \
	php8.2-mysql \
	curl

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/script.sh .
RUN chmod +x /script.sh

CMD [ "./script.sh" ]