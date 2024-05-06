# Docker File for Auto-Deploy
FROM amazonlinux

RUN yum -y update && \
    yum -y install httpd

COPY COPY ./Application/. /var/www/html/

CMD ["/usr/sbin/httpd" , "-D" , "FOREGROUND"]

EXPOSE 80