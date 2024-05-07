# Praktikum-Jarkom-Modul-2

# Anggota

| Nama                            | NRP          |
| ------------------------------- | ------------ |
| Marcelinus Alvinanda Chrisantya | `5027221012` |
| Bintang Ryan Wardana            | `5027221022` |


# Setup Topologi



## 1 

```
bash script.sh
```

Menjalankan script.sh untuk instalasi bind9

```
nano /etc/bind/named.conf.local
```

```
zone "airdrop.it29.com" {
	type master;
	file "/etc/bind/jarkom/airdrop.it29.com";
};
```

Memasukan konfigurasi DNS ke dalam file named.conf.local

```
mkdir /etc/bind/jarkom
```
```
cp /etc/bind/db.local /etc/bind/jarkom/airdrop.it29.com
```

Membuat directory dan file yang sesuai dengan konfigurasi sebelumnya.

```
nano /etc/bind/jarkom/airdrop.it29.com
```

Setting image dengan domain dan ip dari Stabler

```
service bind9 restart
```

Restart bind9 untuk menjalankan perubahan yang sudah dibuat

```
echo nameserver 10.78.1.2 > /etc/resolv.conf
```

Mengarahkan klien pada DNS airdrop.it29.com dengan IP DNS Master

```
ping airdrop.it29.com -c 5
```

Tes apakah DNS bisa diakses klien

**5. Memastikan Client dapat mengakses domain**<br>
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

**6. Memastikan client dapat mengakses domain redzone.it29.com melalui alamat IP Severny**<br>
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

**7. Membuat DNS Slave Georgopol untuk semua domain yang telah dibuat**<br>
Untuk DNS Slave, Georgopol akan dijadikan sebagai DNS slave dan Pochinki sebagai DNS masternya.
1. Konfigurasi pada Pochinki
* Mengedit zone domain pada file /etc/bind/named.conf.local menjadi seperti ini untuk setiap zone dari domain yang telah dibuat
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/643ae750-0e90-46b2-a51e-b7bd82195f77)
IP yang dimasukkan pada zone domain merupakan IP Georgopol yang akan menjadi DNS Slave
2. Konfigurasi pada Georgopol
*  Mengedit zone domain pada file /etc/bind/named.conf.local menjadi seperti ini untuk setiap zone dari domain yang telah dibuat
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/5717f763-dfd6-4098-9e42-b66456242969)
Jika tadi IP yang digunakan adalah IP Georgopol, maka pada zone domain Georgopol, IP yang digunakan adalah IP DNS Master yaitu Pochinki
3. Testing
Sebelum melakukan testing, pastikan merestart bind9 pada DNS Slave dan mematikan bind9 pada DNS Master 
* Stop layanan bind9 DNS Master
```
service bind9 stop
```
Untuk testing apakah DNS Slave dapat digunakan, pastikan pengaturan nameserver mengarah ke IP Pochinki dan IP Georgopol pada setiap client.
   ![Screenshot 2024-05-07 142946](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/8c63e2f7-538e-43b5-a837-6999c48d6cf4)
Berikut adalah hasil testing oleh client terhadap DNS Slave
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/70b5696c-4029-4239-9460-6ebc63a600a6)

**8. Membuat subdomain medkit.airdop.it29.com**<br>
Untuk membuat subdomain, kita dapat mengonfigurasi zone yang telah dibuat, dalam hal ini adalah airdrop.it29.com.
* Pada Pochinki, edit file /etc/bind/jarkom/airdrop.it29.com lalu tambahkan subdomain medkit untuk airdrop.it29.com yang mengarah ke IP Lipovka(10.78.3.4).
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/285fbe83-34c0-4dcf-9fc9-3e55680b4ab6)
Berikut adalah bukti testing nya : 
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/9045db2b-b8cb-4d42-b39b-8a8ca2612c24)

**9. Membuat subdomain siren.redzone.it29.com dan mendelegasikannya ke Georgopol**<br>
1. Konfigurasi Pada Pochinki
   * Pada file /etc/bind/jarkom/redzone.it29.com
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/bdbc6ecc-d482-4a6d-be87-b9263071f72b)
   * Kemudian edit file /etc/bind/named.conf.options menjaadi seperti ini
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/73443613-1637-42a5-b730-e28027ad6506)
   * Lalu edit file /etc/bind/named.conf.local menjadi seperti gambar di bawah
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/c3930819-9986-44ae-b6f7-54d411919db8)<br>

2. Konfigurasi pada Georgopol
   * Edit file /etc/bind/named.conf.options menjaadi seperti ini
     ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/73443613-1637-42a5-b730-e28027ad6506)
   * Menambahkan zone untuk subdomain pada named.conf.local
     ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/6e95697a-6c7a-4631-a27f-9f04728b575d)
   * Kemudian membuat direktori delegasi yang didalamnya terdapat copy db.local untuk siren.redzone.it29.com dan konfigurasikan seperti berikut : 
     ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/d248cdfc-a03d-4145-b185-9126a24df325)
   * Berikut dokumentasi ping oleh client terhadap subdomain yang didelegasikan
     ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/ff808b57-a400-4e63-98f2-0cacebc5e8dd)
     ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/ef4ca570-9df5-4642-9478-e8b31592005e)

**10. Membuat subdomain log di dalam subdomain siren.redzone.it29.com**<br>
1. Mengedit named.conf.local dengan menambahkan zone baru untuk log.siren.redzone.it29.com seperti berikut :
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/fc8b773e-f960-4fa2-9445-a6c8f6bbb695)
2. Copy db.local untuk log.siren.redzone.it29.com dan konfigurasikan seperti berikut
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/71fe7fdd-b34a-4cb1-a046-edec6b432496)
3. Dokumentasi ping ke log.siren.redzone.it29.com
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/afaa4e64-d9d2-4038-8c33-09302d058c0b)
   ![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/102070c8-46d2-488d-b507-19e733059d50)


   






