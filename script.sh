1.
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.78.0.0/16

2~ // pokoknya yang bikin dns pakek di bawah ini

echo nameserver 192.168.122.1 > /etc/resolv.conf

apt-get update
apt-get install bind9 -y

cp -r bind /etc/
service bind9 restart

5. // konekin klien 

echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install dnsutils -y
echo nameserver 10.78.1.2 > /etc/resolv.conf
echo nameserver 10.78.1.3 >> /etc/resolv.conf
apt-get install lynx -y
apt install apache2-utils -y

11.
root@Pochinki:~# cat /etc/bind/named.conf.options
# options {
#         directory "/var/cache/bind";

#         // If there is a firewall between you and nameservers you want
#         // to talk to, you may need to fix the firewall to allow multiple
#         // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

#         // If your ISP provided one or more IP addresses for stable
#         // nameservers, you probably want to use them as forwarders.
#         // Uncomment the following block, and insert the addresses replacing
#         // the all-0's placeholder.

#         forwarders {
#         192.168.122.1;
#         };

#         //========================================================================
#         // If BIND logs error messages about the root key being expired,
#         // you will need to update your keys.  See https://www.isc.org/bind-keys
#         //========================================================================
#         // dnssec-validation auto;
#         allow-query{any;};
#         auth-nxdomain no;    # conform to RFC1035
#         listen-on-v6 { any; };
# };

12.

echo -e "nameserver 10.78.1.2\nnameserver 10.78.1.3" > /etc/resolv.conf

apt-get update

apt-get install wget -y
apt-get install apache2 -y
apt-get install unzip -y
apt-get install libapache2-mod-php7.0 -y

wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=11S6CzcvLG-dB0ws1yp494IURnDvtIO$wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1xn03kTB27K872cokqwEIlk8Zb121Hn$
unzip dir-listing.zip -d dir-listing
unzip lb.zip -d lb

cp /root/lb/worker/index.php /var/www/html/index.php

service apache2 restart

// lainnya pakek nano buat konfig belum sempet ke scripting

13. s// ama kayak yang di atas

14. 

# worker

service apache2 stop

apt-get update
apt-get install nginx -y
apt install php php-fpm php-mysql -y
mkdir /var/www/jarkom
cp /root/lb/worker/index.php /var/www/jarkom/index.php

service php7.0-fpm start

service php7.0-fpm start

echo 'server {
        listen 80;

        root /var/www/jarkom;
        index index.php index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                try_files $uri $uri/ /index.php?$query_string;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        }

        location ~ /\.ht {
                deny all;
        }
}' > /etc/nginx/sites-available/jarkom

ln -s /etc/nginx/sites-available/jarkom /etc/nginx/sites-enabled/jarkom

rm /etc/nginx/sites-enabled/default

service nginx restart

# load balancer

service apache2 stop
apt-get update
apt-get install nginx -y
echo 'upstream backend {
  server 10.78.3.2; # Severny
  server 10.78.3.3; # Stalber
}

server {
  listen 80;
  server_name mylta.it29.com www.mylta.it29.com;

  location / {
    proxy_pass http://backend;
  }
}
' > /etc/nginx/sites-available/jarkom

ln -s /etc/nginx/sites-available/jarkom /etc/nginx/sites-enabled/jarkom

rm /etc/nginx/sites-enabled/default

service nginx restart

16. DI KONFIG PONCHIKI 

17.

# load balancer

rm /etc/nginx/sites-enabled/jarkom

echo 'upstream backend {
  server 10.78.3.2:14000; # Severny
  server 10.78.3.3:14400; # Stalber
}

server {
        listen 14000;
        listen 14400;
  server_name mylta.it29.com www.mylta.it29.com;

  location / {
    proxy_pass http://backend;
  }
}
' > /etc/nginx/sites-available/jarkom

ln -s /etc/nginx/sites-available/jarkom /etc/nginx/sites-enabled/jarkom

rm /etc/nginx/sites-enabled/default

service nginx restart

# worker benerin pakek nano 

cp /root/default /etc/nginx/sites-enabled/jarkom
service nginx restart

18. DI KONFIG PONCHIKI

19. 

cp -r /root/dr-listing/worker2 /var/www/jarkom/

echo -e "server {
        listen 14000;

        root /var/www/jarkom;
        index index.php index.html index.htm index.nginx-debian.html;
        server_name _;

        location / {
                try_files $uri $uri/ /index.php?$query_string;
        }

        location /worker2 {
                autoindex on;
                autoindex_exact_size off;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        }

        location ~ /\.ht {
                deny all;
        }
}" > /etc/nginx/sites-available/jarkom

20. 
echo -e "zone 'tamat.it29.com'{
        type master;
        file "/etc/bind/jarkom/tamat.it29.com";
}" >> /etc/bind/named.conf.local

cp /etc/bind/db.local /etc/bind/jarkom/tamat.it29.com
echo -e "
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     tamat.it29.com. root.tamat.it29.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      tamat.it29.com.
@       IN      A       10.78.3.2
www     IN      CNAME   tamat.it29.com.
@       IN      AAAA    ::1
" > /etc/bind/jarkom/tamat.it29.com

service bind9 restart