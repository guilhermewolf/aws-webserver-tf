#!/bin/bash
REGION=${REGION}
OS=$(cat /etc/os-release | grep "^NAME=" | cut -d'=' -f2 | tr -d '"')
SERVER_NAME=$(hostname)
INTERNAL_IP=$(hostname -I | awk '{print $1}')

yum install httpd -y
systemctl enable httpd
systemctl start httpd


printf '<h1 style="color: #5e9ca0;">Hello from the server: '$SERVER_NAME' </h1>
<h2 style="color: #2e6c80;">General Info:</h2>
<p>- Server Name: '$SERVER_NAME'<br />- Internal IP: '$INTERNAL_IP'<br />- OS: '$OS'<br />-AWS Region: '$REGION'</p>' | sudo tee /var/www/html/index.html
