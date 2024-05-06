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
