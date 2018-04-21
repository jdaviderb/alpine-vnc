#!/bin/sh

mkdir -p /tmp/autofirma
cd /tmp/autofirma
wget http://estaticos.redsara.es/comunes/autofirma/currentversion/AutoFirma_Linux.zip
unzip AutoFirma_Linux.zip
ar x AutoFirma_*.deb
tar xzvf *.tar.gz
tar xvf *.tar.xz
./preinst
cp -R ./etc /
cp -R ./usr /
./postinst

cd /tmp/utils
dos2unix AutoFirma
dos2unix certInfo.txt
dos2unix autofirma_policy.json
cp /tmp/utils/AutoFirma /usr/bin/AutoFirma
chmod 777 /usr/bin/AutoFirma

mkdir -p /tmp/certs
cd /tmp/certs
openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem < /tmp/utils/certInfo.txt
#openssl x509 -text -noout -in certificate.pem
openssl pkcs12 -inkey key.pem -in certificate.pem -export -out certificate.p12 -passout pass:
#openssl pkcs12 -in certificate.p12 -noout -info

mkdir -p /home/alpine/.pki/nssdb
sudo -u alpine certutil -d sql:/home/alpine/.pki/nssdb --empty-password
sudo -u alpine certutil -d sql:/home/alpine/.pki/nssdb -A -t "CT,c,c" -n /usr/local/share/ca-certificates/AutoFirma_ROOT.crt -i /usr/local/share/ca-certificates/AutoFirma_ROOT.crt
sudo -u alpine pk12util -d sql:/home/alpine/.pki/nssdb -i certificate.p12 -W ""

mkdir -p /etc/opt/chrome/policies/managed
chmod -w /etc/opt/chrome/policies/managed
cp /tmp/utils/autofirma_policy.json /etc/opt/chrome/policies/managed/autofirma_policy.json

 