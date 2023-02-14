FROM docker.io/httpd:latest
COPY index.html /usr/local/apache2/htdocs/
COPY .htaccess /usr/local/apache2/htdocs/
COPY httpd.conf /usr/local/apache2/conf/
COPY .creds /usr/local/apache2/
COPY localhost.key /usr/local/apache2/
COPY localhost.crt /usr/local/apache2/
