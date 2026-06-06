SELECT 
    output_address,
    COUNT(*) AS txn_count,
    SUM(output_value) AS total_sent
FROM {{ ref('stg_btc_transactions') }}
WHERE output_value > 10
GROUP BY output_address
ORDER BY total_sent DESC