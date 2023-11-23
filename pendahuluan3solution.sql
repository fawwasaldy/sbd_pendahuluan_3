-- no.1
SELECT * FROM transaksi
WHERE tanggal_transaksi BETWEEN '2023-10-10' AND '2023-10-20';

-- no.2
SELECT transaksi_minuman.tm_transaksi_id AS id_transaksi, SUM(menu_minuman.harga_minuman * transaksi_minuman.jumlah_minuman) AS TOTAL_HARGA FROM transaksi_minuman
JOIN menu_minuman ON (menu_minuman.id_minuman = transaksi_minuman.tm_menu_minuman_id)
GROUP BY id_transaksi;

-- no.3
SELECT customer.*, SUM(menu_minuman.harga_minuman * transaksi_minuman.jumlah_minuman) AS Total_Belanja FROM customer
JOIN transaksi ON (transaksi.customer_id_customer = customer.id_customer)
JOIN transaksi_minuman ON (transaksi_minuman.tm_transaksi_id = transaksi.id_transaksi)
JOIN menu_minuman ON (menu_minuman.id_minuman = transaksi_minuman.tm_menu_minuman_id)
WHERE transaksi.tanggal_transaksi BETWEEN '2023-10-03' AND '2023-10-22'
GROUP by (customer.id_customer);

-- no.4
SELECT pegawai.* FROM pegawai
JOIN transaksi ON (transaksi.pegawai_nik = pegawai.nik)
JOIN customer ON (customer.id_customer = transaksi.customer_id_customer)
WHERE customer.nama_customer IN ('Davi Liam', 'Sisil Triana', 'Hendra Asto');

-- no.5
SELECT MONTH(transaksi.tanggal_transaksi) AS BULAN, YEAR(transaksi.tanggal_transaksi) AS TAHUN, SUM(transaksi_minuman.jumlah_minuman) AS JUMLAH_CUP FROM transaksi
JOIN transaksi_minuman ON (transaksi_minuman.tm_transaksi_id = transaksi.id_transaksi)
GROUP BY BULAN, TAHUN
ORDER BY TAHUN DESC, BULAN ASC;

-- no.6
SELECT AVG(Total_Belanja) FROM (
    SELECT SUM(menu_minuman.harga_minuman * transaksi_minuman.jumlah_minuman) AS Total_Belanja FROM transaksi_minuman
	JOIN menu_minuman ON (menu_minuman.id_minuman = transaksi_minuman.tm_menu_minuman_id)
	GROUP BY (transaksi_minuman.tm_transaksi_id)
) AS TabelRataRataTotalBelanja;

-- no.7
SELECT customer.id_customer, customer.nama_customer, SUM(Belanja_Customer) as Total_Belanja FROM (
    SELECT transaksi.customer_id_customer, SUM(menu_minuman.harga_minuman * transaksi_minuman.jumlah_minuman) AS Belanja_Customer FROM transaksi
    JOIN transaksi_minuman ON (transaksi_minuman.tm_transaksi_id = transaksi.id_transaksi)
    JOIN menu_minuman ON (menu_minuman.id_minuman = transaksi_minuman.tm_menu_minuman_id)
    GROUP BY transaksi.id_transaksi
) AS RataRataTotalBelanjaPerTransaksi
JOIN customer ON (customer.id_customer = RataRataTotalBelanjaPerTransaksi.customer_id_customer)
GROUP BY customer.id_customer
HAVING AVG(Belanja_Customer) > (
    SELECT AVG(avg_total_belanja) FROM (
    	SELECT SUM(menu_minuman.harga_minuman * transaksi_minuman.jumlah_minuman) AS avg_total_belanja FROM transaksi_minuman
		JOIN menu_minuman ON (menu_minuman.id_minuman = transaksi_minuman.tm_menu_minuman_id)
		GROUP BY (transaksi_minuman.tm_transaksi_id)
	) AS RataRataKeseluruhan
);

-- no.8
SELECT * FROM customer
WHERE id_customer NOT IN (
    SELECT m_id_customer FROM membership
);

-- no.9
SELECT COUNT(DISTINCT transaksi.customer_id_customer) AS Jumlah_Customer_yang_Pernah_Memesan_Minuman_Latte FROM transaksi
JOIN transaksi_minuman ON (transaksi_minuman.tm_transaksi_id = transaksi.id_transaksi)
WHERE transaksi_minuman.tm_menu_minuman_id = (
    SELECT id_minuman FROM menu_minuman
    WHERE nama_minuman = 'Latte'
);

-- no.10
SELECT customer.nama_customer, menu_minuman.nama_minuman, SUM(transaksi_minuman.jumlah_minuman) AS JUMLAH_CUP FROM customer
JOIN transaksi ON (transaksi.customer_id_customer = customer.id_customer)
JOIN transaksi_minuman ON (transaksi_minuman.tm_transaksi_id = transaksi.id_transaksi)
JOIN menu_minuman ON (menu_minuman.id_minuman = transaksi_minuman.tm_menu_minuman_id)
WHERE customer.nama_customer LIKE 'S%'
GROUP BY customer.id_customer, menu_minuman.id_minuman;