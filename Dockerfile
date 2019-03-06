# Version: 1.0.0
FROM ubuntu:16.04
MAINTAINER Matias Andres "matias@forma2.net"
RUN apt-get update; apt-get install -y nginx
RUN echo 'Esto se escribe desde el container' \
>/var/www/html/index.html
EXPOSE 80
