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

**5. Memastikan Client dapat mengakses domain**
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

**6. Memastikan client dapat mengakses domain redzone.it29.com melalui alamat IP Severny**
Agar client dapat mengakses domain redzone melalui IP Severny yang merupakan server dari domain redzone, perlu dilakukan konfigurasi  Reverse DNS atau Record PTR pada DNS Master(Pochinki) untuk menerjemahkan alamat IP Severny ke domain redzone yang sudah diterjemahkan sebelumnya.

* Edit file /etc/bind/named.conf.local pada Pochinki
```
nano /etc/bind/named.conf.local
```
* Menambahkan konfigurasi penambahan zone berikut ke dalam file named.conf.local. Zone yang ditambahkan merupakan reverse dari 3 byte awal dari IP Pochinki yaitu 10.78.1.2 menjadi 1.78.10
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/5913bc48-4ca1-4c33-91f3-9f1414ba900e)
* Mengcopy file db.local pada path /etc/bind ke dalam folder jarkom yang baru saja dibuat dengan nama "1.78.10.in-addr.arpa" dan mengeditnya dengan konfigurasi berikut
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/b995ae48-c2e2-47e1-8c19-0f3b42c7db98)
angka 2 di bawah baris 1.78.10.in-addr.arpa merupakan byte ke 4 dari IP Pochinki dan pada konfigurasi domain yang disesuaikan yaitu redzone.it29.com.
![image](https://github.com/J0see1/Jarkom-Modul-2-IT29/assets/143849730/763e730f-ec04-4e3e-8791-4bd10295d28a)




