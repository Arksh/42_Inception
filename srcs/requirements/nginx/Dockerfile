# FROM alpine:3.18

# RUN apk update && apk upgrade && apk add --no-cache \
	# nginx

FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	nginx \
	openssl

	
	# Generate self-signed SSL certificate
RUN mkdir -p /etc/ssl/private /etc/ssl/certs

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=ES/ST=Madrid/L=Madrid/O=42Madrid/OU=Student/CN=localhost" \
	-keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
	
# Ensure proper permissions
RUN chmod 600 /etc/ssl/private/nginx-selfsigned.key && \
	chmod 644 /etc/ssl/certs/nginx-selfsigned.crt

COPY conf/default /etc/nginx/sites-available/.
COPY tools/script.sh /script.sh

# RUN chmod +x /script.sh
# ENTRYPOINT [ "/script.sh" ]

CMD [ "nginx", "-g", "daemon off;" ]