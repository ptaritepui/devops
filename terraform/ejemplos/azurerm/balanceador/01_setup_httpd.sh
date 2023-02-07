#!/bin/bash
dnf -y install httpd
cp /usr/share/httpd/noindex/index.html /var/www/html/
for service in httpd firewalld;
do
    systemctl enable ${service} --now
done
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload
