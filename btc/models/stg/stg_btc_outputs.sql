{{
    config(
        materialized='incremental',
        incremental_strategy='append'
    )
}}

WITH flattened_outputs AS (
    SELECT 
        hashkey,
        block_hash,
        block_number,
        block_timestamp,
        fee,
        input_value,
        output_btc,
        is_coinbase,
        O.VALUE:address::STRING AS output_address,
        O.VALUE:value::FLOAT    AS output_value
    FROM {{ ref('stg_btc') }}, LATERAL FLATTEN(INPUT => OUTPUTS) O
    WHERE O.VALUE:address IS NOT NULL

    {% if is_incremental() %}

    AND block_timestamp >= (SELECT MAX(block_timestamp) FROM {{ this }})

    {% endif %}

)
SELECT 
    hashkey,
    block_hash,
    block_number,
    block_timestamp,
    fee,
    input_value,
    output_btc,
    is_coinbase,
    output_address,
    output_value
FROM flattened_outputs