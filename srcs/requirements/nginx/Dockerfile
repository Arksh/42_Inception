# FROM alpine:3.18

# RUN apk update && apk upgrade && apk add --no-cache \
	# nginx

FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	nginx

COPY default /etc/nginx/sites-available/default

CMD [ "nginx", "-g", "daemon off;" ]