# FROM alpine:3.18

# RUN apk update && apk upgrade && apk add --no-cache \
	# nginx

FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	nginx \
	openssl

COPY default /etc/nginx/sites-available/default

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=ES/ST=Madrid/L=Madrid/O=42Madrid/OU=Student/CN=localhost"

# Ensure proper permissions
RUN chmod 600 /etc/ssl/private/nginx-selfsigned.key && \
	chmod 644 /etc/ssl/certs/nginx-selfsigned.crt

CMD [ "nginx", "-g", "daemon off;" ]