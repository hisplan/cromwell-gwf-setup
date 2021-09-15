#!/bin/bash -e

# https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/
# https://coderwall.com/p/zvvgna/create-htpasswd-file-for-nginx-without-apache
# http://httpd.apache.org/docs/2.2/misc/password_encryptions.html

username="chunj"
pwdfile="password.txt"

printf "${username}:`openssl passwd -apr1 -in ${pwdfile}`\n" >> /etc/apache2/.htpasswd

echo "DONE."
