{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='hashkey'
    )
}}

SELECT *
FROM {{ source('raw', 'btc') }}

{% if is_incremental() %}

WHERE block_timestamp >= (
    SELECT MAX(block_timestamp) 
    FROM {{ this }}
)

{% endif %}