FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

run apt-get install -y 


# python 2.7
RUN apt-get update -qq && apt-get upgrade -y -qq
RUN apt-get install -y python2.7 python-pip
RUN apt-get install -y python-setuptools python-dev build-essential

# nginx
RUN \
  apt-get update && \
  apt-get install -y nginx-light && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

RUN pip install supervisor
RUN pip install gunicorn

# nginx volumes
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]
# supervisord volumes
VOLUME ["/etc/supervisor/conf.d/"]


EXPOSE 80
EXPOSE 443


ADD supervisor/supervisord.conf /etc/supervisor/supervisord.conf

RUN useradd supervisor
RUN mkdir -p /var/log/supervisor/ && chown -R supervisor: /var/log/supervisor/


CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]



