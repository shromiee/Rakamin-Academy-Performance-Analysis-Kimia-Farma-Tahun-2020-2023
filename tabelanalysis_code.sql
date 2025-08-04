CREATE TABLE `rakamin-kf-analytics-123r2343.Kimia_Farma.tabel_analisa` AS
SELECT
  t.transaction_id,
  t.date,
  t.branch_id,  
  c.branch_name,
  c.kota,
  c.provinsi,
  c.rating AS rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  t.price AS actual_price,
  t.discount_percentage,

  -- Gross profit percentage
  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15 
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    WHEN t.price > 500000 THEN 0.30
    ELSE 0
  END AS percentage_gross_laba,

  -- Nett sales
  t.price * (1 - t.discount_percentage / 100.0) AS nett_sales,

  -- Nett profit
  (t.price * (1 - t.discount_percentage / 100.0)) *
    CASE
      WHEN t.price <= 50000 THEN 0.10
      WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15 
      WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
      WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
      WHEN t.price > 500000 THEN 0.30
      ELSE 0
    END AS nett_profit,

  t.rating AS rating_transaksi

FROM
  `Kimia_Farma.kf_final_transaction` AS t
JOIN 
  `Kimia_Farma.kf_product` AS p
  ON t.product_id = p.product_id
JOIN
  `Kimia_Farma.kf_kantor_cabang` AS c
  ON t.branch_id = c.branch_id;