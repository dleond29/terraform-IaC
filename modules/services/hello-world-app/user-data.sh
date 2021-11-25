#!/bin/bash

cat > index.html <<EOF
<h1>${server_text}</h1>
<p>DB address: ${db_address}</p>
<p>DB port: ${db_port}</p>
EOF

nohup busybox httpd -f -p ${server_port} &

#Instalar servidor web apache
#!/bin/sh
apt-get update
apt-get install -y apache2
service start apache2
chkonfig apache2 on
echo "<html><h1>Welcome to Aapache Web Server</h2></html>" > /var/www/html/index.html 

#Instalar unzip
apt-get install -y unzip

#Instalar aws cliv2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#Descargar el backend desde S3
wget https://backendgrupo7c5.s3.amazonaws.com/digitalbooking-0.0.1-SNAPSHOT.jar

#Instalar el jdk
apt-get install -y openjdk-11-jre-headless

# #Ejecutar el backend en el servidor
# java -jar digitalbooking-0.0.1-SNAPSHOT.jar

