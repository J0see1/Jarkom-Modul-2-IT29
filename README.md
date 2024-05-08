# Praktikum-Jarkom-Modul-2

# Anggota

| Nama                            | NRP          |
| ------------------------------- | ------------ |
| Marcelinus Alvinanda Chrisantya | `5027221012` |
| Bintang Ryan Wardana            | `5027221022` |


# Setup Topologi

![alt text](./image/image.png)

Buat topologi seperti di atas sesuai dengan yang ditentukan. 

## 1. Setup node

Untuk membantu pertempuran di Erangel, kamu ditugaskan untuk membuat jaringan komputer yang akan digunakan sebagai alat komunikasi. Sesuaikan rancangan Topologi dengan rancangan dan pembagian yang berada di link yang telah disediakan, dengan ketentuan nodenya sebagai berikut :
1. DNS Master akan diberi nama Pochinki, sesuai dengan kota tempat dibuatnya server tersebut
2. Karena ada kemungkinan musuh akan mencoba menyerang Server Utama, maka buatlah DNS Slave Georgopol yang mengarah ke Pochinki
3. Markas pusat juga meminta dibuatkan tiga Web Server yaitu Severny, Stalber, dan Lipovka. Sedangkan Mylta akan bertindak sebagai Load Balancer untuk server-server tersebut

Setup masing masing node seperti di bawah ini:

## Router

### Erangel
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 10.78.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.78.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.78.3.1
    netmask 255.255.255.0

```
## DNS Node

### Pochinki - DNS Master

```
auto eth0
iface eth0 inet static
    address 10.78.1.2
    netmask 255.255.255.0
    gateway 10.78.1.1

```

### Georgopol - DNS Slave

```
auto eth0
iface eth0 inet static
    address 10.78.1.3
    netmask 255.255.255.0
    gateway 10.78.1.1

```

## Client 

### Rozhok

```
auto eth0
iface eth0 inet static
    address 10.78.2.2
    netmask 255.255.255.0
    gateway 10.78.2.1
```

### School

```
auto eth0
iface eth0 inet static
    address 10.78.2.3
    netmask 255.255.255.0
    gateway 10.78.2.1
```

### FerryPier

```
auto eth0
iface eth0 inet static
    address 10.78.2.4
    netmask 255.255.255.0
    gateway 10.78.2.1
```

## Web Server

### Serverny
```
auto eth0
iface eth0 inet static
    address 10.78.3.2
    netmask 255.255.255.0
    gateway 10.78.3.1
```

### Stalber

```
auto eth0
iface eth0 inet static
    address 10.78.3.3
    netmask 255.255.255.0
    gateway 10.78.3.1
```

### Lipovka

```
auto eth0
iface eth0 inet static
    address 10.78.3.4
    netmask 255.255.255.0
    gateway 10.78.3.1
```

## Load Balancer

### Mylta

```
iface eth0 inet static
    address 10.78.2.5
    netmask 255.255.255.0
    gateway 10.78.2.1
```

## Sebelum memulai mengerjakan konfigurasi dari node lain, pastikan node router sudah tersambung ke internet

```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.78.0.0/16
```
Command di atas digunakan untuk memperbolehkan node lain yang terhubung dengan ip router untuk mengakses internet.

Selanjutnya arahkan koneksi kedua node DNS ke IP Address router, menggunakan command berikut:

```
echo nameserver 192.168.122.1 > /etc/resolv.conf
```

# 2. Membuat domain airdrop.it29.com
Karena para pasukan membutuhkan koordinasi untuk mengambil airdrop, maka buatlah sebuah domain yang mengarah ke Stalber dengan alamat airdrop.xxxx.com dengan alias www.airdrop.xxxx.com dimana xxxx merupakan kode kelompok. Contoh : airdrop.it01.com

---------

## a. Instal semua module yang diperlukan

```
apt-get update
apt-get install bind9 -y
```

## b. Masukan konfigurasi zone ke dalam /etc/bind/named.conf.local, sebagai berikut:

```
echo -e "zone "airdrop.it29.com" {
        type master;
        notify yes;
        also-notify { 10.78.1.3; };
        allow-transfer { 10.78.1.3; };
        file "/etc/bind/jarkom/airdrop.it29.com";
};" >> /etc/bind/named.conf.local
```

## c. Buat file bernama airdrop.it29.com di path /etc/bind/jarkom/ dengan melakukan copy dari template yang sudah disediakan oleh bind

```
mkdir /etc/bind/jarkom

echo -e ";
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     airdrop.it29.com. root.airdrop.it29.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      airdrop.it29.com.
@       IN      A       10.78.3.3
www     IN      CNAME   airdrop.it29.com.
medkit  IN      A       10.78.1.3
@       IN      AAAA    ::1" > /etc/bind/jarkom/airdrop.it29.com" > /etc/bind/jarkom/airdrop.it29.com
```

## d. Restart service bind9, untuk menyimpan konfigurasi yang sudah dibuat

```
service bind9 restart
```

## e. Agar Stabler bisa diarahkan oleh DNS, maka sambungkan ip dari Stabler dengan Pochinki dan Georgopol

```
echo -e "nameserver 10.78.1.2\nameserver 10.78.1.3" > /etc/resolv.conf
```
## f. Test apakah domain sudah bisa diakses menggunakan ping

```
ping airdrop.it29.com -c 5
```

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/a2969313-5006-47ad-85d2-eb193808ec1b)

# 3. Membuat domain redzone.it29.com
Para pasukan juga perlu mengetahui mana titik yang sedang di bombardir artileri, sehingga dibutuhkan domain lain yaitu redzone.xxxx.com dengan alias www.redzone.xxxx.com yang mengarah ke Severny

---------

## a. Instal semua module yang diperlukan

```
apt-get update
apt-get install bind9 -y
```

## b. Masukan konfigurasi zone ke dalam /etc/bind/named.conf.local, sebagai berikut:

```
echo -e "zone "redzone.it29.com" {
        type master;
        notify yes;
        also-notify { 10.78.1.3; };
        allow-transfer { 10.78.1.3; };
        file "/etc/bind/jarkom/redzone.it29.com";
};" >> /etc/bind/named.conf.local
```

## c. Buat file bernama redzone.it29.com di path /etc/bind/jarkom/ dengan melakukan copy dari template yang sudah disediakan oleh bind

```
mkdir /etc/bind/jarkom

echo -e ";
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     redzone.it29.com. root.redzone.it29.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      redzone.it29.com.
@       IN      A       10.78.3.3
www     IN      CNAME   redzone.it29.com.
@       IN      AAAA    ::1" > /etc/bind/jarkom/redzone.it29.com" > /etc/bind/jarkom/redzone.it29.com
```

## d. Restart service bind9, untuk menyimpan konfigurasi yang sudah dibuat

```
service bind9 restart
```

## e. Agar Servernya bisa diarahkan oleh DNS, maka sambungkan ip dari Servernya dengan Pochinki dan Georgopol

```
echo -e "nameserver 10.78.1.2\nameserver 10.78.1.3" > /etc/resolv.conf
```
## f. Test apakah domain sudah bisa diakses menggunakan ping

```
ping redzone.it29.com -c 5
```

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/641479c7-2539-460a-bcc0-1299ae17d949)

# 4. Membuat domain loot.it29.com
Para pasukan juga perlu mengetahui mana titik yang sedang di bombardir artileri, sehingga dibutuhkan domain lain yaitu redzone.xxxx.com dengan alias www.redzone.xxxx.com yang mengarah ke Severny

---------

## a. Instal semua module yang diperlukan

```
apt-get update
apt-get install bind9 -y
```

## b. Masukan konfigurasi zone ke dalam /etc/bind/named.conf.local, sebagai berikut:

```
echo -e "zone "loot.it29.com" {
        type master;
        notify yes;
        also-notify { 10.78.1.3; };
        allow-transfer { 10.78.1.3; };
        file "/etc/bind/jarkom/loot.it29.com";
};" >> /etc/bind/named.conf.local
```

## c. Buat file bernama loot.it29.com di path /etc/bind/jarkom/ dengan melakukan copy dari template yang sudah disediakan oleh bind

```
mkdir /etc/bind/jarkom

echo -e ";
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     loot.it29.com. root.loot.it29.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      loot.it29.com.
@       IN      A       10.78.3.4
www     IN      CNAME   loot.it29.com.
@       IN      AAAA    ::1" > /etc/bind/jarkom/loot.it29.com" > /etc/bind/jarkom/loot.it29.com
```

## d. Restart service bind9, untuk menyimpan konfigurasi yang sudah dibuat

```
service bind9 restart
```

## e. Agar Lipovka bisa diarahkan oleh DNS, maka sambungkan ip dari Lipovka dengan Pochinki dan Georgopol

```
echo -e "nameserver 10.78.1.2\nameserver 10.78.1.3" > /etc/resolv.conf
```

## f. Test apakah domain sudah bisa diakses menggunakan ping

```
ping loot.it29.com -c 5
```

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/7bff272c-6806-4249-b39d-60451724764d)

## **5. Memastikan Client dapat mengakses domain**
setelah membuat domain untuk setiap server(airdrop.it29.com, redzone.it29.com, loot.it29.com), node client harus dikonfigurasi terlebih dahulu dengan cara menambahkan nameserver pada file resolv.conf yang ada di dalam direktori /etc agar client dapat mengakses domain yang telah dibuat.
```
 nano /etc/resolv.conf
```
![Screenshot 2024-05-07 142946](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/8c63e2f7-538e-43b5-a837-6999c48d6cf4)

setiap client memiliki file resolv.conf yang sama yaitu mengarahkan nameserver menuju IP DNS Master dan DNS Slave.
Untuk benar-benar memastikan apakah client dapat mengakses domain, maka dilakukan ping terhadap semua domain pada setiap client dengan command berikut :
```
ping airdrop.it29.com
```
nama domain dapat disesuaikan dengan ketiga domain ataupun dengan menggunakan aliasnya.
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/20284b0b-6ae6-487e-8f5c-afca026498a7)
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/8965c72b-5935-4a2a-98b2-6ceff1867a4f)
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/8e8aca7b-ce90-4ead-a03f-221e1dbe695c)

## **6. Memastikan client dapat mengakses domain redzone.it29.com melalui alamat IP Severny**
Agar client dapat mengakses domain redzone melalui IP Severny yang merupakan server dari domain redzone, perlu dilakukan konfigurasi  Reverse DNS atau Record PTR pada DNS Master(Pochinki) untuk menerjemahkan alamat IP Severny ke domain redzone yang sudah diterjemahkan sebelumnya.

* Edit file /etc/bind/named.conf.local pada Pochinki
```
nano /etc/bind/named.conf.local
```
* Menambahkan konfigurasi penambahan zone berikut ke dalam file named.conf.local. Zone yang ditambahkan merupakan reverse dari 3 byte awal dari IP Pochinki yaitu 10.78.1.2 menjadi 1.78.10
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/5913bc48-4ca1-4c33-91f3-9f1414ba900e)
* Mengcopy file db.local pada path /etc/bind ke dalam folder jarkom yang baru saja dibuat dengan nama "1.78.10.in-addr.arpa" dan mengeditnya dengan konfigurasi berikut
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/b995ae48-c2e2-47e1-8c19-0f3b42c7db98)<br>
angka 2 di bawah baris 1.78.10.in-addr.arpa merupakan byte ke 4 dari IP Pochinki dan pada konfigurasi domain yang disesuaikan yaitu redzone.it29.com.<br>
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/763e730f-ec04-4e3e-8791-4bd10295d28a)

## **7. Membuat DNS Slave Georgopol untuk semua domain yang telah dibuat**
Untuk DNS Slave, Georgopol akan dijadikan sebagai DNS slave dan Pochinki sebagai DNS masternya.
### 1. Konfigurasi pada Pochinki
* Mengedit zone domain pada file /etc/bind/named.conf.local menjadi seperti ini untuk setiap zone dari domain yang telah dibuat
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/643ae750-0e90-46b2-a51e-b7bd82195f77)
IP yang dimasukkan pada zone domain merupakan IP Georgopol yang akan menjadi DNS Slave
### 2. Konfigurasi pada Georgopol
*  Mengedit zone domain pada file /etc/bind/named.conf.local menjadi seperti ini untuk setiap zone dari domain yang telah dibuat
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/5717f763-dfd6-4098-9e42-b66456242969)
Jika tadi IP yang digunakan adalah IP Georgopol, maka pada zone domain Georgopol, IP yang digunakan adalah IP DNS Master yaitu Pochinki
### 3. Testing
Sebelum melakukan testing, pastikan merestart bind9 pada DNS Slave dan mematikan bind9 pada DNS Master 
* Stop layanan bind9 DNS Master
```
service bind9 stop
```
Untuk testing apakah DNS Slave dapat digunakan, pastikan pengaturan nameserver mengarah ke IP Pochinki dan IP Georgopol pada setiap client.
   ![Screenshot 2024-05-07 142946](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/8c63e2f7-538e-43b5-a837-6999c48d6cf4)
Berikut adalah hasil testing oleh client terhadap DNS Slave
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/70b5696c-4029-4239-9460-6ebc63a600a6)

## **8. Membuat subdomain medkit.airdop.it29.com**
Untuk membuat subdomain, kita dapat mengonfigurasi zone yang telah dibuat, dalam hal ini adalah airdrop.it29.com.
* Pada Pochinki, edit file /etc/bind/jarkom/airdrop.it29.com lalu tambahkan subdomain medkit untuk airdrop.it29.com yang mengarah ke IP Lipovka(10.78.3.4).
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/285fbe83-34c0-4dcf-9fc9-3e55680b4ab6)
Berikut adalah bukti testing nya : 
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/9045db2b-b8cb-4d42-b39b-8a8ca2612c24)

## **9. Membuat subdomain siren.redzone.it29.com dan mendelegasikannya ke Georgopol**
### 1. Konfigurasi Pada Pochinki
   * Pada file /etc/bind/jarkom/redzone.it29.com
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/bdbc6ecc-d482-4a6d-be87-b9263071f72b)
   * Kemudian edit file /etc/bind/named.conf.options menjaadi seperti ini
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/73443613-1637-42a5-b730-e28027ad6506)
   * Lalu edit file /etc/bind/named.conf.local menjadi seperti gambar di bawah
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/c3930819-9986-44ae-b6f7-54d411919db8)<br>

### 2. Konfigurasi pada Georgopol
   * Edit file /etc/bind/named.conf.options menjaadi seperti ini
     ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/73443613-1637-42a5-b730-e28027ad6506)
   * Menambahkan zone untuk subdomain pada named.conf.local
     ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/6e95697a-6c7a-4631-a27f-9f04728b575d)
   * Kemudian membuat direktori delegasi yang didalamnya terdapat copy db.local untuk siren.redzone.it29.com dan konfigurasikan seperti berikut : 
     ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/d248cdfc-a03d-4145-b185-9126a24df325)
   * Berikut dokumentasi ping oleh client terhadap subdomain yang didelegasikan
     ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/ff808b57-a400-4e63-98f2-0cacebc5e8dd)
     ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/ef4ca570-9df5-4642-9478-e8b31592005e)

## **10. Membuat subdomain log di dalam subdomain siren.redzone.it29.com**
### 1. Mengedit named.conf.local dengan menambahkan zone baru untuk log.siren.redzone.it29.com seperti berikut :
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/fc8b773e-f960-4fa2-9445-a6c8f6bbb695)
### 2. Copy db.local untuk log.siren.redzone.it29.com dan konfigurasikan seperti berikut
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/71fe7fdd-b34a-4cb1-a046-edec6b432496)
### 3. Dokumentasi ping ke log.siren.redzone.it29.com
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/afaa4e64-d9d2-4038-8c33-09302d058c0b)
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/102070c8-46d2-488d-b507-19e733059d50)

## 11. Forwarding IP DNS

### a. Modifikasi file /etc/bind/named.conf.options dengan forwarder sebagai berikut:

```
        forwarders {
        192.168.122.1;
        };
```

Jika sudah, cek dengan melakukan ping sites lain menggunakan node client yang sudah tersambung dengan DNS.

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/7e1e76b3-1edf-46eb-923a-02b02bee704b)

## 12. Deploy website di Serverny menggunakan apache

### a. Isi script sebagai berikut:

```

echo -e "nameserver 10.78.1.2\nnameserver 10.78.1.3" > /etc/resolv.conf

apt-get update

apt-get install wget -y
apt-get install apache2 -y
apt-get install unzip -y
apt-get install libapache2-mod-php7.0 -y

wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=$wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=$
mkdir /var/www
mkdir /var/www/html

unzip dir-listing.zip -d dir-listing
unzip lb.zip -d lb

cp /root/lb/worker/index.php /var/www/html/index.php

service apache2 restart
```
- Sambungkan node Serverny dengan DNS kemudian install apache2, dan modul lain untuk seperti wget, unzip, dll.
- Kemudian download resource yang sudah diberikan dan unzip
- Copy resource yang sudah di unzip tadi ke file /var/www/html/index.php
- Terakhir restart service apache2

### b. Test konfigurasi

Untuk testing akan digunakan lynx, jadi pastikan sudah menginstall lynx di node client. Berikut command untuk testingnya:

```
lynx http://10.78.3.2/index.php
```

Berikut hasilnya jika berhasil:

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/324e9dde-9019-4c31-aeb7-ec53c154450e)

## 13. Load balancer menggunakan apache

### a. Konfigurasikan node mylta sebagai load balancer dengan script di bawah:

```
echo -e "nameserver 10.78.1.2\nnameserver 10.78.1.3" > /etc/resolv.conf

apt-get update

apt-get install apache2 -y
apt-get install libapache2-mod-php7.0 -y
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer
a2enmod lbmethod_byrequests

rm /var/www/html/index.html

echo -e "<VirtualHost *:80>
        <Proxy balancer://mycluster>
                BalancerMember http://10.78.3.2
                BalancerMember http://10.78.3.3
        </Proxy>
        ProxyPreserveHost On
        ProxyPass / balancer://mycluster/
        ProxyPassReverse / balancer://mycluster/

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet" > /etc/apache2/sites-available/000-default.conf
service apache2 restart
```
- Script akan menginstall module yang diperlukan seperti apache2, dan module algoritma untuk load balancer
- Kemudian menghapus file index.html agar tidak menabrak tampilan dari worker nanti
- Copy konfigurasi ke /etc/apache/sites-available/000-default.conf
- Terakhir restart service apache2

### b. Testing laod balancer

Untuk menunjukkan bahwa load balancer sudah berjalan, saya akan mengetest menggunakan lynx dan setiap ip load balancer di restart akan menampilkan isi index.php dari worker secara bergantian

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/bcd7484b-a57f-4938-9467-f7e7ae703787)

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/dc861976-3082-4907-b2a0-a06efb433272)

## 14. Menganti service apache2 menjadi nginx

### a. Setup load balancer

Berikut scriptnya:

```
service apache2 stop
apt-get update
apt-get install nginx -y
echo "upstream backend {
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
" > /etc/nginx/sites-available/jarkom

ln -s /etc/nginx/sites-available/jarkom /etc/nginx/sites-enabled/jarkom

rm /etc/nginx/sites-enabled/default

service nginx restart
```

- Stop service apache
- Install nginx
- Memasukan konfigurasi ke dalam file jarkom
- Melakukan simlink file jarkom di sites-available dengan sites-enabled
- Menghapus default agar tidak menabrak konfigurasi jarkom
- restart nginx

### b. Setup worker

Script:

```
service apache2 stop

apt-get update
apt-get install nginx -y
apt install php php-fpm php-mysql -y
mkdir /var/www/jarkom
cp /root/lb/worker/index.php /var/www/jarkom/index.php

service php7.0-fpm start

echo -e "server {
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
}" > /etc/nginx/sites-available/jarkom

ln -s /etc/nginx/sites-available/jarkom /etc/nginx/sites-enabled/jarkom

rm /etc/nginx/sites-enabled/default

service nginx restart
```

- Menginstall modul yang diperlukan
- Menjalankan service php7.0-fpm
- Masukan konfigurasi worker ke dalam /etc/nginx/sites-available/jarkom
- Simlink file jarkom
- Menghapus file default
- Restart nginx
- Lakukan untuk semua worker

### c. Hasil

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/2f50e17a-73c1-46b0-b222-815c00ea56b6)

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/92b729a3-93bd-415b-afdd-06a679b2a440)

## 15. Analisis 

## 16. Buat domain mylta.it29.com

### a. Buat zone di konfigurasi DNS Master

```
zone "mylta.it29.com" {
                type master;
                file "/etc/bind/jarkom/mylta.it29.com";
};
```

```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     mylta.it29.com. root.mylta.it29.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      mylta.it29.com.
@       IN      A       10.78.2.5
www     IN      CNAME   mylta.it29.com
@       IN      AAAA    ::1
```

Kemudian restart bind9

### b. Hasil

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/257e42fb-072e-40d5-9a10-25439c58a2d0)

## 17. Port

### a. Modifikasi konfigurasi load balancer

```
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
```

### b. Modifikasi konfigurasi di kedua worker

```
server {
        listen 14400; # atau listen 14000 untuk Serverny

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
}
```
### c. Hasil

https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/803deb9a-c37d-4978-9843-403360d24f5e

## 18. IP mytla

https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/bd25f038-daa7-41ba-abc4-6f3b30428a91

## 19. Dir Listing

Script:

```
cp -r dr-listing/worker2 /var/www/jarkom/

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

service nginx restart
```
### Dokumentasi

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/31333e04-b4f9-4fed-a624-716bc666d089)

## 20. Domain tamat.it29.com

```
zone "tamat.it29.com" {
                type master;
                file "/etc/bind/jarkom/tamat.it29.com";
};
```

```
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
@       IN      A       10.78.3.2:14000
www     IN      CNAME   tamat.it29.com
@       IN      AAAA    ::1
```

## Dokumentasi 

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/9cdf657c-5929-41a3-a5bd-e33899f240d6)

![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/134209563/e37ef604-0f01-4750-8086-620fa12c3931)




